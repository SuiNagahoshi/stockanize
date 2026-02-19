import 'dart:io';
import 'package:path/path.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stockanize/db/parts.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Parts, PartsImages])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());
  static final AppDatabase instance = AppDatabase._internal();
  factory AppDatabase() => instance;

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll(); // 新規インストール時に Parts + PartsImages をまとめて作る
        },
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            await m.createTable(partsImages);
          }
        },
      );
}

/*
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, 'parts.sqlite'));

    // 開発中は強制削除して再作成してもOK
    if (await file.exists()) {
      await file.delete();
    }

    return NativeDatabase(file);
  });
}
*/
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbFile = File(join(dbDir.path, 'parts.sqlite'));

    return NativeDatabase(dbFile);
  });
}
