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

  bool _busy = false;

  @override
  void dispose() {
    _loginUserController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _run(Future<void> Function() task) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await task();
      widget.onScopeChanged();
      if (mounted) setState(() {});
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

  Future<void> _showRegisterDialog() async {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新規登録'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ユーザ名: 3-32文字（英小文字/数字/._-）\n'
                  'パスワード: 8文字以上の英数字または記号',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'ユーザ名'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmController,
                decoration: const InputDecoration(labelText: 'パスワード（確認）'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () async {
              if (passwordController.text != confirmController.text) {
                _snack('確認用パスワードが一致しません');
                return;
              }

              await _run(() async {
                await widget.repository.registerUser(
                  username: usernameController.text,
                  password: passwordController.text,
                );
              });

              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text('登録'),
          ),
        ],
      ),
    );

    usernameController.dispose();
    passwordController.dispose();
    confirmController.dispose();
  }

  Future<void> _showChangePasswordDialog() async {
    final currentController = TextEditingController();
    final nextController = TextEditingController();
    final confirmController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () async {
              if (nextController.text != confirmController.text) {
                _snack('確認用パスワードが一致しません');
                return;
              }

              await _run(() async {
                await widget.repository.changePassword(
                  currentPassword: currentController.text,
                  newPassword: nextController.text,
                );
              });

              if (!mounted) return;
              Navigator.of(context).pop();
              _snack('パスワードを更新しました');
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );

    currentController.dispose();
    nextController.dispose();
    confirmController.dispose();
  }

  Future<void> _showCreateAccountDialog() async {
    final nameController = TextEditingController();
    final passwordController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () async {
              await _run(() async {
                final id = await widget.repository.createAccount(
                  nameController.text,
                  currentPassword: passwordController.text,
                );
                await widget.repository.setActiveAccount(id);
              });

              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text('作成'),
          ),
        ],
      ),
    );

    nameController.dispose();
    passwordController.dispose();
  }

  Future<void> _showCreateGroupDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () async {
              await _run(() async {
                final groupId = await widget.repository.createGroup(
                  nameController.text,
                  description: descController.text,
                );
                await widget.repository.setActiveGroup(groupId);
              });

              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text('作成'),
          ),
        ],
      ),
    );

    nameController.dispose();
    descController.dispose();
  }

  Future<void> _showInviteDialog(int groupId) async {
    final inviteController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('メンバー招待'),
        content: TextField(
          controller: inviteController,
          decoration: const InputDecoration(labelText: '招待するユーザ名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () async {
              await _run(() async {
                await widget.repository.inviteUserToGroup(
                  groupId: groupId,
                  inviteeUsername: inviteController.text,
                );
              });

              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text('招待'),
          ),
        ],
      ),
    );

    inviteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('アカウントとグループ')),
      body: FutureBuilder<User?>(
        future: widget.repository.getCurrentUser(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user == null) {
            return _buildLoggedOut();
          }
          return _buildLoggedIn(user);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _busy ? null : _showRegisterDialog,
                      child: const Text('新規登録'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _busy ? null : _login,
                      child: const Text('ログイン'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedIn(User user) {
    return StreamBuilder<List<Account>>(
      stream: widget.repository.watchAccounts(),
      builder: (context, accountsSnapshot) {
        final accounts = accountsSnapshot.data ?? const <Account>[];
        final activeAccountId = widget.db.currentAccountId;
        final hasActiveAccount =
            accounts.any((account) => account.id == activeAccountId);
        final selectedAccountId = hasActiveAccount
            ? activeAccountId
            : (accounts.isEmpty ? null : accounts.first.id);

        return StreamBuilder<List<UserGroup>>(
          stream: widget.repository.watchGroupsForCurrentAccount(),
          builder: (context, groupsSnapshot) {
            final groups = groupsSnapshot.data ?? const <UserGroup>[];
            final activeGroupId = widget.db.currentGroupId;
            final hasActiveGroup =
                groups.any((group) => group.id == activeGroupId);
            final selectedGroupId = hasActiveGroup ? activeGroupId : null;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.username),
                    subtitle: const Text('ログイン中'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
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
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('アカウント', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          key: ValueKey(selectedAccountId),
                          initialValue: selectedAccountId,
                          decoration:
                              const InputDecoration(labelText: '利用中のアカウント'),
                          items: accounts
                              .map((account) => DropdownMenuItem<String>(
                                    value: account.id,
                                    child: Text(account.name),
                                  ))
                              .toList(),
                          onChanged: (id) async {
                            if (id == null) return;
                            await _run(() async {
                              await widget.repository.setActiveAccount(id);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.tonal(
                            onPressed: _busy ? null : _showCreateAccountDialog,
                            child: const Text('アカウントを作成'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('グループ', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<int?>(
                          key: ValueKey(selectedGroupId),
                          initialValue: selectedGroupId,
                          decoration:
                              const InputDecoration(labelText: '利用中のグループ'),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('全体（グループ未指定）'),
                            ),
                            ...groups.map((group) => DropdownMenuItem<int?>(
                                  value: group.id,
                                  child: Text(group.name),
                                )),
                          ],
                          onChanged: (id) async {
                            await _run(() async {
                              await widget.repository.setActiveGroup(id);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton.tonal(
                              onPressed: _busy ? null : _showCreateGroupDialog,
                              child: const Text('グループを作成'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.tonal(
                              onPressed: (_busy || selectedGroupId == null)
                                  ? null
                                  : () => _showInviteDialog(selectedGroupId),
                              child: const Text('メンバー招待'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (selectedGroupId != null) ...[
                  const SizedBox(height: 10),
                  StreamBuilder<List<GroupMemberView>>(
                    stream:
                        widget.repository.watchGroupMembers(selectedGroupId),
                    builder: (context, membersSnapshot) {
                      final members =
                          membersSnapshot.data ?? const <GroupMemberView>[];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('メンバー (${members.length})',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              if (members.isEmpty)
                                const Text('メンバーはいません')
                              else
                                ...members.map((member) => ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.person_outline),
                                      title: Text(member.username),
                                      trailing: Text(member.role),
                                    )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 10),
                StreamBuilder<List<GroupInviteView>>(
                  stream: widget.repository.watchPendingInvitesForCurrentUser(),
                  builder: (context, invitesSnapshot) {
                    final invites =
                        invitesSnapshot.data ?? const <GroupInviteView>[];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('招待 (${invites.length})',
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            if (invites.isEmpty)
                              const Text('未処理の招待はありません')
                            else
                              ...invites.map((invite) => ListTile(
                                    dense: true,
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
                                                        .declineInvite(
                                                            invite.id);
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
                                                        .acceptInvite(
                                                            invite.id);
                                                  });
                                                },
                                          child: const Text('参加'),
                                        ),
                                      ],
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
