import 'package:flutter/material.dart';
import 'package:stockanize/data/stock_repository.dart';
import 'package:stockanize/db/account_control.dart';
import 'package:stockanize/db/database.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({
    super.key,
    required this.db,
    required this.repository,
    required this.onScopeChanged,
  });

  final AppDatabase db;
  final StockRepository repository;
  final VoidCallback onScopeChanged;

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _loginUserController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerUserController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerPasswordConfirmController = TextEditingController();
  bool _busy = false;
  bool _showRegisterForm = false;

  @override
  void dispose() {
    _loginUserController.dispose();
    _loginPasswordController.dispose();
    _registerUserController.dispose();
    _registerPasswordController.dispose();
    _registerPasswordConfirmController.dispose();
    super.dispose();
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _run(Future<void> Function() task, {String? okMessage}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await task();
      widget.onScopeChanged();
      if (mounted) setState(() {});
      if (okMessage != null) _snack(okMessage);
    } catch (e) {
      _snack('失敗: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _login() async {
    await _run(() async {
      await widget.repository.login(
        username: _loginUserController.text,
        password: _loginPasswordController.text,
      );
      _loginPasswordController.clear();
    });
  }

  Future<void> _register() async {
    if (_registerPasswordController.text !=
        _registerPasswordConfirmController.text) {
      _snack('確認用パスワードが一致しません');
      return;
    }

    await _run(() async {
      await widget.repository.registerUser(
        username: _registerUserController.text,
        password: _registerPasswordController.text,
      );
      _registerUserController.clear();
      _registerPasswordController.clear();
      _registerPasswordConfirmController.clear();
      _showRegisterForm = false;
    });
  }

  Future<void> _showChangePasswordDialog() async {
    final currentController = TextEditingController();
    final nextController = TextEditingController();
    final confirmController = TextEditingController();

    final payload = await showDialog<_ChangePasswordPayload>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('パスワード変更'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                decoration: const InputDecoration(labelText: '現在のパスワード'),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nextController,
                decoration: const InputDecoration(labelText: '新しいパスワード'),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmController,
                decoration: const InputDecoration(labelText: '新しいパスワード（確認）'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              if (nextController.text != confirmController.text) {
                _snack('確認用パスワードが一致しません');
                return;
              }
              Navigator.of(dialogContext).pop(
                _ChangePasswordPayload(
                  currentPassword: currentController.text,
                  newPassword: nextController.text,
                ),
              );
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );

    if (payload == null) return;
    await _run(
      () => widget.repository.changePassword(
        currentPassword: payload.currentPassword,
        newPassword: payload.newPassword,
      ),
      okMessage: 'パスワードを更新しました',
    );
  }

  Future<void> _showCreateAccountDialog() async {
    final nameController = TextEditingController();
    final passwordController = TextEditingController();

    final payload = await showDialog<_CreateAccountPayload>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('アカウント作成'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'アカウント名'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'パスワード確認'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(
                _CreateAccountPayload(
                  name: nameController.text,
                  password: passwordController.text,
                ),
              );
            },
            child: const Text('作成'),
          ),
        ],
      ),
    );

    if (payload == null) return;
    await _run(() async {
      final id = await widget.repository.createAccount(
        payload.name,
        currentPassword: payload.password,
      );
      await widget.repository.setActiveAccount(id);
    });
  }

  Future<void> _showAccountSwitchDialog(List<Account> accounts) async {
    final accountId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('アカウント切り替え'),
        children: accounts
            .map(
              (account) => SimpleDialogOption(
                onPressed: () => Navigator.of(dialogContext).pop(account.id),
                child: Text(
                  account.name,
                  style: TextStyle(
                    fontWeight: account.id == widget.db.currentAccountId
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    if (accountId == null) return;
    await _run(() => widget.repository.setActiveAccount(accountId));
  }

  Future<void> _showCreateGroupDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final payload = await showDialog<_CreateGroupPayload>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('グループ作成'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'グループ名'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: '説明（任意）'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(
                _CreateGroupPayload(
                  name: nameController.text,
                  description: descController.text,
                ),
              );
            },
            child: const Text('作成'),
          ),
        ],
      ),
    );

    if (payload == null) return;
    await _run(() async {
      final groupId = await widget.repository.createGroup(
        payload.name,
        description: payload.description,
      );
      await widget.repository.setActiveGroup(groupId);
    });
  }

  Future<void> _showInviteDialog(int groupId) async {
    final inviteController = TextEditingController();

    final invitee = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('メンバー招待'),
        content: TextField(
          controller: inviteController,
          decoration: const InputDecoration(labelText: '招待するユーザ名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(inviteController.text),
            child: const Text('招待送信'),
          ),
        ],
      ),
    );

    if (invitee == null) return;
    await _run(() async {
      await widget.repository.inviteUserToGroup(
        groupId: groupId,
        inviteeUsername: invitee,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body: FutureBuilder<User?>(
        future: widget.repository.getCurrentUser(),
        builder: (context, userSnapshot) {
          final user = userSnapshot.data;
          if (user == null) {
            return _buildLoggedOut();
          }

          return StreamBuilder<List<Account>>(
            stream: widget.repository.watchAccounts(),
            builder: (context, accountSnapshot) {
              final accounts = accountSnapshot.data ?? const <Account>[];
              return StreamBuilder<List<UserGroup>>(
                stream: widget.repository.watchGroupsForCurrentAccount(),
                builder: (context, groupSnapshot) {
                  final groups = groupSnapshot.data ?? const <UserGroup>[];
                  return _buildLoggedIn(user, accounts, groups);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoggedOut() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('ログイン', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _loginUserController,
                  decoration: const InputDecoration(labelText: 'ユーザ名'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _loginPasswordController,
                  decoration: const InputDecoration(labelText: 'パスワード'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _busy ? null : _login,
                    child: const Text('ログイン'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () {
                          setState(() {
                            _showRegisterForm = !_showRegisterForm;
                          });
                        },
                  child: Text(
                    _showRegisterForm ? '新規登録を閉じる' : 'アカウントをお持ちでない方は新規登録',
                  ),
                ),
                if (_showRegisterForm) ...[
                  const Divider(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('新規登録', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ユーザ名: 3-32文字（英小文字/数字/._-）\n'
                      'パスワード: 8文字以上',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _registerUserController,
                    decoration: const InputDecoration(labelText: 'ユーザ名'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _registerPasswordController,
                    decoration: const InputDecoration(labelText: 'パスワード'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _registerPasswordConfirmController,
                    decoration: const InputDecoration(labelText: 'パスワード（確認）'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: _busy ? null : _register,
                      child: const Text('登録'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedIn(
      User user, List<Account> accounts, List<UserGroup> groups) {
    final activeAccount = accounts.cast<Account?>().firstWhere(
        (a) => a?.id == widget.db.currentAccountId,
        orElse: () => null);
    final activeGroup = groups.cast<UserGroup?>().firstWhere(
        (g) => g?.id == widget.db.currentGroupId,
        orElse: () => null);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.username, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                Text(
                    'アカウント: ${activeAccount?.name ?? widget.db.currentAccountId}'),
                Text('グループ: ${activeGroup?.name ?? '未選択'}'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(
                      onPressed: _busy
                          ? null
                          : () => _showAccountSwitchDialog(accounts),
                      child: const Text('アカウント切り替え'),
                    ),
                    FilledButton.tonal(
                      onPressed: _busy ? null : _showCreateAccountDialog,
                      child: const Text('アカウント作成'),
                    ),
                    OutlinedButton(
                      onPressed: _busy ? null : _showChangePasswordDialog,
                      child: const Text('パスワード変更'),
                    ),
                    OutlinedButton(
                      onPressed: _busy
                          ? null
                          : () async {
                              await _run(() async {
                                await widget.repository.logout();
                              });
                            },
                      child: const Text('ログアウト'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('グループ', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(
                      onPressed: _busy ? null : _showCreateGroupDialog,
                      child: const Text('作成'),
                    ),
                    FilledButton.tonal(
                      onPressed: (_busy || activeGroup == null)
                          ? null
                          : () => _showInviteDialog(activeGroup.id),
                      child: const Text('招待'),
                    ),
                    OutlinedButton(
                      onPressed: (_busy || activeGroup == null)
                          ? null
                          : () async {
                              await _run(() async {
                                await widget.repository
                                    .leaveGroup(activeGroup.id);
                              }, okMessage: 'グループから脱退しました');
                            },
                      child: const Text('脱退'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (groups.isEmpty)
                  const Text('参加中のグループはありません')
                else
                  ...groups.map((group) {
                    final isActive = group.id == widget.db.currentGroupId;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(group.name),
                      subtitle: Text(group.description ?? ''),
                      trailing: TextButton(
                        onPressed: _busy
                            ? null
                            : () async {
                                await _run(() async {
                                  await widget.repository
                                      .setActiveGroup(group.id);
                                });
                              },
                        child: Text(isActive ? '使用中' : '切り替え'),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (activeGroup != null)
          StreamBuilder<List<GroupMemberView>>(
            stream: widget.repository.watchGroupMembers(activeGroup.id),
            builder: (context, membersSnapshot) {
              final members = membersSnapshot.data ?? const <GroupMemberView>[];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('メンバー (${members.length})',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      if (members.isEmpty)
                        const Text('メンバーはいません')
                      else
                        ...members.map((member) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.person_outline),
                              title: Text(member.username),
                              subtitle: Text(member.role),
                            )),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 12),
        StreamBuilder<List<GroupInviteView>>(
          stream: widget.repository.watchPendingInvitesForCurrentUser(),
          builder: (context, receivedSnapshot) {
            final received = receivedSnapshot.data ?? const <GroupInviteView>[];
            return StreamBuilder<List<GroupInviteView>>(
              stream: widget.repository.watchSentInvitesForCurrentUser(),
              builder: (context, sentSnapshot) {
                final sent = sentSnapshot.data ?? const <GroupInviteView>[];
                if (received.isEmpty && sent.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '招待（受信 ${received.length} / 送信 ${sent.length}）',
                          style: const TextStyle(fontSize: 18),
                        ),
                        if (received.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text('受信した招待',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          ...received.map((invite) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(invite.groupName),
                                subtitle: Text('期限: ${invite.expiresAt}'),
                                trailing: Wrap(
                                  spacing: 8,
                                  children: [
                                    OutlinedButton(
                                      onPressed: _busy
                                          ? null
                                          : () async {
                                              await _run(() async {
                                                await widget.repository
                                                    .declineInvite(invite.id);
                                              });
                                            },
                                      child: const Text('辞退'),
                                    ),
                                    FilledButton(
                                      onPressed: _busy
                                          ? null
                                          : () async {
                                              await _run(() async {
                                                await widget.repository
                                                    .acceptInvite(invite.id);
                                              }, okMessage: 'グループに参加しました');
                                            },
                                      child: const Text('参加'),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                        if (sent.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text('送信した招待',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          ...sent.map((invite) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(invite.groupName),
                                subtitle:
                                    Text('招待先: ${invite.inviteeUsername}'),
                              )),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ChangePasswordPayload {
  const _ChangePasswordPayload({
    required this.currentPassword,
    required this.newPassword,
  });
  final String currentPassword;
  final String newPassword;
}

class _CreateAccountPayload {
  const _CreateAccountPayload({required this.name, required this.password});
  final String name;
  final String password;
}

class _CreateGroupPayload {
  const _CreateGroupPayload({required this.name, required this.description});
  final String name;
  final String description;
}
