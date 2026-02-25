import 'package:stockanize/data/stock_repository.dart';
import 'package:stockanize/db/account_control.dart';
import 'package:stockanize/db/database.dart';
import 'package:stockanize/db/parts.dart';

class LocalStockRepository implements StockRepository {
  LocalStockRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Part>> watchParts() => _db.watchParts();

  @override
  Future<int> deletePart(int id) => _db.deletePart(id);

  @override
  Stream<List<Account>> watchAccounts() => _db.watchAccounts();

  @override
  Future<String> createAccount(String name) => _db.createAccount(name);

  @override
  Future<void> renameAccount(String accountId, String newName) =>
      _db.renameAccount(accountId, newName);

  @override
  Future<void> deleteAccount(String accountId) => _db.deleteAccount(accountId);

  @override
  Stream<List<UserGroup>> watchGroupsForCurrentAccount() =>
      _db.watchGroupsForCurrentAccount();

  @override
  Future<int> createGroup(String name, {String? description}) =>
      _db.createGroup(name, description: description);

  @override
  Future<void> renameGroup(int groupId, String name) =>
      _db.renameGroup(groupId, name);

  @override
  Future<void> deleteGroup(int groupId) => _db.deleteGroup(groupId);

  @override
  Future<void> setActiveAccount(String accountId) =>
      _db.setActiveAccount(accountId);

  @override
  Future<void> setActiveGroup(int? groupId) => _db.setActiveGroup(groupId);
}
