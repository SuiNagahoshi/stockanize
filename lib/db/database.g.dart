// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PartsTable extends Parts with TableInfo<$PartsTable, Part> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _subcategoryMeta =
      const VerificationMeta('subcategory');
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
      'subcategory', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
      'stock', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _datasheetUrlMeta =
      const VerificationMeta('datasheetUrl');
  @override
  late final GeneratedColumn<String> datasheetUrl = GeneratedColumn<String>(
      'datasheet_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buyUrlMeta = const VerificationMeta('buyUrl');
  @override
  late final GeneratedColumn<String> buyUrl = GeneratedColumn<String>(
      'buy_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $PartsTable.$convertermetadatan);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        subcategory,
        category,
        name,
        code,
        stock,
        location,
        datasheetUrl,
        buyUrl,
        metadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(Insertable<Part> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subcategory')) {
      context.handle(
          _subcategoryMeta,
          subcategory.isAcceptableOrUnknown(
              data['subcategory']!, _subcategoryMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('stock')) {
      context.handle(
          _stockMeta, stock.isAcceptableOrUnknown(data['stock']!, _stockMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('datasheet_url')) {
      context.handle(
          _datasheetUrlMeta,
          datasheetUrl.isAcceptableOrUnknown(
              data['datasheet_url']!, _datasheetUrlMeta));
    }
    if (data.containsKey('buy_url')) {
      context.handle(_buyUrlMeta,
          buyUrl.isAcceptableOrUnknown(data['buy_url']!, _buyUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Part map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Part(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      subcategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subcategory']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      stock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      datasheetUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}datasheet_url']),
      buyUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}buy_url']),
      metadata: $PartsTable.$convertermetadatan.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])),
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const MetadataConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $convertermetadatan =
      NullAwareTypeConverter.wrap($convertermetadata);
}

class Part extends DataClass implements Insertable<Part> {
  final int id;
  final String? subcategory;
  final String? category;
  final String name;
  final String? code;
  final int stock;
  final String? location;
  final String? datasheetUrl;
  final String? buyUrl;
  final Map<String, dynamic>? metadata;
  const Part(
      {required this.id,
      this.subcategory,
      this.category,
      required this.name,
      this.code,
      required this.stock,
      this.location,
      this.datasheetUrl,
      this.buyUrl,
      this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['stock'] = Variable<int>(stock);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || datasheetUrl != null) {
      map['datasheet_url'] = Variable<String>(datasheetUrl);
    }
    if (!nullToAbsent || buyUrl != null) {
      map['buy_url'] = Variable<String>(buyUrl);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] =
          Variable<String>($PartsTable.$convertermetadatan.toSql(metadata));
    }
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      stock: Value(stock),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      datasheetUrl: datasheetUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(datasheetUrl),
      buyUrl:
          buyUrl == null && nullToAbsent ? const Value.absent() : Value(buyUrl),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory Part.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Part(
      id: serializer.fromJson<int>(json['id']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      category: serializer.fromJson<String?>(json['category']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      stock: serializer.fromJson<int>(json['stock']),
      location: serializer.fromJson<String?>(json['location']),
      datasheetUrl: serializer.fromJson<String?>(json['datasheetUrl']),
      buyUrl: serializer.fromJson<String?>(json['buyUrl']),
      metadata: serializer.fromJson<Map<String, dynamic>?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subcategory': serializer.toJson<String?>(subcategory),
      'category': serializer.toJson<String?>(category),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'stock': serializer.toJson<int>(stock),
      'location': serializer.toJson<String?>(location),
      'datasheetUrl': serializer.toJson<String?>(datasheetUrl),
      'buyUrl': serializer.toJson<String?>(buyUrl),
      'metadata': serializer.toJson<Map<String, dynamic>?>(metadata),
    };
  }

  Part copyWith(
          {int? id,
          Value<String?> subcategory = const Value.absent(),
          Value<String?> category = const Value.absent(),
          String? name,
          Value<String?> code = const Value.absent(),
          int? stock,
          Value<String?> location = const Value.absent(),
          Value<String?> datasheetUrl = const Value.absent(),
          Value<String?> buyUrl = const Value.absent(),
          Value<Map<String, dynamic>?> metadata = const Value.absent()}) =>
      Part(
        id: id ?? this.id,
        subcategory: subcategory.present ? subcategory.value : this.subcategory,
        category: category.present ? category.value : this.category,
        name: name ?? this.name,
        code: code.present ? code.value : this.code,
        stock: stock ?? this.stock,
        location: location.present ? location.value : this.location,
        datasheetUrl:
            datasheetUrl.present ? datasheetUrl.value : this.datasheetUrl,
        buyUrl: buyUrl.present ? buyUrl.value : this.buyUrl,
        metadata: metadata.present ? metadata.value : this.metadata,
      );
  Part copyWithCompanion(PartsCompanion data) {
    return Part(
      id: data.id.present ? data.id.value : this.id,
      subcategory:
          data.subcategory.present ? data.subcategory.value : this.subcategory,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      stock: data.stock.present ? data.stock.value : this.stock,
      location: data.location.present ? data.location.value : this.location,
      datasheetUrl: data.datasheetUrl.present
          ? data.datasheetUrl.value
          : this.datasheetUrl,
      buyUrl: data.buyUrl.present ? data.buyUrl.value : this.buyUrl,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Part(')
          ..write('id: $id, ')
          ..write('subcategory: $subcategory, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('stock: $stock, ')
          ..write('location: $location, ')
          ..write('datasheetUrl: $datasheetUrl, ')
          ..write('buyUrl: $buyUrl, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subcategory, category, name, code, stock,
      location, datasheetUrl, buyUrl, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
          other.subcategory == this.subcategory &&
          other.category == this.category &&
          other.name == this.name &&
          other.code == this.code &&
          other.stock == this.stock &&
          other.location == this.location &&
          other.datasheetUrl == this.datasheetUrl &&
          other.buyUrl == this.buyUrl &&
          other.metadata == this.metadata);
}

class PartsCompanion extends UpdateCompanion<Part> {
  final Value<int> id;
  final Value<String?> subcategory;
  final Value<String?> category;
  final Value<String> name;
  final Value<String?> code;
  final Value<int> stock;
  final Value<String?> location;
  final Value<String?> datasheetUrl;
  final Value<String?> buyUrl;
  final Value<Map<String, dynamic>?> metadata;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.stock = const Value.absent(),
    this.location = const Value.absent(),
    this.datasheetUrl = const Value.absent(),
    this.buyUrl = const Value.absent(),
    this.metadata = const Value.absent(),
  });
  PartsCompanion.insert({
    this.id = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.category = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    this.stock = const Value.absent(),
    this.location = const Value.absent(),
    this.datasheetUrl = const Value.absent(),
    this.buyUrl = const Value.absent(),
    this.metadata = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Part> custom({
    Expression<int>? id,
    Expression<String>? subcategory,
    Expression<String>? category,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? stock,
    Expression<String>? location,
    Expression<String>? datasheetUrl,
    Expression<String>? buyUrl,
    Expression<String>? metadata,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subcategory != null) 'subcategory': subcategory,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (stock != null) 'stock': stock,
      if (location != null) 'location': location,
      if (datasheetUrl != null) 'datasheet_url': datasheetUrl,
      if (buyUrl != null) 'buy_url': buyUrl,
      if (metadata != null) 'metadata': metadata,
    });
  }

  PartsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? subcategory,
      Value<String?>? category,
      Value<String>? name,
      Value<String?>? code,
      Value<int>? stock,
      Value<String?>? location,
      Value<String?>? datasheetUrl,
      Value<String?>? buyUrl,
      Value<Map<String, dynamic>?>? metadata}) {
    return PartsCompanion(
      id: id ?? this.id,
      subcategory: subcategory ?? this.subcategory,
      category: category ?? this.category,
      name: name ?? this.name,
      code: code ?? this.code,
      stock: stock ?? this.stock,
      location: location ?? this.location,
      datasheetUrl: datasheetUrl ?? this.datasheetUrl,
      buyUrl: buyUrl ?? this.buyUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (datasheetUrl.present) {
      map['datasheet_url'] = Variable<String>(datasheetUrl.value);
    }
    if (buyUrl.present) {
      map['buy_url'] = Variable<String>(buyUrl.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(
          $PartsTable.$convertermetadatan.toSql(metadata.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('subcategory: $subcategory, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('stock: $stock, ')
          ..write('location: $location, ')
          ..write('datasheetUrl: $datasheetUrl, ')
          ..write('buyUrl: $buyUrl, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }
}

class $PartsImagesTable extends PartsImages
    with TableInfo<$PartsImagesTable, PartsImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
      'part_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES parts (id) ON DELETE CASCADE'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, partId, sortOrder, imagePath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts_images';
  @override
  VerificationContext validateIntegrity(Insertable<PartsImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(_partIdMeta,
          partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta));
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartsImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartsImage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      partId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part_id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
    );
  }

  @override
  $PartsImagesTable createAlias(String alias) {
    return $PartsImagesTable(attachedDatabase, alias);
  }
}

class PartsImage extends DataClass implements Insertable<PartsImage> {
  final int id;
  final int partId;
  final int sortOrder;
  final String imagePath;
  const PartsImage(
      {required this.id,
      required this.partId,
      required this.sortOrder,
      required this.imagePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['image_path'] = Variable<String>(imagePath);
    return map;
  }

  PartsImagesCompanion toCompanion(bool nullToAbsent) {
    return PartsImagesCompanion(
      id: Value(id),
      partId: Value(partId),
      sortOrder: Value(sortOrder),
      imagePath: Value(imagePath),
    );
  }

  factory PartsImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartsImage(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'imagePath': serializer.toJson<String>(imagePath),
    };
  }

  PartsImage copyWith(
          {int? id, int? partId, int? sortOrder, String? imagePath}) =>
      PartsImage(
        id: id ?? this.id,
        partId: partId ?? this.partId,
        sortOrder: sortOrder ?? this.sortOrder,
        imagePath: imagePath ?? this.imagePath,
      );
  PartsImage copyWithCompanion(PartsImagesCompanion data) {
    return PartsImage(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartsImage(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, partId, sortOrder, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartsImage &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.sortOrder == this.sortOrder &&
          other.imagePath == this.imagePath);
}

class PartsImagesCompanion extends UpdateCompanion<PartsImage> {
  final Value<int> id;
  final Value<int> partId;
  final Value<int> sortOrder;
  final Value<String> imagePath;
  const PartsImagesCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  PartsImagesCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    required int sortOrder,
    required String imagePath,
  })  : partId = Value(partId),
        sortOrder = Value(sortOrder),
        imagePath = Value(imagePath);
  static Insertable<PartsImage> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<int>? sortOrder,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  PartsImagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? partId,
      Value<int>? sortOrder,
      Value<String>? imagePath}) {
    return PartsImagesCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      sortOrder: sortOrder ?? this.sortOrder,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsImagesCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PartsTable parts = $PartsTable(this);
  late final $PartsImagesTable partsImages = $PartsImagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [parts, partsImages];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('parts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('parts_images', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$PartsTableCreateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  Value<String?> subcategory,
  Value<String?> category,
  required String name,
  Value<String?> code,
  Value<int> stock,
  Value<String?> location,
  Value<String?> datasheetUrl,
  Value<String?> buyUrl,
  Value<Map<String, dynamic>?> metadata,
});
typedef $$PartsTableUpdateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  Value<String?> subcategory,
  Value<String?> category,
  Value<String> name,
  Value<String?> code,
  Value<int> stock,
  Value<String?> location,
  Value<String?> datasheetUrl,
  Value<String?> buyUrl,
  Value<Map<String, dynamic>?> metadata,
});

final class $$PartsTableReferences
    extends BaseReferences<_$AppDatabase, $PartsTable, Part> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PartsImagesTable, List<PartsImage>>
      _partsImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.partsImages,
          aliasName: $_aliasNameGenerator(db.parts.id, db.partsImages.partId));

  $$PartsImagesTableProcessedTableManager get partsImagesRefs {
    final manager = $$PartsImagesTableTableManager($_db, $_db.partsImages)
        .filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partsImagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get datasheetUrl => $composableBuilder(
      column: $table.datasheetUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buyUrl => $composableBuilder(
      column: $table.buyUrl, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>?, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> partsImagesRefs(
      Expression<bool> Function($$PartsImagesTableFilterComposer f) f) {
    final $$PartsImagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.partsImages,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsImagesTableFilterComposer(
              $db: $db,
              $table: $db.partsImages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get datasheetUrl => $composableBuilder(
      column: $table.datasheetUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buyUrl => $composableBuilder(
      column: $table.buyUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get datasheetUrl => $composableBuilder(
      column: $table.datasheetUrl, builder: (column) => column);

  GeneratedColumn<String> get buyUrl =>
      $composableBuilder(column: $table.buyUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      get metadata => $composableBuilder(
          column: $table.metadata, builder: (column) => column);

  Expression<T> partsImagesRefs<T extends Object>(
      Expression<T> Function($$PartsImagesTableAnnotationComposer a) f) {
    final $$PartsImagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.partsImages,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsImagesTableAnnotationComposer(
              $db: $db,
              $table: $db.partsImages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsTable,
    Part,
    $$PartsTableFilterComposer,
    $$PartsTableOrderingComposer,
    $$PartsTableAnnotationComposer,
    $$PartsTableCreateCompanionBuilder,
    $$PartsTableUpdateCompanionBuilder,
    (Part, $$PartsTableReferences),
    Part,
    PrefetchHooks Function({bool partsImagesRefs})> {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<int> stock = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> datasheetUrl = const Value.absent(),
            Value<String?> buyUrl = const Value.absent(),
            Value<Map<String, dynamic>?> metadata = const Value.absent(),
          }) =>
              PartsCompanion(
            id: id,
            subcategory: subcategory,
            category: category,
            name: name,
            code: code,
            stock: stock,
            location: location,
            datasheetUrl: datasheetUrl,
            buyUrl: buyUrl,
            metadata: metadata,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String?> category = const Value.absent(),
            required String name,
            Value<String?> code = const Value.absent(),
            Value<int> stock = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> datasheetUrl = const Value.absent(),
            Value<String?> buyUrl = const Value.absent(),
            Value<Map<String, dynamic>?> metadata = const Value.absent(),
          }) =>
              PartsCompanion.insert(
            id: id,
            subcategory: subcategory,
            category: category,
            name: name,
            code: code,
            stock: stock,
            location: location,
            datasheetUrl: datasheetUrl,
            buyUrl: buyUrl,
            metadata: metadata,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PartsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({partsImagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (partsImagesRefs) db.partsImages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (partsImagesRefs)
                    await $_getPrefetchedData<Part, $PartsTable, PartsImage>(
                        currentTable: table,
                        referencedTable:
                            $$PartsTableReferences._partsImagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartsTableReferences(db, table, p0)
                                .partsImagesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.partId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PartsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartsTable,
    Part,
    $$PartsTableFilterComposer,
    $$PartsTableOrderingComposer,
    $$PartsTableAnnotationComposer,
    $$PartsTableCreateCompanionBuilder,
    $$PartsTableUpdateCompanionBuilder,
    (Part, $$PartsTableReferences),
    Part,
    PrefetchHooks Function({bool partsImagesRefs})>;
typedef $$PartsImagesTableCreateCompanionBuilder = PartsImagesCompanion
    Function({
  Value<int> id,
  required int partId,
  required int sortOrder,
  required String imagePath,
});
typedef $$PartsImagesTableUpdateCompanionBuilder = PartsImagesCompanion
    Function({
  Value<int> id,
  Value<int> partId,
  Value<int> sortOrder,
  Value<String> imagePath,
});

final class $$PartsImagesTableReferences
    extends BaseReferences<_$AppDatabase, $PartsImagesTable, PartsImage> {
  $$PartsImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartsTable _partIdTable(_$AppDatabase db) => db.parts
      .createAlias($_aliasNameGenerator(db.partsImages.partId, db.parts.id));

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PartsImagesTableFilterComposer
    extends Composer<_$AppDatabase, $PartsImagesTable> {
  $$PartsImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsImagesTable> {
  $$PartsImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableOrderingComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsImagesTable> {
  $$PartsImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsImagesTable,
    PartsImage,
    $$PartsImagesTableFilterComposer,
    $$PartsImagesTableOrderingComposer,
    $$PartsImagesTableAnnotationComposer,
    $$PartsImagesTableCreateCompanionBuilder,
    $$PartsImagesTableUpdateCompanionBuilder,
    (PartsImage, $$PartsImagesTableReferences),
    PartsImage,
    PrefetchHooks Function({bool partId})> {
  $$PartsImagesTableTableManager(_$AppDatabase db, $PartsImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> partId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
          }) =>
              PartsImagesCompanion(
            id: id,
            partId: partId,
            sortOrder: sortOrder,
            imagePath: imagePath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int partId,
            required int sortOrder,
            required String imagePath,
          }) =>
              PartsImagesCompanion.insert(
            id: id,
            partId: partId,
            sortOrder: sortOrder,
            imagePath: imagePath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PartsImagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (partId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partId,
                    referencedTable:
                        $$PartsImagesTableReferences._partIdTable(db),
                    referencedColumn:
                        $$PartsImagesTableReferences._partIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PartsImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartsImagesTable,
    PartsImage,
    $$PartsImagesTableFilterComposer,
    $$PartsImagesTableOrderingComposer,
    $$PartsImagesTableAnnotationComposer,
    $$PartsImagesTableCreateCompanionBuilder,
    $$PartsImagesTableUpdateCompanionBuilder,
    (PartsImage, $$PartsImagesTableReferences),
    PartsImage,
    PrefetchHooks Function({bool partId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$PartsImagesTableTableManager get partsImages =>
      $$PartsImagesTableTableManager(_db, _db.partsImages);
}
