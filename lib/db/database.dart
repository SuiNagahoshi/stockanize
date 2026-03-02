import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stockanize/db/parts.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Users,
  Accounts,
  AccountMembers,
  UserGroups,
  GroupMembers,
  GroupInvites,
  AppContexts,
  Parts,
  PartsImages,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());
  AppDatabase.forTesting(super.executor);
  static final AppDatabase instance = AppDatabase._internal();
  factory AppDatabase() => instance;

  static const String defaultAccountId = 'personal-default';
  static const int contextRowId = 1;

  String _activeAccountId = defaultAccountId;
  int? _activeGroupId;
  int? _activeUserId;

  String get currentAccountId => _activeAccountId;
  int? get currentGroupId => _activeGroupId;
  int? get currentUserId => _activeUserId;

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            if (!await _tableExists('parts_images')) {
              await m.createTable(partsImages);
            }
          }

          if (from < 3) {
            if (!await _tableExists('accounts')) {
              await m.createTable(accounts);
            }
            if (!await _tableExists('user_groups')) {
              await m.createTable(userGroups);
            }
            if (!await _tableExists('app_contexts')) {
              await m.createTable(appContexts);
            }
            if (!await _columnExists('parts', 'account_id')) {
              await m.addColumn(parts, parts.accountId);
            }
            if (!await _columnExists('parts', 'group_id')) {
              await m.addColumn(parts, parts.groupId);
            }
          }

          if (from < 4) {
            if (!await _tableExists('users')) {
              await m.createTable(users);
            }
            if (!await _tableExists('account_members')) {
              await m.createTable(accountMembers);
            }
            if (!await _tableExists('group_members')) {
              await m.createTable(groupMembers);
            }
            if (!await _tableExists('group_invites')) {
              await m.createTable(groupInvites);
            }

            if (from >= 3 &&
                await _tableExists('app_contexts') &&
                !await _columnExists('app_contexts', 'active_user_id')) {
              await m.addColumn(appContexts, appContexts.activeUserId);
            }
          }

          if (from < 5) {
            if (await _tableExists('accounts')) {
              if (!await _columnExists('accounts', 'password_hash')) {
                await m.addColumn(accounts, accounts.passwordHash);
              }
              if (!await _columnExists('accounts', 'password_salt')) {
                await m.addColumn(accounts, accounts.passwordSalt);
              }
              if (!await _columnExists('accounts', 'password_set_at')) {
                await m.addColumn(accounts, accounts.passwordSetAt);
              }
            }
          }
        },
        beforeOpen: (details) async {
          await _bootstrapTenantContext();
        },
      );

  Future<bool> _tableExists(String tableName) async {
    final rows = await customSelect(
      'SELECT name FROM sqlite_master WHERE type = ? AND name = ?',
      variables: [Variable.withString('table'), Variable.withString(tableName)],
    ).get();
    return rows.isNotEmpty;
  }

  Future<bool> _columnExists(String tableName, String columnName) async {
    final rows = await customSelect('PRAGMA table_info($tableName)').get();
    return rows.any((row) => row.data['name'] == columnName);
  }

  Future<void> _bootstrapTenantContext() async {
    await into(accounts).insertOnConflictUpdate(
      AccountsCompanion.insert(
        id: defaultAccountId,
        name: 'Default Account',
      ),
    );

    await _normalizeLegacyPersonalAccountNames();

    final appContext = await (select(appContexts)
          ..where((t) => t.id.equals(contextRowId)))
        .getSingleOrNull();

    if (appContext == null) {
      await into(appContexts).insert(
        AppContextsCompanion(
          id: const Value(contextRowId),
          activeAccountId: const Value(defaultAccountId),
          activeGroupId: const Value(null),
          activeUserId: const Value(null),
        ),
        mode: InsertMode.insertOrReplace,
      );
      _activeAccountId = defaultAccountId;
      _activeGroupId = null;
      _activeUserId = null;
    } else {
      _activeAccountId = appContext.activeAccountId;
      _activeGroupId = appContext.activeGroupId;
      _activeUserId = appContext.activeUserId;
    }

    await customStatement(
      'UPDATE parts SET account_id = ? WHERE account_id IS NULL',
      <Object>[currentAccountId],
    );
  }

  Future<void> _normalizeLegacyPersonalAccountNames() async {
    final legacyAccounts = await customSelect(
      '''
      SELECT a.id AS account_id, a.name AS account_name, u.username AS username
      FROM accounts a
      JOIN account_members am ON am.account_id = a.id
      JOIN users u ON u.id = am.user_id
      WHERE a.id LIKE 'acc-user-%'
      ''',
    ).get();

    for (final row in legacyAccounts) {
      final accountId = row.read<String>('account_id');
      final accountName = row.read<String>('account_name');
      final username = row.read<String>('username');
      final legacyName = '$username personal';
      if (accountName != legacyName) continue;

      final duplicate = await customSelect(
        '''
        SELECT 1
        FROM accounts
        WHERE name = ? AND id <> ?
        LIMIT 1
        ''',
        variables: [
          Variable.withString(username),
          Variable.withString(accountId),
        ],
      ).getSingleOrNull();
      if (duplicate != null) continue;

      await (update(accounts)..where((a) => a.id.equals(accountId))).write(
        AccountsCompanion(name: Value(username)),
      );
    }
  }

  Future<void> initializeTenantContext() async {
    await _bootstrapTenantContext();
  }

  Future<void> setActiveScope({
    required String accountId,
    int? groupId,
    int? userId,
  }) async {
    final normalizedGroupId = await _normalizeScopeGroupId(
      accountId: accountId,
      groupId: groupId,
      userId: userId,
    );
    await (update(appContexts)..where((t) => t.id.equals(contextRowId))).write(
      AppContextsCompanion(
        activeAccountId: Value(accountId),
        activeGroupId: Value(normalizedGroupId),
        activeUserId: Value(userId),
      ),
    );
    _activeAccountId = accountId;
    _activeGroupId = normalizedGroupId;
    _activeUserId = userId;
  }

  Future<void> setActiveAccount(String accountId, {int? userId}) async {
    final resolvedUserId = userId ?? _activeUserId;
    final previousGroupId = _activeGroupId;
    final previousAccountId = _activeAccountId;

    if (accountId == previousAccountId) {
      return;
    }

    if (resolvedUserId == null) {
      throw StateError('アカウントを切り替えるにはログインが必要です');
    }

    final membership = await (select(accountMembers)
          ..where((m) => m.accountId.equals(accountId))
          ..where((m) => m.userId.equals(resolvedUserId)))
        .getSingleOrNull();
    if (membership == null) {
      throw StateError('このユーザは対象アカウントに所属していません');
    }

    final nextGroupId = await _resolveGroupForAccount(
      accountId: accountId,
      userId: resolvedUserId,
      previousGroupId: previousGroupId,
    );
    final safeNextGroupId = await _normalizeScopeGroupId(
      accountId: accountId,
      groupId: nextGroupId,
      userId: resolvedUserId,
    );

    await setActiveScope(
      accountId: accountId,
      groupId: safeNextGroupId,
      userId: resolvedUserId,
    );
  }

  Future<void> setActiveUser(int? userId) async {
    String nextAccountId = _activeAccountId;

    if (userId != null) {
      final memberships = await (select(accountMembers)
            ..where((m) => m.userId.equals(userId))
            ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
          .get();

      if (memberships.isNotEmpty) {
        final hasCurrent =
            memberships.any((m) => m.accountId == _activeAccountId);
        if (!hasCurrent) {
          nextAccountId = memberships.first.accountId;
        }
      }
    }

    await setActiveScope(
        accountId: nextAccountId, groupId: null, userId: userId);
  }

  Future<void> setActiveGroup(int? groupId) async {
    if (groupId != null) {
      final userId = _activeUserId;
      if (userId == null) {
        throw StateError('グループを選択するにはログインが必要です');
      }

      final member = await (select(groupMembers)
            ..where((m) => m.groupId.equals(groupId))
            ..where((m) => m.userId.equals(userId)))
          .getSingleOrNull();
      if (member == null) {
        throw StateError('このユーザは対象グループに参加していません');
      }
    }

    await setActiveScope(
      accountId: currentAccountId,
      groupId: groupId,
      userId: _activeUserId,
    );
  }

  Stream<AppContext?> watchAppContext() {
    return (select(appContexts)..where((t) => t.id.equals(contextRowId)))
        .watchSingleOrNull();
  }

  Future<int?> _resolveGroupForAccount({
    required String accountId,
    required int userId,
    required int? previousGroupId,
  }) async {
    if (previousGroupId != null) {
      final previousGroupMembership = await (select(userGroups).join([
        innerJoin(groupMembers, groupMembers.groupId.equalsExp(userGroups.id)),
      ])
            ..where(userGroups.id.equals(previousGroupId))
            ..where(userGroups.accountId.equals(accountId))
            ..where(groupMembers.userId.equals(userId)))
          .getSingleOrNull();
      if (previousGroupMembership != null) {
        return previousGroupId;
      }
    }

    final nextGroups = await (select(userGroups).join([
      innerJoin(groupMembers, groupMembers.groupId.equalsExp(userGroups.id)),
    ])
          ..where(userGroups.accountId.equals(accountId))
          ..where(groupMembers.userId.equals(userId))
          ..orderBy([OrderingTerm.asc(userGroups.createdAt)]))
        .get();

    if (nextGroups.isEmpty) {
      return null;
    }
    return nextGroups.first.readTable(userGroups).id;
  }

  Future<int?> _normalizeScopeGroupId({
    required String accountId,
    required int? groupId,
    required int? userId,
  }) async {
    if (groupId == null || userId == null) {
      return null;
    }

    final scopedGroup = await (select(userGroups).join([
      innerJoin(groupMembers, groupMembers.groupId.equalsExp(userGroups.id)),
    ])
          ..where(userGroups.id.equals(groupId))
          ..where(userGroups.accountId.equals(accountId))
          ..where(groupMembers.userId.equals(userId)))
        .getSingleOrNull();

    if (scopedGroup == null) {
      return null;
    }
    return groupId;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbFile = File(join(dbDir.path, 'parts.sqlite'));

    return NativeDatabase(dbFile);
  });
}
