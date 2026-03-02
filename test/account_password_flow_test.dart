import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockanize/db/account_control.dart';
import 'package:stockanize/db/database.dart';

void main() {
  group('Account password flow', () {
    late AppDatabase db;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      await db.initializeTenantContext();
      await db.registerUser(username: 'alice', password: 'alice-pass-123');
    });

    tearDown(() async {
      await db.close();
    });

    test('createAccount stores account password hash and salt', () async {
      final accountId = await db.createAccount('team-alpha',
          accountPassword: 'team-pass-123');

      final account = await (db.select(db.accounts)
            ..where((a) => a.id.equals(accountId)))
          .getSingle();

      expect(account.passwordHash, isNotNull);
      expect(account.passwordSalt, isNotNull);
      expect(account.passwordSetAt, isNotNull);
    });

    test('switchActiveAccount validates target account password', () async {
      final accountA =
          await db.createAccount('team-a', accountPassword: 'team-a-pass');
      final accountB =
          await db.createAccount('team-b', accountPassword: 'team-b-pass');

      expect(
        () => db.switchActiveAccount(
          accountId: accountA,
          accountPassword: 'wrong-password',
        ),
        throwsA(predicate((e) => e.toString().contains('アカウントパスワードが一致しません'))),
      );

      await db.switchActiveAccount(
        accountId: accountA,
        accountPassword: 'team-a-pass',
      );
      expect(db.currentAccountId, accountA);

      await db.switchActiveAccount(
        accountId: accountB,
        accountPassword: 'team-b-pass',
      );
      expect(db.currentAccountId, accountB);
    });

    test('legacy account requires password setup before switching', () async {
      await db.createAccount('team-main', accountPassword: 'team-main-pass');

      final accounts = await db.getAccounts();
      final legacyPersonal =
          accounts.firstWhere((a) => a.id.startsWith('acc-user-'));

      expect(
        () => db.switchActiveAccount(
          accountId: legacyPersonal.id,
          accountPassword: 'anything',
        ),
        throwsA(predicate((e) => e.toString().contains('アカウントパスワード未設定'))),
      );

      await db.setAccountPasswordIfUnset(
        accountId: legacyPersonal.id,
        newPassword: 'personal-pass-123',
      );

      await db.switchActiveAccount(
        accountId: legacyPersonal.id,
        accountPassword: 'personal-pass-123',
      );
      expect(db.currentAccountId, legacyPersonal.id);
    });

    test('login recovers orphan accounts into account_members', () async {
      const orphanId = 'acc-orphan-1';
      await db.into(db.accounts).insert(
            AccountsCompanion.insert(
              id: orphanId,
              name: 'orphan-account',
            ),
          );

      await db.logout();
      await db.login(username: 'alice', password: 'alice-pass-123');

      final accounts = await db.getAccounts();
      expect(accounts.any((a) => a.id == orphanId), isTrue);

      final membership = await (db.select(db.accountMembers)
            ..where((m) => m.accountId.equals(orphanId))
            ..where((m) => m.userId.equals(db.currentUserId!)))
          .getSingleOrNull();
      expect(membership, isNotNull);
      expect(membership!.role, 'owner');
    });

    test('createAccount rejects duplicate account name with clear error',
        () async {
      await db.createAccount('dup-name', accountPassword: 'dup-pass-123');

      expect(
        () => db.createAccount('dup-name', accountPassword: 'another-pass-123'),
        throwsA(
          predicate(
            (e) => e.toString().contains('同名のアカウントが既に存在します'),
          ),
        ),
      );
    });

    test('sent invites are scoped by current account', () async {
      await db.registerUser(username: 'bob', password: 'bob-pass-123');

      final accountA =
          await db.createAccount('scope-a', accountPassword: 'scope-a-pass');
      final groupA = await db.createGroup('group-a');
      await db.inviteUserToGroup(groupId: groupA, inviteeUsername: 'bob');

      final accountB =
          await db.createAccount('scope-b', accountPassword: 'scope-b-pass');
      final groupB = await db.createGroup('group-b');
      await db.inviteUserToGroup(groupId: groupB, inviteeUsername: 'bob');

      final sentOnB = await db.watchSentInvitesForCurrentUser().first;
      expect(sentOnB.length, 1);
      expect(sentOnB.first.groupName, 'group-b');

      await db.switchActiveAccount(
        accountId: accountA,
        accountPassword: 'scope-a-pass',
      );
      final sentOnA = await db.watchSentInvitesForCurrentUser().first;
      expect(sentOnA.length, 1);
      expect(sentOnA.first.groupName, 'group-a');

      await db.switchActiveAccount(
        accountId: accountB,
        accountPassword: 'scope-b-pass',
      );
      final sentOnBAgain = await db.watchSentInvitesForCurrentUser().first;
      expect(sentOnBAgain.length, 1);
      expect(sentOnBAgain.first.groupName, 'group-b');
    });

    test('repeated account switching keeps group scope consistent', () async {
      final accountA = await db.createAccount(
        'switch-a',
        accountPassword: 'switch-a-pass',
      );
      final groupA = await db.createGroup('switch-group-a');

      final accountB = await db.createAccount(
        'switch-b',
        accountPassword: 'switch-b-pass',
      );
      final groupB = await db.createGroup('switch-group-b');

      await db.switchActiveAccount(
        accountId: accountA,
        accountPassword: 'switch-a-pass',
      );
      await db.setActiveGroup(groupA);

      for (var i = 0; i < 10; i++) {
        await db.switchActiveAccount(
          accountId: accountB,
          accountPassword: 'switch-b-pass',
        );
        if (db.currentGroupId != null) {
          final group = await (db.select(db.userGroups)
                ..where((g) => g.id.equals(db.currentGroupId!)))
              .getSingleOrNull();
          expect(group?.accountId, db.currentAccountId);
        }

        await db.switchActiveAccount(
          accountId: accountA,
          accountPassword: 'switch-a-pass',
        );
        if (db.currentGroupId != null) {
          final group = await (db.select(db.userGroups)
                ..where((g) => g.id.equals(db.currentGroupId!)))
              .getSingleOrNull();
          expect(group?.accountId, db.currentAccountId);
        }
      }

      await db.switchActiveAccount(
        accountId: accountB,
        accountPassword: 'switch-b-pass',
      );
      await db.setActiveGroup(groupB);
      expect(db.currentGroupId, groupB);
    });

    test('pending invite is visible and can be handled across account switch',
        () async {
      await db.registerUser(username: 'charlie', password: 'charlie-pass-123');
      await db.logout();
      await db.login(username: 'charlie', password: 'charlie-pass-123');

      await db.createAccount('charlie-a', accountPassword: 'charlie-a-pass');
      final groupA = await db.createGroup('charlie-group-a');
      final inviteA =
          await db.inviteUserToGroup(groupId: groupA, inviteeUsername: 'alice');

      await db.createAccount('charlie-b', accountPassword: 'charlie-b-pass');
      final groupB = await db.createGroup('charlie-group-b');
      final inviteB =
          await db.inviteUserToGroup(groupId: groupB, inviteeUsername: 'alice');

      await db.logout();
      await db.login(username: 'alice', password: 'alice-pass-123');

      final pending = await db.watchPendingInvitesForCurrentUser().first;
      expect(pending.map((e) => e.id), containsAll([inviteA, inviteB]));

      await db.acceptInvite(inviteA);
      final accountA = await (db.select(db.userGroups)
            ..where((g) => g.id.equals(groupA)))
          .map((row) => row.accountId)
          .getSingle();
      expect(db.currentAccountId, accountA);
      expect(db.currentGroupId, groupA);

      await db.declineInvite(inviteB);
      final inviteBStatus = await (db.select(db.groupInvites)
            ..where((i) => i.id.equals(inviteB)))
          .map((row) => row.status)
          .getSingle();
      expect(inviteBStatus, 'declined');
    });
  });
}
