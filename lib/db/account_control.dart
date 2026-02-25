import 'package:drift/drift.dart';
import 'package:stockanize/db/database.dart';

extension AccountControlDao on AppDatabase {
  Stream<List<Account>> watchAccounts() {
    return (select(accounts)..orderBy([(a) => OrderingTerm.asc(a.createdAt)]))
        .watch();
  }

  Future<List<Account>> getAccounts() {
    return (select(accounts)..orderBy([(a) => OrderingTerm.asc(a.createdAt)]))
        .get();
  }

  Future<String> createAccount(String name) async {
    final normalized = name.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('アカウント名は必須です');
    }

    final id = 'acc-${DateTime.now().millisecondsSinceEpoch}';
    await into(accounts).insert(
      AccountsCompanion.insert(
        id: id,
        name: normalized,
      ),
    );
    return id;
  }

  Future<void> renameAccount(String accountId, String newName) async {
    final normalized = newName.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('アカウント名は必須です');
    }

    await (update(accounts)..where((a) => a.id.equals(accountId))).write(
      AccountsCompanion(
        name: Value(normalized),
      ),
    );
  }

  Future<void> deleteAccount(String accountId) async {
    final totalAccounts = await getAccounts();
    if (totalAccounts.length <= 1) {
      throw StateError('最後の1アカウントは削除できません');
    }

    if (accountId == currentAccountId) {
      final fallback = totalAccounts.firstWhere((a) => a.id != accountId);
      await setActiveScope(accountId: fallback.id, groupId: null);
    }

    await (delete(accounts)..where((a) => a.id.equals(accountId))).go();
  }

  Stream<List<UserGroup>> watchGroupsForCurrentAccount() {
    return (select(userGroups)
          ..where((g) => g.accountId.equals(currentAccountId))
          ..orderBy([(g) => OrderingTerm.asc(g.createdAt)]))
        .watch();
  }

  Future<int> createGroup(String name, {String? description}) {
    final normalized = name.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('グループ名は必須です');
    }

    return into(userGroups).insert(
      UserGroupsCompanion.insert(
        accountId: currentAccountId,
        name: normalized,
        description: Value(
            description?.trim().isEmpty ?? true ? null : description!.trim()),
      ),
    );
  }

  Future<void> renameGroup(int groupId, String name) async {
    final normalized = name.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('グループ名は必須です');
    }

    await (update(userGroups)..where((g) => g.id.equals(groupId))).write(
      UserGroupsCompanion(
        name: Value(normalized),
      ),
    );
  }

  Future<void> deleteGroup(int groupId) async {
    if (currentGroupId == groupId) {
      await setActiveGroup(null);
    }

    await (delete(userGroups)..where((g) => g.id.equals(groupId))).go();
  }
}
