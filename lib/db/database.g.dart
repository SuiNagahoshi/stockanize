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
  int get hashCode => Object.hash(id, category, name, code, stock, location,
      datasheetUrl, buyUrl, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PartsTable parts = $PartsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [parts];
}

typedef $$PartsTableCreateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
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
  Value<String?> category,
  Value<String> name,
  Value<String?> code,
  Value<int> stock,
  Value<String?> location,
  Value<String?> datasheetUrl,
  Value<String?> buyUrl,
  Value<Map<String, dynamic>?> metadata,
});

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
    (Part, BaseReferences<_$AppDatabase, $PartsTable, Part>),
    Part,
    PrefetchHooks Function()> {
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
    (Part, BaseReferences<_$AppDatabase, $PartsTable, Part>),
    Part,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
}
