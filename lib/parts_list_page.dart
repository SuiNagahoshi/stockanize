import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linkwell/linkwell.dart';
import 'package:stockanize/db/parts.dart';
import 'package:stockanize/edit_page.dart';
import 'package:stockanize/qr_label.dart';

import 'db/database.dart';

class PartsListPage extends StatefulWidget {
  final AppDatabase db;
  const PartsListPage({super.key, required this.db});

  @override
  State<PartsListPage> createState() => _PartsListPageState();
}

class _PartsListPageState extends State<PartsListPage> {
  //List<Part>? _lastParts; // 最後に有効だったデータを保持する

  final db = AppDatabase.instance;

  Widget _buildPartThumbnail(List<PartsImage> images) {
    if (images.isEmpty) {
      // 画像なし → 従来の仮サムネイル
      return Container(
        color: Colors.blue.withAlpha(25),
        child: const Icon(Icons.electrical_services_outlined),
      );
    }

    // sort_order 昇順で先頭を使う
    final firstImage = images
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Image.file(
      File(firstImage.first.imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        // ファイル欠損時のフォールバック
        return Container(
          color: Colors.blue.withAlpha(25),
          child: const Icon(Icons.broken_image),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parts')),
      body: StreamBuilder<List<Part>>(
        stream: widget.db.watchParts(),
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

                final id = part.id;
                final heroTag = 'hero_part_$id';

                return Card(
                  key: ValueKey(id),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    minVerticalPadding: 10,
                    minLeadingWidth: 0,
                    leading: Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 60,
                          height: 85,
                          child: FutureBuilder<PartsImage?>(
                            future: widget.db.getFirstImageByPartId(part.id),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data == null) {
                                // 画像なし（従来どおり）
                                return Container(
                                  color: Colors.blue.withAlpha(25),
                                  child: const Icon(
                                      Icons.electrical_services_outlined),
                                );
                              }

                              final image = snapshot.data!;
                              return Image.file(
                                File(image.imagePath),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    color: Colors.blue.withAlpha(25),
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      part.name,
                      style: TextStyle(fontSize: 17.5),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          part.category ?? "",
                          style: TextStyle(color: Colors.black45),
                        ),
                        Text(part.code ?? "",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.5))
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
                          await widget.db.deletePart(part.id);
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
                            heroTag: heroTag, index: index, db: db, // 同じタグを渡す
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
            return Center(
              child: Text("エラーが発生しました"),
            );
          }
        },
      ),
    );
  }
}

class HeroListItemPage extends StatefulWidget {
  final Part part;

  final int index;

  final dynamic heroTag;

  final AppDatabase db;

  //late final Part part;
  //late final int index;
  //late final AppDatabase db;

  const HeroListItemPage(
      {super.key,
      required this.part,
      required this.index,
      required this.heroTag,
      required this.db});

  @override
  State<HeroListItemPage> createState() => _HeroListItemPageState();
}

class _HeroListItemPageState extends State<HeroListItemPage> {
  late final Stream<List<Part>> _partsStream;

  List<PartsImage> _images = [];
  bool _loadingImages = true;

  late final PageController _pageController;
  int _currentPage = 0;

  final ValueNotifier<int> _currentPageNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    // ① partsテーブルの変更を監視
    _partsStream = widget.db.watchParts();

    _loadCategories();

    _pageController = PageController()
      ..addListener(() {
        final page = _pageController.page;
        if (page == null) return;

        final index = page.round();
        if (_currentPageNotifier.value != index) {
          _currentPageNotifier.value = index;
        }
      });
    _loadImages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  //final dynamic heroTag;
  late var part = widget.part;

  Future<dynamic> getCategories() async {
    var json = await rootBundle.loadString('assets/categories.json');
    //debugPrint('getcategory\n$json');
    var decoded = jsonDecode(json);
    debugPrint('${decoded.runtimeType}');
    if (decoded is Map) {
      debugPrint('yah');
      return decoded;
    } else {
      return;
    }
  }

  late final categories;
  //_HeroListItemPageState._(this.category);

  // 💡 非同期でデータをロードするメソッド
  Future<void> _loadCategories() async {
    try {
      // getCategory() はグローバルまたは外部で定義された関数として呼び出す
      var data = await getCategories();

      // データの型判定
      if (data is Map<String, dynamic>) {
        // 成功したら late フィールドを初期化し、UIを更新
        setState(() {
          categories = data; // late フィールドへの最初の代入
        });
      } else {
        // 失敗した場合（Mapでなかった場合）
        setState(() {
          categories = {}; // エラー時の代替（例: 空のMap）で late を初期化
        });
        debugPrint('Error: Loaded data is not a Map.');
      }
    } catch (e) {
      // 例外処理（ファイルが見つからないなど）
      setState(() {
        categories = {}; // エラー時の代替で late を初期化
      });
      debugPrint('Error loading category: $e');
    }
  }

