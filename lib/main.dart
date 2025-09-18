import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:linkwell/linkwell.dart';

import 'package:stockanize/db/database.dart';
import 'package:stockanize/db/parts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();

  runApp(MyApp(db: db));
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
      body: FutureBuilder<List<Part>>(
        future: widget.db.getAllParts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final parts = snapshot.data!;
          if (parts.isEmpty) return const Center(child: Text("no item"));

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
                    await widget.db.deletePart(part.id);
                    setState(() {});
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
      icon: const Icon(Icons.person),
      title: const Text("Settings"),
      selectedColor: Colors.orange),
];

class HeroListItemPage extends StatelessWidget {
  final Part part;
  final int index;
  const HeroListItemPage({super.key, required this.part, required this.index});

  @override
  Widget build(BuildContext context) {
    final metadata = part.metadata;

    return Scaffold(
      appBar: AppBar(title: Text(part.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: "hero_list_item_$index",
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
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(part.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  Text(part.category ?? ""),
                  Column(
                    children: [
                      _buildInfoRow("在庫数", part.stock),
                      _buildInfoRow("保管場所", part.location),
                      _buildLinkRow("データシート", part.datasheetUrl),
                      _buildLinkRow("購入先", part.buyUrl),
                      const Divider(),
                      ...metadata.entries.map(
                        (e) => _buildInfoRow(e.key, e.value),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value, {double indent = 0}) {
    if (value is Map<String, dynamic>) {
      return Padding(
        padding: EdgeInsets.only(left: indent, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ...value.entries
                .map((e) => _buildInfoRow(e.key, e.value, indent: indent + 16)),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: indent, top: 4, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(child: Text(value?.toString() ?? "")),
          ],
        ),
      );
    }
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
