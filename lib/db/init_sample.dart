import 'package:drift/drift.dart';
import 'package:stockanize/db/parts.dart';
import 'database.dart';

Future<void> insertSampleData(AppDatabase db) async {
  // DBを一度クリア
  await db.deleteAllParts();

  final samplePart = PartsCompanion.insert(
      category: const Value("Resistor"),
      name: "1kΩ Resistor",
      code: const Value("1111"),
      stock: const Value(120),
      location: const Value("Box A1"),
      datasheetUrl: Value("https://example.com/datasheet.pdf"),
      buyUrl: Value("https://shop.example.com/resister1/"),
      metadata: {
        "resistance": "1kΩ",
        "tolerance": "±5%",
        "power": "1/4W",
        "package": "THD",
        "size": {"depth": "2.7mm", "length": "9mm"}
      });

  await db.insertPart(samplePart);
}
