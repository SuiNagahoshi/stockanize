import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stockanize/db/parts.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Accounts, UserGroups, AppContexts, Parts, PartsImages])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());
  static final AppDatabase instance = AppDatabase._internal();
  factory AppDatabase() => instance;

  static const String defaultAccountId = 'personal-default';
  static const int contextRowId = 1;

  String _activeAccountId = defaultAccountId;
  int? _activeGroupId;

  String get currentAccountId => _activeAccountId;
  int? get currentGroupId => _activeGroupId;

  @override
  int get schemaVersion => 3;

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
        ),
        mode: InsertMode.insertOrReplace,
      );
      _activeAccountId = defaultAccountId;
      _activeGroupId = null;
    } else {
      _activeAccountId = appContext.activeAccountId;
      _activeGroupId = appContext.activeGroupId;
    }

    await customStatement(
      'UPDATE parts SET account_id = ? WHERE account_id IS NULL',
      <Object>[currentAccountId],
    );
  }

  Future<void> initializeTenantContext() async {
    await _bootstrapTenantContext();
  }

  Future<void> setActiveScope({required String accountId, int? groupId}) async {
    await (update(appContexts)..where((t) => t.id.equals(contextRowId))).write(
      AppContextsCompanion(
        activeAccountId: Value(accountId),
        activeGroupId: Value(groupId),
      ),
    );
    _activeAccountId = accountId;
    _activeGroupId = groupId;
  }

  Future<void> setActiveAccount(String accountId) async {
    await setActiveScope(accountId: accountId, groupId: null);
  }

  Future<void> setActiveGroup(int? groupId) async {
    await setActiveScope(accountId: currentAccountId, groupId: groupId);
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