  Future<void> _loadImages() async {
    final images = await widget.db.getImagesByPartId(widget.part.id);

    if (!mounted) return;

    setState(() {
      _images = images;
      _loadingImages = false;
    });
  }

  Widget _buildHeroImage() {
    return StreamBuilder<List<PartsImage>>(
      stream: widget.db.watchImages(widget.part.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const SizedBox(
              height: 250,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // ★ ここで state を更新する代わりに直接代入
        _images = snapshot.data!;
        _loadingImages = false;

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: _images.isEmpty
                    ? _buildPlaceholder()
                    : _buildImageCarousel(),
              ),
              if (_images.length > 1) _buildPageIndicator(),
            ],
          ),
        );
      },
    );
  }



  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue.withAlpha(25),
      ),
      child: const Center(
        child: Icon(
          Icons.electrical_services_outlined,
          color: Colors.blue,
          size: 100,
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _images.length,
      itemBuilder: (context, index) {
        final image = _images[index];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.black,
                pageBuilder: (_, __, ___) {
                  return ImagePreviewPage(
                    images: _images,
                    initialIndex: index,
                  );
                },
              ),
            );
          },
          child: Hero(
            tag: 'part_image_$index',
            child: Image.file(
              File(image.imagePath),
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPageNotifier,
      builder: (context, current, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (index) {
            final isActive = index == current;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              width: isActive ? 10 : 8,
              height: isActive ? 10 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.blue : Colors.grey,
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Hero rebuild');
    print("Hero DB instance: ${widget.db.hashCode}");

    return StreamBuilder<List<Part>>(
        stream: widget.db.watchParts(),//_partsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }

          final parts = snapshot.data!;
          var currentPart = parts.firstWhere((p) => p.id == widget.part.id);
          final metadata = currentPart.metadata;

          debugPrint(metadata.toString());

          return Scaffold(
            appBar: AppBar(
              title: Text(currentPart.name),
              actions: [
                IconButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => EditPartPage(
                                  db: widget.db,
                                  part: currentPart,
                                )),
                      );

                      if (result != null && mounted) {
                        setState(() {
                          debugPrint(
                              '  received id:${result.id} name:${result.name} code:${result.code} location:${result.location} stock:${result.stock}');
                          currentPart = result;
                        });
                      }
                    },
                    icon: Icon(Icons.edit))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /*Hero(
                tag: widget.heroTag, //"hero_list_item_$index",
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.withAlpha(25)),
                  child: const Center(
                    child: Icon(Icons.electrical_services_outlined,
                        color: Colors.blue, size: 100),
                  ),
                ),
              ),*/
                    _buildHeroImage(),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(currentPart.name,
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                        Text(
                            "${currentPart.category ?? ""} / ${currentPart.subcategory ?? ""}"),
                        Column(
                          children: [
                            _buildInfoRow(currentPart, currentPart.category ?? "",
                                "型番", currentPart.code),
                            _buildInfoRow(currentPart, currentPart.category ?? "",
                                "在庫数", currentPart.stock),
                            _buildInfoRow(currentPart, currentPart.category ?? "",
                                "保管場所", currentPart.location),
                            _buildLinkRow("データシート", currentPart.datasheetUrl),
                            _buildLinkRow("購入先", currentPart.buyUrl),
                            const Divider(),
                            ...(metadata ?? {}).entries.map((e) =>
                                _buildInfoRow(currentPart, currentPart.category ?? "",
                                    e.key, e.value)),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'QRコード',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              /*child: QrImageView(
                          data: part.id.toString(),
                          version: QrVersions.auto,
                          size: 180,
                          backgroundColor: Colors.white,
                        ),*/
                              child: PartQrCard(
                                partName: currentPart.name,
                                location: currentPart.location,
                                qrData: currentPart.id.toString(),
                                isHorizontal: true,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /*
  Widget _buildInfoRow(String key, dynamic value, {double indent = 0}) {
    debugPrint('$key, $value');
    // カテゴリごとのスキーマ定義を取得（なければ空マップ）
    final category = (part.category ?? '').toString();
    final Map<String, dynamic> categorySchema =
    (part.metadata?[category] is Map)
        ? Map<String, dynamic>.from(part.metadata?[category])
        : <String, dynamic>{};

    // 内部再帰関数（現在のスキーマコンテキストを受け取る）
    Widget buildRec(String curKey, dynamic curValue,
        Map<String, dynamic> curSchema, double curIndent) {
      // スキーマ定義を解決するヘルパ（ドット区切りキーにも対応）
      Map<String, dynamic>? resolveDef(Map<String, dynamic> s, String k) {
        if (s.containsKey(k)) {
          final v = s[k];
          if (v is Map<String, dynamic>) return v;
          if (v is Map) return Map<String, dynamic>.from(v);
        }

        // ドット区切り ("size.depth") の場合に下っていく
        if (k.contains('.')) {
          final parts = k.split('.');
          Map<String, dynamic>? cs = s;
          for (final p in parts) {
            if (cs == null) return null;
            final child = cs[p];
            if (child is Map) {
              cs = Map<String, dynamic>.from(child);
            } else {
              return null;
            }
          }
          return cs;
        }

        return null;
      }

      final Map<String, dynamic>? def = resolveDef(curSchema, curKey);

      // label と unit を決定（見つからなければ key をそのままラベルにする）
      String label = curKey;
      String? unit;
      Map<String, dynamic>? childrenSchema;

      if (def != null) {
        // def に label があればそれを用いる（通常の項目）
        if (def.containsKey('label')) {
          label = def['label']?.toString() ?? curKey;
          unit = def['unit']?.toString();
          // もし def がさらに子要素を持つなら、子スキーマとして使える可能性を検査
          final clone = Map<String, dynamic>.from(def);
          clone.remove('label');
          clone.remove('unit');
          if (clone.isNotEmpty) {
            // 子スキーマが残っていたら子スキーマとして扱う
            childrenSchema = clone;
          }
        } else {
          // def は「コンテナ」(size のように内部にフィールドを持つ) なので子スキーマとして使う
          childrenSchema = Map<String, dynamic>.from(def);
          // label は親キーをそのまま使う（必要なら schema に label を追加して下さい）
          label = curKey;
        }
      } else {
        // def が無い場合はラベルはそのまま、子スキーマなし
        label = curKey;
        childrenSchema = null;
      }

      // 値の型に応じて表示
      if (curValue is Map) {
        // Map（ネスト） — 子スキーマがあればそれを渡す。なければ curSchema を使う。
        final childSchemaToUse = childrenSchema ?? curSchema;
        return Padding(
          padding: EdgeInsets.only(left: curIndent, top: 4, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              ...curValue.entries.map((entry) {
                // entry.key は動的なので文字列化して渡す
                return buildRec(entry.key.toString(), entry.value,
                    childSchemaToUse, curIndent + 16);
              }).toList(),
            ],
          ),
        );
      } else if (curValue is List) {
        // List の場合は index をラベルにして展開
        return Padding(
          padding: EdgeInsets.only(left: curIndent, top: 4, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              ...curValue.asMap().entries.map((entry) {
                return buildRec('[${entry.key}]', entry.value,
                    childrenSchema ?? curSchema, curIndent + 16);
              }).toList(),
            ],
          ),
        );
      } else {
        // スカラー値
        final display = (curValue == null)
            ? ''
            : (unit != null
            ? '${curValue.toString()} $unit'
            : curValue.toString());
        return Padding(
          padding: EdgeInsets.only(left: curIndent, top: 4, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Text(display)),
            ],
          ),
        );
      }
    } // end buildRec
    buildInfo(part, key, value);
    // 初回はカテゴリスキーマをコンテキストとして渡す
    return buildRec(key, value, categorySchema, indent);
  }
*/
  Widget _buildInfoRow(Part part, String category, String key, dynamic value) {
    (String, String) getLabelFromKey(String category, String key) {
      try {
        final categoriess = categories;
        final label = categoriess[category]?['subcategories']?[part.subcategory]
            ?[key]?['label'];

        if (label == null) {
          return (key, value.toString());
        }

        return (label.toString(), value.toString());
      } catch (e) {
        // LateInitializationError を含むすべての参照失敗を吸収
        return (key, value.toString());
      }
    }

    String label;
    String itemValue;

    switch (key) {
      case "型番":
      case "在庫数":
      case "保管場所":
      case "データシート":
      case "購入先":
        label = key;
        itemValue = value.toString();
        break;
      default:
        (label, itemValue) = getLabelFromKey(category, key);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(itemValue)),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String label, String? url) {
    if (url == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: LinkWell(url,
                  linkStyle: const TextStyle(
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline))),
        ],
      ),
    );
  }
}

class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  final List<PartsImage> images;
  final int initialIndex;

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: SafeArea(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];

              return Center(
                child: Hero(
                  tag: 'part_image_$index',
                  child: Image.file(
                    File(image.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
