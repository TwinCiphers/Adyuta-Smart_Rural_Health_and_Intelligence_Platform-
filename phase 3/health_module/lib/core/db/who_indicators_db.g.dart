// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'who_indicators_db.dart';

// ignore_for_file: type=lint
class $WhoIndicatorTable extends WhoIndicator
    with TableInfo<$WhoIndicatorTable, WhoIndicatorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WhoIndicatorTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _indicatorCodeMeta =
      const VerificationMeta('indicatorCode');
  @override
  late final GeneratedColumn<String> indicatorCode = GeneratedColumn<String>(
      'indicator_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _indicatorNameMeta =
      const VerificationMeta('indicatorName');
  @override
  late final GeneratedColumn<String> indicatorName = GeneratedColumn<String>(
      'indicator_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ingestedAtMeta =
      const VerificationMeta('ingestedAt');
  @override
  late final GeneratedColumn<int> ingestedAt = GeneratedColumn<int>(
      'ingested_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, indicatorCode, indicatorName, value, unit, year, ingestedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'who_indicator';
  @override
  VerificationContext validateIntegrity(Insertable<WhoIndicatorData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('indicator_code')) {
      context.handle(
          _indicatorCodeMeta,
          indicatorCode.isAcceptableOrUnknown(
              data['indicator_code']!, _indicatorCodeMeta));
    } else if (isInserting) {
      context.missing(_indicatorCodeMeta);
    }
    if (data.containsKey('indicator_name')) {
      context.handle(
          _indicatorNameMeta,
          indicatorName.isAcceptableOrUnknown(
              data['indicator_name']!, _indicatorNameMeta));
    } else if (isInserting) {
      context.missing(_indicatorNameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('ingested_at')) {
      context.handle(
          _ingestedAtMeta,
          ingestedAt.isAcceptableOrUnknown(
              data['ingested_at']!, _ingestedAtMeta));
    } else if (isInserting) {
      context.missing(_ingestedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WhoIndicatorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WhoIndicatorData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      indicatorCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}indicator_code'])!,
      indicatorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}indicator_name'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      ingestedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingested_at'])!,
    );
  }

  @override
  $WhoIndicatorTable createAlias(String alias) {
    return $WhoIndicatorTable(attachedDatabase, alias);
  }
}

