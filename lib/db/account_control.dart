import 'dart:math';

import 'package:drift/drift.dart';
import 'package:stockanize/db/database.dart';
import 'package:stockanize/security/password_hasher.dart';

class GroupMemberView {
  const GroupMemberView({
    required this.membershipId,
    required this.groupId,
    required this.userId,
    required this.username,
    required this.role,
  });

  final int membershipId;
  final int groupId;
  final int userId;
  final String username;
  final String role;
}

class GroupInviteView {
  const GroupInviteView({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.inviteeUsername,
    required this.token,
    required this.status,
    required this.expiresAt,
  });

  final int id;
  final int groupId;
  final String groupName;
  final String inviteeUsername;
  final String token;
  final String status;
  final DateTime expiresAt;
}

extension AccountControlDao on AppDatabase {
  Stream<List<User>> watchUsers() {
    return (select(users)..orderBy([(u) => OrderingTerm.asc(u.username)]))
        .watch();
  }

  Future<int> registerUser({
    required String username,
    required String password,
  }) async {
    final normalized = username.trim().toLowerCase();
    _validateUsername(normalized);
    _validatePassword(password);

    final salt = PasswordHasher.createSalt();
    final passwordHash = PasswordHasher.hash(password, salt);

    final userId = await into(users).insert(
      UsersCompanion.insert(
        username: normalized,
        passwordHash: passwordHash,
        passwordSalt: salt,
      ),
    );

    final createdUser =
        await (select(users)..where((u) => u.id.equals(userId))).getSingle();
    final personalAccountId = await _ensurePersonalAccount(createdUser);
    await setActiveScope(
      accountId: personalAccountId,
      groupId: null,
      userId: createdUser.id,
    );
    return userId;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final normalized = username.trim().toLowerCase();
    final user = await (select(users)
          ..where((u) => u.username.equals(normalized)))
        .getSingleOrNull();

    if (user == null) {
      throw StateError('ユーザが見つかりません');
    }

    final isValid = _verifyPasswordWithTolerance(
      password: password,
      salt: user.passwordSalt,
      expectedHash: user.passwordHash,
    );

    if (!isValid) {
      throw StateError('パスワードが正しくありません');
    }

    final personalAccountId = await _ensurePersonalAccount(user);
    await setActiveScope(
      accountId: personalAccountId,
      groupId: null,
      userId: user.id,
    );
  }

  Future<void> logout() async {
    await setActiveUser(null);
  }

