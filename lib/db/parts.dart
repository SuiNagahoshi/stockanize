import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stockanize/db/database.dart';

class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text().nullable()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  IntColumn get stock => integer().withDefault(Constant(0))();
  TextColumn get location => text().nullable()();
  TextColumn get datasheetUrl => text().nullable()();
  TextColumn get buyUrl => text().nullable()();
  TextColumn get metadata => text().nullable().map(const MetadataConverter())();
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
  //Future<void> updatePart(PartsCompanion companion) async {
  //  final id = companion.id.value;
  //
  //  await (update(parts)..where((t) => t.id.equals(id))).write(companion);
  //}

  Future<int> deletePart(int id) =>
      (delete(parts)..where((tbl) => tbl.id.equals(id))).go();

  Future deleteAllParts() => delete(parts).go();
}
