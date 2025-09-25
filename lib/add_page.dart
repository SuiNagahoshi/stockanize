import 'dart:convert';
import 'package:drift/drift.dart';
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
    // decoded が Map であることを確認してキャスト
    if (decoded is Map) {
      setState(() {
        _categories = Map<String, dynamic>.from(decoded);
      });
    } else {
      // 異常系: 空にしておく
      setState(() {
        _categories = {};
      });
    }
  }

  // カテゴリ選択時（既存コントローラは dispose してからクリア）
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
        // Map の型を Map<String,dynamic> に変換して渡す
        _createControllersForParams(Map<String, dynamic>.from(paramsDynamic));
      }
    });
  }

  // 再帰的にコントローラを作る（Map<String,dynamic> を受け取る）
  void _createControllersForParams(Map<String, dynamic> params,
      [String prefix = ""]) {
    params.forEach((key, value) {
      final fieldKey = "$prefix$key";
      if (value is Map) {
        // ネストする Map も同様にキャストして再帰呼び出し
        _createControllersForParams(
            Map<String, dynamic>.from(value), "$fieldKey.");
      } else {
        // 既にコントローラがあれば再利用、なければ作成
        _paramControllers.putIfAbsent(fieldKey, () => TextEditingController());
      }
    });
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
      //Navigator.of(context).pop(true); // 成功したら true を返す
      // debugPrint("navigator complete");
      //Navigator.pushReplacementNamed(context, '/home');
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
                    ..._paramControllers.entries.map((e) => TextFormField(
                          controller: e.value,
                          decoration: InputDecoration(labelText: e.key),
                        )),
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
