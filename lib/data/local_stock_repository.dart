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
  Stream<List<User>> watchUsers() => _db.watchUsers();

  @override
  Future<int> registerUser({
    required String username,
    required String password,
  }) =>
      _db.registerUser(username: username, password: password);

  @override
  Future<void> login({required String username, required String password}) =>
      _db.login(username: username, password: password);

  @override
  Future<void> logout() => _db.logout();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _db.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  @override
  Future<User?> getCurrentUser() => _db.getCurrentUser();

  @override
  Stream<List<Account>> watchAccounts() => _db.watchAccounts();

  @override
  Future<String> createAccount(String name,
          {required String accountPassword}) =>
      _db.createAccount(name, accountPassword: accountPassword);

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
  Future<void> leaveGroup(int groupId) => _db.leaveGroup(groupId);

  @override
  Stream<List<GroupMemberView>> watchGroupMembers(int groupId) =>
      _db.watchGroupMembers(groupId);

  @override
  Future<int> inviteUserToGroup({
    required int groupId,
    required String inviteeUsername,
  }) =>
      _db.inviteUserToGroup(groupId: groupId, inviteeUsername: inviteeUsername);

  @override
  Stream<List<GroupInviteView>> watchPendingInvitesForCurrentUser() =>
      _db.watchPendingInvitesForCurrentUser();

  @override
  Stream<List<GroupInviteView>> watchSentInvitesForCurrentUser() =>
      _db.watchSentInvitesForCurrentUser();

  @override
  Future<void> acceptInvite(int inviteId) => _db.acceptInvite(inviteId);

  @override
  Future<void> declineInvite(int inviteId) => _db.declineInvite(inviteId);

  @override
  Future<void> setActiveAccount(
    String accountId, {
    required String accountPassword,
  }) =>
      _db.switchActiveAccount(
        accountId: accountId,
        accountPassword: accountPassword,
      );

  @override
  Future<void> setAccountPasswordIfUnset(
    String accountId, {
    required String newPassword,
  }) =>
      _db.setAccountPasswordIfUnset(
        accountId: accountId,
        newPassword: newPassword,
      );

  @override
  Future<void> setActiveGroup(int? groupId) => _db.setActiveGroup(groupId);

  @override
  Future<void> setActiveUser(int? userId) => _db.setActiveUser(userId);
}
