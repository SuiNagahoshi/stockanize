import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PartQrCard extends StatefulWidget {
  final String partName;
  final String? location;
  final String qrData;
  final bool isHorizontal;

  const PartQrCard({
    required this.partName,
    required this.location,
    required this.qrData,
    this.isHorizontal = false,
    super.key,
  });

  @override
  State<PartQrCard> createState() => _PartQrCardState();
}

class _PartQrCardState extends State<PartQrCard> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _saveAsPng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final dir = await getExternalStorageDirectory();
      final saveDir = Directory("${dir!.path}/QR_Labels");
      if (!saveDir.existsSync()) {
        saveDir.createSync(recursive: true);
      }

      final filePath =
          '${saveDir.path}/${widget.partName}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PNG画像を保存しました:\n$filePath'),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      debugPrint("保存失敗: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('保存に失敗しました: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.isHorizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.partName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('保管場所: ${widget.location}',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                size: 120,
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.partName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('保管場所: ${widget.location}',
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                size: 160,
              ),
            ],
          );

    return Column(
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: content,
          ),
        ),
        const SizedBox(height: 24),
        SafeArea(
          child: ElevatedButton.icon(
            onPressed: _saveAsPng,
            icon: const Icon(Icons.download),
            label: const Text("PNG画像として保存"),
          ),
        ),
      ],
    );
  }
}
