import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:stockanize/db/database.dart';

import '../add_page.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get passwordSalt => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  TextColumn get passwordHash => text().nullable()();
  TextColumn get passwordSalt => text().nullable()();
  DateTimeColumn get passwordSetAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class AccountMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountId =>
      text().references(Accounts, #id, onDelete: KeyAction.cascade)();
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text().withDefault(const Constant('owner'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['UNIQUE(account_id, user_id)'];
}

class UserGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountId =>
      text().references(Accounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['UNIQUE(account_id, name)'];
}

class GroupMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId =>
      integer().references(UserGroups, #id, onDelete: KeyAction.cascade)();
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text().withDefault(const Constant('member'))();
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['UNIQUE(group_id, user_id)'];
}

class GroupInvites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId =>
      integer().references(UserGroups, #id, onDelete: KeyAction.cascade)();
  IntColumn get invitedByUserId => integer()
      .references(Users, #id, onDelete: KeyAction.setNull)
      .nullable()();
  TextColumn get inviteeUsername => text()();
  TextColumn get token => text().unique()();
  DateTimeColumn get expiresAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class AppContexts extends Table {
  IntColumn get id => integer()();
  TextColumn get activeAccountId => text().references(Accounts, #id)();
  IntColumn get activeGroupId => integer()
      .nullable()
      .references(UserGroups, #id, onDelete: KeyAction.setNull)();
  IntColumn get activeUserId => integer()
      .nullable()
      .references(Users, #id, onDelete: KeyAction.setNull)();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountId => text()
      .references(Accounts, #id, onDelete: KeyAction.cascade)
      .nullable()();
  IntColumn get groupId => integer()
      .nullable()
      .references(UserGroups, #id, onDelete: KeyAction.setNull)();
  TextColumn get subcategory => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
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
  Future<int> insertPart(PartsCompanion entry) {
    final scoped = entry.copyWith(
      accountId: Value(currentAccountId),
      groupId: entry.groupId.present ? entry.groupId : Value(currentGroupId),
    );
    return into(parts).insert(scoped);
  }

  Future<List<Part>> getAllParts() {
    final query = select(parts)
      ..where((t) => t.accountId.equals(currentAccountId));
    if (currentGroupId != null) {
      query.where((t) => t.groupId.equals(currentGroupId!));
    }
    return query.get();
  }

  Stream<List<Part>> watchParts() {
    final query = select(parts)
      ..where((t) => t.accountId.equals(currentAccountId));
    if (currentGroupId != null) {
      query.where((t) => t.groupId.equals(currentGroupId!));
    }
    return query.watch();
  }

  Stream<List<PartsImage>> watchImages(int partId) {
    return (select(partsImages)
          ..where((t) => t.partId.equals(partId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  Future<Part?> getPartById(int id) {
    final query = select(parts)
      ..where((tbl) => tbl.id.equals(id))
      ..where((tbl) => tbl.accountId.equals(currentAccountId));
    if (currentGroupId != null) {
      query.where((tbl) => tbl.groupId.equals(currentGroupId!));
    }
    return query.getSingleOrNull();
  }

  Future<void> updatePart(Part part) {
    if (part.accountId != currentAccountId) {
      throw StateError('アクティブなアカウント外のデータは更新できません');
    }
    return update(parts).replace(part);
  }

  Future deleteAllParts() {
    final query = delete(parts)
      ..where((tbl) => tbl.accountId.equals(currentAccountId));
    return query.go();
  }

  Future<int> insertPartWithImages(
    PartsCompanion entry,
    List<ImageItem> imageItem,
  ) async {
    final images = imageItem.map((item) => File(item.file.path)).toList();
    return transaction(() async {
      final partId = await insertPart(entry);
      await _insertImages(partId, images);
      return partId;
    });
  }

  Future<void> updatePartWithImages(
    Part updatedPart,
    List<ImageItem> imageItems,
  ) async {
    if (updatedPart.accountId != currentAccountId) {
      throw StateError('アクティブなアカウント外のデータは更新できません');
    }

    return transaction(() async {
      await update(parts).replace(updatedPart);

      final existing = await (select(partsImages)
            ..where((t) => t.partId.equals(updatedPart.id)))
          .get();

      final existingPaths = existing.map((e) => e.imagePath).toSet();
      final newPaths = imageItems.map((e) => e.file.path).toSet();

      final removed = existingPaths.difference(newPaths);
      for (final removedPath in removed) {
        final file = File(removedPath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      await (delete(partsImages)..where((t) => t.partId.equals(updatedPart.id)))
          .go();

      await _insertImages(
        updatedPart.id,
        imageItems.map((e) => File(e.file.path)).toList(),
      );
    });
  }

  Future<int> deletePart(int id) async {
    return transaction(() async {
      final target = await getPartById(id);
      if (target == null) {
        return 0;
      }
      await _deleteImagesByPart(id);
      return (delete(parts)..where((t) => t.id.equals(id))).go();
    });
  }

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
      final file = images[i];

      String finalPath;
      if (file.path.startsWith(imageDir.path)) {
        finalPath = file.path;
      } else {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';

        final saved = await file.copy('${imageDir.path}/$fileName');
        finalPath = saved.path;
      }

      await into(partsImages).insert(
        PartsImagesCompanion.insert(
          partId: partId,
          sortOrder: i,
          imagePath: finalPath,
        ),
      );
    }
  }

  Future<void> _deleteImagesByPart(int partId) async {
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
