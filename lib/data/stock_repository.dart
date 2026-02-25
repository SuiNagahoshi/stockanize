import 'package:stockanize/db/database.dart';

abstract class StockRepository {
  Stream<List<Part>> watchParts();
  Future<int> deletePart(int id);

  Stream<List<Account>> watchAccounts();
  Future<String> createAccount(String name);
  Future<void> renameAccount(String accountId, String newName);
  Future<void> deleteAccount(String accountId);

  Stream<List<UserGroup>> watchGroupsForCurrentAccount();
  Future<int> createGroup(String name, {String? description});
  Future<void> renameGroup(int groupId, String name);
  Future<void> deleteGroup(int groupId);

  Future<void> setActiveAccount(String accountId);
  Future<void> setActiveGroup(int? groupId);
}
