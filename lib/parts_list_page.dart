import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockanize/db/parts.dart';

import 'add_page.dart';
import 'db/database.dart';
import 'main.dart';

class PartsListPage extends StatefulWidget {
  final AppDatabase db;
  const PartsListPage({Key? key, required this.db}) : super(key: key);

  @override
  State<PartsListPage> createState() => _PartsListPageState();
}

class _PartsListPageState extends State<PartsListPage> {
  List<Part>? _lastParts; // 最後に有効だったデータを保持する

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parts')),
      body: StreamBuilder<List<Part>>(
        stream: widget.db.watchAllParts(),
        builder: (context, snapshot) {
          try {
            // エラーは必ず出力してユーザーにも見せる
            if (snapshot.hasError) {
              debugPrint('watchAllParts error: ${snapshot.error}');
              return Center(child: Text('エラー: ${snapshot.error}'));
            }

            // snapshot.data が入っていれば更新。なければ _lastParts を使う
            //if (snapshot.hasData) {
            //  _lastParts = snapshot.data;
            //}

            //final parts = _lastParts ?? [];

            final parts = snapshot.data!;
            // 初回かつまだ読み込み中でデータが一切無ければロード表示
            //if (_lastParts == null) {
            //  return const Center(child: CircularProgressIndicator());
            //}

            if (parts.isEmpty) {
              return const Center(child: Text("no item"));
            }

            return ListView.builder(
              itemCount: parts.length,
              itemBuilder: (context, index) {
                final part = parts[index];

                // idはDBから来るのでnullableだが、ここでは必ず存在するはず
                final id = part.id;
                final heroTag = 'hero_part_${id ?? index}';

                return Card(
                  key: ValueKey(id ?? index),
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    minVerticalPadding: 10,
                    minLeadingWidth: 0,
                    leading: Hero(
                      tag: heroTag,
                      child: Container(
                        width: 60,
                        height: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.withAlpha(25),
                        ),
                        child: const Icon(Icons.electrical_services_outlined),
                      ),
                    ),
                    title: Text(part.name, style: TextStyle(fontSize: 17.5),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(part.category ?? "", style: TextStyle(color: Colors.black45),),
                        Text(part.code ?? "", style: TextStyle(color: Colors.black, fontSize: 16.5))
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("削除してよろしいですか？"),
                            content: Text("${part.name} を削除しますか？"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text("キャンセル"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text("削除する"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          // StreamBuilder で自動反映されるので setState 不要
                          await widget.db.deletePart(part.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${part.name} を削除しました")),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HeroListItemPage(
                            part: part,
                            heroTag: heroTag, index: index, // 同じタグを渡す
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } catch (e, st) {
            debugPrint("error: building parts list $e\n$st");
            return Center(child: Text("エラーが発生しました"),);
          }
        },
      ),
    );
  }
}


/*class PartsListPage extends StatefulWidget {
  final AppDatabase db;
  const PartsListPage({super.key, required this.db});

  @override
  State<PartsListPage> createState() => _PartsListPageState();
}

class _PartsListPageState extends State<PartsListPage> {
  late Future<List<Part>> _partsFuture;

  @override
  void initState() {
    super.initState();
    _partsFuture = widget.db.getAllParts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("部品リスト")),
      body: StreamBuilder<List<Part>>(
        stream: widget.db.watchAllParts(), // ← ここを Future から Stream に変更
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("エラー: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("no item"));
          }

          final parts = snapshot.data!;

          return StreamBuilder<List<Part>>(
            stream: widget.db.watchAllParts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('エラー: ${snapshot.error}'));
              }

              //final parts = snapshot.data;

              if (parts == null) {
                // 初回のみインジケータを出す
                return const Center(child: CircularProgressIndicator());
              }

              if (parts.isEmpty) {
                return const Center(child: Text("登録されている部品はありません"));
              }

              //final parts = snapshot.data!;

              return ListView.builder(
                itemCount: parts.length,
                itemBuilder: (context, index) {
                  final part = parts[index];
                  return ListTile(
                    minTileHeight: 85,
                    title: Text(part.name),
                    leading: Hero(
                      tag: "hero_list_item_$index",
                      child: Container(
                        width: 60,
                        height: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.withAlpha(25),
                        ),
                        child: const Icon(Icons.electrical_services_outlined),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("削除してよろしいですか？"),
                            content: Text("${part.name}を削除しますか？"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text("キャンセル"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text("削除する"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await widget.db.deletePart(part.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${part.name}を削除しました")),
                          );
                        }
                      },
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HeroListItemPage(part: part, index: index),
                      ),
                    ),
                  );
                },
              );
            },
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPartPage(db: widget.db)),
          );
          // Navigator.pop() の戻り値を気にしなくても自動更新される
        },
      ),
    );
  }
}
*/


/*
FutureBuilder<List<Part>>(
  future: widget.db.getAllParts(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text("エラーが発生しました: ${snapshot.error}"));
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text("no item"));
    }
    final parts = snapshot.data!;
    //if (parts.isEmpty) return const Center(child: Text("no item"));

    return ListView.builder(
      itemCount: parts.length,
      itemBuilder: (context, index) {
        final part = parts[index];
        return ListTile(
          minTileHeight: 85,
          title: Text(part.name),
          leading: Hero(
            tag: "hero_list_item_$index",
            child: Container(
              width: 60,
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.withAlpha(25),
              ),
              child: const Icon(Icons.electrical_services_outlined),
            ),
          ),
          trailing: IconButton(
          onPressed: () async {
            final confirm = await showDialog(context: context, builder: (ctx) => AlertDialog(
              title: const Text("削除してよろしいですか？"),
              content: Text("${part.name}を削除しますか？"),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("キャンセル")),
                ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("削除する"))
              ],
            ));
            if (confirm == true) {
              await widget.db.deletePart(part.id!);
              setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${part.name}を削除しました"))
              );
            }
          },
          icon: const Icon(Icons.delete, color: Colors.red),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HeroListItemPage(part: part, index: index),
            ),
          ),
        );
      },
    );
  },
),
*/