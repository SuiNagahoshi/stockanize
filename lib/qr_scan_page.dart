import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_result_page.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _navigating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_navigating) return; // 二重遷移防止

    final code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _navigating = true);

    // カメラセッションを停止
    await _controller.stop();

    if (!mounted) return;

    // 遷移を少し遅延させると安定します（フレーム切り替えタイミング対策）
    await Future.delayed(const Duration(milliseconds: 200));

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrResultPage(partId: code),
      ),
    );

    // 戻ってきたら再開
    if (mounted) {
      await _controller.start();
      setState(() => _navigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QRコードスキャン')),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}
