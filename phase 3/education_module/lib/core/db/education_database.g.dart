// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_database.dart';

// ignore_for_file: type=lint
class $ExampleTableTable extends ExampleTable
    with TableInfo<$ExampleTableTable, ExampleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExampleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('pending'))
          .withConverter<SyncStatus>($ExampleTableTable.$convertersyncStatus);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>('last_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, data, syncStatus, lastUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'example_table';
  @override
  VerificationContext validateIntegrity(Insertable<ExampleTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExampleTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExampleTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      syncStatus: $ExampleTableTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      lastUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_updated_at'])!,
    );
  }

  @override
  $ExampleTableTable createAlias(String alias) {
    return $ExampleTableTable(attachedDatabase, alias);
  }

  static TypeConverter<SyncStatus, String> $convertersyncStatus =
      const SyncStatusConverter();
}

class ExampleTableData extends DataClass
    implements Insertable<ExampleTableData> {
  final int id;
  final String data;
  final SyncStatus syncStatus;
  final DateTime lastUpdatedAt;
  const ExampleTableData(
      {required this.id,
      required this.data,
      required this.syncStatus,
      required this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data'] = Variable<String>(data);
    {
      map['sync_status'] = Variable<String>(
          $ExampleTableTable.$convertersyncStatus.toSql(syncStatus));
    }
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    return map;
  }

  ExampleTableCompanion toCompanion(bool nullToAbsent) {
    return ExampleTableCompanion(
      id: Value(id),
      data: Value(data),
      syncStatus: Value(syncStatus),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory ExampleTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExampleTableData(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<String>(json['data']),
      syncStatus: serializer.fromJson<SyncStatus>(json['syncStatus']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<String>(data),
      'syncStatus': serializer.toJson<SyncStatus>(syncStatus),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
    };
  }

  ExampleTableData copyWith(
          {int? id,
          String? data,
          SyncStatus? syncStatus,
          DateTime? lastUpdatedAt}) =>
      ExampleTableData(
        id: id ?? this.id,
        data: data ?? this.data,
        syncStatus: syncStatus ?? this.syncStatus,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('ExampleTableData(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data, syncStatus, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExampleTableData &&
          other.id == this.id &&
          other.data == this.data &&
          other.syncStatus == this.syncStatus &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class ExampleTableCompanion extends UpdateCompanion<ExampleTableData> {
  final Value<int> id;
  final Value<String> data;
  final Value<SyncStatus> syncStatus;
  final Value<DateTime> lastUpdatedAt;
  const ExampleTableCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
  });
  ExampleTableCompanion.insert({
    this.id = const Value.absent(),
    required String data,
    this.syncStatus = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
  }) : data = Value(data);
  static Insertable<ExampleTableData> custom({
    Expression<int>? id,
    Expression<String>? data,
    Expression<String>? syncStatus,
    Expression<DateTime>? lastUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
    });
  }

  ExampleTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? data,
      Value<SyncStatus>? syncStatus,
      Value<DateTime>? lastUpdatedAt}) {
    return ExampleTableCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      syncStatus: syncStatus ?? this.syncStatus,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $ExampleTableTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExampleTableCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$EducationDatabase extends GeneratedDatabase {
  _$EducationDatabase(QueryExecutor e) : super(e);
  late final $ExampleTableTable exampleTable = $ExampleTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [exampleTable];
}
