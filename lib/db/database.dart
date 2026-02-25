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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            await m.createTable(partsImages);
          }

          if (from < 3) {
            await m.createTable(accounts);
            await m.createTable(userGroups);
            await m.createTable(appContexts);
            await m.addColumn(parts, parts.accountId);
            await m.addColumn(parts, parts.groupId);
          }

          if (from < 4) {
            await m.createTable(users);
            await m.createTable(accountMembers);
            await m.createTable(groupMembers);
            await m.createTable(groupInvites);

            if (from >= 3) {
              await m.addColumn(appContexts, appContexts.activeUserId);
            }
          }
        },
        beforeOpen: (details) async {
          await _bootstrapTenantContext();
        },
      );

  Future<void> _bootstrapTenantContext() async {
    await into(accounts).insertOnConflictUpdate(
      AccountsCompanion.insert(
        id: defaultAccountId,
        name: 'Personal',
      ),
    );

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

  Future<void> initializeTenantContext() async {
    await _bootstrapTenantContext();
  }

  Future<void> setActiveScope({
    required String accountId,
    int? groupId,
    int? userId,
  }) async {
    await (update(appContexts)..where((t) => t.id.equals(contextRowId))).write(
      AppContextsCompanion(
        activeAccountId: Value(accountId),
        activeGroupId: Value(groupId),
        activeUserId: Value(userId),
      ),
    );
    _activeAccountId = accountId;
    _activeGroupId = groupId;
    _activeUserId = userId;
  }

  Future<void> setActiveAccount(String accountId) async {
    final userId = _activeUserId;
    if (userId == null) {
      throw StateError('アカウントを切り替えるにはログインが必要です');
    }

    final membership = await (select(accountMembers)
          ..where((m) => m.accountId.equals(accountId))
          ..where((m) => m.userId.equals(userId)))
        .getSingleOrNull();
    if (membership == null) {
      throw StateError('このユーザは対象アカウントに所属していません');
    }

    await setActiveScope(accountId: accountId, groupId: null, userId: userId);
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbFile = File(join(dbDir.path, 'parts.sqlite'));

    return NativeDatabase(dbFile);
  });
}
