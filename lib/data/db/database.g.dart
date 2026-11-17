// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, birthDate, sex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String birthDate;
  final String sex;
  const UserProfile({
    required this.id,
    required this.birthDate,
    required this.sex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['birth_date'] = Variable<String>(birthDate);
    map['sex'] = Variable<String>(sex);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      birthDate: Value(birthDate),
      sex: Value(sex),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      birthDate: serializer.fromJson<String>(json['birthDate']),
      sex: serializer.fromJson<String>(json['sex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'birthDate': serializer.toJson<String>(birthDate),
      'sex': serializer.toJson<String>(sex),
    };
  }

  UserProfile copyWith({int? id, String? birthDate, String? sex}) =>
      UserProfile(
        id: id ?? this.id,
        birthDate: birthDate ?? this.birthDate,
        sex: sex ?? this.sex,
      );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      sex: data.sex.present ? data.sex.value : this.sex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, birthDate, sex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.birthDate == this.birthDate &&
          other.sex == this.sex);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> birthDate;
  final Value<String> sex;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.sex = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String birthDate,
    required String sex,
  }) : birthDate = Value(birthDate),
       sex = Value(sex);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? birthDate,
    Expression<String>? sex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (birthDate != null) 'birth_date': birthDate,
      if (sex != null) 'sex': sex,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? birthDate,
    Value<String>? sex,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loadTypeMeta = const VerificationMeta(
    'loadType',
  );
  @override
  late final GeneratedColumn<String> loadType = GeneratedColumn<String>(
    'load_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, name, loadType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('load_type')) {
      context.handle(
        _loadTypeMeta,
        loadType.isAcceptableOrUnknown(data['load_type']!, _loadTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_loadTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      loadType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}load_type'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String key;
  final String name;
  final String loadType;
  const Exercise({
    required this.id,
    required this.key,
    required this.name,
    required this.loadType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['name'] = Variable<String>(name);
    map['load_type'] = Variable<String>(loadType);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      key: Value(key),
      name: Value(name),
      loadType: Value(loadType),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      name: serializer.fromJson<String>(json['name']),
      loadType: serializer.fromJson<String>(json['loadType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'name': serializer.toJson<String>(name),
      'loadType': serializer.toJson<String>(loadType),
    };
  }

  Exercise copyWith({int? id, String? key, String? name, String? loadType}) =>
      Exercise(
        id: id ?? this.id,
        key: key ?? this.key,
        name: name ?? this.name,
        loadType: loadType ?? this.loadType,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      loadType: data.loadType.present ? data.loadType.value : this.loadType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('loadType: $loadType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, name, loadType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.key == this.key &&
          other.name == this.name &&
          other.loadType == this.loadType);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> name;
  final Value<String> loadType;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.loadType = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String name,
    required String loadType,
  }) : key = Value(key),
       name = Value(name),
       loadType = Value(loadType);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? name,
    Expression<String>? loadType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (loadType != null) 'load_type': loadType,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? name,
    Value<String>? loadType,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      loadType: loadType ?? this.loadType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (loadType.present) {
      map['load_type'] = Variable<String>(loadType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('loadType: $loadType')
          ..write(')'))
        .toString();
  }
}

class $PlanDaysTable extends PlanDays with TableInfo<$PlanDaysTable, PlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRestDayMeta = const VerificationMeta(
    'isRestDay',
  );
  @override
  late final GeneratedColumn<bool> isRestDay = GeneratedColumn<bool>(
    'is_rest_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_rest_day" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, weekday, name, isRestDay];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_rest_day')) {
      context.handle(
        _isRestDayMeta,
        isRestDay.isAcceptableOrUnknown(data['is_rest_day']!, _isRestDayMeta),
      );
    } else if (isInserting) {
      context.missing(_isRestDayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isRestDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_rest_day'],
      )!,
    );
  }

  @override
  $PlanDaysTable createAlias(String alias) {
    return $PlanDaysTable(attachedDatabase, alias);
  }
}

