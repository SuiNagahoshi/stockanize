import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
                            title: Text(_items[index]),
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
  const HeroListItemPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Item Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            Text(
              "item $index",
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
      ),
    );
  }
}
