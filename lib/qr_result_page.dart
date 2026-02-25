import 'package:flutter/material.dart';
import 'db/database.dart';
import 'db/parts.dart';

class QrResultPage extends StatefulWidget {
  final String partId;
  const QrResultPage({super.key, required this.partId});

  @override
  State<QrResultPage> createState() => _QrResultPageState();
}

class _QrResultPageState extends State<QrResultPage> {
  Part? part;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPart();
  }

  Future<void> _loadPart() async {
    final db = AppDatabase.instance;
    final id = int.tryParse(widget.partId);
    if (id == null) {
      setState(() => loading = false);
      return;
    }

    final result = await db.getPartById(id);

    setState(() {
      part = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (part == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('部品が見つかりません')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('このQRコードに対応する部品は登録されていません。'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(part!.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('型番ID: ${part!.id}'),
            Text('在庫数: ${part!.stock}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final db = AppDatabase();
                final updated = part!.copyWith(stock: part!.stock + 1);
                await db.updatePart(updated);
                _loadPart();
              },
              child: const Text('在庫を +1'),
            ),
          ],
        ),
      ),
    );
  }
}
