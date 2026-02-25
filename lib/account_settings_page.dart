import 'package:flutter/material.dart';
import 'package:stockanize/data/stock_repository.dart';
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
  final _accountNameController = TextEditingController();
  final _groupNameController = TextEditingController();
  final _groupDescriptionController = TextEditingController();

  bool _savingAccount = false;
  bool _savingGroup = false;

  @override
  void dispose() {
    _accountNameController.dispose();
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _showRenameAccountDialog(Account account) async {
    final controller = TextEditingController(text: account.name);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アカウント名を変更'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '新しい名前'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await widget.repository
                    .renameAccount(account.id, controller.text);
                if (!mounted) return;
                Navigator.of(context).pop();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('更新失敗: $e')));
              }
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  Future<void> _showRenameGroupDialog(UserGroup group) async {
    final controller = TextEditingController(text: group.name);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('グループ名を変更'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '新しい名前'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await widget.repository.renameGroup(group.id, controller.text);
                if (!mounted) return;
                Navigator.of(context).pop();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('更新失敗: $e')));
              }
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('アカウント設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('アカウント', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          StreamBuilder<List<Account>>(
            stream: widget.repository.watchAccounts(),
            builder: (context, snapshot) {
              final accounts = snapshot.data ?? const <Account>[];

              if (accounts.isEmpty) {
                return const Text('アカウントがありません');
              }

              final activeId = widget.db.currentAccountId;
              final hasCurrent =
                  accounts.any((account) => account.id == activeId);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: hasCurrent ? activeId : accounts.first.id,
                    decoration: const InputDecoration(
                      labelText: 'アクティブアカウント',
                    ),
                    items: accounts
                        .map(
                          (account) => DropdownMenuItem<String>(
                            value: account.id,
                            child: Text(account.name),
                          ),
                        )
                        .toList(),
                    onChanged: (id) async {
                      if (id == null) return;
                      await widget.repository.setActiveAccount(id);
                      widget.onScopeChanged();
                      if (!mounted) return;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  ...accounts.map(
                    (account) => ListTile(
                      dense: true,
                      title: Text(account.name),
                      subtitle: Text(account.id),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            onPressed: () => _showRenameAccountDialog(account),
                            icon: const Icon(Icons.edit),
                            tooltip: '名前変更',
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                await widget.repository
                                    .deleteAccount(account.id);
                                widget.onScopeChanged();
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('削除失敗: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: '削除',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _accountNameController,
            decoration: const InputDecoration(labelText: '新規アカウント名'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _savingAccount
                ? null
                : () async {
                    setState(() => _savingAccount = true);
                    try {
                      final id = await widget.repository
                          .createAccount(_accountNameController.text);
                      await widget.repository.setActiveAccount(id);
                      _accountNameController.clear();
                      widget.onScopeChanged();
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('作成失敗: $e')),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _savingAccount = false);
                      }
                    }
                  },
            child: const Text('アカウントを作成'),
          ),
          const Divider(height: 32),
          const Text('グループ', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          StreamBuilder<List<UserGroup>>(
            stream: widget.repository.watchGroupsForCurrentAccount(),
            builder: (context, snapshot) {
              final groups = snapshot.data ?? const <UserGroup>[];

              final activeGroupId = widget.db.currentGroupId;
              final hasCurrentGroup = groups.any((g) => g.id == activeGroupId);
              final dropdownValue = hasCurrentGroup ? activeGroupId : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<int?>(
                    value: dropdownValue,
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
                      await widget.repository.setActiveGroup(id);
                      widget.onScopeChanged();
                      if (!mounted) return;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  ...groups.map(
                    (group) => ListTile(
                      dense: true,
                      title: Text(group.name),
                      subtitle: Text(group.description ?? '-'),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            onPressed: () => _showRenameGroupDialog(group),
                            icon: const Icon(Icons.edit),
                            tooltip: '名前変更',
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                await widget.repository.deleteGroup(group.id);
                                widget.onScopeChanged();
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('削除失敗: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: '削除',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(labelText: '新規グループ名'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _groupDescriptionController,
            decoration: const InputDecoration(labelText: '説明（任意）'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _savingGroup
                ? null
                : () async {
                    setState(() => _savingGroup = true);
                    try {
                      await widget.repository.createGroup(
                        _groupNameController.text,
                        description: _groupDescriptionController.text,
                      );
                      _groupNameController.clear();
                      _groupDescriptionController.clear();
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('作成失敗: $e')),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _savingGroup = false);
                      }
                    }
                  },
            child: const Text('グループを作成'),
          ),
        ],
      ),
    );
  }
}