class PlanDay extends DataClass implements Insertable<PlanDay> {
  final int id;
  final int weekday;
  final String name;
  final bool isRestDay;
  const PlanDay({
    required this.id,
    required this.weekday,
    required this.name,
    required this.isRestDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weekday'] = Variable<int>(weekday);
    map['name'] = Variable<String>(name);
    map['is_rest_day'] = Variable<bool>(isRestDay);
    return map;
  }

  PlanDaysCompanion toCompanion(bool nullToAbsent) {
    return PlanDaysCompanion(
      id: Value(id),
      weekday: Value(weekday),
      name: Value(name),
      isRestDay: Value(isRestDay),
    );
  }

  factory PlanDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanDay(
      id: serializer.fromJson<int>(json['id']),
      weekday: serializer.fromJson<int>(json['weekday']),
      name: serializer.fromJson<String>(json['name']),
      isRestDay: serializer.fromJson<bool>(json['isRestDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekday': serializer.toJson<int>(weekday),
      'name': serializer.toJson<String>(name),
      'isRestDay': serializer.toJson<bool>(isRestDay),
    };
  }

  PlanDay copyWith({int? id, int? weekday, String? name, bool? isRestDay}) =>
      PlanDay(
        id: id ?? this.id,
        weekday: weekday ?? this.weekday,
        name: name ?? this.name,
        isRestDay: isRestDay ?? this.isRestDay,
      );
  PlanDay copyWithCompanion(PlanDaysCompanion data) {
    return PlanDay(
      id: data.id.present ? data.id.value : this.id,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      name: data.name.present ? data.name.value : this.name,
      isRestDay: data.isRestDay.present ? data.isRestDay.value : this.isRestDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanDay(')
          ..write('id: $id, ')
          ..write('weekday: $weekday, ')
          ..write('name: $name, ')
          ..write('isRestDay: $isRestDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekday, name, isRestDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanDay &&
          other.id == this.id &&
          other.weekday == this.weekday &&
          other.name == this.name &&
          other.isRestDay == this.isRestDay);
}

class PlanDaysCompanion extends UpdateCompanion<PlanDay> {
  final Value<int> id;
  final Value<int> weekday;
  final Value<String> name;
  final Value<bool> isRestDay;
  const PlanDaysCompanion({
    this.id = const Value.absent(),
    this.weekday = const Value.absent(),
    this.name = const Value.absent(),
    this.isRestDay = const Value.absent(),
  });
  PlanDaysCompanion.insert({
    this.id = const Value.absent(),
    required int weekday,
    required String name,
    required bool isRestDay,
  }) : weekday = Value(weekday),
       name = Value(name),
       isRestDay = Value(isRestDay);
  static Insertable<PlanDay> custom({
    Expression<int>? id,
    Expression<int>? weekday,
    Expression<String>? name,
    Expression<bool>? isRestDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekday != null) 'weekday': weekday,
      if (name != null) 'name': name,
      if (isRestDay != null) 'is_rest_day': isRestDay,
    });
  }

  PlanDaysCompanion copyWith({
    Value<int>? id,
    Value<int>? weekday,
    Value<String>? name,
    Value<bool>? isRestDay,
  }) {
    return PlanDaysCompanion(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      name: name ?? this.name,
      isRestDay: isRestDay ?? this.isRestDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isRestDay.present) {
      map['is_rest_day'] = Variable<bool>(isRestDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanDaysCompanion(')
          ..write('id: $id, ')
          ..write('weekday: $weekday, ')
          ..write('name: $name, ')
          ..write('isRestDay: $isRestDay')
          ..write(')'))
        .toString();
  }
}

class $PlanSlotsTable extends PlanSlots
    with TableInfo<$PlanSlotsTable, PlanSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planDayIdMeta = const VerificationMeta(
    'planDayId',
  );
  @override
  late final GeneratedColumn<int> planDayId = GeneratedColumn<int>(
    'plan_day_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_days (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _orderIdxMeta = const VerificationMeta(
    'orderIdx',
  );
  @override
  late final GeneratedColumn<int> orderIdx = GeneratedColumn<int>(
    'order_idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repMinMeta = const VerificationMeta('repMin');
  @override
  late final GeneratedColumn<int> repMin = GeneratedColumn<int>(
    'rep_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repMaxMeta = const VerificationMeta('repMax');
  @override
  late final GeneratedColumn<int> repMax = GeneratedColumn<int>(
    'rep_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rirMinMeta = const VerificationMeta('rirMin');
  @override
  late final GeneratedColumn<int> rirMin = GeneratedColumn<int>(
    'rir_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rirMaxMeta = const VerificationMeta('rirMax');
  @override
  late final GeneratedColumn<int> rirMax = GeneratedColumn<int>(
    'rir_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progRepsMeta = const VerificationMeta(
    'progReps',
  );
  @override
  late final GeneratedColumn<int> progReps = GeneratedColumn<int>(
    'prog_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progSetsMeta = const VerificationMeta(
    'progSets',
  );
  @override
  late final GeneratedColumn<int> progSets = GeneratedColumn<int>(
    'prog_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planDayId,
    exerciseId,
    orderIdx,
    targetSets,
    repMin,
    repMax,
    rirMin,
    rirMax,
    progReps,
    progSets,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_day_id')) {
      context.handle(
        _planDayIdMeta,
        planDayId.isAcceptableOrUnknown(data['plan_day_id']!, _planDayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planDayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_idx')) {
      context.handle(
        _orderIdxMeta,
        orderIdx.isAcceptableOrUnknown(data['order_idx']!, _orderIdxMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdxMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    } else if (isInserting) {
      context.missing(_targetSetsMeta);
    }
    if (data.containsKey('rep_min')) {
      context.handle(
        _repMinMeta,
        repMin.isAcceptableOrUnknown(data['rep_min']!, _repMinMeta),
      );
    } else if (isInserting) {
      context.missing(_repMinMeta);
    }
    if (data.containsKey('rep_max')) {
      context.handle(
        _repMaxMeta,
        repMax.isAcceptableOrUnknown(data['rep_max']!, _repMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_repMaxMeta);
    }
    if (data.containsKey('rir_min')) {
      context.handle(
        _rirMinMeta,
        rirMin.isAcceptableOrUnknown(data['rir_min']!, _rirMinMeta),
      );
    }
    if (data.containsKey('rir_max')) {
      context.handle(
        _rirMaxMeta,
        rirMax.isAcceptableOrUnknown(data['rir_max']!, _rirMaxMeta),
      );
    }
    if (data.containsKey('prog_reps')) {
      context.handle(
        _progRepsMeta,
        progReps.isAcceptableOrUnknown(data['prog_reps']!, _progRepsMeta),
      );
    } else if (isInserting) {
      context.missing(_progRepsMeta);
    }
    if (data.containsKey('prog_sets')) {
      context.handle(
        _progSetsMeta,
        progSets.isAcceptableOrUnknown(data['prog_sets']!, _progSetsMeta),
      );
    } else if (isInserting) {
      context.missing(_progSetsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_day_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_idx'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      repMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_min'],
      )!,
      repMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_max'],
      )!,
      rirMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rir_min'],
      ),
      rirMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rir_max'],
      ),
      progReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prog_reps'],
      )!,
      progSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prog_sets'],
      )!,
    );
  }

  @override
  $PlanSlotsTable createAlias(String alias) {
    return $PlanSlotsTable(attachedDatabase, alias);
  }
}

class PlanSlot extends DataClass implements Insertable<PlanSlot> {
  final int id;
  final int planDayId;
  final int exerciseId;
  final int orderIdx;
  final int targetSets;
  final int repMin;
  final int repMax;
  final int? rirMin;
  final int? rirMax;
  final int progReps;
  final int progSets;
  const PlanSlot({
    required this.id,
    required this.planDayId,
    required this.exerciseId,
    required this.orderIdx,
    required this.targetSets,
    required this.repMin,
    required this.repMax,
    this.rirMin,
    this.rirMax,
    required this.progReps,
    required this.progSets,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_day_id'] = Variable<int>(planDayId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['order_idx'] = Variable<int>(orderIdx);
    map['target_sets'] = Variable<int>(targetSets);
    map['rep_min'] = Variable<int>(repMin);
    map['rep_max'] = Variable<int>(repMax);
    if (!nullToAbsent || rirMin != null) {
      map['rir_min'] = Variable<int>(rirMin);
    }
    if (!nullToAbsent || rirMax != null) {
      map['rir_max'] = Variable<int>(rirMax);
    }
    map['prog_reps'] = Variable<int>(progReps);
    map['prog_sets'] = Variable<int>(progSets);
    return map;
  }

  PlanSlotsCompanion toCompanion(bool nullToAbsent) {
    return PlanSlotsCompanion(
      id: Value(id),
      planDayId: Value(planDayId),
      exerciseId: Value(exerciseId),
      orderIdx: Value(orderIdx),
      targetSets: Value(targetSets),
      repMin: Value(repMin),
      repMax: Value(repMax),
      rirMin: rirMin == null && nullToAbsent
          ? const Value.absent()
          : Value(rirMin),
      rirMax: rirMax == null && nullToAbsent
          ? const Value.absent()
          : Value(rirMax),
      progReps: Value(progReps),
      progSets: Value(progSets),
    );
  }

  factory PlanSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanSlot(
      id: serializer.fromJson<int>(json['id']),
      planDayId: serializer.fromJson<int>(json['planDayId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      orderIdx: serializer.fromJson<int>(json['orderIdx']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      repMin: serializer.fromJson<int>(json['repMin']),
      repMax: serializer.fromJson<int>(json['repMax']),
      rirMin: serializer.fromJson<int?>(json['rirMin']),
      rirMax: serializer.fromJson<int?>(json['rirMax']),
      progReps: serializer.fromJson<int>(json['progReps']),
      progSets: serializer.fromJson<int>(json['progSets']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planDayId': serializer.toJson<int>(planDayId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'orderIdx': serializer.toJson<int>(orderIdx),
      'targetSets': serializer.toJson<int>(targetSets),
      'repMin': serializer.toJson<int>(repMin),
      'repMax': serializer.toJson<int>(repMax),
      'rirMin': serializer.toJson<int?>(rirMin),
      'rirMax': serializer.toJson<int?>(rirMax),
      'progReps': serializer.toJson<int>(progReps),
      'progSets': serializer.toJson<int>(progSets),
    };
  }

  PlanSlot copyWith({
    int? id,
    int? planDayId,
    int? exerciseId,
    int? orderIdx,
    int? targetSets,
    int? repMin,
    int? repMax,
    Value<int?> rirMin = const Value.absent(),
    Value<int?> rirMax = const Value.absent(),
    int? progReps,
    int? progSets,
  }) => PlanSlot(
    id: id ?? this.id,
    planDayId: planDayId ?? this.planDayId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIdx: orderIdx ?? this.orderIdx,
    targetSets: targetSets ?? this.targetSets,
    repMin: repMin ?? this.repMin,
    repMax: repMax ?? this.repMax,
    rirMin: rirMin.present ? rirMin.value : this.rirMin,
    rirMax: rirMax.present ? rirMax.value : this.rirMax,
    progReps: progReps ?? this.progReps,
    progSets: progSets ?? this.progSets,
  );
  PlanSlot copyWithCompanion(PlanSlotsCompanion data) {
    return PlanSlot(
      id: data.id.present ? data.id.value : this.id,
      planDayId: data.planDayId.present ? data.planDayId.value : this.planDayId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIdx: data.orderIdx.present ? data.orderIdx.value : this.orderIdx,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      repMin: data.repMin.present ? data.repMin.value : this.repMin,
      repMax: data.repMax.present ? data.repMax.value : this.repMax,
      rirMin: data.rirMin.present ? data.rirMin.value : this.rirMin,
      rirMax: data.rirMax.present ? data.rirMax.value : this.rirMax,
      progReps: data.progReps.present ? data.progReps.value : this.progReps,
      progSets: data.progSets.present ? data.progSets.value : this.progSets,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanSlot(')
          ..write('id: $id, ')
          ..write('planDayId: $planDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIdx: $orderIdx, ')
          ..write('targetSets: $targetSets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('rirMin: $rirMin, ')
          ..write('rirMax: $rirMax, ')
          ..write('progReps: $progReps, ')
          ..write('progSets: $progSets')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planDayId,
    exerciseId,
    orderIdx,
    targetSets,
    repMin,
    repMax,
    rirMin,
    rirMax,
    progReps,
    progSets,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanSlot &&
          other.id == this.id &&
          other.planDayId == this.planDayId &&
          other.exerciseId == this.exerciseId &&
          other.orderIdx == this.orderIdx &&
          other.targetSets == this.targetSets &&
          other.repMin == this.repMin &&
          other.repMax == this.repMax &&
          other.rirMin == this.rirMin &&
          other.rirMax == this.rirMax &&
          other.progReps == this.progReps &&
          other.progSets == this.progSets);
}

class PlanSlotsCompanion extends UpdateCompanion<PlanSlot> {
  final Value<int> id;
  final Value<int> planDayId;
  final Value<int> exerciseId;
  final Value<int> orderIdx;
  final Value<int> targetSets;
  final Value<int> repMin;
  final Value<int> repMax;
  final Value<int?> rirMin;
  final Value<int?> rirMax;
  final Value<int> progReps;
  final Value<int> progSets;
  const PlanSlotsCompanion({
    this.id = const Value.absent(),
    this.planDayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIdx = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    this.rirMin = const Value.absent(),
    this.rirMax = const Value.absent(),
    this.progReps = const Value.absent(),
    this.progSets = const Value.absent(),
  });
  PlanSlotsCompanion.insert({
    this.id = const Value.absent(),
    required int planDayId,
    required int exerciseId,
    required int orderIdx,
    required int targetSets,
    required int repMin,
    required int repMax,
    this.rirMin = const Value.absent(),
    this.rirMax = const Value.absent(),
    required int progReps,
    required int progSets,
  }) : planDayId = Value(planDayId),
       exerciseId = Value(exerciseId),
       orderIdx = Value(orderIdx),
       targetSets = Value(targetSets),
       repMin = Value(repMin),
       repMax = Value(repMax),
       progReps = Value(progReps),
       progSets = Value(progSets);
  static Insertable<PlanSlot> custom({
    Expression<int>? id,
    Expression<int>? planDayId,
    Expression<int>? exerciseId,
    Expression<int>? orderIdx,
    Expression<int>? targetSets,
    Expression<int>? repMin,
    Expression<int>? repMax,
    Expression<int>? rirMin,
    Expression<int>? rirMax,
    Expression<int>? progReps,
    Expression<int>? progSets,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planDayId != null) 'plan_day_id': planDayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIdx != null) 'order_idx': orderIdx,
      if (targetSets != null) 'target_sets': targetSets,
      if (repMin != null) 'rep_min': repMin,
      if (repMax != null) 'rep_max': repMax,
      if (rirMin != null) 'rir_min': rirMin,
      if (rirMax != null) 'rir_max': rirMax,
      if (progReps != null) 'prog_reps': progReps,
      if (progSets != null) 'prog_sets': progSets,
    });
  }

  PlanSlotsCompanion copyWith({
    Value<int>? id,
    Value<int>? planDayId,
    Value<int>? exerciseId,
    Value<int>? orderIdx,
    Value<int>? targetSets,
    Value<int>? repMin,
    Value<int>? repMax,
    Value<int?>? rirMin,
    Value<int?>? rirMax,
    Value<int>? progReps,
    Value<int>? progSets,
  }) {
    return PlanSlotsCompanion(
      id: id ?? this.id,
      planDayId: planDayId ?? this.planDayId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIdx: orderIdx ?? this.orderIdx,
      targetSets: targetSets ?? this.targetSets,
      repMin: repMin ?? this.repMin,
      repMax: repMax ?? this.repMax,
      rirMin: rirMin ?? this.rirMin,
      rirMax: rirMax ?? this.rirMax,
      progReps: progReps ?? this.progReps,
      progSets: progSets ?? this.progSets,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planDayId.present) {
      map['plan_day_id'] = Variable<int>(planDayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (orderIdx.present) {
      map['order_idx'] = Variable<int>(orderIdx.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (repMin.present) {
      map['rep_min'] = Variable<int>(repMin.value);
    }
    if (repMax.present) {
      map['rep_max'] = Variable<int>(repMax.value);
    }
    if (rirMin.present) {
      map['rir_min'] = Variable<int>(rirMin.value);
    }
    if (rirMax.present) {
      map['rir_max'] = Variable<int>(rirMax.value);
    }
    if (progReps.present) {
      map['prog_reps'] = Variable<int>(progReps.value);
    }
    if (progSets.present) {
      map['prog_sets'] = Variable<int>(progSets.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanSlotsCompanion(')
          ..write('id: $id, ')
          ..write('planDayId: $planDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIdx: $orderIdx, ')
          ..write('targetSets: $targetSets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('rirMin: $rirMin, ')
          ..write('rirMax: $rirMax, ')
          ..write('progReps: $progReps, ')
          ..write('progSets: $progSets')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planDayIdMeta = const VerificationMeta(
    'planDayId',
  );
  @override
  late final GeneratedColumn<int> planDayId = GeneratedColumn<int>(
    'plan_day_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_days (id)',
    ),
  );
  static const VerificationMeta _plannedDateMeta = const VerificationMeta(
    'plannedDate',
  );
  @override
  late final GeneratedColumn<String> plannedDate = GeneratedColumn<String>(
    'planned_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _performedDateMeta = const VerificationMeta(
    'performedDate',
  );
  @override
  late final GeneratedColumn<String> performedDate = GeneratedColumn<String>(
    'performed_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planDayId,
    plannedDate,
    performedDate,
    status,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_day_id')) {
      context.handle(
        _planDayIdMeta,
        planDayId.isAcceptableOrUnknown(data['plan_day_id']!, _planDayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planDayIdMeta);
    }
    if (data.containsKey('planned_date')) {
      context.handle(
        _plannedDateMeta,
        plannedDate.isAcceptableOrUnknown(
          data['planned_date']!,
          _plannedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDateMeta);
    }
    if (data.containsKey('performed_date')) {
      context.handle(
        _performedDateMeta,
        performedDate.isAcceptableOrUnknown(
          data['performed_date']!,
          _performedDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_day_id'],
      )!,
      plannedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned_date'],
      )!,
      performedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performed_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final int planDayId;
  final String plannedDate;
  final String? performedDate;
  final String status;
  final String? note;
  const WorkoutSession({
    required this.id,
    required this.planDayId,
    required this.plannedDate,
    this.performedDate,
    required this.status,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_day_id'] = Variable<int>(planDayId);
    map['planned_date'] = Variable<String>(plannedDate);
    if (!nullToAbsent || performedDate != null) {
      map['performed_date'] = Variable<String>(performedDate);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      planDayId: Value(planDayId),
      plannedDate: Value(plannedDate),
      performedDate: performedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(performedDate),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      planDayId: serializer.fromJson<int>(json['planDayId']),
      plannedDate: serializer.fromJson<String>(json['plannedDate']),
      performedDate: serializer.fromJson<String?>(json['performedDate']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planDayId': serializer.toJson<int>(planDayId),
      'plannedDate': serializer.toJson<String>(plannedDate),
      'performedDate': serializer.toJson<String?>(performedDate),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
    };
  }

  WorkoutSession copyWith({
    int? id,
    int? planDayId,
    String? plannedDate,
    Value<String?> performedDate = const Value.absent(),
    String? status,
    Value<String?> note = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    planDayId: planDayId ?? this.planDayId,
    plannedDate: plannedDate ?? this.plannedDate,
    performedDate: performedDate.present
        ? performedDate.value
        : this.performedDate,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      planDayId: data.planDayId.present ? data.planDayId.value : this.planDayId,
      plannedDate: data.plannedDate.present
          ? data.plannedDate.value
          : this.plannedDate,
      performedDate: data.performedDate.present
          ? data.performedDate.value
          : this.performedDate,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('planDayId: $planDayId, ')
          ..write('plannedDate: $plannedDate, ')
          ..write('performedDate: $performedDate, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planDayId, plannedDate, performedDate, status, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.planDayId == this.planDayId &&
          other.plannedDate == this.plannedDate &&
          other.performedDate == this.performedDate &&
          other.status == this.status &&
          other.note == this.note);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<int> planDayId;
  final Value<String> plannedDate;
  final Value<String?> performedDate;
  final Value<String> status;
  final Value<String?> note;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.planDayId = const Value.absent(),
    this.plannedDate = const Value.absent(),
    this.performedDate = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int planDayId,
    required String plannedDate,
    this.performedDate = const Value.absent(),
    required String status,
    this.note = const Value.absent(),
  }) : planDayId = Value(planDayId),
       plannedDate = Value(plannedDate),
       status = Value(status);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<int>? planDayId,
    Expression<String>? plannedDate,
    Expression<String>? performedDate,
    Expression<String>? status,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planDayId != null) 'plan_day_id': planDayId,
      if (plannedDate != null) 'planned_date': plannedDate,
      if (performedDate != null) 'performed_date': performedDate,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? planDayId,
    Value<String>? plannedDate,
    Value<String?>? performedDate,
    Value<String>? status,
    Value<String?>? note,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      planDayId: planDayId ?? this.planDayId,
      plannedDate: plannedDate ?? this.plannedDate,
      performedDate: performedDate ?? this.performedDate,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planDayId.present) {
      map['plan_day_id'] = Variable<int>(planDayId.value);
    }
    if (plannedDate.present) {
      map['planned_date'] = Variable<String>(plannedDate.value);
    }
    if (performedDate.present) {
      map['performed_date'] = Variable<String>(performedDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('planDayId: $planDayId, ')
          ..write('plannedDate: $plannedDate, ')
          ..write('performedDate: $performedDate, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $SessionExercisesTable extends SessionExercises
    with TableInfo<$SessionExercisesTable, SessionExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
    ),
  );
  static const VerificationMeta _slotIdMeta = const VerificationMeta('slotId');
  @override
  late final GeneratedColumn<int> slotId = GeneratedColumn<int>(
    'slot_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_slots (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _topWeightMeta = const VerificationMeta(
    'topWeight',
  );
  @override
  late final GeneratedColumn<double> topWeight = GeneratedColumn<double>(
    'top_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _e1rmBestMeta = const VerificationMeta(
    'e1rmBest',
  );
  @override
  late final GeneratedColumn<double> e1rmBest = GeneratedColumn<double>(
    'e1rm_best',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyweightKgMeta = const VerificationMeta(
    'bodyweightKg',
  );
  @override
  late final GeneratedColumn<double> bodyweightKg = GeneratedColumn<double>(
    'bodyweight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressionResultMeta = const VerificationMeta(
    'progressionResult',
  );
  @override
  late final GeneratedColumn<String> progressionResult =
      GeneratedColumn<String>(
        'progression_result',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _progressionMessageMeta =
      const VerificationMeta('progressionMessage');
  @override
  late final GeneratedColumn<String> progressionMessage =
      GeneratedColumn<String>(
        'progression_message',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    slotId,
    exerciseId,
    topWeight,
    e1rmBest,
    volume,
    bodyweightKg,
    progressionResult,
    progressionMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('slot_id')) {
      context.handle(
        _slotIdMeta,
        slotId.isAcceptableOrUnknown(data['slot_id']!, _slotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_slotIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('top_weight')) {
      context.handle(
        _topWeightMeta,
        topWeight.isAcceptableOrUnknown(data['top_weight']!, _topWeightMeta),
      );
    } else if (isInserting) {
      context.missing(_topWeightMeta);
    }
    if (data.containsKey('e1rm_best')) {
      context.handle(
        _e1rmBestMeta,
        e1rmBest.isAcceptableOrUnknown(data['e1rm_best']!, _e1rmBestMeta),
      );
    } else if (isInserting) {
      context.missing(_e1rmBestMeta);
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    } else if (isInserting) {
      context.missing(_volumeMeta);
    }
    if (data.containsKey('bodyweight_kg')) {
      context.handle(
        _bodyweightKgMeta,
        bodyweightKg.isAcceptableOrUnknown(
          data['bodyweight_kg']!,
          _bodyweightKgMeta,
        ),
      );
    }
    if (data.containsKey('progression_result')) {
      context.handle(
        _progressionResultMeta,
        progressionResult.isAcceptableOrUnknown(
          data['progression_result']!,
          _progressionResultMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressionResultMeta);
    }
    if (data.containsKey('progression_message')) {
      context.handle(
        _progressionMessageMeta,
        progressionMessage.isAcceptableOrUnknown(
          data['progression_message']!,
          _progressionMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressionMessageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      slotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      topWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_weight'],
      )!,
      e1rmBest: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}e1rm_best'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume'],
      )!,
      bodyweightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bodyweight_kg'],
      ),
      progressionResult: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progression_result'],
      )!,
      progressionMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progression_message'],
      )!,
    );
  }

  @override
  $SessionExercisesTable createAlias(String alias) {
    return $SessionExercisesTable(attachedDatabase, alias);
  }
}

class SessionExercise extends DataClass implements Insertable<SessionExercise> {
  final int id;
  final int sessionId;
  final int slotId;
  final int exerciseId;
  final double topWeight;
  final double e1rmBest;
  final double volume;

  /// Körpergewicht, mit dem der e1RM berechnet wurde (nur Dip/Pullup).
  final double? bodyweightKg;
  final String progressionResult;
  final String progressionMessage;
  const SessionExercise({
    required this.id,
    required this.sessionId,
    required this.slotId,
    required this.exerciseId,
    required this.topWeight,
    required this.e1rmBest,
    required this.volume,
    this.bodyweightKg,
    required this.progressionResult,
    required this.progressionMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['slot_id'] = Variable<int>(slotId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['top_weight'] = Variable<double>(topWeight);
    map['e1rm_best'] = Variable<double>(e1rmBest);
    map['volume'] = Variable<double>(volume);
    if (!nullToAbsent || bodyweightKg != null) {
      map['bodyweight_kg'] = Variable<double>(bodyweightKg);
    }
    map['progression_result'] = Variable<String>(progressionResult);
    map['progression_message'] = Variable<String>(progressionMessage);
    return map;
  }

  SessionExercisesCompanion toCompanion(bool nullToAbsent) {
    return SessionExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      slotId: Value(slotId),
      exerciseId: Value(exerciseId),
      topWeight: Value(topWeight),
      e1rmBest: Value(e1rmBest),
      volume: Value(volume),
      bodyweightKg: bodyweightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyweightKg),
      progressionResult: Value(progressionResult),
      progressionMessage: Value(progressionMessage),
    );
  }

  factory SessionExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExercise(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      slotId: serializer.fromJson<int>(json['slotId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      topWeight: serializer.fromJson<double>(json['topWeight']),
      e1rmBest: serializer.fromJson<double>(json['e1rmBest']),
      volume: serializer.fromJson<double>(json['volume']),
      bodyweightKg: serializer.fromJson<double?>(json['bodyweightKg']),
      progressionResult: serializer.fromJson<String>(json['progressionResult']),
      progressionMessage: serializer.fromJson<String>(
        json['progressionMessage'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'slotId': serializer.toJson<int>(slotId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'topWeight': serializer.toJson<double>(topWeight),
      'e1rmBest': serializer.toJson<double>(e1rmBest),
      'volume': serializer.toJson<double>(volume),
      'bodyweightKg': serializer.toJson<double?>(bodyweightKg),
      'progressionResult': serializer.toJson<String>(progressionResult),
      'progressionMessage': serializer.toJson<String>(progressionMessage),
    };
  }

  SessionExercise copyWith({
    int? id,
    int? sessionId,
    int? slotId,
    int? exerciseId,
    double? topWeight,
    double? e1rmBest,
    double? volume,
    Value<double?> bodyweightKg = const Value.absent(),
    String? progressionResult,
    String? progressionMessage,
  }) => SessionExercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    slotId: slotId ?? this.slotId,
    exerciseId: exerciseId ?? this.exerciseId,
    topWeight: topWeight ?? this.topWeight,
    e1rmBest: e1rmBest ?? this.e1rmBest,
    volume: volume ?? this.volume,
    bodyweightKg: bodyweightKg.present ? bodyweightKg.value : this.bodyweightKg,
    progressionResult: progressionResult ?? this.progressionResult,
    progressionMessage: progressionMessage ?? this.progressionMessage,
  );
  SessionExercise copyWithCompanion(SessionExercisesCompanion data) {
    return SessionExercise(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      slotId: data.slotId.present ? data.slotId.value : this.slotId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      topWeight: data.topWeight.present ? data.topWeight.value : this.topWeight,
      e1rmBest: data.e1rmBest.present ? data.e1rmBest.value : this.e1rmBest,
      volume: data.volume.present ? data.volume.value : this.volume,
      bodyweightKg: data.bodyweightKg.present
          ? data.bodyweightKg.value
          : this.bodyweightKg,
      progressionResult: data.progressionResult.present
          ? data.progressionResult.value
          : this.progressionResult,
      progressionMessage: data.progressionMessage.present
          ? data.progressionMessage.value
          : this.progressionMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercise(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('slotId: $slotId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('topWeight: $topWeight, ')
          ..write('e1rmBest: $e1rmBest, ')
          ..write('volume: $volume, ')
          ..write('bodyweightKg: $bodyweightKg, ')
          ..write('progressionResult: $progressionResult, ')
          ..write('progressionMessage: $progressionMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    slotId,
    exerciseId,
    topWeight,
    e1rmBest,
    volume,
    bodyweightKg,
    progressionResult,
    progressionMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.slotId == this.slotId &&
          other.exerciseId == this.exerciseId &&
          other.topWeight == this.topWeight &&
          other.e1rmBest == this.e1rmBest &&
          other.volume == this.volume &&
          other.bodyweightKg == this.bodyweightKg &&
          other.progressionResult == this.progressionResult &&
          other.progressionMessage == this.progressionMessage);
}

class SessionExercisesCompanion extends UpdateCompanion<SessionExercise> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> slotId;
  final Value<int> exerciseId;
  final Value<double> topWeight;
  final Value<double> e1rmBest;
  final Value<double> volume;
  final Value<double?> bodyweightKg;
  final Value<String> progressionResult;
  final Value<String> progressionMessage;
  const SessionExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.slotId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.topWeight = const Value.absent(),
    this.e1rmBest = const Value.absent(),
    this.volume = const Value.absent(),
    this.bodyweightKg = const Value.absent(),
    this.progressionResult = const Value.absent(),
    this.progressionMessage = const Value.absent(),
  });
  SessionExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int slotId,
    required int exerciseId,
    required double topWeight,
    required double e1rmBest,
    required double volume,
    this.bodyweightKg = const Value.absent(),
    required String progressionResult,
    required String progressionMessage,
  }) : sessionId = Value(sessionId),
       slotId = Value(slotId),
       exerciseId = Value(exerciseId),
       topWeight = Value(topWeight),
       e1rmBest = Value(e1rmBest),
       volume = Value(volume),
       progressionResult = Value(progressionResult),
       progressionMessage = Value(progressionMessage);
  static Insertable<SessionExercise> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? slotId,
    Expression<int>? exerciseId,
    Expression<double>? topWeight,
    Expression<double>? e1rmBest,
    Expression<double>? volume,
    Expression<double>? bodyweightKg,
    Expression<String>? progressionResult,
    Expression<String>? progressionMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (slotId != null) 'slot_id': slotId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (topWeight != null) 'top_weight': topWeight,
      if (e1rmBest != null) 'e1rm_best': e1rmBest,
      if (volume != null) 'volume': volume,
      if (bodyweightKg != null) 'bodyweight_kg': bodyweightKg,
      if (progressionResult != null) 'progression_result': progressionResult,
      if (progressionMessage != null) 'progression_message': progressionMessage,
    });
  }

  SessionExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? slotId,
    Value<int>? exerciseId,
    Value<double>? topWeight,
    Value<double>? e1rmBest,
    Value<double>? volume,
    Value<double?>? bodyweightKg,
    Value<String>? progressionResult,
    Value<String>? progressionMessage,
  }) {
    return SessionExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      slotId: slotId ?? this.slotId,
      exerciseId: exerciseId ?? this.exerciseId,
      topWeight: topWeight ?? this.topWeight,
      e1rmBest: e1rmBest ?? this.e1rmBest,
      volume: volume ?? this.volume,
      bodyweightKg: bodyweightKg ?? this.bodyweightKg,
      progressionResult: progressionResult ?? this.progressionResult,
      progressionMessage: progressionMessage ?? this.progressionMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (slotId.present) {
      map['slot_id'] = Variable<int>(slotId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (topWeight.present) {
      map['top_weight'] = Variable<double>(topWeight.value);
    }
    if (e1rmBest.present) {
      map['e1rm_best'] = Variable<double>(e1rmBest.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (bodyweightKg.present) {
      map['bodyweight_kg'] = Variable<double>(bodyweightKg.value);
    }
    if (progressionResult.present) {
      map['progression_result'] = Variable<String>(progressionResult.value);
    }
    if (progressionMessage.present) {
      map['progression_message'] = Variable<String>(progressionMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('slotId: $slotId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('topWeight: $topWeight, ')
          ..write('e1rmBest: $e1rmBest, ')
          ..write('volume: $volume, ')
          ..write('bodyweightKg: $bodyweightKg, ')
          ..write('progressionResult: $progressionResult, ')
          ..write('progressionMessage: $progressionMessage')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionExerciseIdMeta = const VerificationMeta(
    'sessionExerciseId',
  );
  @override
  late final GeneratedColumn<int> sessionExerciseId = GeneratedColumn<int>(
    'session_exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES session_exercises (id)',
    ),
  );
  static const VerificationMeta _setNoMeta = const VerificationMeta('setNo');
  @override
  late final GeneratedColumn<int> setNo = GeneratedColumn<int>(
    'set_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<int> rir = GeneratedColumn<int>(
    'rir',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionExerciseId,
    setNo,
    reps,
    weight,
    rir,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
        _sessionExerciseIdMeta,
        sessionExerciseId.isAcceptableOrUnknown(
          data['session_exercise_id']!,
          _sessionExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('set_no')) {
      context.handle(
        _setNoMeta,
        setNo.isAcceptableOrUnknown(data['set_no']!, _setNoMeta),
      );
    } else if (isInserting) {
      context.missing(_setNoMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_exercise_id'],
      )!,
      setNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_no'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rir'],
      ),
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLog extends DataClass implements Insertable<SetLog> {
  final int id;
  final int sessionExerciseId;
  final int setNo;
  final int reps;
  final double weight;
  final int? rir;
  const SetLog({
    required this.id,
    required this.sessionExerciseId,
    required this.setNo,
    required this.reps,
    required this.weight,
    this.rir,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_exercise_id'] = Variable<int>(sessionExerciseId);
    map['set_no'] = Variable<int>(setNo);
    map['reps'] = Variable<int>(reps);
    map['weight'] = Variable<double>(weight);
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<int>(rir);
    }
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      sessionExerciseId: Value(sessionExerciseId),
      setNo: Value(setNo),
      reps: Value(reps),
      weight: Value(weight),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
    );
  }

  factory SetLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLog(
      id: serializer.fromJson<int>(json['id']),
      sessionExerciseId: serializer.fromJson<int>(json['sessionExerciseId']),
      setNo: serializer.fromJson<int>(json['setNo']),
      reps: serializer.fromJson<int>(json['reps']),
      weight: serializer.fromJson<double>(json['weight']),
      rir: serializer.fromJson<int?>(json['rir']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionExerciseId': serializer.toJson<int>(sessionExerciseId),
      'setNo': serializer.toJson<int>(setNo),
      'reps': serializer.toJson<int>(reps),
      'weight': serializer.toJson<double>(weight),
      'rir': serializer.toJson<int?>(rir),
    };
  }

  SetLog copyWith({
    int? id,
    int? sessionExerciseId,
    int? setNo,
    int? reps,
    double? weight,
    Value<int?> rir = const Value.absent(),
  }) => SetLog(
    id: id ?? this.id,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    setNo: setNo ?? this.setNo,
    reps: reps ?? this.reps,
    weight: weight ?? this.weight,
    rir: rir.present ? rir.value : this.rir,
  );
  SetLog copyWithCompanion(SetLogsCompanion data) {
    return SetLog(
      id: data.id.present ? data.id.value : this.id,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      setNo: data.setNo.present ? data.setNo.value : this.setNo,
      reps: data.reps.present ? data.reps.value : this.reps,
      weight: data.weight.present ? data.weight.value : this.weight,
      rir: data.rir.present ? data.rir.value : this.rir,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLog(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setNo: $setNo, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('rir: $rir')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionExerciseId, setNo, reps, weight, rir);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLog &&
          other.id == this.id &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.setNo == this.setNo &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.rir == this.rir);
}

class SetLogsCompanion extends UpdateCompanion<SetLog> {
  final Value<int> id;
  final Value<int> sessionExerciseId;
  final Value<int> setNo;
  final Value<int> reps;
  final Value<double> weight;
  final Value<int?> rir;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.setNo = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.rir = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionExerciseId,
    required int setNo,
    required int reps,
    required double weight,
    this.rir = const Value.absent(),
  }) : sessionExerciseId = Value(sessionExerciseId),
       setNo = Value(setNo),
       reps = Value(reps),
       weight = Value(weight);
  static Insertable<SetLog> custom({
    Expression<int>? id,
    Expression<int>? sessionExerciseId,
    Expression<int>? setNo,
    Expression<int>? reps,
    Expression<double>? weight,
    Expression<int>? rir,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (setNo != null) 'set_no': setNo,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (rir != null) 'rir': rir,
    });
  }

  SetLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionExerciseId,
    Value<int>? setNo,
    Value<int>? reps,
    Value<double>? weight,
    Value<int?>? rir,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      setNo: setNo ?? this.setNo,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      rir: rir ?? this.rir,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<int>(sessionExerciseId.value);
    }
    if (setNo.present) {
      map['set_no'] = Variable<int>(setNo.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (rir.present) {
      map['rir'] = Variable<int>(rir.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setNo: $setNo, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('rir: $rir')
          ..write(')'))
        .toString();
  }
}

class $BodyWeightEntriesTable extends BodyWeightEntries
    with TableInfo<$BodyWeightEntriesTable, BodyWeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyWeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtMsMeta = const VerificationMeta(
    'measuredAtMs',
  );
  @override
  late final GeneratedColumn<int> measuredAtMs = GeneratedColumn<int>(
    'measured_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, weightKg, measuredAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_weight_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyWeightEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('measured_at_ms')) {
      context.handle(
        _measuredAtMsMeta,
        measuredAtMs.isAcceptableOrUnknown(
          data['measured_at_ms']!,
          _measuredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyWeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyWeightEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      measuredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}measured_at_ms'],
      )!,
    );
  }

  @override
  $BodyWeightEntriesTable createAlias(String alias) {
    return $BodyWeightEntriesTable(attachedDatabase, alias);
  }
}

class BodyWeightEntry extends DataClass implements Insertable<BodyWeightEntry> {
  final int id;
  final String date;
  final double weightKg;
  final int measuredAtMs;
  const BodyWeightEntry({
    required this.id,
    required this.date,
    required this.weightKg,
    required this.measuredAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['weight_kg'] = Variable<double>(weightKg);
    map['measured_at_ms'] = Variable<int>(measuredAtMs);
    return map;
  }

  BodyWeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return BodyWeightEntriesCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: Value(weightKg),
      measuredAtMs: Value(measuredAtMs),
    );
  }

  factory BodyWeightEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyWeightEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      measuredAtMs: serializer.fromJson<int>(json['measuredAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'weightKg': serializer.toJson<double>(weightKg),
      'measuredAtMs': serializer.toJson<int>(measuredAtMs),
    };
  }

  BodyWeightEntry copyWith({
    int? id,
    String? date,
    double? weightKg,
    int? measuredAtMs,
  }) => BodyWeightEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    weightKg: weightKg ?? this.weightKg,
    measuredAtMs: measuredAtMs ?? this.measuredAtMs,
  );
  BodyWeightEntry copyWithCompanion(BodyWeightEntriesCompanion data) {
    return BodyWeightEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      measuredAtMs: data.measuredAtMs.present
          ? data.measuredAtMs.value
          : this.measuredAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyWeightEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('measuredAtMs: $measuredAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weightKg, measuredAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyWeightEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.measuredAtMs == this.measuredAtMs);
}

class BodyWeightEntriesCompanion extends UpdateCompanion<BodyWeightEntry> {
  final Value<int> id;
  final Value<String> date;
  final Value<double> weightKg;
  final Value<int> measuredAtMs;
  const BodyWeightEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.measuredAtMs = const Value.absent(),
  });
  BodyWeightEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required double weightKg,
    required int measuredAtMs,
  }) : date = Value(date),
       weightKg = Value(weightKg),
       measuredAtMs = Value(measuredAtMs);
  static Insertable<BodyWeightEntry> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<double>? weightKg,
    Expression<int>? measuredAtMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (measuredAtMs != null) 'measured_at_ms': measuredAtMs,
    });
  }

  BodyWeightEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<double>? weightKg,
    Value<int>? measuredAtMs,
  }) {
    return BodyWeightEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      measuredAtMs: measuredAtMs ?? this.measuredAtMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (measuredAtMs.present) {
      map['measured_at_ms'] = Variable<int>(measuredAtMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyWeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('measuredAtMs: $measuredAtMs')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $PlanDaysTable planDays = $PlanDaysTable(this);
  late final $PlanSlotsTable planSlots = $PlanSlotsTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $SessionExercisesTable sessionExercises = $SessionExercisesTable(
    this,
  );
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $BodyWeightEntriesTable bodyWeightEntries =
      $BodyWeightEntriesTable(this);
  late final Index idxSessionsPlanned = Index(
    'idx_sessions_planned',
    'CREATE INDEX idx_sessions_planned ON workout_sessions (planned_date)',
  );
  late final Index idxSeExercise = Index(
    'idx_se_exercise',
    'CREATE INDEX idx_se_exercise ON session_exercises (exercise_id)',
  );
  late final Index idxSetsSe = Index(
    'idx_sets_se',
    'CREATE INDEX idx_sets_se ON set_logs (session_exercise_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    appSettings,
    exercises,
    planDays,
    planSlots,
    workoutSessions,
    sessionExercises,
    setLogs,
    bodyWeightEntries,
    idxSessionsPlanned,
    idxSeExercise,
    idxSetsSe,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      required String birthDate,
      required String sex,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> birthDate,
      Value<String> sex,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> birthDate = const Value.absent(),
            Value<String> sex = const Value.absent(),
          }) => UserProfilesCompanion(id: id, birthDate: birthDate, sex: sex),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String birthDate,
                required String sex,
              }) => UserProfilesCompanion.insert(
                id: id,
                birthDate: birthDate,
                sex: sex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String key,
  required String name,
  required String loadType,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> key,
  Value<String> name,
  Value<String> loadType,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanSlotsTable, List<PlanSlot>>
  _planSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planSlots,
    aliasName: 'exercises__id__plan_slots__exercise_id',
  );

  $$PlanSlotsTableProcessedTableManager get planSlotsRefs {
    final manager = $$PlanSlotsTableTableManager(
      $_db,
      $_db.planSlots,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_planSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'exercises__id__session_exercises__exercise_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loadType => $composableBuilder(
    column: $table.loadType,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> planSlotsRefs(
    Expression<bool> Function($$PlanSlotsTableFilterComposer f) f,
  ) {
    final $$PlanSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planSlots,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanSlotsTableFilterComposer(
            $db: $db,
            $table: $db.planSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadType => $composableBuilder(
    column: $table.loadType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get loadType =>
      $composableBuilder(column: $table.loadType, builder: (column) => column);

  Expression<T> planSlotsRefs<T extends Object>(
    Expression<T> Function($$PlanSlotsTableAnnotationComposer a) f,
  ) {
    final $$PlanSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planSlots,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.planSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool planSlotsRefs,
            bool sessionExercisesRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> loadType = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                key: key,
                name: name,
                loadType: loadType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String name,
                required String loadType,
              }) => ExercisesCompanion.insert(
                id: id,
                key: key,
                name: name,
                loadType: loadType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({planSlotsRefs = false, sessionExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (planSlotsRefs) db.planSlots,
                    if (sessionExercisesRefs) db.sessionExercises,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (planSlotsRefs)
                        await $_getPrefetchedDataByColumns<
                          Exercise,
                          $ExercisesTable,
                          PlanSlot,
                          $PlanSlotsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._planSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).planSlotsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'exercise_id',
                          typedResults: items,
                        ),
                      if (sessionExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          Exercise,
                          $ExercisesTable,
                          SessionExercise,
                          $SessionExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'exercise_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool planSlotsRefs, bool sessionExercisesRefs})
    >;
typedef $$PlanDaysTableCreateCompanionBuilder = PlanDaysCompanion Function({
  Value<int> id,
  required int weekday,
  required String name,
  required bool isRestDay,
});
typedef $$PlanDaysTableUpdateCompanionBuilder = PlanDaysCompanion Function({
  Value<int> id,
  Value<int> weekday,
  Value<String> name,
  Value<bool> isRestDay,
});

final class $$PlanDaysTableReferences
    extends BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDay> {
  $$PlanDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanSlotsTable, List<PlanSlot>>
  _planSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planSlots,
    aliasName: 'plan_days__id__plan_slots__plan_day_id',
  );

  $$PlanSlotsTableProcessedTableManager get planSlotsRefs {
    final manager = $$PlanSlotsTableTableManager(
      $_db,
      $_db.planSlots,
    ).filter((f) => f.planDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_planSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'plan_days__id__workout_sessions__plan_day_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.planDayId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRestDay => $composableBuilder(
    column: $table.isRestDay,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> planSlotsRefs(
    Expression<bool> Function($$PlanSlotsTableFilterComposer f) f,
  ) {
    final $$PlanSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planSlots,
      getReferencedColumn: (t) => t.planDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanSlotsTableFilterComposer(
            $db: $db,
            $table: $db.planSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.planDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRestDay => $composableBuilder(
    column: $table.isRestDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isRestDay =>
      $composableBuilder(column: $table.isRestDay, builder: (column) => column);

  Expression<T> planSlotsRefs<T extends Object>(
    Expression<T> Function($$PlanSlotsTableAnnotationComposer a) f,
  ) {
    final $$PlanSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planSlots,
      getReferencedColumn: (t) => t.planDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.planSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.planDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanDaysTable,
          PlanDay,
          $$PlanDaysTableFilterComposer,
          $$PlanDaysTableOrderingComposer,
          $$PlanDaysTableAnnotationComposer,
          $$PlanDaysTableCreateCompanionBuilder,
          $$PlanDaysTableUpdateCompanionBuilder,
          (PlanDay, $$PlanDaysTableReferences),
          PlanDay,
          PrefetchHooks Function({bool planSlotsRefs, bool workoutSessionsRefs})
        > {
  $$PlanDaysTableTableManager(_$AppDatabase db, $PlanDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isRestDay = const Value.absent(),
              }) => PlanDaysCompanion(
                id: id,
                weekday: weekday,
                name: name,
                isRestDay: isRestDay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weekday,
                required String name,
                required bool isRestDay,
              }) => PlanDaysCompanion.insert(
                id: id,
                weekday: weekday,
                name: name,
                isRestDay: isRestDay,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanDaysTable, PlanDay>(table),
                  $$PlanDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({planSlotsRefs = false, workoutSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (planSlotsRefs) db.planSlots,
                    if (workoutSessionsRefs) db.workoutSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (planSlotsRefs)
                        await $_getPrefetchedDataByColumns<
                          PlanDay,
                          $PlanDaysTable,
                          PlanSlot,
                          $PlanSlotsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PlanDaysTableReferences
                              ._planSlotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlanDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).planSlotsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'plan_day_id',
                          typedResults: items,
                        ),
                      if (workoutSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          PlanDay,
                          $PlanDaysTable,
                          WorkoutSession,
                          $WorkoutSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PlanDaysTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlanDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'plan_day_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanDaysTable,
      PlanDay,
      $$PlanDaysTableFilterComposer,
      $$PlanDaysTableOrderingComposer,
      $$PlanDaysTableAnnotationComposer,
      $$PlanDaysTableCreateCompanionBuilder,
      $$PlanDaysTableUpdateCompanionBuilder,
      (PlanDay, $$PlanDaysTableReferences),
      PlanDay,
      PrefetchHooks Function({bool planSlotsRefs, bool workoutSessionsRefs})
    >;
typedef $$PlanSlotsTableCreateCompanionBuilder = PlanSlotsCompanion Function({
  Value<int> id,
  required int planDayId,
  required int exerciseId,
  required int orderIdx,
  required int targetSets,
  required int repMin,
  required int repMax,
  Value<int?> rirMin,
  Value<int?> rirMax,
  required int progReps,
  required int progSets,
});
typedef $$PlanSlotsTableUpdateCompanionBuilder = PlanSlotsCompanion Function({
  Value<int> id,
  Value<int> planDayId,
  Value<int> exerciseId,
  Value<int> orderIdx,
  Value<int> targetSets,
  Value<int> repMin,
  Value<int> repMax,
  Value<int?> rirMin,
  Value<int?> rirMax,
  Value<int> progReps,
  Value<int> progSets,
});

final class $$PlanSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $PlanSlotsTable, PlanSlot> {
  $$PlanSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlanDaysTable _planDayIdTable(_$AppDatabase db) =>
      db.planDays.createAlias('plan_slots__plan_day_id__plan_days__id');

  $$PlanDaysTableProcessedTableManager get planDayId {
    final $_column = $_itemColumn<int>('plan_day_id')!;

    final manager = $$PlanDaysTableTableManager(
      $_db,
      $_db.planDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('plan_slots__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'plan_slots__id__session_exercises__slot_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.slotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlanSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanSlotsTable> {
  $$PlanSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIdx => $composableBuilder(
    column: $table.orderIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rirMin => $composableBuilder(
    column: $table.rirMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rirMax => $composableBuilder(
    column: $table.rirMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progReps => $composableBuilder(
    column: $table.progReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progSets => $composableBuilder(
    column: $table.progSets,
    builder: (column) => ColumnFilters(column),
  );

  $$PlanDaysTableFilterComposer get planDayId {
    final $$PlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanSlotsTable> {
  $$PlanSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIdx => $composableBuilder(
    column: $table.orderIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rirMin => $composableBuilder(
    column: $table.rirMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rirMax => $composableBuilder(
    column: $table.rirMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progReps => $composableBuilder(
    column: $table.progReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progSets => $composableBuilder(
    column: $table.progSets,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlanDaysTableOrderingComposer get planDayId {
    final $$PlanDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableOrderingComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanSlotsTable> {
  $$PlanSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIdx =>
      $composableBuilder(column: $table.orderIdx, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repMin =>
      $composableBuilder(column: $table.repMin, builder: (column) => column);

  GeneratedColumn<int> get repMax =>
      $composableBuilder(column: $table.repMax, builder: (column) => column);

  GeneratedColumn<int> get rirMin =>
      $composableBuilder(column: $table.rirMin, builder: (column) => column);

  GeneratedColumn<int> get rirMax =>
      $composableBuilder(column: $table.rirMax, builder: (column) => column);

  GeneratedColumn<int> get progReps =>
      $composableBuilder(column: $table.progReps, builder: (column) => column);

  GeneratedColumn<int> get progSets =>
      $composableBuilder(column: $table.progSets, builder: (column) => column);

  $$PlanDaysTableAnnotationComposer get planDayId {
    final $$PlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.slotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanSlotsTable,
          PlanSlot,
          $$PlanSlotsTableFilterComposer,
          $$PlanSlotsTableOrderingComposer,
          $$PlanSlotsTableAnnotationComposer,
          $$PlanSlotsTableCreateCompanionBuilder,
          $$PlanSlotsTableUpdateCompanionBuilder,
          (PlanSlot, $$PlanSlotsTableReferences),
          PlanSlot,
          PrefetchHooks Function({
            bool planDayId,
            bool exerciseId,
            bool sessionExercisesRefs,
          })
        > {
  $$PlanSlotsTableTableManager(_$AppDatabase db, $PlanSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planDayId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> orderIdx = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<int> repMin = const Value.absent(),
                Value<int> repMax = const Value.absent(),
                Value<int?> rirMin = const Value.absent(),
                Value<int?> rirMax = const Value.absent(),
                Value<int> progReps = const Value.absent(),
                Value<int> progSets = const Value.absent(),
              }) => PlanSlotsCompanion(
                id: id,
                planDayId: planDayId,
                exerciseId: exerciseId,
                orderIdx: orderIdx,
                targetSets: targetSets,
                repMin: repMin,
                repMax: repMax,
                rirMin: rirMin,
                rirMax: rirMax,
                progReps: progReps,
                progSets: progSets,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planDayId,
                required int exerciseId,
                required int orderIdx,
                required int targetSets,
                required int repMin,
                required int repMax,
                Value<int?> rirMin = const Value.absent(),
                Value<int?> rirMax = const Value.absent(),
                required int progReps,
                required int progSets,
              }) => PlanSlotsCompanion.insert(
                id: id,
                planDayId: planDayId,
                exerciseId: exerciseId,
                orderIdx: orderIdx,
                targetSets: targetSets,
                repMin: repMin,
                repMax: repMax,
                rirMin: rirMin,
                rirMax: rirMax,
                progReps: progReps,
                progSets: progSets,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanSlotsTable, PlanSlot>(table),
                  $$PlanSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                planDayId = false,
                exerciseId = false,
                sessionExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionExercisesRefs) db.sessionExercises,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (planDayId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.planDayId,
                            referencedTable: $$PlanSlotsTableReferences
                                ._planDayIdTable(db),
                            referencedColumn: $$PlanSlotsTableReferences
                                ._planDayIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$PlanSlotsTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$PlanSlotsTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          PlanSlot,
                          $PlanSlotsTable,
                          SessionExercise,
                          $SessionExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$PlanSlotsTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlanSlotsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'slot_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlanSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanSlotsTable,
      PlanSlot,
      $$PlanSlotsTableFilterComposer,
      $$PlanSlotsTableOrderingComposer,
      $$PlanSlotsTableAnnotationComposer,
      $$PlanSlotsTableCreateCompanionBuilder,
      $$PlanSlotsTableUpdateCompanionBuilder,
      (PlanSlot, $$PlanSlotsTableReferences),
      PlanSlot,
      PrefetchHooks Function({
        bool planDayId,
        bool exerciseId,
        bool sessionExercisesRefs,
      })
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      required int planDayId,
      required String plannedDate,
      Value<String?> performedDate,
      required String status,
      Value<String?> note,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      Value<int> planDayId,
      Value<String> plannedDate,
      Value<String?> performedDate,
      Value<String> status,
      Value<String?> note,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlanDaysTable _planDayIdTable(_$AppDatabase db) =>
      db.planDays.createAlias('workout_sessions__plan_day_id__plan_days__id');

  $$PlanDaysTableProcessedTableManager get planDayId {
    final $_column = $_itemColumn<int>('plan_day_id')!;

    final manager = $$PlanDaysTableTableManager(
      $_db,
      $_db.planDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'workout_sessions__id__session_exercises__session_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plannedDate => $composableBuilder(
    column: $table.plannedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get performedDate => $composableBuilder(
    column: $table.performedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PlanDaysTableFilterComposer get planDayId {
    final $$PlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plannedDate => $composableBuilder(
    column: $table.plannedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performedDate => $composableBuilder(
    column: $table.performedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlanDaysTableOrderingComposer get planDayId {
    final $$PlanDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableOrderingComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get plannedDate => $composableBuilder(
    column: $table.plannedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get performedDate => $composableBuilder(
    column: $table.performedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PlanDaysTableAnnotationComposer get planDayId {
    final $$PlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planDayId,
      referencedTable: $db.planDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.planDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({bool planDayId, bool sessionExercisesRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planDayId = const Value.absent(),
                Value<String> plannedDate = const Value.absent(),
                Value<String?> performedDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                planDayId: planDayId,
                plannedDate: plannedDate,
                performedDate: performedDate,
                status: status,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planDayId,
                required String plannedDate,
                Value<String?> performedDate = const Value.absent(),
                required String status,
                Value<String?> note = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                planDayId: planDayId,
                plannedDate: plannedDate,
                performedDate: performedDate,
                status: status,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({planDayId = false, sessionExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionExercisesRefs) db.sessionExercises,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (planDayId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.planDayId,
                            referencedTable: $$WorkoutSessionsTableReferences
                                ._planDayIdTable(db),
                            referencedColumn: $$WorkoutSessionsTableReferences
                                ._planDayIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          SessionExercise,
                          $SessionExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({bool planDayId, bool sessionExercisesRefs})
    >;
typedef $$SessionExercisesTableCreateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<int> id,
      required int sessionId,
      required int slotId,
      required int exerciseId,
      required double topWeight,
      required double e1rmBest,
      required double volume,
      Value<double?> bodyweightKg,
      required String progressionResult,
      required String progressionMessage,
    });
typedef $$SessionExercisesTableUpdateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> slotId,
      Value<int> exerciseId,
      Value<double> topWeight,
      Value<double> e1rmBest,
      Value<double> volume,
      Value<double?> bodyweightKg,
      Value<String> progressionResult,
      Value<String> progressionMessage,
    });

final class $$SessionExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SessionExercisesTable, SessionExercise> {
  $$SessionExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('session_exercises__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlanSlotsTable _slotIdTable(_$AppDatabase db) =>
      db.planSlots.createAlias('session_exercises__slot_id__plan_slots__id');

  $$PlanSlotsTableProcessedTableManager get slotId {
    final $_column = $_itemColumn<int>('slot_id')!;

    final manager = $$PlanSlotsTableTableManager(
      $_db,
      $_db.planSlots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_slotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('session_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'session_exercises__id__set_logs__session_exercise_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topWeight => $composableBuilder(
    column: $table.topWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get e1rmBest => $composableBuilder(
    column: $table.e1rmBest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyweightKg => $composableBuilder(
    column: $table.bodyweightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressionResult => $composableBuilder(
    column: $table.progressionResult,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressionMessage => $composableBuilder(
    column: $table.progressionMessage,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanSlotsTableFilterComposer get slotId {
    final $$PlanSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.planSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanSlotsTableFilterComposer(
            $db: $db,
            $table: $db.planSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topWeight => $composableBuilder(
    column: $table.topWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get e1rmBest => $composableBuilder(
    column: $table.e1rmBest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyweightKg => $composableBuilder(
    column: $table.bodyweightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressionResult => $composableBuilder(
    column: $table.progressionResult,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressionMessage => $composableBuilder(
    column: $table.progressionMessage,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanSlotsTableOrderingComposer get slotId {
    final $$PlanSlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.planSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanSlotsTableOrderingComposer(
            $db: $db,
            $table: $db.planSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get topWeight =>
      $composableBuilder(column: $table.topWeight, builder: (column) => column);

  GeneratedColumn<double> get e1rmBest =>
      $composableBuilder(column: $table.e1rmBest, builder: (column) => column);

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<double> get bodyweightKg => $composableBuilder(
    column: $table.bodyweightKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get progressionResult => $composableBuilder(
    column: $table.progressionResult,
    builder: (column) => column,
  );

  GeneratedColumn<String> get progressionMessage => $composableBuilder(
    column: $table.progressionMessage,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanSlotsTableAnnotationComposer get slotId {
    final $$PlanSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.slotId,
      referencedTable: $db.planSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.planSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionExercisesTable,
          SessionExercise,
          $$SessionExercisesTableFilterComposer,
          $$SessionExercisesTableOrderingComposer,
          $$SessionExercisesTableAnnotationComposer,
          $$SessionExercisesTableCreateCompanionBuilder,
          $$SessionExercisesTableUpdateCompanionBuilder,
          (SessionExercise, $$SessionExercisesTableReferences),
          SessionExercise,
          PrefetchHooks Function({
            bool sessionId,
            bool slotId,
            bool exerciseId,
            bool setLogsRefs,
          })
        > {
  $$SessionExercisesTableTableManager(
    _$AppDatabase db,
    $SessionExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> slotId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<double> topWeight = const Value.absent(),
                Value<double> e1rmBest = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<double?> bodyweightKg = const Value.absent(),
                Value<String> progressionResult = const Value.absent(),
                Value<String> progressionMessage = const Value.absent(),
              }) => SessionExercisesCompanion(
                id: id,
                sessionId: sessionId,
                slotId: slotId,
                exerciseId: exerciseId,
                topWeight: topWeight,
                e1rmBest: e1rmBest,
                volume: volume,
                bodyweightKg: bodyweightKg,
                progressionResult: progressionResult,
                progressionMessage: progressionMessage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int slotId,
                required int exerciseId,
                required double topWeight,
                required double e1rmBest,
                required double volume,
                Value<double?> bodyweightKg = const Value.absent(),
                required String progressionResult,
                required String progressionMessage,
              }) => SessionExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                slotId: slotId,
                exerciseId: exerciseId,
                topWeight: topWeight,
                e1rmBest: e1rmBest,
                volume: volume,
                bodyweightKg: bodyweightKg,
                progressionResult: progressionResult,
                progressionMessage: progressionMessage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionExercisesTable, SessionExercise>(table),
                  $$SessionExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionId = false,
                slotId = false,
                exerciseId = false,
                setLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (slotId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.slotId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._slotIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._slotIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (setLogsRefs)
                        await $_getPrefetchedDataByColumns<
                          SessionExercise,
                          $SessionExercisesTable,
                          SetLog,
                          $SetLogsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SessionExercisesTableReferences
                              ._setLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).setLogsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_exercise_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionExercisesTable,
      SessionExercise,
      $$SessionExercisesTableFilterComposer,
      $$SessionExercisesTableOrderingComposer,
      $$SessionExercisesTableAnnotationComposer,
      $$SessionExercisesTableCreateCompanionBuilder,
      $$SessionExercisesTableUpdateCompanionBuilder,
      (SessionExercise, $$SessionExercisesTableReferences),
      SessionExercise,
      PrefetchHooks Function({
        bool sessionId,
        bool slotId,
        bool exerciseId,
        bool setLogsRefs,
      })
    >;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  required int sessionExerciseId,
  required int setNo,
  required int reps,
  required double weight,
  Value<int?> rir,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<int> id,
  Value<int> sessionExerciseId,
  Value<int> setNo,
  Value<int> reps,
  Value<double> weight,
  Value<int?> rir,
});

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLog> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionExercisesTable _sessionExerciseIdTable(_$AppDatabase db) => db
      .sessionExercises
      .createAlias('set_logs__session_exercise_id__session_exercises__id');

  $$SessionExercisesTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<int>('session_exercise_id')!;

    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNo => $composableBuilder(
    column: $table.setNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionExercisesTableFilterComposer get sessionExerciseId {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNo => $composableBuilder(
    column: $table.setNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionExercisesTableOrderingComposer get sessionExerciseId {
    final $$SessionExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNo =>
      $composableBuilder(column: $table.setNo, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  $$SessionExercisesTableAnnotationComposer get sessionExerciseId {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLog,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLog, $$SetLogsTableReferences),
          SetLog,
          PrefetchHooks Function({bool sessionExerciseId})
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionExerciseId = const Value.absent(),
                Value<int> setNo = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int?> rir = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                sessionExerciseId: sessionExerciseId,
                setNo: setNo,
                reps: reps,
                weight: weight,
                rir: rir,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionExerciseId,
                required int setNo,
                required int reps,
                required double weight,
                Value<int?> rir = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                sessionExerciseId: sessionExerciseId,
                setNo: setNo,
                reps: reps,
                weight: weight,
                rir: rir,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SetLogsTable, SetLog>(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (sessionExerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionExerciseId,
                        referencedTable: $$SetLogsTableReferences
                            ._sessionExerciseIdTable(db),
                        referencedColumn: $$SetLogsTableReferences
                            ._sessionExerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLog,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLog, $$SetLogsTableReferences),
      SetLog,
      PrefetchHooks Function({bool sessionExerciseId})
    >;
typedef $$BodyWeightEntriesTableCreateCompanionBuilder =
    BodyWeightEntriesCompanion Function({
      Value<int> id,
      required String date,
      required double weightKg,
      required int measuredAtMs,
    });
typedef $$BodyWeightEntriesTableUpdateCompanionBuilder =
    BodyWeightEntriesCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<double> weightKg,
      Value<int> measuredAtMs,
    });

class $$BodyWeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get measuredAtMs => $composableBuilder(
    column: $table.measuredAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyWeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get measuredAtMs => $composableBuilder(
    column: $table.measuredAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyWeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get measuredAtMs => $composableBuilder(
    column: $table.measuredAtMs,
    builder: (column) => column,
  );
}

class $$BodyWeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyWeightEntriesTable,
          BodyWeightEntry,
          $$BodyWeightEntriesTableFilterComposer,
          $$BodyWeightEntriesTableOrderingComposer,
          $$BodyWeightEntriesTableAnnotationComposer,
          $$BodyWeightEntriesTableCreateCompanionBuilder,
          $$BodyWeightEntriesTableUpdateCompanionBuilder,
          (
            BodyWeightEntry,
            BaseReferences<
              _$AppDatabase,
              $BodyWeightEntriesTable,
              BodyWeightEntry
            >,
          ),
          BodyWeightEntry,
          PrefetchHooks Function()
        > {
  $$BodyWeightEntriesTableTableManager(
    _$AppDatabase db,
    $BodyWeightEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyWeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyWeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyWeightEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> measuredAtMs = const Value.absent(),
              }) => BodyWeightEntriesCompanion(
                id: id,
                date: date,
                weightKg: weightKg,
                measuredAtMs: measuredAtMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required double weightKg,
                required int measuredAtMs,
              }) => BodyWeightEntriesCompanion.insert(
                id: id,
                date: date,
                weightKg: weightKg,
                measuredAtMs: measuredAtMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyWeightEntriesTable, BodyWeightEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BodyWeightEntriesTable,
                    BodyWeightEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyWeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyWeightEntriesTable,
      BodyWeightEntry,
      $$BodyWeightEntriesTableFilterComposer,
      $$BodyWeightEntriesTableOrderingComposer,
      $$BodyWeightEntriesTableAnnotationComposer,
      $$BodyWeightEntriesTableCreateCompanionBuilder,
      $$BodyWeightEntriesTableUpdateCompanionBuilder,
      (
        BodyWeightEntry,
        BaseReferences<_$AppDatabase, $BodyWeightEntriesTable, BodyWeightEntry>,
      ),
      BodyWeightEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$PlanDaysTableTableManager get planDays =>
      $$PlanDaysTableTableManager(_db, _db.planDays);
  $$PlanSlotsTableTableManager get planSlots =>
      $$PlanSlotsTableTableManager(_db, _db.planSlots);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(_db, _db.sessionExercises);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$BodyWeightEntriesTableTableManager get bodyWeightEntries =>
      $$BodyWeightEntriesTableTableManager(_db, _db.bodyWeightEntries);
}
