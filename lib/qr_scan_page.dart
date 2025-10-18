import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:stockanize/parts_list_page.dart';

import 'db/database.dart';

class QrScanPage extends StatefulWidget {
  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanning = true; // スキャン制御用フラグ

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return; // すでに処理中なら無視

    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;
    if (value == null) return;

    setState(() => _isScanning = false); // スキャン停止
    _controller.stop(); // カメラのスキャンも停止

    // QRコードを使ってDBから部品を検索
    final partId = int.tryParse(value);
    if (partId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('無効なQRコードです')),
      );
      _resumeScanning();
      return;
    }

    final db = AppDatabase.instance;

    final partsList = await db.select(db.parts).get();
    final index = partsList.indexWhere((p) => p.id == partId);
    if (index == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('このQRコードに対応する部品が見つかりませんでした。')),
      );
      setState(() => _isScanning = false);
      return;
    }
    final part = partsList[index];
    final heroTag = 'hero_part_$partId';

    // 部品詳細ページへ遷移
    await Navigator.push(
        context,
        //MaterialPageRoute(builder: (_) => QrResultPage(partId: partId.toString())),
        MaterialPageRoute(
            builder: (context) =>
                HeroListItemPage(part: part, index: index, heroTag: heroTag)));

    // 戻ってきたらスキャンを再開
    _resumeScanning();
  }

  void _resumeScanning() async {
    await _controller.start();
    setState(() => _isScanning = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRコードをスキャン')),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}
