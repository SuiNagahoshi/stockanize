import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:linkwell/linkwell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockanize',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StockanizeHomePage(title: 'Stockanize Home'),
    );
  }
}

class StockanizeHomePage extends StatefulWidget {
  const StockanizeHomePage({super.key, required this.title});

  final String title;

  @override
  State<StockanizeHomePage> createState() => _StockanizeHomePageState();
}

class _StockanizeHomePageState extends State<StockanizeHomePage> {
  int _counter = 0;
  int _index = 0;

  final List<String> _items = [];

  void _addItem() {
    setState(() {
      _counter++;
      _items.add('item ${_items.length + 1}');
    });
  }

  void _removeItem(int index) {
    setState(() {
      _counter--;
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter in Item List',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
                child: _items.isEmpty
                    ? const Center(
                        child: Text("no item"),
                      )
                    : ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            minTileHeight: 85,
                            title: Text("${_items[index]}"),
                            leading: Hero(
                                tag: "hero_list_item_$index",
                                child: Container(
                                  width: 60,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue.withValues(alpha: 0.1),
                                  ),
                                  child: const Icon(
                                      Icons.electrical_services_outlined),
                                )),
                            trailing: IconButton(
                                onPressed: () => _removeItem(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HeroListItemPage(index: index))),
                          );
                        }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem();
        },
        tooltip: 'Increment',
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
  final int index;
  HeroListItemPage({super.key, required this.index});

  final Map<String, dynamic> partData = const {
    "category": "Resistor",
    "name": "1kΩ Resistor",
    "stock": 120,
    "location": "Box A1",
    "datasheetUrl": "https://example.com/datasheet.pdf",
    "buyUrl": "https://shop.example.com/resister1/",
    "metadata": {
      "resistance": "1kΩ",
      "tolerance": "±5%",
      "power": "1/4W",
      "package": "THD",
      "size": {
        "depth": "2.7mm",
        "length": "9mm"
      }
    }
  };

  @override
  Widget build(BuildContext context) {
    final metadata = partData["metadata"] as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title: Text("Item ${index + 1}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
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
                            color: Colors.blue.withValues(alpha: 0.1)),
                        child: const Center(
                          child: Icon(
                            Icons.electrical_services_outlined,
                            color: Colors.blue,
                            size: 100,
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "item ${index + 1}",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Text(
                          partData["category"],
                          //style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "code",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        /*Text(
                          "${partData["stock"]} in stock",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),*/
                        Column(
                          children: [
                            _buildInfoRow("在庫数", partData["stock"]),
                            _buildInfoRow("保管場所", partData["location"]),
                            _buildLinkRow("データシート", partData["datasheetUrl"]),
                            _buildLinkRow("購入先", partData["buyUrl"]),
                            const Divider(),
                            //const Text("詳細パラメータ",
                            //    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ...metadata.entries.map((e) => _buildInfoRow(e.key, e.value)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        )
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value, {double indent = 0}) {
    if (value is Map<String, dynamic>) {
      // Map の場合 → 見出し + 再帰的に展開
      return Padding(
        padding: EdgeInsets.only(left: indent, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            ...value.entries.map((e) =>
                _buildInfoRow(e.key, e.value, indent: indent + 16)),
          ],
        ),
      );
    } else {
      // 値がプリミティブ型の場合
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
            Expanded(child: Text(value.toString())),
          ],
        ),
      );
    }
  }


  Widget _buildLinkRow(String label, String url) {
    //return _buildInfoRow(label, url); // 将来的にはInkWellでリンク化
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: LinkWell(url, linkStyle: TextStyle(color: Colors.lightBlue, decoration: TextDecoration.underline)))
        ],
      ),
    );
  }
}
