import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:stockanize/db/parts.dart';

import 'db/database.dart';

class AddPartPage extends StatefulWidget {
  final AppDatabase db;
  const AddPartPage({super.key, required this.db});

  @override
  State<AddPartPage> createState() => _AddPartPageState();
}

class _AddPartPageState extends State<AddPartPage> {
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
  Map<String, TextEditingController> _paramControllers = {};

  late Map<String, double> _maxUnitWidths = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
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
        _maxUnitWidths = unitWidths;
      });
    } else {
      setState(() {
        _categories = {};
        _maxUnitWidths = {};
      });
    }
  }

  // --- カテゴリ変更時の処理: 既存コントローラは dispose してから新規作成 ---
  void _onCategorySelected(String? category) {
    if (category == null) return;

    // 既存コントローラを破棄してからクリア（メモリリーク防止）
    for (final c in _paramControllers.values) {
      c.dispose();
    }
    _paramControllers.clear();

    setState(() {
      _selectedCategory = category;
      final paramsDynamic = _categories[category];
      if (paramsDynamic is Map) {
        _createControllersForParams(Map<String, dynamic>.from(paramsDynamic));
      }
    });
  }

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
        maxWidth = tp.width;
      }
    }
    return maxWidth;
  }

  /// schema を再帰して "leaf" (label を持つフィールド) に対して
  /// controller を作る。キーはドット区切り (例: "size.depth") で格納する。
  void _createControllersForParams(Map<String, dynamic> params,
      [String prefix = ""]) {
    params.forEach((key, value) {
      final dottedKey = prefix.isEmpty ? key : "$prefix.$key";

      if (value is Map) {
        // leaf 判定: 'label' キーがあれば入力フィールドの対象
        final mapValue = Map<String, dynamic>.from(value);
        if (mapValue.containsKey('label')) {
          // leaf: コントローラを用意
          _paramControllers.putIfAbsent(
              dottedKey, () => TextEditingController());
        } else {
          // container: ネストを再帰（子要素をそのまま渡す）
          _createControllersForParams(mapValue, dottedKey);
        }
      } else {
        // 予期しない型でもトリビアルに controller を作る（互換性維持）
        _paramControllers.putIfAbsent(dottedKey, () => TextEditingController());
      }
    });
  }

  /// ドット区切りキーに対応して schema 定義を辿るヘルパ
  Map<String, dynamic>? _resolveDefForDottedKey(
      String category, String dottedKey) {
    final catDefRaw = _categories[category];
    if (catDefRaw is! Map) return null;

    Map<String, dynamic>? node = Map<String, dynamic>.from(catDefRaw);
    final parts = dottedKey.split('.');
    for (final p in parts) {
      final child = node?[p];
      if (child == null) return null;
      if (child is Map) {
        node = Map<String, dynamic>.from(child);
      } else {
        return null;
      }
    }
    return node;
  }

  /// フォーム行を描画（TextField の右に unit を固定表示）
  /// keyName はドット区切りキー (例: "size.depth")
  Widget _buildParamRow(String keyName, TextEditingController controller) {
    final category = _selectedCategory ?? '';
    final def = _resolveDefForDottedKey(category, keyName);

    final label = (def != null && def['label'] != null)
        ? def['label'].toString()
        : keyName.split('.').last;
    final unit =
        (def != null && def['unit'] != null) ? def['unit'].toString() : null;

    // カテゴリごとの最大 unit 幅を取得
    final unitWidth = _maxUnitWidths[category] ?? 0;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: unitWidth, // unit が null でも必ず幅を確保
              child: (unit != null)
                  ? Text(unit, style: const TextStyle(color: Colors.grey))
                  : const SizedBox.shrink(),
            )
          ]),
        ]));
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
      category: _selectedCategory != null
          ? Value(_selectedCategory!)
          : const Value.absent(),

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
      metadata: metadata.isNotEmpty ? Value(metadata) : const Value.absent(),
    );

    debugPrint("companion: $companion");

    /*try {
      final id = await widget.db.insertPart(companion);
      debugPrint("inserted part with id: $id");
      //if (!mounted) return;
      if (!mounted) {
        debugPrint("not mounted");
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("部品を登録しました")));
      //Navigator.of(context).pop(); // 登録後に閉じる
      Navigator.pop(context);
    } catch (e, st) {
      // ここでログを残してクラッシュを防ぐ
      debugPrint('insertPart error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('保存に失敗しました: $e')));
      }
    }*/
    try {
      await widget.db.insertPart(companion);
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
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "カテゴリ"),
                    items: _categories.keys
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    value: _selectedCategory,
                    onChanged: _onCategorySelected,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "部品名"),
                    validator: (v) => v == null || v.isEmpty ? "必須項目です" : null,
                  ),
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(labelText: "型番"),
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(labelText: "在庫数"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: "保管場所"),
                  ),
                  TextFormField(
                    controller: _datasheetUrlController,
                    decoration: const InputDecoration(labelText: "データシートURL"),
                  ),
                  TextFormField(
                    controller: _buyUrlController,
                    decoration: const InputDecoration(labelText: "購入先URL"),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedCategory != null) ...[
                    const Divider(),
                    Text("カテゴリパラメータ",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    ..._paramControllers.entries
                        .map((e) => _buildParamRow(e.key, e.value))
                        .toList(),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _savePart,
                    icon: const Icon(Icons.save),
                    label: const Text("登録"),
                  )
                ],
              ),
            ),
    );
  }
}
