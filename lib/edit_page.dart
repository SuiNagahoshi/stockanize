import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
// ここで Part の型が生成されている前提
import 'package:stockanize/db/parts.dart';
import 'add_page.dart';
import 'db/database.dart';

class EditPartPage extends StatefulWidget {
  final AppDatabase db;
  final Part? part; // ← ここが渡される Part

  const EditPartPage({super.key, required this.db, this.part});

  @override
  State<EditPartPage> createState() => _EditPartPageState();
}

class _EditPartPageState extends State<EditPartPage>
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
  String? _selectedImplementation;
  final Map<String, TextEditingController> _paramControllers = {};

  final List<ImageItem> _images = [];
  bool _loadingImages = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // カテゴリを読み込み、読み込み完了後に part の初期化を行う
    _loadCategories().then((_) {
      if (widget.part != null) {
        _applyPartToControllers(widget.part!);
      }
    });
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
    for (final c in _paramControllers.values) {
      c.dispose();
    }
    _paramControllers.clear();

    _nameController.dispose();
    _codeController.dispose();
    _stockController.dispose();
    _locationController.dispose();
    _datasheetUrlController.dispose();
    _buyUrlController.dispose();

    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scrollKey = GlobalKey();
  int? _draggingIndex;
  int? _targetIndex;
  bool _isDraggingAtTail = false;

  late final AnimationController _dragAnimController;
  late final Animation<double> _dragScale;
  late final Animation<double> _dragOpacity;

  Future<void> _loadCategories() async {
    final jsonStr = await rootBundle.loadString('assets/categories.json');
    final dynamic decoded = jsonDecode(jsonStr);
    if (decoded is Map) {
      setState(() {
        _categories = Map<String, dynamic>.from(decoded);
      });
    } else {
      setState(() {
        _categories = {};
      });
    }
  }

  Future<void> _loadPartImages(int partId) async {
    final rows = await widget.db.getImagesByPartId(partId);

    _images.clear();

    for (final row in rows) {
      _images.add(
        ImageItem(
          XFile(row.imagePath),
        ),
      );
    }

    setState(() {
      _loadingImages = false;
    });
  }

  /// Part を受け取り UI の初期値としてセットする
  void _applyPartToControllers(Part part) {
    _loadPartImages(part.id);
    // category は UI 上のカテゴリ選択に反映
    setState(() {
      _selectedCategory = part.category;
      _selectedSubcategory = part.subcategory ?? "";
      _nameController.text = part.name;
      _codeController.text = part.code ?? "";
      _stockController.text = part.stock.toString();
      _locationController.text = part.location ?? "";
      _datasheetUrlController.text = part.datasheetUrl ?? "";
      _buyUrlController.text = part.buyUrl ?? "";

      // metadata は Map<String, dynamic>?（converter により）
      final meta = part.metadata;
      if (meta != null) {
        // controller が未作成のキーもあるため、ここで作成して値を入れる
        meta.forEach((k, v) {
          final s = v == null ? "" : v.toString();
          // すでにコントローラがある場合はテキストを設定、なければ新規作成
          final controller =
              _paramControllers.putIfAbsent(k, () => TextEditingController());
          controller.text = s;
        });

        debugPrint("=======meta=======");
        debugPrint("meta: $meta");
        debugPrint("impl: ${meta.containsKey("implementation")}");

        // もし implementation に値があれば反映しておく
        if (meta.containsKey("implementation")) {
          _selectedImplementation = meta["implementation"]?.toString();
        }
      }
    });
  }

  // 以降は既存実装（必要に応じてそのまま使えるよう調整）
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

    paramMap.remove("name");
    paramMap.remove("subcategories");

    final widgets = <Widget>[];

    for (final entry in paramMap.entries) {
      final key = entry.key;
      final value = entry.value;

      debugPrint("=======buildCategoryParams=======");
      debugPrint("key: $key, value: $value");

      // _paramControllers に TextEditingController を安全に保持
      if (!_paramControllers.containsKey(key)) {
        _paramControllers[key] = TextEditingController();
      }

      widgets.add(_buildParamRow(key, value));
    }

    return widgets;
  }

  Widget _buildParamRow(String key, dynamic param) {
    if (param == null) return const SizedBox.shrink();

    final label = (param is Map && param["label"] is String)
        ? param["label"] as String
        : key;
    final unit = (param is Map && param["unit"] is String)
        ? param["unit"] as String?
        : null;

    debugPrint("=======buildCategoryParams=======");
    debugPrint("key: $key,label: $label, unit: $unit");

    // implementation (選択肢)
    if (key == "implementation" && param is Map && param["option"] is List) {
      final options = List<String>.from(param["option"]);
      final currentValue = _selectedImplementation;

      debugPrint("=======implementation=======");
      debugPrint(
          "type: ${param["option"].runtimeType}, param: $param, op: $options, value: $currentValue");

      return DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        initialValue: currentValue,
        items: options
            .map((opt) => DropdownMenuItem<String>(
                  value: opt,
                  child: Text(opt),
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            _selectedImplementation = val;
            // metadata 用 controller も更新しておく
            _paramControllers[key]?.text = val ?? "";
          });
        },
      );
    }

    // package (implementation に依存するドロップダウン)
    if (key == "package" && param is Map) {
      final implOptions = param["optionByImplementation"];
      debugPrint("=======package=======");
      debugPrint(
          "type: ${param.runtimeType}, param: $param, impl: $implOptions, implType: ${implOptions.runtimeType}");
      if (implOptions is Map<String, dynamic>) {
        final options = _selectedImplementation != null &&
                implOptions.containsKey(_selectedImplementation)
            ? List<String>.from(implOptions[_selectedImplementation] ?? [])
            : <String>[];

        final controller =
            _paramControllers.putIfAbsent(key, () => TextEditingController());

        debugPrint("controller: $controller\ntext: ${controller.text}");

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
            });
          },
        );
      }
    }

    // size のような子要素を持つ構造
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

    // 通常のパラメータ処理
    final controller =
        _paramControllers.putIfAbsent(key, () => TextEditingController());

    if (param is Map && param.containsKey("option")) {
      List<String> options = List<String>.from(param["option"]);

      if (!options.contains("その他")) options.add("その他");

      String? selectedOption =
          controller.text.isNotEmpty ? controller.text : null;

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
            padding: const EdgeInsets.only(left: 10),
            child: Text(unit),
          ),
        ]
      ],
    );
  }

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

  Widget _childDrag(int index) {
    return SizedBox(
      width: _images[index].width ?? 100, // 初回保険
      height: 200,
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

  Future<void> _savePart() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> metadata = {};
    _paramControllers.forEach((key, controller) {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        metadata[key] = text;
      }
    });

    final companion = PartsCompanion(
      category: _selectedCategory != null
          ? Value(_selectedCategory!)
          : const Value.absent(),
      subcategory: _selectedSubcategory != null
          ? Value(_selectedSubcategory!)
          : const Value.absent(),
      name: Value(_nameController.text.trim()),
      code: _codeController.text.isNotEmpty
          ? Value(_codeController.text)
          : const Value.absent(),
      stock: _stockController.text.isNotEmpty
          ? Value(int.tryParse(_stockController.text) ?? 0)
          : const Value.absent(),
      location: _locationController.text.isNotEmpty
          ? Value(_locationController.text)
          : const Value.absent(),
      datasheetUrl: _datasheetUrlController.text.isNotEmpty
          ? Value(_datasheetUrlController.text)
          : const Value.absent(),
      buyUrl: _buyUrlController.text.isNotEmpty
          ? Value(_buyUrlController.text)
          : const Value.absent(),
      metadata: metadata.isNotEmpty ? Value(metadata) : const Value.absent(),
    );

    final result = (widget.part ??
            Part(
              id: 0,
              accountId: widget.db.currentAccountId,
              groupId: widget.db.currentGroupId,
              category: null,
              subcategory: null,
              name: '',
              code: null,
              stock: 0,
              location: null,
              datasheetUrl: null,
              buyUrl: null,
              metadata: const {},
            ))
        .copyWith(
      accountId: Value(widget.db.currentAccountId),
      groupId: Value(widget.db.currentGroupId),
      category: Value(_selectedCategory),
      subcategory: Value(_selectedSubcategory),
      name: _nameController.text,
      code: Value(_codeController.text),
      stock: int.tryParse(_stockController.text) ?? 0,
      location: Value(_locationController.text),
      datasheetUrl: Value(_datasheetUrlController.text),
      buyUrl: Value(_buyUrlController.text),
      metadata: metadata,
    );

    try {
      if (widget.part == null) {
        // --- 新規追加 ---
        await widget.db.insertPart(companion);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("部品を登録しました")),
        );
      } else {
        // --- 既存更新 ---
        /* await (widget.db.update(widget.db.parts)
              ..where((tbl) => tbl.id.equals(widget.part!.id)))
            .write(companion);*/
        await widget.db.updatePartWithImages(result, _images);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("部品を更新しました")),
        );
      }

      //Navigator.push(context, MaterialPageRoute(builder: (context) => HeroListItemPage(part: widget.part, index: index, heroTag: heroTag, db: db)))
      debugPrint(
          'PartEdit: pop returning -> id:${result.id} name:${result.name} code:${result.code} location:${result.location} stock:${result.stock}\nmetadata:${result.metadata}');
      print("Edit DB instance: ${widget.db.hashCode}");

      Navigator.of(context).pop(result);
    } catch (e, st) {
      debugPrint('savePart error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存に失敗しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.part == null ? "部品を追加" : "部品を編集")),
      body: _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /*SizedBox(
                    height: 110,
                    child: _loadingImages
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                _images.length,
                                (index) => _buildImageItem(index),
                              ),
                            ),
                          ),
                  ),*/
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
                        // カテゴリ変更時は param controllers を一旦クリアして再生成する
                        for (final c in _paramControllers.values) {
                          c.dispose();
                        }
                        _paramControllers.clear();
                      });
                    },
                  ),

                  // サブカテゴリ（あれば）
                  if (_selectedCategory != null &&
                      _categories[_selectedCategory]?["subcategories"] != null)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "サブカテゴリ"),
                      items: (_categories[_selectedCategory]!["subcategories"]
                              as Map<String, dynamic>)
                          .entries
                          .map(
                            (entry) => DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value["name"] ?? entry.key),
                            ),
                          )
                          .toList(),
                      initialValue:
                          (_categories[_selectedCategory]!["subcategories"]
                                      as Map<String, dynamic>)
                                  .containsKey(_selectedSubcategory)
                              ? _selectedSubcategory
                              : null,
                      onChanged: (value) {
                        setState(() {
                          _selectedSubcategory = value;
                        });
                      },
                    ),

                  // 共通フィールド
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

                  // カテゴリパラメータ
                  if (_selectedCategory != null) ...[
                    const Divider(),
                    Text("カテゴリパラメータ",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    ..._buildCategoryParams(),
                  ],

                  const SizedBox(height: 20),
                  SafeArea(
                    child: ElevatedButton.icon(
                      onPressed: _savePart,
                      icon: const Icon(Icons.save),
                      label: Text(widget.part == null ? "登録" : "更新"),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
