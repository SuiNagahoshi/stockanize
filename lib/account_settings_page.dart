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
  int _section = 0;

  final _loginUserController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _registerUserController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerPasswordConfirmController = TextEditingController();

  final _accountNameController = TextEditingController();
  final _accountPasswordController = TextEditingController();

  final _groupNameController = TextEditingController();
  final _groupDescController = TextEditingController();
  final _inviteUsernameController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

  bool _busy = false;

  @override
  void dispose() {
    _loginUserController.dispose();
    _loginPasswordController.dispose();
    _registerUserController.dispose();
    _registerPasswordController.dispose();
    _registerPasswordConfirmController.dispose();
    _accountNameController.dispose();
    _accountPasswordController.dispose();
    _groupNameController.dispose();
    _groupDescController.dispose();
    _inviteUsernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _runGuarded(Future<void> Function() task) async {
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
    await _runGuarded(() async {
      await widget.repository.login(
        username: _loginUserController.text,
        password: _loginPasswordController.text,
      );
      _loginPasswordController.clear();
    });
  }

  Future<void> _register() async {
    final pw = _registerPasswordController.text;
    final confirm = _registerPasswordConfirmController.text;
    if (pw != confirm) {
      _snack('確認用パスワードが一致しません');
      return;
    }

    await _runGuarded(() async {
      await widget.repository.registerUser(
        username: _registerUserController.text,
        password: pw,
      );
      _registerUserController.clear();
      _registerPasswordController.clear();
      _registerPasswordConfirmController.clear();
    });
  }

  Future<void> _changePassword() async {
    final next = _newPasswordController.text;
    if (next != _newPasswordConfirmController.text) {
      _snack('新しいパスワード確認が一致しません');
      return;
    }

    await _runGuarded(() async {
      await widget.repository.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: next,
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _newPasswordConfirmController.clear();
      _snack('パスワードを更新しました');
    });
  }

  Future<void> _createAccount() async {
    await _runGuarded(() async {
      final id = await widget.repository.createAccount(
        _accountNameController.text,
        currentPassword: _accountPasswordController.text,
      );
      await widget.repository.setActiveAccount(id);
      _accountNameController.clear();
      _accountPasswordController.clear();
    });
  }

  Future<void> _createGroup() async {
    await _runGuarded(() async {
      final groupId = await widget.repository.createGroup(
        _groupNameController.text,
        description: _groupDescController.text,
      );
      await widget.repository.setActiveGroup(groupId);
      _groupNameController.clear();
      _groupDescController.clear();
    });
  }

  Future<void> _invite(int groupId) async {
    await _runGuarded(() async {
      await widget.repository.inviteUserToGroup(
        groupId: groupId,
        inviteeUsername: _inviteUsernameController.text,
      );
      _inviteUsernameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('アクセスとチーム設定')),
      body: StreamBuilder<AppContext?>(
        stream: widget.db.watchAppContext(),
        builder: (context, _) {
          return FutureBuilder<User?>(
            future: widget.repository.getCurrentUser(),
            builder: (context, userSnapshot) {
              final currentUser = userSnapshot.data;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _summaryCard(currentUser),
                  const SizedBox(height: 12),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('アクセス')),
                      ButtonSegment(value: 1, label: Text('ワークスペース')),
                      ButtonSegment(value: 2, label: Text('チーム')),
                    ],
                    selected: {_section},
                    onSelectionChanged: (values) {
                      setState(() => _section = values.first);
                    },
                  ),
                  const SizedBox(height: 12),
                  if (_section == 0) _accessSection(currentUser),
                  if (_section == 1) _workspaceSection(currentUser),
                  if (_section == 2) _teamSection(currentUser),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _summaryCard(User? currentUser) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.person, size: 18),
              label: Text(currentUser?.username ?? '未ログイン'),
            ),
            Chip(
              avatar: const Icon(Icons.apartment, size: 18),
              label: Text(widget.db.currentAccountId),
            ),
            Chip(
              avatar: const Icon(Icons.groups, size: 18),
              label: Text(
                widget.db.currentGroupId == null
                    ? 'グループ: 全体'
                    : 'グループID: ${widget.db.currentGroupId}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accessSection(User? currentUser) {
    return Column(
      children: [
        if (currentUser == null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ログイン', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: _busy ? null : _login,
                      child: const Text('ログイン'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('ユーザ登録', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ユーザ名: 3-32文字の英小文字/数字/._-\n'
                    'パスワード: 12文字以上+大小英字+数字+記号',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: _busy ? null : _register,
                    child: const Text('登録してログイン'),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (currentUser != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ログイン中: ${currentUser.username}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _currentPasswordController,
                    decoration: const InputDecoration(labelText: '現在のパスワード'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(labelText: '新しいパスワード'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPasswordConfirmController,
                    decoration:
                        const InputDecoration(labelText: '新しいパスワード（確認）'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: _busy
                            ? null
                            : () async {
                                await _runGuarded(() async {
                                  await widget.repository.logout();
                                });
                              },
                        child: const Text('ログアウト'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _busy ? null : _changePassword,
                        child: const Text('パスワード更新'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _workspaceSection(User? currentUser) {
    if (currentUser == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Text('先にログインしてください。'),
        ),
      );
    }

    return StreamBuilder<List<Account>>(
      stream: widget.repository.watchAccounts(),
      builder: (context, snapshot) {
        final accounts = snapshot.data ?? const <Account>[];
        final activeId = widget.db.currentAccountId;
        final hasCurrent = accounts.any((a) => a.id == activeId);

        return Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: hasCurrent
                          ? activeId
                          : (accounts.isEmpty ? null : accounts.first.id),
                      decoration:
                          const InputDecoration(labelText: 'アクティブアカウント'),
                      items: accounts
                          .map((account) => DropdownMenuItem<String>(
                                value: account.id,
                                child: Text(account.name),
                              ))
                          .toList(),
                      onChanged: (id) async {
                        if (id == null) return;
                        await _runGuarded(() async {
                          await widget.repository.setActiveAccount(id);
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '参加アカウント数: ${accounts.length}',
                        style: const TextStyle(color: Colors.black54),
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
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('新規アカウント作成', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _accountNameController,
                      decoration: const InputDecoration(labelText: 'アカウント名'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _accountPasswordController,
                      decoration:
                          const InputDecoration(labelText: '現在のパスワード（確認）'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: _busy ? null : _createAccount,
                        child: const Text('安全に作成'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _teamSection(User? currentUser) {
    if (currentUser == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Text('先にログインしてください。'),
        ),
      );
    }

    return StreamBuilder<List<UserGroup>>(
      stream: widget.repository.watchGroupsForCurrentAccount(),
      builder: (context, snapshot) {
        final groups = snapshot.data ?? const <UserGroup>[];
        final activeGroupId = widget.db.currentGroupId;
        final hasCurrent = groups.any((g) => g.id == activeGroupId);
        final selectedGroupId = hasCurrent ? activeGroupId : null;

        return Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    DropdownButtonFormField<int?>(
                      initialValue: selectedGroupId,
                      decoration: const InputDecoration(labelText: 'アクティブグループ'),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('すべてのグループ'),
                        ),
                        ...groups.map(
                          (group) => DropdownMenuItem<int?>(
                            value: group.id,
                            child: Text(group.name),
                          ),
                        ),
                      ],
                      onChanged: (id) async {
                        await _runGuarded(() async {
                          await widget.repository.setActiveGroup(id);
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '参加グループ数: ${groups.length}',
                        style: const TextStyle(color: Colors.black54),
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
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('新規グループ作成', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _groupNameController,
                      decoration: const InputDecoration(labelText: 'グループ名'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _groupDescController,
                      decoration: const InputDecoration(labelText: '説明（任意）'),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: _busy ? null : _createGroup,
                        child: const Text('グループを作成'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedGroupId != null) ...[
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('メンバー招待', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _inviteUsernameController,
                        decoration:
                            const InputDecoration(labelText: '招待するユーザ名'),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed:
                              _busy ? null : () => _invite(selectedGroupId),
                          child: const Text('招待を送る'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<GroupMemberView>>(
                stream: widget.repository.watchGroupMembers(selectedGroupId),
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
                            const Text('参加メンバーがいません')
                          else
                            ...members.map(
                              (m) => ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.person),
                                title: Text(m.username),
                                trailing: Text(m.role),
                              ),
                            ),
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
              builder: (context, inviteSnapshot) {
                final invites =
                    inviteSnapshot.data ?? const <GroupInviteView>[];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('あなたへの招待 (${invites.length})',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        if (invites.isEmpty)
                          const Text('未処理の招待はありません')
                        else
                          ...invites.map(
                            (invite) => ListTile(
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
                                            await _runGuarded(() async {
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
                                            await _runGuarded(() async {
                                              await widget.repository
                                                  .acceptInvite(invite.id);
                                            });
                                          },
                                    child: const Text('参加'),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
  }
}
