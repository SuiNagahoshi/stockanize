import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:stockanize/db/database.dart';

class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get subcategory => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  IntColumn get stock => integer().withDefault(Constant(0))();
  TextColumn get location => text().nullable()();
  TextColumn get datasheetUrl => text().nullable()();
  TextColumn get buyUrl => text().nullable()();
  TextColumn get metadata => text().map(const MetadataConverter())();
}

class MetadataConverter extends TypeConverter<Map<String, dynamic>, String> {
  const MetadataConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    try {
      return fromDb.isNotEmpty
          ? Map<String, dynamic>.from(jsonDecode(fromDb) as Map)
          : {};
    } catch (_) {
      return {};
    }
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return jsonEncode(value);
  }
}

extension PartDao on AppDatabase {
  Future<int> insertPart(PartsCompanion entry) => into(parts).insert(entry);

  Future<List<Part>> getAllParts() => select(parts).get();

  Stream<List<Part>> watchAllParts() => select(parts).watch();

  Future<Part?> getPartById(int id) =>
      (select(parts)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<void> updatePart(Part part) => update(parts).replace(part);

  //Future<int> deletePart(int id) =>
  //    (delete(parts)..where((tbl) => tbl.id.equals(id))).go();

  Future deleteAllParts() => delete(parts).go();

  /// Part + 参考画像をまとめて登録
  Future<int> insertPartWithImages(
    PartsCompanion entry,
    List<File> images,
  ) async {
    return transaction(() async {
      final partId = await into(parts).insert(entry);
      await _insertImages(partId, images);
      return partId;
    });
  }

  /// Part + 参考画像をまとめて更新
  Future<void> updatePartWithImages(
    Part part,
    List<File> images,
  ) async {
    return transaction(() async {
      await update(parts).replace(part);

      // 既存画像を全削除 → 再登録
      await _deleteImagesByPart(part.id);
      await _insertImages(part.id, images);
    });
  }

  /// Part 削除時に参考画像も削除
  Future<int> deletePart(int id) async {
    return transaction(() async {
      await _deleteImagesByPart(id);
      return (delete(parts)..where((t) => t.id.equals(id))).go();
    });
  }

  // ---- 以下は PartDao 内部実装（外から呼ばれない）----

  Future<void> _insertImages(
    int partId,
    List<File> images,
  ) async {
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${dir.path}/parts_images');

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    for (int i = 0; i < images.length; i++) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(images[i].path)}';

      final saved = await images[i].copy('${imageDir.path}/$fileName');

      await into(partsImages).insert(
        PartsImagesCompanion.insert(
          partId: partId,
          sortOrder: i,
          imagePath: saved.path,
        ),
      );
    }
  }

  Future<void> _deleteImagesByPart(int partId) async {
    final rows = await (select(partsImages)
          ..where((t) => t.partId.equals(partId)))
        .get();

    for (final row in rows) {
      final file = File(row.imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await (delete(partsImages)..where((t) => t.partId.equals(partId))).go();
  }

  Future<List<PartsImage>> getImagesByPartId(int partId) {
    return (select(partsImages)
          ..where((tbl) => tbl.partId.equals(partId))
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.sortOrder),
          ]))
        .get();
  }

  Future<PartsImage?> getFirstImageByPartId(int partId) {
    return (select(partsImages)
          ..where((tbl) => tbl.partId.equals(partId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)])
          ..limit(1))
        .getSingleOrNull();
  }
}

class PartsImages extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get partId =>
      integer().references(Parts, #id, onDelete: KeyAction.cascade)();

  IntColumn get sortOrder => integer()();

  TextColumn get imagePath => text()();
}
