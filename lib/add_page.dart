import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:stockanize/db/parts.dart';
import 'db/database.dart';

class AddPartPage extends StatefulWidget {
  final AppDatabase db;
  const AddPartPage({super.key, required this.db});

  @override
  State<AddPartPage> createState() => _AddPartPageState();
}

class _AddPartPageState extends State<AddPartPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // 共通フィールド
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _stockController = TextEditingController();
  final _locationController = TextEditingController();
  final _datasheetUrlController = TextEditingController();
  final _buyUrlController = TextEditingController();

  // カテゴリとパラメータ
  Map<String, dynamic> _categories = {};
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _selectedImplementation; // 選択中の実装形式
  final Map<String, TextEditingController> _paramControllers = {};

  //List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCategories();

    _dragAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _dragScale = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(
        parent: _dragAnimController,
        curve: Curves.easeOut,
      ),
    );

    _dragOpacity = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _dragAnimController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    // 動的に作ったコントローラを全部 dispose
    for (final c in _paramControllers.values) {
      c.dispose();
    }
    _paramControllers.clear();

    // 既存コントローラも dispose
    _nameController.dispose();
    _codeController.dispose();
    _stockController.dispose();
    _locationController.dispose();
    _datasheetUrlController.dispose();
    _buyUrlController.dispose();

    super.dispose();
  }

  // カテゴリ読み込み（少し堅牢にキャスト）
  Future<void> _loadCategories() async {
    final jsonStr = await rootBundle.loadString('assets/categories.json');
    final dynamic decoded = jsonDecode(jsonStr);
    if (decoded is Map) {
      final cats = Map<String, dynamic>.from(decoded);

      // カテゴリごとに unit 幅を計算
      final unitWidths = <String, double>{};
      cats.forEach((category, schema) {
        unitWidths[category] = _calcMaxUnitWidth(category, schema);
      });

      setState(() {
        _categories = cats;
      });
    } else {
      setState(() {
        _categories = {};
      });
    }
  }

  // --- カテゴリ変更時の処理: 既存コントローラは dispose してから新規作成 ---

  double _calcMaxUnitWidth(String category, Map<String, dynamic> schema) {
    final units = <String>[];

    void collectUnits(Map<String, dynamic> map) {
      map.forEach((key, def) {
        if (def is Map<String, dynamic>) {
          if (def['unit'] != null) {
            units.add(def['unit'].toString());
          }
          def.forEach((k, v) {
            if (v is Map<String, dynamic>) {
              collectUnits({k: v});
            }
          });
        }
      });
    }

    collectUnits(schema);

    final textStyle = const TextStyle(color: Colors.grey);
    final tp = TextPainter(
        textDirection: TextDirection.ltr, textAlign: TextAlign.left);

    double maxWidth = 0;
    for (final u in units) {
      tp.text = TextSpan(text: u, style: textStyle);
      tp.layout();
      if (tp.width > maxWidth) {
        maxWidth = tp.width + 10;
      }
    }
    return maxWidth;
  }

  /// スキーマに準拠してパラメータを構築する
  List<Widget> _buildCategoryParams() {
    final category = _categories[_selectedCategory];
    if (category == null) return [];

    Map<String, dynamic>? paramMap;

    // サブカテゴリ選択時
    if (_selectedSubcategory != null &&
        category["subcategories"] != null &&
        category["subcategories"][_selectedSubcategory] != null) {
      paramMap = Map<String, dynamic>.from(
          category["subcategories"][_selectedSubcategory]);
    } else {
      // サブカテゴリが存在しない or 未選択 → category直下
      paramMap = Map<String, dynamic>.from(category);
    }

    // "name" や "subcategories" はパラメータではない
    paramMap.remove("name");
    paramMap.remove("subcategories");

    final widgets = <Widget>[];

    for (final entry in paramMap.entries) {
      final key = entry.key;
      final value = entry.value;

      // _paramControllers に TextEditingController を安全に保持
      if (!_paramControllers.containsKey(key)) {
        _paramControllers[key] = TextEditingController();
      }

      widgets.add(_buildParamRow(key, value));
    }

    return widgets;
  }

  /// フォーム行を描画（TextField の右に unit を固定表示）
  /// keyName はドット区切りキー (例: "size.depth")
  /// 通常のテキスト/ドロップダウン行の描画関数（既存のものを維持）
  /// key: dotted key, value: Map定義 (label/unit/option/…)
  Widget _buildParamRow(String key, dynamic param) {
    if (param == null) return const SizedBox.shrink();

    final label = (param is Map && param["label"] is String)
        ? param["label"] as String
        : key;
    final unit = (param is Map && param["unit"] is String)
        ? param["unit"] as String?
        : null;

    // --------------------------------------------
    // ① 実装形式 (implementation)
    // --------------------------------------------
    if (key == "implementation" && param is Map && param["option"] is List) {
      final options = List<String>.from(param["option"]);
      final currentValue = _selectedImplementation;

      final controller =
          _paramControllers.putIfAbsent(key, () => TextEditingController());

      return DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        initialValue: controller.text.isNotEmpty ? controller.text : null,
        items: options
            .map((opt) => DropdownMenuItem<String>(
                  value: opt,
                  child: Text(opt),
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            _selectedImplementation = val;
            controller.text = val ?? "";

            debugPrint("=====selectImpl=====: $_selectedImplementation");
            debugPrint("val: ${controller.text}");
          });
        },
      );
    }

    // --------------------------------------------
    // ② パッケージ (implementation依存)
    // --------------------------------------------
    if (key == "package" && param is Map) {
      final implOptions = param["optionByImplementation"];
      if (implOptions is Map<String, dynamic>) {
        final options = _selectedImplementation != null &&
                implOptions.containsKey(_selectedImplementation)
            ? List<String>.from(implOptions[_selectedImplementation] ?? [])
            : <String>[];
        debugPrint("=====add_package=====");
        debugPrint("op: $options");

        final controller =
            _paramControllers.putIfAbsent(key, () => TextEditingController());

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: label),
          initialValue: controller.text.isNotEmpty ? controller.text : null,
          items: options
              .map((opt) => DropdownMenuItem<String>(
                    value: opt,
                    child: Text(opt),
                  ))
              .toList(),
          onChanged: (val) {
            setState(() {
              controller.text = val ?? "";
              debugPrint("val: ${controller.text}");
            });
          },
        );
      }
    }

    // --------------------------------------------
    // ③ size のような label + 子要素を持つ構造
    // --------------------------------------------
    if (param is Map && param.containsKey("label")) {
      final subParams = param.entries
          .where((e) => e.key != "label" && e.key != "unit" && e.value is Map)
          .toList();

      if (subParams.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 6),
            ...subParams.map((e) => _buildParamRow(e.key, e.value)),
          ],
        );
      }
    }

    // --------------------------------------------
    // ④ 通常のパラメータ処理
    // optionがある → ドロップダウン
    // ない → テキストフィールド
    // --------------------------------------------
    final controller =
        _paramControllers.putIfAbsent(key, () => TextEditingController());

    if (param is Map && param.containsKey("option")) {
      List<String> options = List<String>.from(param["option"]);

      // 「その他」を追加（重複防止）
      if (!options.contains("その他")) options.add("その他");

      // 現在の選択値
      String? selectedOption =
          controller.text.isNotEmpty ? controller.text : null;

      // 「その他」入力欄用
      final otherController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedOption != "" ? selectedOption : null,
                decoration: InputDecoration(labelText: param["label"]),
                items: options.map((opt) {
                  return DropdownMenuItem<String>(
                    value: opt,
                    child: Text(opt),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedOption = newValue;
                    controller.text = newValue ?? "";
                    if (newValue != "その他") {
                      otherController.clear();
                    }
                  });
                },
              ),
              if (selectedOption == "その他") ...[
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: otherController,
                        decoration: InputDecoration(labelText: "その他（直接入力）"),
                        onChanged: (text) {
                          controller.text = text;
                        },
                      ),
                    ),
                  ],
                )
              ],
            ],
          );
        },
      );
    }

    // optionがない → 通常テキスト入力
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
          ),
        ),
        if (unit != null) ...[
          const SizedBox(width: 8),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(unit),
          ),
        ]
      ],
    );
  }

  Future<String> saveImageToAppDir(File original) async {
    final bytes = await original.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw Exception('画像のデコードに失敗');
    }

    // 横1600pxを上限に縮小（縦横比維持）
    final resized =
        decoded.width > 1600 ? img.copyResize(decoded, width: 1600) : decoded;

    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${dir.path}/parts_images');

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final file = File('${imageDir.path}/$fileName');
    await file.writeAsBytes(img.encodeJpg(resized, quality: 85));

    return file.path;
  }

  Future<void> _savePart() async {
    debugPrint("=== _savePart START ===");
    if (!_formKey.currentState!.validate()) {
      debugPrint("form validation failed");
      return;
    }

    debugPrint("selected category: $_selectedCategory");
    debugPrint("name: ${_nameController.text}");
    debugPrint("metadata controllers: $_paramControllers");

    // metadata を Map<String, dynamic> で作る（string値のみ格納）
    final Map<String, dynamic> metadata = {};
    _paramControllers.forEach((key, controller) {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        debugPrint("key: $key, text: $text");
        metadata[key] = text;
      }
    });

    debugPrint("metadata to save: $metadata");

    // 各フィールドをトリムして、空なら Value.absent() にする（nullable列向け）
    final nameValue = _nameController.text.trim();
    final codeText = _codeController.text.trim();
    final stockText = _stockController.text.trim();
    final locationText = _locationController.text.trim();
    final datasheetText = _datasheetUrlController.text.trim();
    final buyUrlText = _buyUrlController.text.trim();

    final companion = PartsCompanion(
      // category は nullable なので absent を使うパターン
      category: Value(_selectedCategory),

      subcategory: Value(_selectedSubcategory),

      // name は non-null（テーブル定義に合わせて必須扱い） -> ただし Value で渡す
      name: Value(nameValue),

      // optional fields
      code: codeText.isNotEmpty ? Value(codeText) : const Value.absent(),
      stock: stockText.isNotEmpty
          ? Value(int.tryParse(stockText) ?? 0)
          : const Value.absent(),
      location:
          locationText.isNotEmpty ? Value(locationText) : const Value.absent(),
      datasheetUrl: datasheetText.isNotEmpty
          ? Value(datasheetText)
          : const Value.absent(),
      buyUrl: buyUrlText.isNotEmpty ? Value(buyUrlText) : const Value.absent(),

      // metadata 列は non-null（現状）を想定。空でも {} を渡す。
      metadata: Value(metadata),
    );

    debugPrint("companion: $companion");

    try {
      //await widget.db.insertPart(companion);

      await widget.db.transaction(() async {
        widget.db.insertPartWithImages(companion, _images);
        /* // 1. Part 保存
        final partId = await widget.db.insertPart(companion);

        // 2. 画像保存
        for (int i = 0; i < _images.length; i++) {
          final srcFile = File(_images[i].file.path);

          // app 領域へコピー
          final dir = await getApplicationDocumentsDirectory();
          final imageDir = Directory('${dir.path}/part_images/$partId');
          if (!await imageDir.exists()) {
            await imageDir.create(recursive: true);
          }

          final ext = srcFile.path.split('.').last;
          final dstPath =
              '${imageDir.path}/${DateTime.now().millisecondsSinceEpoch}_$i.$ext';

          final savedFile = await srcFile.copy(dstPath);

          // DB 登録（順番付き）
          await widget.db.into(widget.db.partsImages).insert(
                PartsImagesCompanion.insert(
                  partId: partId,
                  imagePath: savedFile.path,
                  sortOrder: i,
                ),
          );
        }*/
      });

      debugPrint("insert");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("部品を登録しました")),
      );
      debugPrint("snackbar");

      // 入力フォームをリセット（カテゴリも含めて）
      setState(() {
        _selectedCategory = null; // カテゴリもリセット
        _nameController.clear();
        _codeController.clear();
        _stockController.clear();
        _locationController.clear();
        _datasheetUrlController.clear();
        _buyUrlController.clear();
        for (final controller in _paramControllers.values) {
          controller.clear();
        }
        _images.clear(); // ★ 画像もリセット
      });
    } catch (e, st) {
      debugPrint('insertPart error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存に失敗しました: $e')),
        );
        Navigator.of(context).pop(false); // 失敗したら false を返す
      }
    }
  }

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scrollKey = GlobalKey();
  int? _draggingIndex;
  int? _targetIndex;
  bool _isDraggingAtTail = false;

  late final AnimationController _dragAnimController;
  late final Animation<double> _dragScale;
  late final Animation<double> _dragOpacity;

  final List<ImageItem> _images = [];

  Future<void> _pickFromGallery() async {
    final List<XFile> picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        for (final f in picked) {
          _images.add(ImageItem(f));
        }
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _images.add(ImageItem(picked));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);

      if (_draggingIndex != null) {
        if (_draggingIndex == index) {
          _draggingIndex = null;
          _targetIndex = null;
        } else if (_draggingIndex! > index) {
          _draggingIndex = _draggingIndex! - 1;
        }
      }

      if (_targetIndex != null && _targetIndex! > index) {
        _targetIndex = _targetIndex! - 1;
      }
    });
  }

  RenderBox? _getScrollRenderBox() {
    final ctx = _scrollKey.currentContext;
    if (ctx == null) return null;

    final renderObject = ctx.findRenderObject();
    if (renderObject == null || !renderObject.attached) {
      return null;
    }

    return renderObject as RenderBox;
  }

  void _handleAutoScroll(Offset globalPosition) {
    final renderBox = _getScrollRenderBox();
    if (renderBox == null) return;

    final local = renderBox.globalToLocal(globalPosition);

    // 実コンテンツ幅
    double contentWidth = 0;
    for (final item in _images) {
      contentWidth += (item.width ?? 100);
    }

    const tailHitMargin = 16.0;

    // --- 最後尾判定 ---
    final atTail = local.dx > contentWidth - tailHitMargin;

    if (_isDraggingAtTail != atTail) {
      setState(() {
        _isDraggingAtTail = atTail;
        _targetIndex = atTail ? _images.length : _targetIndex;
      });
    }

    // --- auto-scroll ---
    const edgeThreshold = 40;
    const scrollSpeed = 12;

    if (local.dx < edgeThreshold) {
      _scrollController.jumpTo(
        (_scrollController.offset - scrollSpeed)
            .clamp(0.0, _scrollController.position.maxScrollExtent),
      );
    } else if (local.dx > renderBox.size.width - edgeThreshold) {
      _scrollController.jumpTo(
        (_scrollController.offset + scrollSpeed)
            .clamp(0.0, _scrollController.position.maxScrollExtent),
      );
    }
  }

  Widget _childDrag(int index) {
    return SizedBox(
      width: _images[index].width ?? 100, // 初回保険
      height: 200,
    );
  }

  Widget _imageItem(int index) {
    final bool isDragging = _draggingIndex == index;

    return AnimatedScale(
      scale: isDragging ? 0.9 : 1.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: isDragging ? 0.4 : 1.0,
        duration: const Duration(seconds: 1),
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.file(
                File(_images[index].file.path),
                key: _images[index].key,
                height: 100,
                fit: BoxFit.fitHeight,
                frameBuilder: (context, child, frame, _) {
                  // ★最初にレイアウトされた瞬間だけ width を保存
                  if (frame != null && _images[index].width == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final ctx = _images[index].key.currentContext;
                      if (ctx == null) return;
                      final box = ctx.findRenderObject() as RenderBox;
                      _images[index].width = box.size.width;
                    });
                  }
                  return child;
                },
              ),
              Positioned(
                top: -6,
                right: -6,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                  onPressed: () {
                    setState(() => _removeImage(index));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(int index) {
    final isLast = index == _images.length - 1;
    const tailAreaWidth = 24.0;

    return LongPressDraggable<int>(
      data: index,
      onDragStarted: () {
        _dragAnimController.forward(from: 0);
        _draggingIndex = index;
      },
      onDragUpdate: (details) {
        _handleAutoScroll(details.globalPosition);
      },
      onDragEnd: (_) {
        if (_draggingIndex != null &&
            _targetIndex != null &&
            _draggingIndex != _targetIndex) {
          setState(() {
            final item = _images.removeAt(_draggingIndex!);
            final insertIndex =
                _targetIndex! > _images.length ? _images.length : _targetIndex!;
            _images.insert(insertIndex, item);
          });
        }

        setState(() {
          _draggingIndex = null;
          _targetIndex = null;
        });
      },
      feedback: _dragFeedback(index),
      childWhenDragging: _childDrag(index),
      child: DragTarget<int>(onWillAccept: (from) {
        if (from == null || from == index) return false;

        setState(() {
          _targetIndex = index;
        });
        return true;
      }, onMove: (details) {
        // ★ 最後の画像の「尾部」に入ったら最後尾扱い
        if (isLast) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final local = box.globalToLocal(details.offset);
            if (local.dx > box.size.width - tailAreaWidth) {
              if (_targetIndex != _images.length) {
                setState(() {
                  _targetIndex = _images.length;
                });
              }
            }
          }
        }
      }, builder: (context, _, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 前方挿入ライン
            if (_draggingIndex != null && _targetIndex == index)
              _insertIndicator(),

            _staticImageView(index),

            // ★ 最後尾専用エリア
            if (isLast)
              SizedBox(
                width: tailAreaWidth,
                child: _draggingIndex != null && _targetIndex == _images.length
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: _insertIndicator(),
                      )
                    : null,
              ),
          ],
        );
      }),
    );
  }

  Widget _staticImageView(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.file(
            File(_images[index].file.path),
            key: _images[index].key,
            height: 200,
            fit: BoxFit.fitHeight,
            frameBuilder: (context, child, frame, _) {
              // ★最初にレイアウトされた瞬間だけ width を保存
              if (frame != null && _images[index].width == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final ctx = _images[index].key.currentContext;
                  if (ctx == null) return;
                  final box = ctx.findRenderObject() as RenderBox;
                  _images[index].width = box.size.width;
                });
              }
              return child;
            },
          ),
          Positioned(
            top: -6,
            right: -6,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.red),
              onPressed: () {
                setState(() => _images.removeAt(index));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageView(int index, {double scale = 1.0, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(seconds: 1),
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.file(
                File(_images[index].file.path),
                key: _images[index].key,
                height: 200,
                fit: BoxFit.fitHeight,
                frameBuilder: (context, child, frame, _) {
                  // ★最初にレイアウトされた瞬間だけ width を保存
                  if (frame != null && _images[index].width == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final ctx = _images[index].key.currentContext;
                      if (ctx == null) return;
                      final box = ctx.findRenderObject() as RenderBox;
                      _images[index].width = box.size.width;
                    });
                  }
                  return child;
                },
              ),
              Positioned(
                top: -6,
                right: -6,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                  onPressed: () {
                    setState(() => _removeImage(index));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dragFeedback(int index) {
    return AnimatedBuilder(
      animation: _dragAnimController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _dragOpacity,
          child: ScaleTransition(
            scale: _dragScale,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: _staticImageView(index),
      ),
    );
  }

  Widget _insertIndicator() {
    return Container(
      width: 2,
      height: 200,
      margin: const EdgeInsets.only(right: 12),
      color: Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("部品を追加")),
      body: _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _pickFromGallery,
                        child: const Text('ギャラリー'),
                      ),
                      ElevatedButton(
                        onPressed: _takePhoto,
                        child: const Text('カメラ'),
                      ),
                    ],
                  ),
                  const Spacer(),

                  SizedBox(
                    key: _scrollKey,
                    height: 200,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        ...List.generate(
                          _images.length,
                          (index) => _buildImageItem(index),
                        ),
                        //_buildEndDragTarget(),
                        // ★ 最後尾専用の DragTarget（透明）
                        DragTarget<int>(
                          onWillAccept: (from) {
                            if (from == null) return false;
                            setState(() {
                              _targetIndex = _images.length;
                            });
                            return true;
                          },
                          builder: (_, __, ___) {
                            return SizedBox(
                              width: 24, // ← ヒットテスト用（描画はしない）
                              height: 200,
                            );
                          },
                        ),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // ===== メインカテゴリ =====
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "カテゴリ"),
                    items: _categories.entries
                        .map((entry) => DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value["name"] ?? entry.key),
                            ))
                        .toList(),
                    initialValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        _selectedSubcategory = null;
                        _paramControllers.clear();
                      });
                    },
                  ),

                  // ===== サブカテゴリ（存在する場合のみ） =====
                  if (_selectedCategory != null &&
                      _categories[_selectedCategory]?["subcategories"] != null)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "サブカテゴリ"),
                      items: (_categories[_selectedCategory]!["subcategories"]
                              as Map<String, dynamic>)
                          .entries
                          .map((entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value["name"] ?? entry.key),
                              ))
                          .toList(),
                      initialValue: _selectedSubcategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedSubcategory = value;
                          _paramControllers.clear();
                        });
                      },
                    ),

                  // ===== 共通フィールド =====
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "部品名"),
                    validator: (v) => v == null || v.isEmpty ? "必須項目です" : null,
                  ),
                  TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(labelText: "型番")),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(labelText: "在庫数"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: "保管場所")),
                  TextFormField(
                      controller: _datasheetUrlController,
                      decoration:
                          const InputDecoration(labelText: "データシートURL")),
                  TextFormField(
                      controller: _buyUrlController,
                      decoration: const InputDecoration(labelText: "購入先URL")),

                  const SizedBox(height: 20),

                  // ===== カテゴリパラメータ =====
                  if (_selectedCategory != null) ...[
                    const Divider(),
                    Text("カテゴリパラメータ",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    ..._buildCategoryParams(),
                  ],

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _savePart,
                    icon: const Icon(Icons.save),
                    label: const Text("登録"),
                  ),
                ],
              ),
            ),
    );
  }
}

class ImageItem {
  ImageItem(this.file) : key = GlobalKey();

  final XFile file;
  final GlobalKey key;

  double? width;
}
