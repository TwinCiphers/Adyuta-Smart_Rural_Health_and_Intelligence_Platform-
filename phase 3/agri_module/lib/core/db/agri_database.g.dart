// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agri_database.dart';

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

class $MandiPricesTable extends MandiPrices
    with TableInfo<$MandiPricesTable, MandiPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MandiPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _districtMeta =
      const VerificationMeta('district');
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
      'district', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketMeta = const VerificationMeta('market');
  @override
  late final GeneratedColumn<String> market = GeneratedColumn<String>(
      'market', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commodityMeta =
      const VerificationMeta('commodity');
  @override
  late final GeneratedColumn<String> commodity = GeneratedColumn<String>(
      'commodity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _varietyMeta =
      const VerificationMeta('variety');
  @override
  late final GeneratedColumn<String> variety = GeneratedColumn<String>(
      'variety', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _minPriceMeta =
      const VerificationMeta('minPrice');
  @override
  late final GeneratedColumn<double> minPrice = GeneratedColumn<double>(
      'min_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _maxPriceMeta =
      const VerificationMeta('maxPrice');
  @override
  late final GeneratedColumn<double> maxPrice = GeneratedColumn<double>(
      'max_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _modalPriceMeta =
      const VerificationMeta('modalPrice');
  @override
  late final GeneratedColumn<double> modalPrice = GeneratedColumn<double>(
      'modal_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceUnitMeta =
      const VerificationMeta('priceUnit');
  @override
  late final GeneratedColumn<String> priceUnit = GeneratedColumn<String>(
      'price_unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('per Qtl'));
  static const VerificationMeta _observedAtMeta =
      const VerificationMeta('observedAt');
  @override
  late final GeneratedColumn<int> observedAt = GeneratedColumn<int>(
      'observed_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ingestedAtMeta =
      const VerificationMeta('ingestedAt');
  @override
  late final GeneratedColumn<int> ingestedAt = GeneratedColumn<int>(
      'ingested_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Agmarknet'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        state,
        district,
        market,
        commodity,
        variety,
        minPrice,
        maxPrice,
        modalPrice,
        priceUnit,
        observedAt,
        ingestedAt,
        source
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mandi_prices';
  @override
  VerificationContext validateIntegrity(Insertable<MandiPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('district')) {
      context.handle(_districtMeta,
          district.isAcceptableOrUnknown(data['district']!, _districtMeta));
    } else if (isInserting) {
      context.missing(_districtMeta);
    }
    if (data.containsKey('market')) {
      context.handle(_marketMeta,
          market.isAcceptableOrUnknown(data['market']!, _marketMeta));
    } else if (isInserting) {
      context.missing(_marketMeta);
    }
    if (data.containsKey('commodity')) {
      context.handle(_commodityMeta,
          commodity.isAcceptableOrUnknown(data['commodity']!, _commodityMeta));
    } else if (isInserting) {
      context.missing(_commodityMeta);
    }
    if (data.containsKey('variety')) {
      context.handle(_varietyMeta,
          variety.isAcceptableOrUnknown(data['variety']!, _varietyMeta));
    }
    if (data.containsKey('min_price')) {
      context.handle(_minPriceMeta,
          minPrice.isAcceptableOrUnknown(data['min_price']!, _minPriceMeta));
    }
    if (data.containsKey('max_price')) {
      context.handle(_maxPriceMeta,
          maxPrice.isAcceptableOrUnknown(data['max_price']!, _maxPriceMeta));
    }
    if (data.containsKey('modal_price')) {
      context.handle(
          _modalPriceMeta,
          modalPrice.isAcceptableOrUnknown(
              data['modal_price']!, _modalPriceMeta));
    } else if (isInserting) {
      context.missing(_modalPriceMeta);
    }
    if (data.containsKey('price_unit')) {
      context.handle(_priceUnitMeta,
          priceUnit.isAcceptableOrUnknown(data['price_unit']!, _priceUnitMeta));
    }
    if (data.containsKey('observed_at')) {
      context.handle(
          _observedAtMeta,
          observedAt.isAcceptableOrUnknown(
              data['observed_at']!, _observedAtMeta));
    } else if (isInserting) {
      context.missing(_observedAtMeta);
    }
    if (data.containsKey('ingested_at')) {
      context.handle(
          _ingestedAtMeta,
          ingestedAt.isAcceptableOrUnknown(
              data['ingested_at']!, _ingestedAtMeta));
    } else if (isInserting) {
      context.missing(_ingestedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MandiPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MandiPrice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      district: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}district'])!,
      market: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market'])!,
      commodity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}commodity'])!,
      variety: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variety'])!,
      minPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_price'])!,
      maxPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_price'])!,
      modalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}modal_price'])!,
      priceUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_unit'])!,
      observedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}observed_at'])!,
      ingestedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingested_at'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
    );
  }

  @override
  $MandiPricesTable createAlias(String alias) {
    return $MandiPricesTable(attachedDatabase, alias);
  }
}

class MandiPrice extends DataClass implements Insertable<MandiPrice> {
  final int id;
  final String state;
  final String district;
  final String market;
  final String commodity;
  final String variety;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final String priceUnit;

  /// Unix milliseconds – when the price was reported at the mandi.
  final int observedAt;

  /// Unix milliseconds – when this row was written to local DB.
  final int ingestedAt;
  final String source;
  const MandiPrice(
      {required this.id,
      required this.state,
      required this.district,
      required this.market,
      required this.commodity,
      required this.variety,
      required this.minPrice,
      required this.maxPrice,
      required this.modalPrice,
      required this.priceUnit,
      required this.observedAt,
      required this.ingestedAt,
      required this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['state'] = Variable<String>(state);
    map['district'] = Variable<String>(district);
    map['market'] = Variable<String>(market);
    map['commodity'] = Variable<String>(commodity);
    map['variety'] = Variable<String>(variety);
    map['min_price'] = Variable<double>(minPrice);
    map['max_price'] = Variable<double>(maxPrice);
    map['modal_price'] = Variable<double>(modalPrice);
    map['price_unit'] = Variable<String>(priceUnit);
    map['observed_at'] = Variable<int>(observedAt);
    map['ingested_at'] = Variable<int>(ingestedAt);
    map['source'] = Variable<String>(source);
    return map;
  }

  MandiPricesCompanion toCompanion(bool nullToAbsent) {
    return MandiPricesCompanion(
      id: Value(id),
      state: Value(state),
      district: Value(district),
      market: Value(market),
      commodity: Value(commodity),
      variety: Value(variety),
      minPrice: Value(minPrice),
      maxPrice: Value(maxPrice),
      modalPrice: Value(modalPrice),
      priceUnit: Value(priceUnit),
      observedAt: Value(observedAt),
      ingestedAt: Value(ingestedAt),
      source: Value(source),
    );
  }

  factory MandiPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MandiPrice(
      id: serializer.fromJson<int>(json['id']),
      state: serializer.fromJson<String>(json['state']),
      district: serializer.fromJson<String>(json['district']),
      market: serializer.fromJson<String>(json['market']),
      commodity: serializer.fromJson<String>(json['commodity']),
      variety: serializer.fromJson<String>(json['variety']),
      minPrice: serializer.fromJson<double>(json['minPrice']),
      maxPrice: serializer.fromJson<double>(json['maxPrice']),
      modalPrice: serializer.fromJson<double>(json['modalPrice']),
      priceUnit: serializer.fromJson<String>(json['priceUnit']),
      observedAt: serializer.fromJson<int>(json['observedAt']),
      ingestedAt: serializer.fromJson<int>(json['ingestedAt']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'state': serializer.toJson<String>(state),
      'district': serializer.toJson<String>(district),
      'market': serializer.toJson<String>(market),
      'commodity': serializer.toJson<String>(commodity),
      'variety': serializer.toJson<String>(variety),
      'minPrice': serializer.toJson<double>(minPrice),
      'maxPrice': serializer.toJson<double>(maxPrice),
      'modalPrice': serializer.toJson<double>(modalPrice),
      'priceUnit': serializer.toJson<String>(priceUnit),
      'observedAt': serializer.toJson<int>(observedAt),
      'ingestedAt': serializer.toJson<int>(ingestedAt),
      'source': serializer.toJson<String>(source),
    };
  }

  MandiPrice copyWith(
          {int? id,
          String? state,
          String? district,
          String? market,
          String? commodity,
          String? variety,
          double? minPrice,
          double? maxPrice,
          double? modalPrice,
          String? priceUnit,
          int? observedAt,
          int? ingestedAt,
          String? source}) =>
      MandiPrice(
        id: id ?? this.id,
        state: state ?? this.state,
        district: district ?? this.district,
        market: market ?? this.market,
        commodity: commodity ?? this.commodity,
        variety: variety ?? this.variety,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        modalPrice: modalPrice ?? this.modalPrice,
        priceUnit: priceUnit ?? this.priceUnit,
        observedAt: observedAt ?? this.observedAt,
        ingestedAt: ingestedAt ?? this.ingestedAt,
        source: source ?? this.source,
      );
  @override
  String toString() {
    return (StringBuffer('MandiPrice(')
          ..write('id: $id, ')
          ..write('state: $state, ')
          ..write('district: $district, ')
          ..write('market: $market, ')
          ..write('commodity: $commodity, ')
          ..write('variety: $variety, ')
          ..write('minPrice: $minPrice, ')
          ..write('maxPrice: $maxPrice, ')
          ..write('modalPrice: $modalPrice, ')
          ..write('priceUnit: $priceUnit, ')
          ..write('observedAt: $observedAt, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      state,
      district,
      market,
      commodity,
      variety,
      minPrice,
      maxPrice,
      modalPrice,
      priceUnit,
      observedAt,
      ingestedAt,
      source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MandiPrice &&
          other.id == this.id &&
          other.state == this.state &&
          other.district == this.district &&
          other.market == this.market &&
          other.commodity == this.commodity &&
          other.variety == this.variety &&
          other.minPrice == this.minPrice &&
          other.maxPrice == this.maxPrice &&
          other.modalPrice == this.modalPrice &&
          other.priceUnit == this.priceUnit &&
          other.observedAt == this.observedAt &&
          other.ingestedAt == this.ingestedAt &&
          other.source == this.source);
}

class MandiPricesCompanion extends UpdateCompanion<MandiPrice> {
  final Value<int> id;
  final Value<String> state;
  final Value<String> district;
  final Value<String> market;
  final Value<String> commodity;
  final Value<String> variety;
  final Value<double> minPrice;
  final Value<double> maxPrice;
  final Value<double> modalPrice;
  final Value<String> priceUnit;
  final Value<int> observedAt;
  final Value<int> ingestedAt;
  final Value<String> source;
  const MandiPricesCompanion({
    this.id = const Value.absent(),
    this.state = const Value.absent(),
    this.district = const Value.absent(),
    this.market = const Value.absent(),
    this.commodity = const Value.absent(),
    this.variety = const Value.absent(),
    this.minPrice = const Value.absent(),
    this.maxPrice = const Value.absent(),
    this.modalPrice = const Value.absent(),
    this.priceUnit = const Value.absent(),
    this.observedAt = const Value.absent(),
    this.ingestedAt = const Value.absent(),
    this.source = const Value.absent(),
  });
  MandiPricesCompanion.insert({
    this.id = const Value.absent(),
    required String state,
    required String district,
    required String market,
    required String commodity,
    this.variety = const Value.absent(),
    this.minPrice = const Value.absent(),
    this.maxPrice = const Value.absent(),
    required double modalPrice,
    this.priceUnit = const Value.absent(),
    required int observedAt,
    required int ingestedAt,
    this.source = const Value.absent(),
  })  : state = Value(state),
        district = Value(district),
        market = Value(market),
        commodity = Value(commodity),
        modalPrice = Value(modalPrice),
        observedAt = Value(observedAt),
        ingestedAt = Value(ingestedAt);
  static Insertable<MandiPrice> custom({
    Expression<int>? id,
    Expression<String>? state,
    Expression<String>? district,
    Expression<String>? market,
    Expression<String>? commodity,
    Expression<String>? variety,
    Expression<double>? minPrice,
    Expression<double>? maxPrice,
    Expression<double>? modalPrice,
    Expression<String>? priceUnit,
    Expression<int>? observedAt,
    Expression<int>? ingestedAt,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (state != null) 'state': state,
      if (district != null) 'district': district,
      if (market != null) 'market': market,
      if (commodity != null) 'commodity': commodity,
      if (variety != null) 'variety': variety,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (modalPrice != null) 'modal_price': modalPrice,
      if (priceUnit != null) 'price_unit': priceUnit,
      if (observedAt != null) 'observed_at': observedAt,
      if (ingestedAt != null) 'ingested_at': ingestedAt,
      if (source != null) 'source': source,
    });
  }

  MandiPricesCompanion copyWith(
      {Value<int>? id,
      Value<String>? state,
      Value<String>? district,
      Value<String>? market,
      Value<String>? commodity,
      Value<String>? variety,
      Value<double>? minPrice,
      Value<double>? maxPrice,
      Value<double>? modalPrice,
      Value<String>? priceUnit,
      Value<int>? observedAt,
      Value<int>? ingestedAt,
      Value<String>? source}) {
    return MandiPricesCompanion(
      id: id ?? this.id,
      state: state ?? this.state,
      district: district ?? this.district,
      market: market ?? this.market,
      commodity: commodity ?? this.commodity,
      variety: variety ?? this.variety,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      modalPrice: modalPrice ?? this.modalPrice,
      priceUnit: priceUnit ?? this.priceUnit,
      observedAt: observedAt ?? this.observedAt,
      ingestedAt: ingestedAt ?? this.ingestedAt,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (market.present) {
      map['market'] = Variable<String>(market.value);
    }
    if (commodity.present) {
      map['commodity'] = Variable<String>(commodity.value);
    }
    if (variety.present) {
      map['variety'] = Variable<String>(variety.value);
    }
    if (minPrice.present) {
      map['min_price'] = Variable<double>(minPrice.value);
    }
    if (maxPrice.present) {
      map['max_price'] = Variable<double>(maxPrice.value);
    }
    if (modalPrice.present) {
      map['modal_price'] = Variable<double>(modalPrice.value);
    }
    if (priceUnit.present) {
      map['price_unit'] = Variable<String>(priceUnit.value);
    }
    if (observedAt.present) {
      map['observed_at'] = Variable<int>(observedAt.value);
    }
    if (ingestedAt.present) {
      map['ingested_at'] = Variable<int>(ingestedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MandiPricesCompanion(')
          ..write('id: $id, ')
          ..write('state: $state, ')
          ..write('district: $district, ')
          ..write('market: $market, ')
          ..write('commodity: $commodity, ')
          ..write('variety: $variety, ')
          ..write('minPrice: $minPrice, ')
          ..write('maxPrice: $maxPrice, ')
          ..write('modalPrice: $modalPrice, ')
          ..write('priceUnit: $priceUnit, ')
          ..write('observedAt: $observedAt, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $WeatherCacheTable extends WeatherCache
    with TableInfo<$WeatherCacheTable, WeatherCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _responseJsonMeta =
      const VerificationMeta('responseJson');
  @override
  late final GeneratedColumn<String> responseJson = GeneratedColumn<String>(
      'response_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<int> fetchedAt = GeneratedColumn<int>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, latitude, longitude, locationName, responseJson, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_cache';
  @override
  VerificationContext validateIntegrity(Insertable<WeatherCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    } else if (isInserting) {
      context.missing(_locationNameMeta);
    }
    if (data.containsKey('response_json')) {
      context.handle(
          _responseJsonMeta,
          responseJson.isAcceptableOrUnknown(
              data['response_json']!, _responseJsonMeta));
    } else if (isInserting) {
      context.missing(_responseJsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeatherCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name'])!,
      responseJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}response_json'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $WeatherCacheTable createAlias(String alias) {
    return $WeatherCacheTable(attachedDatabase, alias);
  }
}

class WeatherCacheData extends DataClass
    implements Insertable<WeatherCacheData> {
  final int id;
  final double latitude;
  final double longitude;
  final String locationName;

  /// Complete JSON response body from Open-Meteo /v1/forecast.
  final String responseJson;

  /// Unix milliseconds – when this cache entry was fetched.
  final int fetchedAt;
  const WeatherCacheData(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.locationName,
      required this.responseJson,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['location_name'] = Variable<String>(locationName);
    map['response_json'] = Variable<String>(responseJson);
    map['fetched_at'] = Variable<int>(fetchedAt);
    return map;
  }

  WeatherCacheCompanion toCompanion(bool nullToAbsent) {
    return WeatherCacheCompanion(
      id: Value(id),
      latitude: Value(latitude),
      longitude: Value(longitude),
      locationName: Value(locationName),
      responseJson: Value(responseJson),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory WeatherCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherCacheData(
      id: serializer.fromJson<int>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      locationName: serializer.fromJson<String>(json['locationName']),
      responseJson: serializer.fromJson<String>(json['responseJson']),
      fetchedAt: serializer.fromJson<int>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'locationName': serializer.toJson<String>(locationName),
      'responseJson': serializer.toJson<String>(responseJson),
      'fetchedAt': serializer.toJson<int>(fetchedAt),
    };
  }

  WeatherCacheData copyWith(
          {int? id,
          double? latitude,
          double? longitude,
          String? locationName,
          String? responseJson,
          int? fetchedAt}) =>
      WeatherCacheData(
        id: id ?? this.id,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        locationName: locationName ?? this.locationName,
        responseJson: responseJson ?? this.responseJson,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  @override
  String toString() {
    return (StringBuffer('WeatherCacheData(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('responseJson: $responseJson, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, latitude, longitude, locationName, responseJson, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherCacheData &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.locationName == this.locationName &&
          other.responseJson == this.responseJson &&
          other.fetchedAt == this.fetchedAt);
}

class WeatherCacheCompanion extends UpdateCompanion<WeatherCacheData> {
  final Value<int> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> locationName;
  final Value<String> responseJson;
  final Value<int> fetchedAt;
  const WeatherCacheCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.locationName = const Value.absent(),
    this.responseJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  WeatherCacheCompanion.insert({
    this.id = const Value.absent(),
    required double latitude,
    required double longitude,
    required String locationName,
    required String responseJson,
    required int fetchedAt,
  })  : latitude = Value(latitude),
        longitude = Value(longitude),
        locationName = Value(locationName),
        responseJson = Value(responseJson),
        fetchedAt = Value(fetchedAt);
  static Insertable<WeatherCacheData> custom({
    Expression<int>? id,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? locationName,
    Expression<String>? responseJson,
    Expression<int>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationName != null) 'location_name': locationName,
      if (responseJson != null) 'response_json': responseJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  WeatherCacheCompanion copyWith(
      {Value<int>? id,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String>? locationName,
      Value<String>? responseJson,
      Value<int>? fetchedAt}) {
    return WeatherCacheCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      responseJson: responseJson ?? this.responseJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (responseJson.present) {
      map['response_json'] = Variable<String>(responseJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<int>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherCacheCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('responseJson: $responseJson, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AgriDatabase extends GeneratedDatabase {
  _$AgriDatabase(QueryExecutor e) : super(e);
  late final $ExampleTableTable exampleTable = $ExampleTableTable(this);
  late final $MandiPricesTable mandiPrices = $MandiPricesTable(this);
  late final $WeatherCacheTable weatherCache = $WeatherCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [exampleTable, mandiPrices, weatherCache];
}