class WhoIndicatorData extends DataClass
    implements Insertable<WhoIndicatorData> {
  final int id;
  final String indicatorCode;
  final String indicatorName;
  final double value;
  final String unit;
  final int year;
  final int ingestedAt;
  const WhoIndicatorData(
      {required this.id,
      required this.indicatorCode,
      required this.indicatorName,
      required this.value,
      required this.unit,
      required this.year,
      required this.ingestedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['indicator_code'] = Variable<String>(indicatorCode);
    map['indicator_name'] = Variable<String>(indicatorName);
    map['value'] = Variable<double>(value);
    map['unit'] = Variable<String>(unit);
    map['year'] = Variable<int>(year);
    map['ingested_at'] = Variable<int>(ingestedAt);
    return map;
  }

  WhoIndicatorCompanion toCompanion(bool nullToAbsent) {
    return WhoIndicatorCompanion(
      id: Value(id),
      indicatorCode: Value(indicatorCode),
      indicatorName: Value(indicatorName),
      value: Value(value),
      unit: Value(unit),
      year: Value(year),
      ingestedAt: Value(ingestedAt),
    );
  }

  factory WhoIndicatorData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WhoIndicatorData(
      id: serializer.fromJson<int>(json['id']),
      indicatorCode: serializer.fromJson<String>(json['indicatorCode']),
      indicatorName: serializer.fromJson<String>(json['indicatorName']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      year: serializer.fromJson<int>(json['year']),
      ingestedAt: serializer.fromJson<int>(json['ingestedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'indicatorCode': serializer.toJson<String>(indicatorCode),
      'indicatorName': serializer.toJson<String>(indicatorName),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'year': serializer.toJson<int>(year),
      'ingestedAt': serializer.toJson<int>(ingestedAt),
    };
  }

  WhoIndicatorData copyWith(
          {int? id,
          String? indicatorCode,
          String? indicatorName,
          double? value,
          String? unit,
          int? year,
          int? ingestedAt}) =>
      WhoIndicatorData(
        id: id ?? this.id,
        indicatorCode: indicatorCode ?? this.indicatorCode,
        indicatorName: indicatorName ?? this.indicatorName,
        value: value ?? this.value,
        unit: unit ?? this.unit,
        year: year ?? this.year,
        ingestedAt: ingestedAt ?? this.ingestedAt,
      );
  @override
  String toString() {
    return (StringBuffer('WhoIndicatorData(')
          ..write('id: $id, ')
          ..write('indicatorCode: $indicatorCode, ')
          ..write('indicatorName: $indicatorName, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('year: $year, ')
          ..write('ingestedAt: $ingestedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, indicatorCode, indicatorName, value, unit, year, ingestedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhoIndicatorData &&
          other.id == this.id &&
          other.indicatorCode == this.indicatorCode &&
          other.indicatorName == this.indicatorName &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.year == this.year &&
          other.ingestedAt == this.ingestedAt);
}

class WhoIndicatorCompanion extends UpdateCompanion<WhoIndicatorData> {
  final Value<int> id;
  final Value<String> indicatorCode;
  final Value<String> indicatorName;
  final Value<double> value;
  final Value<String> unit;
  final Value<int> year;
  final Value<int> ingestedAt;
  const WhoIndicatorCompanion({
    this.id = const Value.absent(),
    this.indicatorCode = const Value.absent(),
    this.indicatorName = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.year = const Value.absent(),
    this.ingestedAt = const Value.absent(),
  });
  WhoIndicatorCompanion.insert({
    this.id = const Value.absent(),
    required String indicatorCode,
    required String indicatorName,
    required double value,
    required String unit,
    required int year,
    required int ingestedAt,
  })  : indicatorCode = Value(indicatorCode),
        indicatorName = Value(indicatorName),
        value = Value(value),
        unit = Value(unit),
        year = Value(year),
        ingestedAt = Value(ingestedAt);
  static Insertable<WhoIndicatorData> custom({
    Expression<int>? id,
    Expression<String>? indicatorCode,
    Expression<String>? indicatorName,
    Expression<double>? value,
    Expression<String>? unit,
    Expression<int>? year,
    Expression<int>? ingestedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (indicatorCode != null) 'indicator_code': indicatorCode,
      if (indicatorName != null) 'indicator_name': indicatorName,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (year != null) 'year': year,
      if (ingestedAt != null) 'ingested_at': ingestedAt,
    });
  }

  WhoIndicatorCompanion copyWith(
      {Value<int>? id,
      Value<String>? indicatorCode,
      Value<String>? indicatorName,
      Value<double>? value,
      Value<String>? unit,
      Value<int>? year,
      Value<int>? ingestedAt}) {
    return WhoIndicatorCompanion(
      id: id ?? this.id,
      indicatorCode: indicatorCode ?? this.indicatorCode,
      indicatorName: indicatorName ?? this.indicatorName,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      year: year ?? this.year,
      ingestedAt: ingestedAt ?? this.ingestedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (indicatorCode.present) {
      map['indicator_code'] = Variable<String>(indicatorCode.value);
    }
    if (indicatorName.present) {
      map['indicator_name'] = Variable<String>(indicatorName.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (ingestedAt.present) {
      map['ingested_at'] = Variable<int>(ingestedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WhoIndicatorCompanion(')
          ..write('id: $id, ')
          ..write('indicatorCode: $indicatorCode, ')
          ..write('indicatorName: $indicatorName, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('year: $year, ')
          ..write('ingestedAt: $ingestedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$WhoIndicatorsDatabase extends GeneratedDatabase {
  _$WhoIndicatorsDatabase(QueryExecutor e) : super(e);
  late final $WhoIndicatorTable whoIndicator = $WhoIndicatorTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [whoIndicator];
}
