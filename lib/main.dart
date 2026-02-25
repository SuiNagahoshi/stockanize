import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:stockanize/account_settings_page.dart';
import 'package:stockanize/add_page.dart';
import 'package:stockanize/data/local_stock_repository.dart';
import 'package:stockanize/data/stock_repository.dart';
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
  await db.initializeTenantContext();
  final repository = LocalStockRepository(db);

  runZonedGuarded(() {
    runApp(MyApp(
      db: db,
      repository: repository,
    ));
  }, (error, stack) {
    debugPrint('Uncaught zone error: $error\n$stack');
  });
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  final StockRepository repository;

  const MyApp({super.key, required this.db, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockanize',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StockanizeHomePage(
        db: db,
        repository: repository,
        title: 'Stockanize Home',
      ),
      routes: {
        '/home': (context) => StockanizeHomePage(
              title: 'Stockanize Home',
              db: db,
              repository: repository,
            ),
        '/add': (context) => AddPartPage(db: db)
      },
    );
  }
}

class StockanizeHomePage extends StatefulWidget {
  const StockanizeHomePage({
    super.key,
    required this.title,
    required this.db,
    required this.repository,
  });

  final String title;
  final AppDatabase db;
  final StockRepository repository;

  @override
  State<StockanizeHomePage> createState() => _StockanizeHomePageState();
}

class _StockanizeHomePageState extends State<StockanizeHomePage> {
  int _index = 0;

  Future<void> _addItem() async {
    const samplePart = PartsCompanion(
      category: Value('Resistor'),
      name: Value('1kΩ Resistor'),
      code: Value('1111'),
      stock: Value(120),
      location: Value('Box A1'),
      datasheetUrl: Value('https://example.com/datasheet.pdf'),
      buyUrl: Value('https://shop.example.com/resister1/'),
      metadata: Value({
        'resistance': '1kΩ',
        'tolerance': '±5%',
        'power': '1/4W',
        'package': 'THD',
        'size': {'depth': '2.7mm', 'length': '9mm'}
      }),
    );

    await widget.db.insertPart(samplePart);
    if (!mounted) return;
    setState(() {});
  }

  void _refreshScope() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          '${widget.title} (${widget.db.currentAccountId})'
          '${widget.db.currentGroupId == null ? '' : ' / group:${widget.db.currentGroupId}'}',
        ),
      ),
      body: <Widget>[
        SizedBox.expand(
          child: PartsListPage(db: widget.db),
        ),
        SizedBox.expand(
          child: AddPartPage(db: widget.db),
        ),
        SizedBox.expand(
          child: QrScanPage(),
        ),
        SizedBox.expand(
          child: AccountSettingsPage(
            db: widget.db,
            repository: widget.repository,
            onScopeChanged: _refreshScope,
          ),
        ),
      ][_index],
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
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
    title: const Text('Home'),
    selectedColor: Colors.purple,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.add_circle),
    title: const Text('Add'),
    selectedColor: Colors.teal,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.qr_code),
    title: const Text('QRCode'),
    selectedColor: Colors.lightGreen,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text('Account'),
    selectedColor: Colors.orange,
  ),
];
