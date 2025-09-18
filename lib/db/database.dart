import 'dart:io';
import 'package:path/path.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stockanize/db/parts.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Parts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, 'parts.sqlite'));
    return NativeDatabase(file);
  });
}
