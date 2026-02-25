// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String name;
  final DateTime createdAt;
  const Account(
      {required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Account copyWith({String? id, String? name, DateTime? createdAt}) => Account(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserGroupsTable extends UserGroups
    with TableInfo<$UserGroupsTable, UserGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, accountId, name, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_groups';
  @override
  VerificationContext validateIntegrity(Insertable<UserGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UserGroupsTable createAlias(String alias) {
    return $UserGroupsTable(attachedDatabase, alias);
  }
}

class UserGroup extends DataClass implements Insertable<UserGroup> {
  final int id;
  final String accountId;
  final String name;
  final String? description;
  final DateTime createdAt;
  const UserGroup(
      {required this.id,
      required this.accountId,
      required this.name,
      this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<String>(accountId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserGroupsCompanion toCompanion(bool nullToAbsent) {
    return UserGroupsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory UserGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGroup(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<String>(accountId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserGroup copyWith(
          {int? id,
          String? accountId,
          String? name,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt}) =>
      UserGroup(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  UserGroup copyWithCompanion(UserGroupsCompanion data) {
    return UserGroup(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserGroup(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGroup &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class UserGroupsCompanion extends UpdateCompanion<UserGroup> {
  final Value<int> id;
  final Value<String> accountId;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const UserGroupsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : accountId = Value(accountId),
        name = Value(name);
  static Insertable<UserGroup> custom({
    Expression<int>? id,
    Expression<String>? accountId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserGroupsCompanion copyWith(
      {Value<int>? id,
      Value<String>? accountId,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime>? createdAt}) {
    return UserGroupsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGroupsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppContextsTable extends AppContexts
    with TableInfo<$AppContextsTable, AppContext> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppContextsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _activeAccountIdMeta =
      const VerificationMeta('activeAccountId');
  @override
  late final GeneratedColumn<String> activeAccountId = GeneratedColumn<String>(
      'active_account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _activeGroupIdMeta =
      const VerificationMeta('activeGroupId');
  @override
  late final GeneratedColumn<int> activeGroupId = GeneratedColumn<int>(
      'active_group_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES user_groups (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns => [id, activeAccountId, activeGroupId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_contexts';
  @override
  VerificationContext validateIntegrity(Insertable<AppContext> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('active_account_id')) {
      context.handle(
          _activeAccountIdMeta,
          activeAccountId.isAcceptableOrUnknown(
              data['active_account_id']!, _activeAccountIdMeta));
    } else if (isInserting) {
      context.missing(_activeAccountIdMeta);
    }
    if (data.containsKey('active_group_id')) {
      context.handle(
          _activeGroupIdMeta,
          activeGroupId.isAcceptableOrUnknown(
              data['active_group_id']!, _activeGroupIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppContext map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppContext(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      activeAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}active_account_id'])!,
      activeGroupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}active_group_id']),
    );
  }

  @override
  $AppContextsTable createAlias(String alias) {
    return $AppContextsTable(attachedDatabase, alias);
  }
}

class AppContext extends DataClass implements Insertable<AppContext> {
  final int id;
  final String activeAccountId;
  final int? activeGroupId;
  const AppContext(
      {required this.id, required this.activeAccountId, this.activeGroupId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['active_account_id'] = Variable<String>(activeAccountId);
    if (!nullToAbsent || activeGroupId != null) {
      map['active_group_id'] = Variable<int>(activeGroupId);
    }
    return map;
  }

  AppContextsCompanion toCompanion(bool nullToAbsent) {
    return AppContextsCompanion(
      id: Value(id),
      activeAccountId: Value(activeAccountId),
      activeGroupId: activeGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeGroupId),
    );
  }

  factory AppContext.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppContext(
      id: serializer.fromJson<int>(json['id']),
      activeAccountId: serializer.fromJson<String>(json['activeAccountId']),
      activeGroupId: serializer.fromJson<int?>(json['activeGroupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activeAccountId': serializer.toJson<String>(activeAccountId),
      'activeGroupId': serializer.toJson<int?>(activeGroupId),
    };
  }

  AppContext copyWith(
          {int? id,
          String? activeAccountId,
          Value<int?> activeGroupId = const Value.absent()}) =>
      AppContext(
        id: id ?? this.id,
        activeAccountId: activeAccountId ?? this.activeAccountId,
        activeGroupId:
            activeGroupId.present ? activeGroupId.value : this.activeGroupId,
      );
  AppContext copyWithCompanion(AppContextsCompanion data) {
    return AppContext(
      id: data.id.present ? data.id.value : this.id,
      activeAccountId: data.activeAccountId.present
          ? data.activeAccountId.value
          : this.activeAccountId,
      activeGroupId: data.activeGroupId.present
          ? data.activeGroupId.value
          : this.activeGroupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppContext(')
          ..write('id: $id, ')
          ..write('activeAccountId: $activeAccountId, ')
          ..write('activeGroupId: $activeGroupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, activeAccountId, activeGroupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppContext &&
          other.id == this.id &&
          other.activeAccountId == this.activeAccountId &&
          other.activeGroupId == this.activeGroupId);
}

class AppContextsCompanion extends UpdateCompanion<AppContext> {
  final Value<int> id;
  final Value<String> activeAccountId;
  final Value<int?> activeGroupId;
  const AppContextsCompanion({
    this.id = const Value.absent(),
    this.activeAccountId = const Value.absent(),
    this.activeGroupId = const Value.absent(),
  });
  AppContextsCompanion.insert({
    this.id = const Value.absent(),
    required String activeAccountId,
    this.activeGroupId = const Value.absent(),
  }) : activeAccountId = Value(activeAccountId);
  static Insertable<AppContext> custom({
    Expression<int>? id,
    Expression<String>? activeAccountId,
    Expression<int>? activeGroupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activeAccountId != null) 'active_account_id': activeAccountId,
      if (activeGroupId != null) 'active_group_id': activeGroupId,
    });
  }

  AppContextsCompanion copyWith(
      {Value<int>? id,
      Value<String>? activeAccountId,
      Value<int?>? activeGroupId}) {
    return AppContextsCompanion(
      id: id ?? this.id,
      activeAccountId: activeAccountId ?? this.activeAccountId,
      activeGroupId: activeGroupId ?? this.activeGroupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activeAccountId.present) {
      map['active_account_id'] = Variable<String>(activeAccountId.value);
    }
    if (activeGroupId.present) {
      map['active_group_id'] = Variable<int>(activeGroupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppContextsCompanion(')
          ..write('id: $id, ')
          ..write('activeAccountId: $activeAccountId, ')
          ..write('activeGroupId: $activeGroupId')
          ..write(')'))
        .toString();
  }
}

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
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES accounts (id) ON DELETE CASCADE'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES user_groups (id) ON DELETE SET NULL'));
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
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      metadata = GeneratedColumn<String>('metadata', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($PartsTable.$convertermetadata);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        groupId,
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
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
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
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id']),
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
      metadata: $PartsTable.$convertermetadata.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata'])!),
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertermetadata =
      const MetadataConverter();
}

class Part extends DataClass implements Insertable<Part> {
  final int id;
  final String? accountId;
  final int? groupId;
  final String? subcategory;
  final String? category;
  final String name;
  final String? code;
  final int stock;
  final String? location;
  final String? datasheetUrl;
  final String? buyUrl;
  final Map<String, dynamic> metadata;
  const Part(
      {required this.id,
      this.accountId,
      this.groupId,
      this.subcategory,
      this.category,
      required this.name,
      this.code,
      required this.stock,
      this.location,
      this.datasheetUrl,
      this.buyUrl,
      required this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
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
    {
      map['metadata'] =
          Variable<String>($PartsTable.$convertermetadata.toSql(metadata));
    }
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
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
      metadata: Value(metadata),
    );
  }

  factory Part.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Part(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      category: serializer.fromJson<String?>(json['category']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      stock: serializer.fromJson<int>(json['stock']),
      location: serializer.fromJson<String?>(json['location']),
      datasheetUrl: serializer.fromJson<String?>(json['datasheetUrl']),
      buyUrl: serializer.fromJson<String?>(json['buyUrl']),
      metadata: serializer.fromJson<Map<String, dynamic>>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<String?>(accountId),
      'groupId': serializer.toJson<int?>(groupId),
      'subcategory': serializer.toJson<String?>(subcategory),
      'category': serializer.toJson<String?>(category),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'stock': serializer.toJson<int>(stock),
      'location': serializer.toJson<String?>(location),
      'datasheetUrl': serializer.toJson<String?>(datasheetUrl),
      'buyUrl': serializer.toJson<String?>(buyUrl),
      'metadata': serializer.toJson<Map<String, dynamic>>(metadata),
    };
  }

  Part copyWith(
          {int? id,
          Value<String?> accountId = const Value.absent(),
          Value<int?> groupId = const Value.absent(),
          Value<String?> subcategory = const Value.absent(),
          Value<String?> category = const Value.absent(),
          String? name,
          Value<String?> code = const Value.absent(),
          int? stock,
          Value<String?> location = const Value.absent(),
          Value<String?> datasheetUrl = const Value.absent(),
          Value<String?> buyUrl = const Value.absent(),
          Map<String, dynamic>? metadata}) =>
      Part(
        id: id ?? this.id,
        accountId: accountId.present ? accountId.value : this.accountId,
        groupId: groupId.present ? groupId.value : this.groupId,
        subcategory: subcategory.present ? subcategory.value : this.subcategory,
        category: category.present ? category.value : this.category,
        name: name ?? this.name,
        code: code.present ? code.value : this.code,
        stock: stock ?? this.stock,
        location: location.present ? location.value : this.location,
        datasheetUrl:
            datasheetUrl.present ? datasheetUrl.value : this.datasheetUrl,
        buyUrl: buyUrl.present ? buyUrl.value : this.buyUrl,
        metadata: metadata ?? this.metadata,
      );
  Part copyWithCompanion(PartsCompanion data) {
    return Part(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
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
          ..write('accountId: $accountId, ')
          ..write('groupId: $groupId, ')
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
  int get hashCode => Object.hash(id, accountId, groupId, subcategory, category,
      name, code, stock, location, datasheetUrl, buyUrl, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.groupId == this.groupId &&
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
  final Value<String?> accountId;
  final Value<int?> groupId;
  final Value<String?> subcategory;
  final Value<String?> category;
  final Value<String> name;
  final Value<String?> code;
  final Value<int> stock;
  final Value<String?> location;
  final Value<String?> datasheetUrl;
  final Value<String?> buyUrl;
  final Value<Map<String, dynamic>> metadata;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.groupId = const Value.absent(),
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
    this.accountId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.category = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    this.stock = const Value.absent(),
    this.location = const Value.absent(),
    this.datasheetUrl = const Value.absent(),
    this.buyUrl = const Value.absent(),
    required Map<String, dynamic> metadata,
  })  : name = Value(name),
        metadata = Value(metadata);
  static Insertable<Part> custom({
    Expression<int>? id,
    Expression<String>? accountId,
    Expression<int>? groupId,
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
      if (accountId != null) 'account_id': accountId,
      if (groupId != null) 'group_id': groupId,
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
      Value<String?>? accountId,
      Value<int?>? groupId,
      Value<String?>? subcategory,
      Value<String?>? category,
      Value<String>? name,
      Value<String?>? code,
      Value<int>? stock,
      Value<String?>? location,
      Value<String?>? datasheetUrl,
      Value<String?>? buyUrl,
      Value<Map<String, dynamic>>? metadata}) {
    return PartsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      groupId: groupId ?? this.groupId,
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
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
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
          $PartsTable.$convertermetadata.toSql(metadata.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('groupId: $groupId, ')
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
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $UserGroupsTable userGroups = $UserGroupsTable(this);
  late final $AppContextsTable appContexts = $AppContextsTable(this);
  late final $PartsTable parts = $PartsTable(this);
  late final $PartsImagesTable partsImages = $PartsImagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [accounts, userGroups, appContexts, parts, partsImages];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_groups', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('user_groups',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('app_contexts', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('parts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('user_groups',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('parts', kind: UpdateKind.update),
            ],
          ),
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

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String name,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserGroupsTable, List<UserGroup>>
      _userGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.userGroups,
          aliasName:
              $_aliasNameGenerator(db.accounts.id, db.userGroups.accountId));

  $$UserGroupsTableProcessedTableManager get userGroupsRefs {
    final manager = $$UserGroupsTableTableManager($_db, $_db.userGroups)
        .filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userGroupsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AppContextsTable, List<AppContext>>
      _appContextsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.appContexts,
              aliasName: $_aliasNameGenerator(
                  db.accounts.id, db.appContexts.activeAccountId));

  $$AppContextsTableProcessedTableManager get appContextsRefs {
    final manager = $$AppContextsTableTableManager($_db, $_db.appContexts)
        .filter(
            (f) => f.activeAccountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_appContextsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PartsTable, List<Part>> _partsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.parts,
          aliasName: $_aliasNameGenerator(db.accounts.id, db.parts.accountId));

  $$PartsTableProcessedTableManager get partsRefs {
    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_partsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> userGroupsRefs(
      Expression<bool> Function($$UserGroupsTableFilterComposer f) f) {
    final $$UserGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userGroups,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserGroupsTableFilterComposer(
              $db: $db,
              $table: $db.userGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> appContextsRefs(
      Expression<bool> Function($$AppContextsTableFilterComposer f) f) {
    final $$AppContextsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.appContexts,
        getReferencedColumn: (t) => t.activeAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppContextsTableFilterComposer(
              $db: $db,
              $table: $db.appContexts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> partsRefs(
      Expression<bool> Function($$PartsTableFilterComposer f) f) {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.accountId,
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
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> userGroupsRefs<T extends Object>(
      Expression<T> Function($$UserGroupsTableAnnotationComposer a) f) {
    final $$UserGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userGroups,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.userGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> appContextsRefs<T extends Object>(
      Expression<T> Function($$AppContextsTableAnnotationComposer a) f) {
    final $$AppContextsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.appContexts,
        getReferencedColumn: (t) => t.activeAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppContextsTableAnnotationComposer(
              $db: $db,
              $table: $db.appContexts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> partsRefs<T extends Object>(
      Expression<T> Function($$PartsTableAnnotationComposer a) f) {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.accountId,
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
    return f(composer);
  }
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function(
        {bool userGroupsRefs, bool appContextsRefs, bool partsRefs})> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AccountsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {userGroupsRefs = false,
              appContextsRefs = false,
              partsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userGroupsRefs) db.userGroups,
                if (appContextsRefs) db.appContexts,
                if (partsRefs) db.parts
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userGroupsRefs)
                    await $_getPrefetchedData<Account, $AccountsTable,
                            UserGroup>(
                        currentTable: table,
                        referencedTable:
                            $$AccountsTableReferences._userGroupsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .userGroupsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items),
                  if (appContextsRefs)
                    await $_getPrefetchedData<Account, $AccountsTable,
                            AppContext>(
                        currentTable: table,
                        referencedTable:
                            $$AccountsTableReferences._appContextsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .appContextsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.activeAccountId == item.id),
                        typedResults: items),
                  if (partsRefs)
                    await $_getPrefetchedData<Account, $AccountsTable, Part>(
                        currentTable: table,
                        referencedTable:
                            $$AccountsTableReferences._partsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0).partsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function(
        {bool userGroupsRefs, bool appContextsRefs, bool partsRefs})>;
typedef $$UserGroupsTableCreateCompanionBuilder = UserGroupsCompanion Function({
  Value<int> id,
  required String accountId,
  required String name,
  Value<String?> description,
  Value<DateTime> createdAt,
});
typedef $$UserGroupsTableUpdateCompanionBuilder = UserGroupsCompanion Function({
  Value<int> id,
  Value<String> accountId,
  Value<String> name,
  Value<String?> description,
  Value<DateTime> createdAt,
});

final class $$UserGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $UserGroupsTable, UserGroup> {
  $$UserGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
          $_aliasNameGenerator(db.userGroups.accountId, db.accounts.id));

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AppContextsTable, List<AppContext>>
      _appContextsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.appContexts,
              aliasName: $_aliasNameGenerator(
                  db.userGroups.id, db.appContexts.activeGroupId));

  $$AppContextsTableProcessedTableManager get appContextsRefs {
    final manager = $$AppContextsTableTableManager($_db, $_db.appContexts)
        .filter((f) => f.activeGroupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_appContextsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PartsTable, List<Part>> _partsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.parts,
          aliasName: $_aliasNameGenerator(db.userGroups.id, db.parts.groupId));

  $$PartsTableProcessedTableManager get partsRefs {
    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UserGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $UserGroupsTable> {
  $$UserGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> appContextsRefs(
      Expression<bool> Function($$AppContextsTableFilterComposer f) f) {
    final $$AppContextsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.appContexts,
        getReferencedColumn: (t) => t.activeGroupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppContextsTableFilterComposer(
              $db: $db,
              $table: $db.appContexts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> partsRefs(
      Expression<bool> Function($$PartsTableFilterComposer f) f) {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.groupId,
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
    return f(composer);
  }
}

class $$UserGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserGroupsTable> {
  $$UserGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserGroupsTable> {
  $$UserGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> appContextsRefs<T extends Object>(
      Expression<T> Function($$AppContextsTableAnnotationComposer a) f) {
    final $$AppContextsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.appContexts,
        getReferencedColumn: (t) => t.activeGroupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AppContextsTableAnnotationComposer(
              $db: $db,
              $table: $db.appContexts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> partsRefs<T extends Object>(
      Expression<T> Function($$PartsTableAnnotationComposer a) f) {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.groupId,
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
    return f(composer);
  }
}

class $$UserGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserGroupsTable,
    UserGroup,
    $$UserGroupsTableFilterComposer,
    $$UserGroupsTableOrderingComposer,
    $$UserGroupsTableAnnotationComposer,
    $$UserGroupsTableCreateCompanionBuilder,
    $$UserGroupsTableUpdateCompanionBuilder,
    (UserGroup, $$UserGroupsTableReferences),
    UserGroup,
    PrefetchHooks Function(
        {bool accountId, bool appContextsRefs, bool partsRefs})> {
  $$UserGroupsTableTableManager(_$AppDatabase db, $UserGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UserGroupsCompanion(
            id: id,
            accountId: accountId,
            name: name,
            description: description,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String accountId,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              UserGroupsCompanion.insert(
            id: id,
            accountId: accountId,
            name: name,
            description: description,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserGroupsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {accountId = false, appContextsRefs = false, partsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (appContextsRefs) db.appContexts,
                if (partsRefs) db.parts
              ],
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
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$UserGroupsTableReferences._accountIdTable(db),
                    referencedColumn:
                        $$UserGroupsTableReferences._accountIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (appContextsRefs)
                    await $_getPrefetchedData<UserGroup, $UserGroupsTable,
                            AppContext>(
                        currentTable: table,
                        referencedTable: $$UserGroupsTableReferences
                            ._appContextsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UserGroupsTableReferences(db, table, p0)
                                .appContextsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.activeGroupId == item.id),
                        typedResults: items),
                  if (partsRefs)
                    await $_getPrefetchedData<UserGroup, $UserGroupsTable,
                            Part>(
                        currentTable: table,
                        referencedTable:
                            $$UserGroupsTableReferences._partsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UserGroupsTableReferences(db, table, p0)
                                .partsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UserGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserGroupsTable,
    UserGroup,
    $$UserGroupsTableFilterComposer,
    $$UserGroupsTableOrderingComposer,
    $$UserGroupsTableAnnotationComposer,
    $$UserGroupsTableCreateCompanionBuilder,
    $$UserGroupsTableUpdateCompanionBuilder,
    (UserGroup, $$UserGroupsTableReferences),
    UserGroup,
    PrefetchHooks Function(
        {bool accountId, bool appContextsRefs, bool partsRefs})>;
typedef $$AppContextsTableCreateCompanionBuilder = AppContextsCompanion
    Function({
  Value<int> id,
  required String activeAccountId,
  Value<int?> activeGroupId,
});
typedef $$AppContextsTableUpdateCompanionBuilder = AppContextsCompanion
    Function({
  Value<int> id,
  Value<String> activeAccountId,
  Value<int?> activeGroupId,
});

final class $$AppContextsTableReferences
    extends BaseReferences<_$AppDatabase, $AppContextsTable, AppContext> {
  $$AppContextsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _activeAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
          $_aliasNameGenerator(db.appContexts.activeAccountId, db.accounts.id));

  $$AccountsTableProcessedTableManager get activeAccountId {
    final $_column = $_itemColumn<String>('active_account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activeAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UserGroupsTable _activeGroupIdTable(_$AppDatabase db) =>
      db.userGroups.createAlias(
          $_aliasNameGenerator(db.appContexts.activeGroupId, db.userGroups.id));

  $$UserGroupsTableProcessedTableManager? get activeGroupId {
    final $_column = $_itemColumn<int>('active_group_id');
    if ($_column == null) return null;
    final manager = $$UserGroupsTableTableManager($_db, $_db.userGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activeGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AppContextsTableFilterComposer
    extends Composer<_$AppDatabase, $AppContextsTable> {
  $$AppContextsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get activeAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.activeAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserGroupsTableFilterComposer get activeGroupId {
    final $$UserGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.activeGroupId,
        referencedTable: $db.userGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserGroupsTableFilterComposer(
              $db: $db,
              $table: $db.userGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AppContextsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppContextsTable> {
  $$AppContextsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get activeAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.activeAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserGroupsTableOrderingComposer get activeGroupId {
    final $$UserGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.activeGroupId,
        referencedTable: $db.userGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.userGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AppContextsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppContextsTable> {
  $$AppContextsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$AccountsTableAnnotationComposer get activeAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.activeAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserGroupsTableAnnotationComposer get activeGroupId {
    final $$UserGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.activeGroupId,
        referencedTable: $db.userGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.userGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AppContextsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppContextsTable,
    AppContext,
    $$AppContextsTableFilterComposer,
    $$AppContextsTableOrderingComposer,
    $$AppContextsTableAnnotationComposer,
    $$AppContextsTableCreateCompanionBuilder,
    $$AppContextsTableUpdateCompanionBuilder,
    (AppContext, $$AppContextsTableReferences),
    AppContext,
    PrefetchHooks Function({bool activeAccountId, bool activeGroupId})> {
  $$AppContextsTableTableManager(_$AppDatabase db, $AppContextsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppContextsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppContextsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppContextsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> activeAccountId = const Value.absent(),
            Value<int?> activeGroupId = const Value.absent(),
          }) =>
              AppContextsCompanion(
            id: id,
            activeAccountId: activeAccountId,
            activeGroupId: activeGroupId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String activeAccountId,
            Value<int?> activeGroupId = const Value.absent(),
          }) =>
              AppContextsCompanion.insert(
            id: id,
            activeAccountId: activeAccountId,
            activeGroupId: activeGroupId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AppContextsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {activeAccountId = false, activeGroupId = false}) {
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
                if (activeAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.activeAccountId,
                    referencedTable:
                        $$AppContextsTableReferences._activeAccountIdTable(db),
                    referencedColumn: $$AppContextsTableReferences
                        ._activeAccountIdTable(db)
                        .id,
                  ) as T;
                }
                if (activeGroupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.activeGroupId,
                    referencedTable:
                        $$AppContextsTableReferences._activeGroupIdTable(db),
                    referencedColumn:
                        $$AppContextsTableReferences._activeGroupIdTable(db).id,
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

typedef $$AppContextsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppContextsTable,
    AppContext,
    $$AppContextsTableFilterComposer,
    $$AppContextsTableOrderingComposer,
    $$AppContextsTableAnnotationComposer,
    $$AppContextsTableCreateCompanionBuilder,
    $$AppContextsTableUpdateCompanionBuilder,
    (AppContext, $$AppContextsTableReferences),
    AppContext,
    PrefetchHooks Function({bool activeAccountId, bool activeGroupId})>;
typedef $$PartsTableCreateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  Value<String?> accountId,
  Value<int?> groupId,
  Value<String?> subcategory,
  Value<String?> category,
  required String name,
  Value<String?> code,
  Value<int> stock,
  Value<String?> location,
  Value<String?> datasheetUrl,
  Value<String?> buyUrl,
  required Map<String, dynamic> metadata,
});
typedef $$PartsTableUpdateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  Value<String?> accountId,
  Value<int?> groupId,
  Value<String?> subcategory,
  Value<String?> category,
  Value<String> name,
  Value<String?> code,
  Value<int> stock,
  Value<String?> location,
  Value<String?> datasheetUrl,
  Value<String?> buyUrl,
  Value<Map<String, dynamic>> metadata,
});

final class $$PartsTableReferences
    extends BaseReferences<_$AppDatabase, $PartsTable, Part> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) => db.accounts
      .createAlias($_aliasNameGenerator(db.parts.accountId, db.accounts.id));

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UserGroupsTable _groupIdTable(_$AppDatabase db) => db.userGroups
      .createAlias($_aliasNameGenerator(db.parts.groupId, db.userGroups.id));

  $$UserGroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<int>('group_id');
    if ($_column == null) return null;
    final manager = $$UserGroupsTableTableManager($_db, $_db.userGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

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

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get metadata => $composableBuilder(
          column: $table.metadata,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserGroupsTableFilterComposer get groupId {
    final $$UserGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.userGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserGroupsTableFilterComposer(
              $db: $db,
              $table: $db.userGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

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

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserGroupsTableOrderingComposer get groupId {
    final $$UserGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.userGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.userGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserGroupsTableAnnotationComposer get groupId {
    final $$UserGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.userGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.userGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

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
    PrefetchHooks Function(
        {bool accountId, bool groupId, bool partsImagesRefs})> {
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
            Value<String?> accountId = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<int> stock = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> datasheetUrl = const Value.absent(),
            Value<String?> buyUrl = const Value.absent(),
            Value<Map<String, dynamic>> metadata = const Value.absent(),
          }) =>
              PartsCompanion(
            id: id,
            accountId: accountId,
            groupId: groupId,
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
            Value<String?> accountId = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String?> category = const Value.absent(),
            required String name,
            Value<String?> code = const Value.absent(),
            Value<int> stock = const Value.absent(),
            Value<String?> location = const Value.absent(),
            Value<String?> datasheetUrl = const Value.absent(),
            Value<String?> buyUrl = const Value.absent(),
            required Map<String, dynamic> metadata,
          }) =>
              PartsCompanion.insert(
            id: id,
            accountId: accountId,
            groupId: groupId,
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
          prefetchHooksCallback: (
              {accountId = false, groupId = false, partsImagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (partsImagesRefs) db.partsImages],
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
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable: $$PartsTableReferences._accountIdTable(db),
                    referencedColumn:
                        $$PartsTableReferences._accountIdTable(db).id,
                  ) as T;
                }
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable: $$PartsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$PartsTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
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
    PrefetchHooks Function(
        {bool accountId, bool groupId, bool partsImagesRefs})>;
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
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$UserGroupsTableTableManager get userGroups =>
      $$UserGroupsTableTableManager(_db, _db.userGroups);
  $$AppContextsTableTableManager get appContexts =>
      $$AppContextsTableTableManager(_db, _db.appContexts);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$PartsImagesTableTableManager get partsImages =>
      $$PartsImagesTableTableManager(_db, _db.partsImages);
}
