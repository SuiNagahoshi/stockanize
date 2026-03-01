import 'package:stockanize/db/account_control.dart';
import 'package:stockanize/db/database.dart';

abstract class StockRepository {
  Stream<List<Part>> watchParts();
  Future<int> deletePart(int id);

  Stream<List<User>> watchUsers();
  Future<int> registerUser(
      {required String username, required String password});
  Future<void> login({required String username, required String password});
  Future<void> logout();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<User?> getCurrentUser();

  Stream<List<Account>> watchAccounts();
  Future<String> createAccount(String name, {required String accountPassword});
  Future<void> renameAccount(String accountId, String newName);
  Future<void> deleteAccount(String accountId);

  Stream<List<UserGroup>> watchGroupsForCurrentAccount();
  Future<int> createGroup(String name, {String? description});
  Future<void> renameGroup(int groupId, String name);
  Future<void> deleteGroup(int groupId);
  Future<void> leaveGroup(int groupId);

  Stream<List<GroupMemberView>> watchGroupMembers(int groupId);
  Future<int> inviteUserToGroup({
    required int groupId,
    required String inviteeUsername,
  });
  Stream<List<GroupInviteView>> watchPendingInvitesForCurrentUser();
  Stream<List<GroupInviteView>> watchSentInvitesForCurrentUser();
  Future<void> acceptInvite(int inviteId);
  Future<void> declineInvite(int inviteId);

  Future<void> setActiveAccount(
    String accountId, {
    required String accountPassword,
  });
  Future<void> setAccountPasswordIfUnset(
    String accountId, {
    required String newPassword,
  });
  Future<void> setActiveGroup(int? groupId);
  Future<void> setActiveUser(int? userId);
}