  Future<void> switchActiveAccount({
    required String accountId,
    required String currentPassword,
  }) async {
    final user = await _requireCurrentUserAndVerifyPassword(currentPassword);
    await setActiveAccount(accountId, userId: user.id);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final userId = currentUserId;
    if (userId == null) {
      throw StateError('ログインが必要です');
    }

    final currentUser =
        await (select(users)..where((u) => u.id.equals(userId))).getSingle();

    final currentValid = _verifyPasswordWithTolerance(
      password: currentPassword,
      salt: currentUser.passwordSalt,
      expectedHash: currentUser.passwordHash,
    );
    if (!currentValid) {
      throw StateError('現在のパスワードが正しくありません');
    }

    _validatePassword(newPassword);

    final salt = PasswordHasher.createSalt();
    final passwordHash = PasswordHasher.hash(newPassword, salt);

    await (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        passwordSalt: Value(salt),
        passwordHash: Value(passwordHash),
      ),
    );
  }

  Future<User?> getCurrentUser() async {
    final userId = currentUserId;
    if (userId == null) return null;
    return (select(users)..where((u) => u.id.equals(userId))).getSingleOrNull();
  }

  Stream<List<Account>> watchAccounts() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value(const <Account>[]);
    }

    final query = select(accounts).join([
      innerJoin(
          accountMembers, accountMembers.accountId.equalsExp(accounts.id)),
    ])
      ..where(accountMembers.userId.equals(userId))
      ..orderBy([OrderingTerm.asc(accounts.createdAt)]);

    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(accounts)).toList();
    });
  }

  Future<List<Account>> getAccounts() async {
    final userId = currentUserId;
    if (userId == null) {
      return const <Account>[];
    }

    final query = select(accounts).join([
      innerJoin(
          accountMembers, accountMembers.accountId.equalsExp(accounts.id)),
    ])
      ..where(accountMembers.userId.equals(userId))
      ..orderBy([OrderingTerm.asc(accounts.createdAt)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(accounts)).toList();
  }

  Future<String> createAccount(
    String name, {
    required String currentPassword,
  }) async {
    final normalized = name.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('アカウント名は必須です');
    }

    final user = await _requireCurrentUserAndVerifyPassword(currentPassword);

    final id = 'acc-${DateTime.now().millisecondsSinceEpoch}';
    await into(accounts).insert(
      AccountsCompanion.insert(
        id: id,
        name: normalized,
      ),
    );

    await into(accountMembers).insert(
      AccountMembersCompanion.insert(
        accountId: id,
        userId: user.id,
        role: const Value('owner'),
      ),
    );

    await setActiveScope(accountId: id, groupId: null, userId: user.id);
    return id;
  }

  Future<void> renameAccount(String accountId, String newName) async {
    final normalized = newName.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('アカウント名は必須です');
    }

    await _ensureAccountMember(accountId);

    await (update(accounts)..where((a) => a.id.equals(accountId))).write(
      AccountsCompanion(
        name: Value(normalized),
      ),
    );
  }

  Future<void> deleteAccount(String accountId) async {
    await _ensureAccountMember(accountId);

    final accountList = await getAccounts();
    if (accountList.length <= 1) {
      throw StateError('最後の1アカウントは削除できません');
    }

    if (accountId == currentAccountId) {
      final fallback = accountList.firstWhere((a) => a.id != accountId);
      await setActiveScope(
        accountId: fallback.id,
        groupId: null,
        userId: currentUserId,
      );
    }

    await (delete(accounts)..where((a) => a.id.equals(accountId))).go();
  }

  Future<void> addUserToAccount({
    required String accountId,
    required String username,
    String role = 'member',
  }) async {
    await _ensureAccountMember(accountId);
    final normalized = username.trim().toLowerCase();

    final user = await (select(users)
          ..where((u) => u.username.equals(normalized)))
        .getSingleOrNull();
    if (user == null) {
      throw StateError('招待対象ユーザが存在しません');
    }

    await _ensureAccountMemberRow(
      accountId: accountId,
      userId: user.id,
      role: role,
    );
  }

  Stream<List<UserGroup>> watchGroupsForCurrentAccount() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value(const <UserGroup>[]);
    }

    final query = select(userGroups).join([
      innerJoin(groupMembers, groupMembers.groupId.equalsExp(userGroups.id)),
    ])
      ..where(userGroups.accountId.equals(currentAccountId))
      ..where(groupMembers.userId.equals(userId))
      ..orderBy([OrderingTerm.asc(userGroups.createdAt)]);

    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(userGroups)).toList();
    });
  }

  Future<int> createGroup(String name, {String? description}) async {
    final user = await _requireCurrentUser();
    final accountId = await _ensureUsableAccountForUser(user);

    final normalized = name.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('グループ名は必須です');
    }

    final groupId = await into(userGroups).insert(
      UserGroupsCompanion.insert(
        accountId: accountId,
        name: normalized,
        description: Value(
          description?.trim().isEmpty ?? true ? null : description!.trim(),
        ),
      ),
    );

    await into(groupMembers).insert(
      GroupMembersCompanion.insert(
        groupId: groupId,
        userId: user.id,
        role: const Value('admin'),
      ),
    );

    if (accountId != currentAccountId) {
      await setActiveScope(
          accountId: accountId, groupId: groupId, userId: user.id);
    }

    return groupId;
  }

  Future<void> renameGroup(int groupId, String name) async {
    await _ensureGroupMember(groupId);

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
    await _ensureGroupMember(groupId);

    if (currentGroupId == groupId) {
      await setActiveGroup(null);
    }

    await (delete(userGroups)..where((g) => g.id.equals(groupId))).go();
  }

  Future<void> leaveGroup(int groupId) async {
    final userId = currentUserId;
    if (userId == null) {
      throw StateError('ログインが必要です');
    }

    final membership = await (select(groupMembers)
          ..where((m) => m.groupId.equals(groupId))
          ..where((m) => m.userId.equals(userId)))
        .getSingleOrNull();
    if (membership == null) {
      throw StateError('既にこのグループに参加していません');
    }

    await (delete(groupMembers)..where((m) => m.id.equals(membership.id))).go();

    if (currentGroupId == groupId) {
      await setActiveGroup(null);
    }
  }

  Stream<List<GroupMemberView>> watchGroupMembers(int groupId) {
    final query = select(groupMembers).join([
      innerJoin(users, users.id.equalsExp(groupMembers.userId)),
    ])
      ..where(groupMembers.groupId.equals(groupId));

    return query.watch().map((rows) {
      return rows.map((row) {
        final membership = row.readTable(groupMembers);
        final user = row.readTable(users);
        return GroupMemberView(
          membershipId: membership.id,
          groupId: membership.groupId,
          userId: user.id,
          username: user.username,
          role: membership.role,
        );
      }).toList()
        ..sort((a, b) => a.username.compareTo(b.username));
    });
  }

  Future<int> inviteUserToGroup({
    required int groupId,
    required String inviteeUsername,
  }) async {
    final inviter = await _requireCurrentUser();
    await _ensureGroupMember(groupId);

    final normalized = inviteeUsername.trim().toLowerCase();
    _validateUsername(normalized);

    final token = _generateInviteToken();
    final expiresAt = DateTime.now().add(const Duration(days: 7));

    return into(groupInvites).insert(
      GroupInvitesCompanion.insert(
        groupId: groupId,
        invitedByUserId: Value(inviter.id),
        inviteeUsername: normalized,
        token: token,
        expiresAt: expiresAt,
      ),
    );
  }

  Stream<List<GroupInviteView>> watchPendingInvitesForCurrentUser() async* {
    final user = await getCurrentUser();
    if (user == null) {
      yield const <GroupInviteView>[];
      return;
    }

    final username = user.username;
    final query = select(groupInvites).join([
      innerJoin(userGroups, userGroups.id.equalsExp(groupInvites.groupId)),
    ])
      ..where(groupInvites.inviteeUsername.equals(username))
      ..where(groupInvites.status.equals('pending'));

    yield* query.watch().map((rows) {
      return rows.map((row) {
        final invite = row.readTable(groupInvites);
        final group = row.readTable(userGroups);
        return GroupInviteView(
          id: invite.id,
          groupId: invite.groupId,
          groupName: group.name,
          inviteeUsername: invite.inviteeUsername,
          token: invite.token,
          status: invite.status,
          expiresAt: invite.expiresAt,
        );
      }).toList()
        ..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  Stream<List<GroupInviteView>> watchSentInvitesForCurrentUser() async* {
    final userId = currentUserId;
    if (userId == null) {
      yield const <GroupInviteView>[];
      return;
    }

    final query = select(groupInvites).join([
      innerJoin(userGroups, userGroups.id.equalsExp(groupInvites.groupId)),
    ])
      ..where(groupInvites.invitedByUserId.equals(userId))
      ..where(groupInvites.status.equals('pending'));

    yield* query.watch().map((rows) {
      return rows.map((row) {
        final invite = row.readTable(groupInvites);
        final group = row.readTable(userGroups);
        return GroupInviteView(
          id: invite.id,
          groupId: invite.groupId,
          groupName: group.name,
          inviteeUsername: invite.inviteeUsername,
          token: invite.token,
          status: invite.status,
          expiresAt: invite.expiresAt,
        );
      }).toList()
        ..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  Future<void> acceptInvite(int inviteId) async {
    final user = await _requireCurrentUser();

    final invite = await (select(groupInvites)
          ..where((i) => i.id.equals(inviteId)))
        .getSingleOrNull();
    if (invite == null) {
      throw StateError('招待が存在しません');
    }

    if (invite.status != 'pending') {
      throw StateError('この招待は既に処理済みです');
    }

    if (invite.inviteeUsername != user.username) {
      throw StateError('この招待は現在のユーザ向けではありません');
    }

    if (invite.expiresAt.isBefore(DateTime.now())) {
      throw StateError('招待の有効期限が切れています');
    }

    final group = await (select(userGroups)
          ..where((g) => g.id.equals(invite.groupId)))
        .getSingleOrNull();
    if (group == null) {
      throw StateError('招待先グループが存在しません');
    }

    await transaction(() async {
      await _ensureAccountMemberRow(
        accountId: group.accountId,
        userId: user.id,
        role: 'member',
      );

      await _ensureGroupMemberRow(
        groupId: invite.groupId,
        userId: user.id,
        role: 'member',
      );

      await (update(groupInvites)..where((i) => i.id.equals(inviteId))).write(
        const GroupInvitesCompanion(
          status: Value('accepted'),
        ),
      );
    });

    await setActiveScope(
      accountId: group.accountId,
      groupId: group.id,
      userId: user.id,
    );
  }

  Future<void> declineInvite(int inviteId) async {
    final user = await _requireCurrentUser();

    final invite = await (select(groupInvites)
          ..where((i) => i.id.equals(inviteId)))
        .getSingleOrNull();
    if (invite == null) {
      throw StateError('招待が存在しません');
    }

    if (invite.inviteeUsername != user.username) {
      throw StateError('この招待は現在のユーザ向けではありません');
    }

    await (update(groupInvites)..where((i) => i.id.equals(inviteId))).write(
      const GroupInvitesCompanion(
        status: Value('declined'),
      ),
    );
  }

  Future<User> _requireCurrentUser() async {
    final user = await getCurrentUser();
    if (user == null) {
      throw StateError('ログインが必要です');
    }
    return user;
  }

  Future<User> _requireCurrentUserAndVerifyPassword(String password) async {
    final user = await _requireCurrentUser();
    final verified = _verifyPasswordWithTolerance(
      password: password,
      salt: user.passwordSalt,
      expectedHash: user.passwordHash,
    );
    if (!verified) {
      throw StateError('パスワードが正しくありません');
    }
    return user;
  }

  bool _verifyPasswordWithTolerance({
    required String password,
    required String salt,
    required String expectedHash,
  }) {
    final rawMatched = PasswordHasher.verify(
      password: password,
      salt: salt,
      expectedHash: expectedHash,
    );
    if (rawMatched) return true;

    final trimmed = password.trim();
    if (trimmed == password) return false;

    return PasswordHasher.verify(
      password: trimmed,
      salt: salt,
      expectedHash: expectedHash,
    );
  }

  Future<void> _ensureAccountMember(String accountId) async {
    final userId = currentUserId;
    if (userId == null) {
      throw StateError('ログインが必要です');
    }

    final membership = await (select(accountMembers)
          ..where((m) => m.accountId.equals(accountId))
          ..where((m) => m.userId.equals(userId)))
        .getSingleOrNull();
    if (membership == null) {
      throw StateError('対象アカウントに所属していません');
    }
  }

  Future<void> _ensureGroupMember(int groupId) async {
    final userId = currentUserId;
    if (userId == null) {
      throw StateError('ログインが必要です');
    }

    final membership = await (select(groupMembers)
          ..where((m) => m.groupId.equals(groupId))
          ..where((m) => m.userId.equals(userId)))
        .getSingleOrNull();

    if (membership == null) {
      throw StateError('対象グループに参加していません');
    }
  }

  void _validateUsername(String username) {
    final rule = RegExp(r'^[a-z0-9._-]{3,32}$');
    if (!rule.hasMatch(username)) {
      throw ArgumentError('ユーザ名は3〜32文字の英小文字/数字/._-のみ使用可能です');
    }
  }

  void _validatePassword(String password) {
    if (password.trim().length < 8) {
      throw ArgumentError('パスワードは8文字以上で入力してください');
    }
  }

  String _generateInviteToken() {
    final random = Random.secure();
    final value = List<int>.generate(16, (_) => random.nextInt(256));
    return value.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<String> _ensurePersonalAccount(User user) async {
    final accountId = 'acc-user-${user.id}';
    final accountName = user.username;

    await into(accounts).insertOnConflictUpdate(
      AccountsCompanion.insert(
        id: accountId,
        name: accountName,
      ),
    );

    await _ensureAccountMemberRow(
      accountId: accountId,
      userId: user.id,
      role: 'owner',
    );

    return accountId;
  }

  Future<String> _ensureUsableAccountForUser(User user) async {
    final currentMembership = await (select(accountMembers)
          ..where((m) => m.accountId.equals(currentAccountId))
          ..where((m) => m.userId.equals(user.id)))
        .getSingleOrNull();
    if (currentMembership != null) {
      return currentAccountId;
    }

    final memberships = await (select(accountMembers)
          ..where((m) => m.userId.equals(user.id))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
    if (memberships.isNotEmpty) {
      return memberships.first.accountId;
    }

    return _ensurePersonalAccount(user);
  }

  Future<void> _ensureAccountMemberRow({
    required String accountId,
    required int userId,
    required String role,
  }) async {
    final existing = await (select(accountMembers)
          ..where((m) => m.accountId.equals(accountId))
          ..where((m) => m.userId.equals(userId)))
        .getSingleOrNull();
    if (existing != null) return;

    await into(accountMembers).insert(
      AccountMembersCompanion.insert(
        accountId: accountId,
        userId: userId,
        role: Value(role),
      ),
    );
  }

  Future<void> _ensureGroupMemberRow({
    required int groupId,
    required int userId,
    required String role,
  }) async {
    final existing = await (select(groupMembers)
          ..where((m) => m.groupId.equals(groupId))
          ..where((m) => m.userId.equals(userId)))
        .getSingleOrNull();
    if (existing != null) return;

    await into(groupMembers).insert(
      GroupMembersCompanion.insert(
        groupId: groupId,
        userId: userId,
        role: Value(role),
      ),
    );
  }
}
