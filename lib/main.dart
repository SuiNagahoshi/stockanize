import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:stockanize/add_page.dart';

import 'package:stockanize/db/database.dart';
import 'package:stockanize/db/parts.dart';
import 'package:stockanize/parts_list_page.dart';
import 'package:stockanize/qr_scan_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };

  final db = AppDatabase();

  runZonedGuarded(() {
    runApp(MyApp(
      db: db,
    ));
  }, (error, stack) {
    debugPrint('Uncaught zone error: $error\n$stack');
  });
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockanize',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StockanizeHomePage(db: db, title: 'Stockanize Home'),
      routes: {
        '/home': (context) =>
            StockanizeHomePage(title: 'Stockanize Home', db: db),
        '/add': (context) => AddPartPage(db: db)
      },
    );
  }
}

class StockanizeHomePage extends StatefulWidget {
  const StockanizeHomePage({super.key, required this.title, required this.db});
  final String title;
  final AppDatabase db;

  @override
  State<StockanizeHomePage> createState() => _StockanizeHomePageState();
}

class _StockanizeHomePageState extends State<StockanizeHomePage> {
  Future<void> _addItem() async {
    const samplePart = PartsCompanion(
      category: Value("Resistor"),
      name: Value("1kΩ Resistor"),
      code: Value("1111"),
      stock: Value(120),
      location: Value("Box A1"),
      datasheetUrl: Value("https://example.com/datasheet.pdf"),
      buyUrl: Value("https://shop.example.com/resister1/"),
      metadata: Value({
        "resistance": "1kΩ",
        "tolerance": "±5%",
        "power": "1/4W",
        "package": "THD",
        "size": {"depth": "2.7mm", "length": "9mm"}
      }),
    );

    await widget.db.insertPart(samplePart);
    setState(() {}); // DB追加後に再描画
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: <Widget>[
        SizedBox.expand(
          child: PartsListPage(db: widget.db),
        ),
        SizedBox.expand(
          child: AddPartPage(db: widget.db),
        ),
        SizedBox.expand(
          child: QrScannerPage(),
        ),
        SizedBox.expand(
          child: Center(
            child: Text("test3"),
          ),
        ),

      ][_index],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem();
        },
        tooltip: 'Add Part',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _index,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: _navBarItems,
      ),

    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Home"),
      selectedColor: Colors.purple),
  SalomonBottomBarItem(
      icon: const Icon(Icons.add_circle),
      title: const Text("Add"),
      selectedColor: Colors.teal),
  SalomonBottomBarItem(
      icon: const Icon(Icons.qr_code),
      title: const Text("QRCode"),
      selectedColor: Colors.lightGreen),
  SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: const Text("Settings"),
      selectedColor: Colors.orange),
];

/*
class PartAdd extends StatefulWidget {
  final AppDatabase database;

  const PartAdd({super.key, required this.database});

  @override
  State<StatefulWidget> createState() => _PartAddState();
}

class _PartAddState extends State<PartAdd> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  //final _categoryController = TextEditingController();
  final _partCodeController = TextEditingController();
  final _stockController = TextEditingController();
  final _locationController = TextEditingController();
  final _datasheetUrlController = TextEditingController();
  final _buyUrlController = TextEditingController();

  String? _selectedCategory;

  final Map<String, TextEditingController> _metadataControllers = {};

  final Map<String, dynamic> _metadataSchema = {
    "Resistor": {
      "resistance": null,
      "tolerance": null,
      "power": null,
      "package": null,
      "size": {
        "depth": null,
        "length": null,
      },
    },
    "IC": {
      "pins": null,
      "package": null,
      "voltage": null,
      "size": {
        "width": null,
        "depth": null,
        "height": null,
      },
    },
  };

  void _onCategoryChanged(String? value) {
    setState(() {
      _selectedCategory = value;
      _metadataControllers.clear();
      if (value != null && _metadataSchema.containsKey(value)) {
        for (var key in _metadataSchema[value]!) {
          _metadataControllers[key] = TextEditingController();
        }
      }
    });
  }

  Future<void> _savePart() async {
    if (_formKey.currentState?.validate() ?? false) {
      final metadata = <String, dynamic>{};
      _metadataControllers.forEach((key, controller) {
        metadata[key] = controller.text;
      });

      final part = Part(
          name: _nameController.text,
          category: _selectedCategory ?? "Unknown",
          code: _partCodeController.text,
          stock: int.tryParse(_stockController.text) ?? 0,
          location: _locationController.text,
          datasheetUrl: _datasheetUrlController.text.isEmpty ? null : _datasheetUrlController.text,
          buyUrl: _buyUrlController.text.isEmpty ? null : _buyUrlController.text,
          metadata: metadata
      );
      
      await widget.database.insertPart(part as PartsCompanion);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("部品を追加しました")),
      );

      _nameController.clear();
      _partCodeController.clear();
      _stockController.clear();
      _locationController.clear();
      _datasheetUrlController.clear();
      _buyUrlController.clear();
      _onCategoryChanged(null);
    }
  }

  Widget _buildMetadataFields(Map<String, dynamic> schema, Map<String, dynamic> values, {double indent = 0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: schema.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;

        if (value is Map<String, dynamic>) {
          values[key] ??= {};
          return Padding(
            padding: EdgeInsets.only(left: indent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
                _buildMetadataFields(value, values[key], indent: indent + 16),
              ],
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(left: indent, bottom: 8),
            child: TextFormField(
              decoration: InputDecoration(labelText: key),
              onChanged: (val) => values[key] = val,
            ),
          );
        }
      }).toList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("部品を追加")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "部品名"),
              onSaved: (value) => _name = value ?? "",
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "カテゴリ"),
              onSaved: (value) => _category = value ?? "",
            ),
            const SizedBox(height: 16),
            if (_category.isNotEmpty && _metadataSchema.containsKey(_category))
              _buildMetadataFields(_metadataSchema[_category], ""),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePart,
              child: const Text("保存"),
            ),
          ],
        ),
      ),
    );
  }
}*/
