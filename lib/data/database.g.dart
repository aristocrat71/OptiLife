// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AppStateTable extends AppState
    with TableInfo<$AppStateTable, AppStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lifetimeLeMeta = const VerificationMeta(
    'lifetimeLe',
  );
  @override
  late final GeneratedColumn<int> lifetimeLe = GeneratedColumn<int>(
    'lifetime_le',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentBiomeStartedAtMeta =
      const VerificationMeta('currentBiomeStartedAt');
  @override
  late final GeneratedColumn<DateTime> currentBiomeStartedAt =
      GeneratedColumn<DateTime>(
        'current_biome_started_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _biomesCompletedMeta = const VerificationMeta(
    'biomesCompleted',
  );
  @override
  late final GeneratedColumn<int> biomesCompleted = GeneratedColumn<int>(
    'biomes_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuestCategory?, String>
  pendingTreeCategory =
      GeneratedColumn<String>(
        'pending_tree_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<QuestCategory?>(
        $AppStateTable.$converterpendingTreeCategoryn,
      );
  static const VerificationMeta _lastRerollDateMeta = const VerificationMeta(
    'lastRerollDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastRerollDate =
      GeneratedColumn<DateTime>(
        'last_reroll_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lifetimeLe,
    currentBiomeStartedAt,
    biomesCompleted,
    pendingTreeCategory,
    lastRerollDate,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lifetime_le')) {
      context.handle(
        _lifetimeLeMeta,
        lifetimeLe.isAcceptableOrUnknown(data['lifetime_le']!, _lifetimeLeMeta),
      );
    }
    if (data.containsKey('current_biome_started_at')) {
      context.handle(
        _currentBiomeStartedAtMeta,
        currentBiomeStartedAt.isAcceptableOrUnknown(
          data['current_biome_started_at']!,
          _currentBiomeStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('biomes_completed')) {
      context.handle(
        _biomesCompletedMeta,
        biomesCompleted.isAcceptableOrUnknown(
          data['biomes_completed']!,
          _biomesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('last_reroll_date')) {
      context.handle(
        _lastRerollDateMeta,
        lastRerollDate.isAcceptableOrUnknown(
          data['last_reroll_date']!,
          _lastRerollDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lifetimeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lifetime_le'],
      )!,
      currentBiomeStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}current_biome_started_at'],
      )!,
      biomesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}biomes_completed'],
      )!,
      pendingTreeCategory: $AppStateTable.$converterpendingTreeCategoryn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}pending_tree_category'],
            ),
          ),
      lastRerollDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reroll_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $AppStateTable createAlias(String alias) {
    return $AppStateTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuestCategory, String, String>
  $converterpendingTreeCategory = const EnumNameConverter<QuestCategory>(
    QuestCategory.values,
  );
  static JsonTypeConverter2<QuestCategory?, String?, String?>
  $converterpendingTreeCategoryn = JsonTypeConverter2.asNullable(
    $converterpendingTreeCategory,
  );
}

class AppStateRow extends DataClass implements Insertable<AppStateRow> {
  final int id;
  final int lifetimeLe;
  final DateTime currentBiomeStartedAt;
  final int biomesCompleted;
  final QuestCategory? pendingTreeCategory;
  final DateTime? lastRerollDate;
  final DateTime createdAt;
  final DateTime lastModified;
  const AppStateRow({
    required this.id,
    required this.lifetimeLe,
    required this.currentBiomeStartedAt,
    required this.biomesCompleted,
    this.pendingTreeCategory,
    this.lastRerollDate,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lifetime_le'] = Variable<int>(lifetimeLe);
    map['current_biome_started_at'] = Variable<DateTime>(currentBiomeStartedAt);
    map['biomes_completed'] = Variable<int>(biomesCompleted);
    if (!nullToAbsent || pendingTreeCategory != null) {
      map['pending_tree_category'] = Variable<String>(
        $AppStateTable.$converterpendingTreeCategoryn.toSql(
          pendingTreeCategory,
        ),
      );
    }
    if (!nullToAbsent || lastRerollDate != null) {
      map['last_reroll_date'] = Variable<DateTime>(lastRerollDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  AppStateCompanion toCompanion(bool nullToAbsent) {
    return AppStateCompanion(
      id: Value(id),
      lifetimeLe: Value(lifetimeLe),
      currentBiomeStartedAt: Value(currentBiomeStartedAt),
      biomesCompleted: Value(biomesCompleted),
      pendingTreeCategory: pendingTreeCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingTreeCategory),
      lastRerollDate: lastRerollDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRerollDate),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory AppStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppStateRow(
      id: serializer.fromJson<int>(json['id']),
      lifetimeLe: serializer.fromJson<int>(json['lifetimeLe']),
      currentBiomeStartedAt: serializer.fromJson<DateTime>(
        json['currentBiomeStartedAt'],
      ),
      biomesCompleted: serializer.fromJson<int>(json['biomesCompleted']),
      pendingTreeCategory: $AppStateTable.$converterpendingTreeCategoryn
          .fromJson(serializer.fromJson<String?>(json['pendingTreeCategory'])),
      lastRerollDate: serializer.fromJson<DateTime?>(json['lastRerollDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lifetimeLe': serializer.toJson<int>(lifetimeLe),
      'currentBiomeStartedAt': serializer.toJson<DateTime>(
        currentBiomeStartedAt,
      ),
      'biomesCompleted': serializer.toJson<int>(biomesCompleted),
      'pendingTreeCategory': serializer.toJson<String?>(
        $AppStateTable.$converterpendingTreeCategoryn.toJson(
          pendingTreeCategory,
        ),
      ),
      'lastRerollDate': serializer.toJson<DateTime?>(lastRerollDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  AppStateRow copyWith({
    int? id,
    int? lifetimeLe,
    DateTime? currentBiomeStartedAt,
    int? biomesCompleted,
    Value<QuestCategory?> pendingTreeCategory = const Value.absent(),
    Value<DateTime?> lastRerollDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? lastModified,
  }) => AppStateRow(
    id: id ?? this.id,
    lifetimeLe: lifetimeLe ?? this.lifetimeLe,
    currentBiomeStartedAt: currentBiomeStartedAt ?? this.currentBiomeStartedAt,
    biomesCompleted: biomesCompleted ?? this.biomesCompleted,
    pendingTreeCategory: pendingTreeCategory.present
        ? pendingTreeCategory.value
        : this.pendingTreeCategory,
    lastRerollDate: lastRerollDate.present
        ? lastRerollDate.value
        : this.lastRerollDate,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  AppStateRow copyWithCompanion(AppStateCompanion data) {
    return AppStateRow(
      id: data.id.present ? data.id.value : this.id,
      lifetimeLe: data.lifetimeLe.present
          ? data.lifetimeLe.value
          : this.lifetimeLe,
      currentBiomeStartedAt: data.currentBiomeStartedAt.present
          ? data.currentBiomeStartedAt.value
          : this.currentBiomeStartedAt,
      biomesCompleted: data.biomesCompleted.present
          ? data.biomesCompleted.value
          : this.biomesCompleted,
      pendingTreeCategory: data.pendingTreeCategory.present
          ? data.pendingTreeCategory.value
          : this.pendingTreeCategory,
      lastRerollDate: data.lastRerollDate.present
          ? data.lastRerollDate.value
          : this.lastRerollDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppStateRow(')
          ..write('id: $id, ')
          ..write('lifetimeLe: $lifetimeLe, ')
          ..write('currentBiomeStartedAt: $currentBiomeStartedAt, ')
          ..write('biomesCompleted: $biomesCompleted, ')
          ..write('pendingTreeCategory: $pendingTreeCategory, ')
          ..write('lastRerollDate: $lastRerollDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lifetimeLe,
    currentBiomeStartedAt,
    biomesCompleted,
    pendingTreeCategory,
    lastRerollDate,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppStateRow &&
          other.id == this.id &&
          other.lifetimeLe == this.lifetimeLe &&
          other.currentBiomeStartedAt == this.currentBiomeStartedAt &&
          other.biomesCompleted == this.biomesCompleted &&
          other.pendingTreeCategory == this.pendingTreeCategory &&
          other.lastRerollDate == this.lastRerollDate &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class AppStateCompanion extends UpdateCompanion<AppStateRow> {
  final Value<int> id;
  final Value<int> lifetimeLe;
  final Value<DateTime> currentBiomeStartedAt;
  final Value<int> biomesCompleted;
  final Value<QuestCategory?> pendingTreeCategory;
  final Value<DateTime?> lastRerollDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  const AppStateCompanion({
    this.id = const Value.absent(),
    this.lifetimeLe = const Value.absent(),
    this.currentBiomeStartedAt = const Value.absent(),
    this.biomesCompleted = const Value.absent(),
    this.pendingTreeCategory = const Value.absent(),
    this.lastRerollDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
  });
  AppStateCompanion.insert({
    this.id = const Value.absent(),
    this.lifetimeLe = const Value.absent(),
    this.currentBiomeStartedAt = const Value.absent(),
    this.biomesCompleted = const Value.absent(),
    this.pendingTreeCategory = const Value.absent(),
    this.lastRerollDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
  });
  static Insertable<AppStateRow> custom({
    Expression<int>? id,
    Expression<int>? lifetimeLe,
    Expression<DateTime>? currentBiomeStartedAt,
    Expression<int>? biomesCompleted,
    Expression<String>? pendingTreeCategory,
    Expression<DateTime>? lastRerollDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lifetimeLe != null) 'lifetime_le': lifetimeLe,
      if (currentBiomeStartedAt != null)
        'current_biome_started_at': currentBiomeStartedAt,
      if (biomesCompleted != null) 'biomes_completed': biomesCompleted,
      if (pendingTreeCategory != null)
        'pending_tree_category': pendingTreeCategory,
      if (lastRerollDate != null) 'last_reroll_date': lastRerollDate,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
    });
  }

  AppStateCompanion copyWith({
    Value<int>? id,
    Value<int>? lifetimeLe,
    Value<DateTime>? currentBiomeStartedAt,
    Value<int>? biomesCompleted,
    Value<QuestCategory?>? pendingTreeCategory,
    Value<DateTime?>? lastRerollDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
  }) {
    return AppStateCompanion(
      id: id ?? this.id,
      lifetimeLe: lifetimeLe ?? this.lifetimeLe,
      currentBiomeStartedAt:
          currentBiomeStartedAt ?? this.currentBiomeStartedAt,
      biomesCompleted: biomesCompleted ?? this.biomesCompleted,
      pendingTreeCategory: pendingTreeCategory ?? this.pendingTreeCategory,
      lastRerollDate: lastRerollDate ?? this.lastRerollDate,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lifetimeLe.present) {
      map['lifetime_le'] = Variable<int>(lifetimeLe.value);
    }
    if (currentBiomeStartedAt.present) {
      map['current_biome_started_at'] = Variable<DateTime>(
        currentBiomeStartedAt.value,
      );
    }
    if (biomesCompleted.present) {
      map['biomes_completed'] = Variable<int>(biomesCompleted.value);
    }
    if (pendingTreeCategory.present) {
      map['pending_tree_category'] = Variable<String>(
        $AppStateTable.$converterpendingTreeCategoryn.toSql(
          pendingTreeCategory.value,
        ),
      );
    }
    if (lastRerollDate.present) {
      map['last_reroll_date'] = Variable<DateTime>(lastRerollDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppStateCompanion(')
          ..write('id: $id, ')
          ..write('lifetimeLe: $lifetimeLe, ')
          ..write('currentBiomeStartedAt: $currentBiomeStartedAt, ')
          ..write('biomesCompleted: $biomesCompleted, ')
          ..write('pendingTreeCategory: $pendingTreeCategory, ')
          ..write('lastRerollDate: $lastRerollDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _liquidFillEnabledMeta = const VerificationMeta(
    'liquidFillEnabled',
  );
  @override
  late final GeneratedColumn<bool> liquidFillEnabled = GeneratedColumn<bool>(
    'liquid_fill_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("liquid_fill_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<JournalFont, String> journalFont =
      GeneratedColumn<String>(
        'journal_font',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(JournalFont.handwriting.name),
      ).withConverter<JournalFont>($SettingsTable.$converterjournalFont);
  @override
  late final GeneratedColumnWithTypeConverter<JournalAlignment, String>
  journalAlignment = GeneratedColumn<String>(
    'journal_alignment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(JournalAlignment.left.name),
  ).withConverter<JournalAlignment>($SettingsTable.$converterjournalAlignment);
  static const VerificationMeta _questsPerDayMeta = const VerificationMeta(
    'questsPerDay',
  );
  @override
  late final GeneratedColumn<int> questsPerDay = GeneratedColumn<int>(
    'quests_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _morningReminderMinMeta =
      const VerificationMeta('morningReminderMin');
  @override
  late final GeneratedColumn<int> morningReminderMin = GeneratedColumn<int>(
    'morning_reminder_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9 * 60),
  );
  static const VerificationMeta _eveningReminderMinMeta =
      const VerificationMeta('eveningReminderMin');
  @override
  late final GeneratedColumn<int> eveningReminderMin = GeneratedColumn<int>(
    'evening_reminder_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20 * 60),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    liquidFillEnabled,
    journalFont,
    journalAlignment,
    questsPerDay,
    notificationsEnabled,
    morningReminderMin,
    eveningReminderMin,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('liquid_fill_enabled')) {
      context.handle(
        _liquidFillEnabledMeta,
        liquidFillEnabled.isAcceptableOrUnknown(
          data['liquid_fill_enabled']!,
          _liquidFillEnabledMeta,
        ),
      );
    }
    if (data.containsKey('quests_per_day')) {
      context.handle(
        _questsPerDayMeta,
        questsPerDay.isAcceptableOrUnknown(
          data['quests_per_day']!,
          _questsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('morning_reminder_min')) {
      context.handle(
        _morningReminderMinMeta,
        morningReminderMin.isAcceptableOrUnknown(
          data['morning_reminder_min']!,
          _morningReminderMinMeta,
        ),
      );
    }
    if (data.containsKey('evening_reminder_min')) {
      context.handle(
        _eveningReminderMinMeta,
        eveningReminderMin.isAcceptableOrUnknown(
          data['evening_reminder_min']!,
          _eveningReminderMinMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      liquidFillEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}liquid_fill_enabled'],
      )!,
      journalFont: $SettingsTable.$converterjournalFont.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}journal_font'],
        )!,
      ),
      journalAlignment: $SettingsTable.$converterjournalAlignment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}journal_alignment'],
        )!,
      ),
      questsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quests_per_day'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      morningReminderMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morning_reminder_min'],
      )!,
      eveningReminderMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evening_reminder_min'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<JournalFont, String, String> $converterjournalFont =
      const EnumNameConverter<JournalFont>(JournalFont.values);
  static JsonTypeConverter2<JournalAlignment, String, String>
  $converterjournalAlignment = const EnumNameConverter<JournalAlignment>(
    JournalAlignment.values,
  );
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final bool liquidFillEnabled;
  final JournalFont journalFont;
  final JournalAlignment journalAlignment;
  final int questsPerDay;
  final bool notificationsEnabled;
  final int morningReminderMin;
  final int eveningReminderMin;
  final DateTime createdAt;
  final DateTime lastModified;
  const SettingsRow({
    required this.id,
    required this.liquidFillEnabled,
    required this.journalFont,
    required this.journalAlignment,
    required this.questsPerDay,
    required this.notificationsEnabled,
    required this.morningReminderMin,
    required this.eveningReminderMin,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['liquid_fill_enabled'] = Variable<bool>(liquidFillEnabled);
    {
      map['journal_font'] = Variable<String>(
        $SettingsTable.$converterjournalFont.toSql(journalFont),
      );
    }
    {
      map['journal_alignment'] = Variable<String>(
        $SettingsTable.$converterjournalAlignment.toSql(journalAlignment),
      );
    }
    map['quests_per_day'] = Variable<int>(questsPerDay);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['morning_reminder_min'] = Variable<int>(morningReminderMin);
    map['evening_reminder_min'] = Variable<int>(eveningReminderMin);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      liquidFillEnabled: Value(liquidFillEnabled),
      journalFont: Value(journalFont),
      journalAlignment: Value(journalAlignment),
      questsPerDay: Value(questsPerDay),
      notificationsEnabled: Value(notificationsEnabled),
      morningReminderMin: Value(morningReminderMin),
      eveningReminderMin: Value(eveningReminderMin),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      liquidFillEnabled: serializer.fromJson<bool>(json['liquidFillEnabled']),
      journalFont: $SettingsTable.$converterjournalFont.fromJson(
        serializer.fromJson<String>(json['journalFont']),
      ),
      journalAlignment: $SettingsTable.$converterjournalAlignment.fromJson(
        serializer.fromJson<String>(json['journalAlignment']),
      ),
      questsPerDay: serializer.fromJson<int>(json['questsPerDay']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      morningReminderMin: serializer.fromJson<int>(json['morningReminderMin']),
      eveningReminderMin: serializer.fromJson<int>(json['eveningReminderMin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'liquidFillEnabled': serializer.toJson<bool>(liquidFillEnabled),
      'journalFont': serializer.toJson<String>(
        $SettingsTable.$converterjournalFont.toJson(journalFont),
      ),
      'journalAlignment': serializer.toJson<String>(
        $SettingsTable.$converterjournalAlignment.toJson(journalAlignment),
      ),
      'questsPerDay': serializer.toJson<int>(questsPerDay),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'morningReminderMin': serializer.toJson<int>(morningReminderMin),
      'eveningReminderMin': serializer.toJson<int>(eveningReminderMin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  SettingsRow copyWith({
    int? id,
    bool? liquidFillEnabled,
    JournalFont? journalFont,
    JournalAlignment? journalAlignment,
    int? questsPerDay,
    bool? notificationsEnabled,
    int? morningReminderMin,
    int? eveningReminderMin,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => SettingsRow(
    id: id ?? this.id,
    liquidFillEnabled: liquidFillEnabled ?? this.liquidFillEnabled,
    journalFont: journalFont ?? this.journalFont,
    journalAlignment: journalAlignment ?? this.journalAlignment,
    questsPerDay: questsPerDay ?? this.questsPerDay,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    morningReminderMin: morningReminderMin ?? this.morningReminderMin,
    eveningReminderMin: eveningReminderMin ?? this.eveningReminderMin,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  SettingsRow copyWithCompanion(SettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      liquidFillEnabled: data.liquidFillEnabled.present
          ? data.liquidFillEnabled.value
          : this.liquidFillEnabled,
      journalFont: data.journalFont.present
          ? data.journalFont.value
          : this.journalFont,
      journalAlignment: data.journalAlignment.present
          ? data.journalAlignment.value
          : this.journalAlignment,
      questsPerDay: data.questsPerDay.present
          ? data.questsPerDay.value
          : this.questsPerDay,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      morningReminderMin: data.morningReminderMin.present
          ? data.morningReminderMin.value
          : this.morningReminderMin,
      eveningReminderMin: data.eveningReminderMin.present
          ? data.eveningReminderMin.value
          : this.eveningReminderMin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('liquidFillEnabled: $liquidFillEnabled, ')
          ..write('journalFont: $journalFont, ')
          ..write('journalAlignment: $journalAlignment, ')
          ..write('questsPerDay: $questsPerDay, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('morningReminderMin: $morningReminderMin, ')
          ..write('eveningReminderMin: $eveningReminderMin, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    liquidFillEnabled,
    journalFont,
    journalAlignment,
    questsPerDay,
    notificationsEnabled,
    morningReminderMin,
    eveningReminderMin,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.liquidFillEnabled == this.liquidFillEnabled &&
          other.journalFont == this.journalFont &&
          other.journalAlignment == this.journalAlignment &&
          other.questsPerDay == this.questsPerDay &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.morningReminderMin == this.morningReminderMin &&
          other.eveningReminderMin == this.eveningReminderMin &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class SettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<bool> liquidFillEnabled;
  final Value<JournalFont> journalFont;
  final Value<JournalAlignment> journalAlignment;
  final Value<int> questsPerDay;
  final Value<bool> notificationsEnabled;
  final Value<int> morningReminderMin;
  final Value<int> eveningReminderMin;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.liquidFillEnabled = const Value.absent(),
    this.journalFont = const Value.absent(),
    this.journalAlignment = const Value.absent(),
    this.questsPerDay = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.morningReminderMin = const Value.absent(),
    this.eveningReminderMin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.liquidFillEnabled = const Value.absent(),
    this.journalFont = const Value.absent(),
    this.journalAlignment = const Value.absent(),
    this.questsPerDay = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.morningReminderMin = const Value.absent(),
    this.eveningReminderMin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<bool>? liquidFillEnabled,
    Expression<String>? journalFont,
    Expression<String>? journalAlignment,
    Expression<int>? questsPerDay,
    Expression<bool>? notificationsEnabled,
    Expression<int>? morningReminderMin,
    Expression<int>? eveningReminderMin,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (liquidFillEnabled != null) 'liquid_fill_enabled': liquidFillEnabled,
      if (journalFont != null) 'journal_font': journalFont,
      if (journalAlignment != null) 'journal_alignment': journalAlignment,
      if (questsPerDay != null) 'quests_per_day': questsPerDay,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (morningReminderMin != null)
        'morning_reminder_min': morningReminderMin,
      if (eveningReminderMin != null)
        'evening_reminder_min': eveningReminderMin,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? liquidFillEnabled,
    Value<JournalFont>? journalFont,
    Value<JournalAlignment>? journalAlignment,
    Value<int>? questsPerDay,
    Value<bool>? notificationsEnabled,
    Value<int>? morningReminderMin,
    Value<int>? eveningReminderMin,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      liquidFillEnabled: liquidFillEnabled ?? this.liquidFillEnabled,
      journalFont: journalFont ?? this.journalFont,
      journalAlignment: journalAlignment ?? this.journalAlignment,
      questsPerDay: questsPerDay ?? this.questsPerDay,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      morningReminderMin: morningReminderMin ?? this.morningReminderMin,
      eveningReminderMin: eveningReminderMin ?? this.eveningReminderMin,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (liquidFillEnabled.present) {
      map['liquid_fill_enabled'] = Variable<bool>(liquidFillEnabled.value);
    }
    if (journalFont.present) {
      map['journal_font'] = Variable<String>(
        $SettingsTable.$converterjournalFont.toSql(journalFont.value),
      );
    }
    if (journalAlignment.present) {
      map['journal_alignment'] = Variable<String>(
        $SettingsTable.$converterjournalAlignment.toSql(journalAlignment.value),
      );
    }
    if (questsPerDay.present) {
      map['quests_per_day'] = Variable<int>(questsPerDay.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (morningReminderMin.present) {
      map['morning_reminder_min'] = Variable<int>(morningReminderMin.value);
    }
    if (eveningReminderMin.present) {
      map['evening_reminder_min'] = Variable<int>(eveningReminderMin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('liquidFillEnabled: $liquidFillEnabled, ')
          ..write('journalFont: $journalFont, ')
          ..write('journalAlignment: $journalAlignment, ')
          ..write('questsPerDay: $questsPerDay, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('morningReminderMin: $morningReminderMin, ')
          ..write('eveningReminderMin: $eveningReminderMin, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }
}

class $QuestsTable extends Quests with TableInfo<$QuestsTable, Quest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuestCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<QuestCategory>($QuestsTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<QuestSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<QuestSource>($QuestsTable.$convertersource);
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    category,
    source,
    isActive,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: $QuestsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      source: $QuestsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $QuestsTable createAlias(String alias) {
    return $QuestsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuestCategory, String, String> $convertercategory =
      const EnumNameConverter<QuestCategory>(QuestCategory.values);
  static JsonTypeConverter2<QuestSource, String, String> $convertersource =
      const EnumNameConverter<QuestSource>(QuestSource.values);
}

class Quest extends DataClass implements Insertable<Quest> {
  final String id;
  final String title;
  final String? description;
  final QuestCategory category;
  final QuestSource source;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastModified;
  const Quest({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.source,
    required this.isActive,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['category'] = Variable<String>(
        $QuestsTable.$convertercategory.toSql(category),
      );
    }
    {
      map['source'] = Variable<String>(
        $QuestsTable.$convertersource.toSql(source),
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  QuestsCompanion toCompanion(bool nullToAbsent) {
    return QuestsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      source: Value(source),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory Quest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quest(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      category: $QuestsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      source: $QuestsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(
        $QuestsTable.$convertercategory.toJson(category),
      ),
      'source': serializer.toJson<String>(
        $QuestsTable.$convertersource.toJson(source),
      ),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  Quest copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    QuestCategory? category,
    QuestSource? source,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => Quest(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    category: category ?? this.category,
    source: source ?? this.source,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  Quest copyWithCompanion(QuestsCompanion data) {
    return Quest(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      source: data.source.present ? data.source.value : this.source,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quest(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('source: $source, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    source,
    isActive,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quest &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.source == this.source &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class QuestsCompanion extends UpdateCompanion<Quest> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<QuestCategory> category;
  final Value<QuestSource> source;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const QuestsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.source = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required QuestCategory category,
    required QuestSource source,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       category = Value(category),
       source = Value(source);
  static Insertable<Quest> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? source,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (source != null) 'source': source,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<QuestCategory>? category,
    Value<QuestSource>? source,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return QuestsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      source: source ?? this.source,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $QuestsTable.$convertercategory.toSql(category.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $QuestsTable.$convertersource.toSql(source.value),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('source: $source, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestCompletionsTable extends QuestCompletions
    with TableInfo<$QuestCompletionsTable, QuestCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _questIdMeta = const VerificationMeta(
    'questId',
  );
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
    'quest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quests (id)',
    ),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leAwardedMeta = const VerificationMeta(
    'leAwarded',
  );
  @override
  late final GeneratedColumn<int> leAwarded = GeneratedColumn<int>(
    'le_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuestCategory, String>
  categoryAtCompletion =
      GeneratedColumn<String>(
        'category_at_completion',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<QuestCategory>(
        $QuestCompletionsTable.$convertercategoryAtCompletion,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questId,
    completedAt,
    date,
    leAwarded,
    categoryAtCompletion,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quest_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quest_id')) {
      context.handle(
        _questIdMeta,
        questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('le_awarded')) {
      context.handle(
        _leAwardedMeta,
        leAwarded.isAcceptableOrUnknown(data['le_awarded']!, _leAwardedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestCompletion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      questId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      leAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}le_awarded'],
      )!,
      categoryAtCompletion: $QuestCompletionsTable
          .$convertercategoryAtCompletion
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}category_at_completion'],
            )!,
          ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $QuestCompletionsTable createAlias(String alias) {
    return $QuestCompletionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuestCategory, String, String>
  $convertercategoryAtCompletion = const EnumNameConverter<QuestCategory>(
    QuestCategory.values,
  );
}

class QuestCompletion extends DataClass implements Insertable<QuestCompletion> {
  final String id;
  final String questId;
  final DateTime completedAt;
  final DateTime date;
  final int leAwarded;
  final QuestCategory categoryAtCompletion;
  final DateTime createdAt;
  final DateTime lastModified;
  const QuestCompletion({
    required this.id,
    required this.questId,
    required this.completedAt,
    required this.date,
    required this.leAwarded,
    required this.categoryAtCompletion,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quest_id'] = Variable<String>(questId);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['date'] = Variable<DateTime>(date);
    map['le_awarded'] = Variable<int>(leAwarded);
    {
      map['category_at_completion'] = Variable<String>(
        $QuestCompletionsTable.$convertercategoryAtCompletion.toSql(
          categoryAtCompletion,
        ),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  QuestCompletionsCompanion toCompanion(bool nullToAbsent) {
    return QuestCompletionsCompanion(
      id: Value(id),
      questId: Value(questId),
      completedAt: Value(completedAt),
      date: Value(date),
      leAwarded: Value(leAwarded),
      categoryAtCompletion: Value(categoryAtCompletion),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory QuestCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestCompletion(
      id: serializer.fromJson<String>(json['id']),
      questId: serializer.fromJson<String>(json['questId']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      date: serializer.fromJson<DateTime>(json['date']),
      leAwarded: serializer.fromJson<int>(json['leAwarded']),
      categoryAtCompletion: $QuestCompletionsTable
          .$convertercategoryAtCompletion
          .fromJson(serializer.fromJson<String>(json['categoryAtCompletion'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questId': serializer.toJson<String>(questId),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'date': serializer.toJson<DateTime>(date),
      'leAwarded': serializer.toJson<int>(leAwarded),
      'categoryAtCompletion': serializer.toJson<String>(
        $QuestCompletionsTable.$convertercategoryAtCompletion.toJson(
          categoryAtCompletion,
        ),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  QuestCompletion copyWith({
    String? id,
    String? questId,
    DateTime? completedAt,
    DateTime? date,
    int? leAwarded,
    QuestCategory? categoryAtCompletion,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => QuestCompletion(
    id: id ?? this.id,
    questId: questId ?? this.questId,
    completedAt: completedAt ?? this.completedAt,
    date: date ?? this.date,
    leAwarded: leAwarded ?? this.leAwarded,
    categoryAtCompletion: categoryAtCompletion ?? this.categoryAtCompletion,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  QuestCompletion copyWithCompanion(QuestCompletionsCompanion data) {
    return QuestCompletion(
      id: data.id.present ? data.id.value : this.id,
      questId: data.questId.present ? data.questId.value : this.questId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      date: data.date.present ? data.date.value : this.date,
      leAwarded: data.leAwarded.present ? data.leAwarded.value : this.leAwarded,
      categoryAtCompletion: data.categoryAtCompletion.present
          ? data.categoryAtCompletion.value
          : this.categoryAtCompletion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestCompletion(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('completedAt: $completedAt, ')
          ..write('date: $date, ')
          ..write('leAwarded: $leAwarded, ')
          ..write('categoryAtCompletion: $categoryAtCompletion, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    questId,
    completedAt,
    date,
    leAwarded,
    categoryAtCompletion,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestCompletion &&
          other.id == this.id &&
          other.questId == this.questId &&
          other.completedAt == this.completedAt &&
          other.date == this.date &&
          other.leAwarded == this.leAwarded &&
          other.categoryAtCompletion == this.categoryAtCompletion &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class QuestCompletionsCompanion extends UpdateCompanion<QuestCompletion> {
  final Value<String> id;
  final Value<String> questId;
  final Value<DateTime> completedAt;
  final Value<DateTime> date;
  final Value<int> leAwarded;
  final Value<QuestCategory> categoryAtCompletion;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const QuestCompletionsCompanion({
    this.id = const Value.absent(),
    this.questId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.date = const Value.absent(),
    this.leAwarded = const Value.absent(),
    this.categoryAtCompletion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestCompletionsCompanion.insert({
    this.id = const Value.absent(),
    required String questId,
    required DateTime completedAt,
    required DateTime date,
    this.leAwarded = const Value.absent(),
    required QuestCategory categoryAtCompletion,
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : questId = Value(questId),
       completedAt = Value(completedAt),
       date = Value(date),
       categoryAtCompletion = Value(categoryAtCompletion);
  static Insertable<QuestCompletion> custom({
    Expression<String>? id,
    Expression<String>? questId,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? date,
    Expression<int>? leAwarded,
    Expression<String>? categoryAtCompletion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questId != null) 'quest_id': questId,
      if (completedAt != null) 'completed_at': completedAt,
      if (date != null) 'date': date,
      if (leAwarded != null) 'le_awarded': leAwarded,
      if (categoryAtCompletion != null)
        'category_at_completion': categoryAtCompletion,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestCompletionsCompanion copyWith({
    Value<String>? id,
    Value<String>? questId,
    Value<DateTime>? completedAt,
    Value<DateTime>? date,
    Value<int>? leAwarded,
    Value<QuestCategory>? categoryAtCompletion,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return QuestCompletionsCompanion(
      id: id ?? this.id,
      questId: questId ?? this.questId,
      completedAt: completedAt ?? this.completedAt,
      date: date ?? this.date,
      leAwarded: leAwarded ?? this.leAwarded,
      categoryAtCompletion: categoryAtCompletion ?? this.categoryAtCompletion,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (leAwarded.present) {
      map['le_awarded'] = Variable<int>(leAwarded.value);
    }
    if (categoryAtCompletion.present) {
      map['category_at_completion'] = Variable<String>(
        $QuestCompletionsTable.$convertercategoryAtCompletion.toSql(
          categoryAtCompletion.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('completedAt: $completedAt, ')
          ..write('date: $date, ')
          ..write('leAwarded: $leAwarded, ')
          ..write('categoryAtCompletion: $categoryAtCompletion, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyQuestRollsTable extends DailyQuestRolls
    with TableInfo<$DailyQuestRollsTable, DailyQuestRoll> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyQuestRollsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _questIdMeta = const VerificationMeta(
    'questId',
  );
  @override
  late final GeneratedColumn<String> questId = GeneratedColumn<String>(
    'quest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quests (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolledAtMeta = const VerificationMeta(
    'rolledAt',
  );
  @override
  late final GeneratedColumn<DateTime> rolledAt = GeneratedColumn<DateTime>(
    'rolled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questId,
    date,
    rolledAt,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_quest_rolls';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyQuestRoll> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quest_id')) {
      context.handle(
        _questIdMeta,
        questId.isAcceptableOrUnknown(data['quest_id']!, _questIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('rolled_at')) {
      context.handle(
        _rolledAtMeta,
        rolledAt.isAcceptableOrUnknown(data['rolled_at']!, _rolledAtMeta),
      );
    } else if (isInserting) {
      context.missing(_rolledAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyQuestRoll map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyQuestRoll(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      questId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      rolledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rolled_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $DailyQuestRollsTable createAlias(String alias) {
    return $DailyQuestRollsTable(attachedDatabase, alias);
  }
}

class DailyQuestRoll extends DataClass implements Insertable<DailyQuestRoll> {
  final String id;
  final String questId;
  final DateTime date;
  final DateTime rolledAt;
  final DateTime createdAt;
  final DateTime lastModified;
  const DailyQuestRoll({
    required this.id,
    required this.questId,
    required this.date,
    required this.rolledAt,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quest_id'] = Variable<String>(questId);
    map['date'] = Variable<DateTime>(date);
    map['rolled_at'] = Variable<DateTime>(rolledAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  DailyQuestRollsCompanion toCompanion(bool nullToAbsent) {
    return DailyQuestRollsCompanion(
      id: Value(id),
      questId: Value(questId),
      date: Value(date),
      rolledAt: Value(rolledAt),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory DailyQuestRoll.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyQuestRoll(
      id: serializer.fromJson<String>(json['id']),
      questId: serializer.fromJson<String>(json['questId']),
      date: serializer.fromJson<DateTime>(json['date']),
      rolledAt: serializer.fromJson<DateTime>(json['rolledAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questId': serializer.toJson<String>(questId),
      'date': serializer.toJson<DateTime>(date),
      'rolledAt': serializer.toJson<DateTime>(rolledAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  DailyQuestRoll copyWith({
    String? id,
    String? questId,
    DateTime? date,
    DateTime? rolledAt,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => DailyQuestRoll(
    id: id ?? this.id,
    questId: questId ?? this.questId,
    date: date ?? this.date,
    rolledAt: rolledAt ?? this.rolledAt,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  DailyQuestRoll copyWithCompanion(DailyQuestRollsCompanion data) {
    return DailyQuestRoll(
      id: data.id.present ? data.id.value : this.id,
      questId: data.questId.present ? data.questId.value : this.questId,
      date: data.date.present ? data.date.value : this.date,
      rolledAt: data.rolledAt.present ? data.rolledAt.value : this.rolledAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestRoll(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('date: $date, ')
          ..write('rolledAt: $rolledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, questId, date, rolledAt, createdAt, lastModified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyQuestRoll &&
          other.id == this.id &&
          other.questId == this.questId &&
          other.date == this.date &&
          other.rolledAt == this.rolledAt &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class DailyQuestRollsCompanion extends UpdateCompanion<DailyQuestRoll> {
  final Value<String> id;
  final Value<String> questId;
  final Value<DateTime> date;
  final Value<DateTime> rolledAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const DailyQuestRollsCompanion({
    this.id = const Value.absent(),
    this.questId = const Value.absent(),
    this.date = const Value.absent(),
    this.rolledAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyQuestRollsCompanion.insert({
    this.id = const Value.absent(),
    required String questId,
    required DateTime date,
    required DateTime rolledAt,
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : questId = Value(questId),
       date = Value(date),
       rolledAt = Value(rolledAt);
  static Insertable<DailyQuestRoll> custom({
    Expression<String>? id,
    Expression<String>? questId,
    Expression<DateTime>? date,
    Expression<DateTime>? rolledAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questId != null) 'quest_id': questId,
      if (date != null) 'date': date,
      if (rolledAt != null) 'rolled_at': rolledAt,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyQuestRollsCompanion copyWith({
    Value<String>? id,
    Value<String>? questId,
    Value<DateTime>? date,
    Value<DateTime>? rolledAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return DailyQuestRollsCompanion(
      id: id ?? this.id,
      questId: questId ?? this.questId,
      date: date ?? this.date,
      rolledAt: rolledAt ?? this.rolledAt,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questId.present) {
      map['quest_id'] = Variable<String>(questId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rolledAt.present) {
      map['rolled_at'] = Variable<DateTime>(rolledAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestRollsCompanion(')
          ..write('id: $id, ')
          ..write('questId: $questId, ')
          ..write('date: $date, ')
          ..write('rolledAt: $rolledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HabitType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HabitType>($HabitsTable.$convertertype);
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    type,
    isActive,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      type: $HabitsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HabitType, String, String> $convertertype =
      const EnumNameConverter<HabitType>(HabitType.values);
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final String title;
  final String? description;
  final HabitType type;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastModified;
  const Habit({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.isActive,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['type'] = Variable<String>($HabitsTable.$convertertype.toSql(type));
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      type: $HabitsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(
        $HabitsTable.$convertertype.toJson(type),
      ),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  Habit copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    HabitType? type,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => Habit(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    type: type ?? this.type,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    type,
    isActive,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<HabitType> type;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required HabitType type,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       type = Value(type);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? type,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<HabitType>? type,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $HabitsTable.$convertertype.toSql(type.value),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitLogsTable extends HabitLogs
    with TableInfo<$HabitLogsTable, HabitLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HabitLogStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HabitLogStatus>($HabitLogsTable.$converterstatus);
  static const VerificationMeta _leAwardedMeta = const VerificationMeta(
    'leAwarded',
  );
  @override
  late final GeneratedColumn<int> leAwarded = GeneratedColumn<int>(
    'le_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    date,
    status,
    leAwarded,
    loggedAt,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('le_awarded')) {
      context.handle(
        _leAwardedMeta,
        leAwarded.isAcceptableOrUnknown(data['le_awarded']!, _leAwardedMeta),
      );
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      status: $HabitLogsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      leAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}le_awarded'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $HabitLogsTable createAlias(String alias) {
    return $HabitLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HabitLogStatus, String, String> $converterstatus =
      const EnumNameConverter<HabitLogStatus>(HabitLogStatus.values);
}

class HabitLog extends DataClass implements Insertable<HabitLog> {
  final String id;
  final String habitId;
  final DateTime date;
  final HabitLogStatus status;
  final int leAwarded;
  final DateTime loggedAt;
  final DateTime createdAt;
  final DateTime lastModified;
  const HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    required this.status,
    required this.leAwarded,
    required this.loggedAt,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['date'] = Variable<DateTime>(date);
    {
      map['status'] = Variable<String>(
        $HabitLogsTable.$converterstatus.toSql(status),
      );
    }
    map['le_awarded'] = Variable<int>(leAwarded);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  HabitLogsCompanion toCompanion(bool nullToAbsent) {
    return HabitLogsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      date: Value(date),
      status: Value(status),
      leAwarded: Value(leAwarded),
      loggedAt: Value(loggedAt),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory HabitLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitLog(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: $HabitLogsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      leAwarded: serializer.fromJson<int>(json['leAwarded']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(
        $HabitLogsTable.$converterstatus.toJson(status),
      ),
      'leAwarded': serializer.toJson<int>(leAwarded),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  HabitLog copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    HabitLogStatus? status,
    int? leAwarded,
    DateTime? loggedAt,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => HabitLog(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    date: date ?? this.date,
    status: status ?? this.status,
    leAwarded: leAwarded ?? this.leAwarded,
    loggedAt: loggedAt ?? this.loggedAt,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  HabitLog copyWithCompanion(HabitLogsCompanion data) {
    return HabitLog(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      leAwarded: data.leAwarded.present ? data.leAwarded.value : this.leAwarded,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitLog(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('leAwarded: $leAwarded, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    habitId,
    date,
    status,
    leAwarded,
    loggedAt,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitLog &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.status == this.status &&
          other.leAwarded == this.leAwarded &&
          other.loggedAt == this.loggedAt &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class HabitLogsCompanion extends UpdateCompanion<HabitLog> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<DateTime> date;
  final Value<HabitLogStatus> status;
  final Value<int> leAwarded;
  final Value<DateTime> loggedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const HabitLogsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.leAwarded = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitLogsCompanion.insert({
    this.id = const Value.absent(),
    required String habitId,
    required DateTime date,
    required HabitLogStatus status,
    this.leAwarded = const Value.absent(),
    required DateTime loggedAt,
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       date = Value(date),
       status = Value(status),
       loggedAt = Value(loggedAt);
  static Insertable<HabitLog> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<int>? leAwarded,
    Expression<DateTime>? loggedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (leAwarded != null) 'le_awarded': leAwarded,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<DateTime>? date,
    Value<HabitLogStatus>? status,
    Value<int>? leAwarded,
    Value<DateTime>? loggedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return HabitLogsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      status: status ?? this.status,
      leAwarded: leAwarded ?? this.leAwarded,
      loggedAt: loggedAt ?? this.loggedAt,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $HabitLogsTable.$converterstatus.toSql(status.value),
      );
    }
    if (leAwarded.present) {
      map['le_awarded'] = Variable<int>(leAwarded.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('leAwarded: $leAwarded, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 300,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    dueDate,
    completedAt,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime lastModified;
  const TaskRow({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.completedAt,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: Value(dueDate),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  TaskRow copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    DateTime? dueDate,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? lastModified,
  }) => TaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    dueDate: dueDate ?? this.dueDate,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    dueDate,
    completedAt,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> dueDate;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required DateTime dueDate,
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       dueDate = Value(dueDate);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime>? dueDate,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    body,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
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
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final String id;
  final DateTime date;
  final String body;
  final DateTime createdAt;
  final DateTime lastModified;
  const JournalEntry({
    required this.id,
    required this.date,
    required this.body,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      date: Value(date),
      body: Value(body),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  JournalEntry copyWith({
    String? id,
    DateTime? date,
    String? body,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => JournalEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, body, createdAt, lastModified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<JournalEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TreesTable extends Trees with TableInfo<$TreesTable, TreeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuestCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<QuestCategory>($TreesTable.$convertercategory);
  static const VerificationMeta _plantedAtMeta = const VerificationMeta(
    'plantedAt',
  );
  @override
  late final GeneratedColumn<DateTime> plantedAt = GeneratedColumn<DateTime>(
    'planted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelAtPlantingMeta = const VerificationMeta(
    'levelAtPlanting',
  );
  @override
  late final GeneratedColumn<int> levelAtPlanting = GeneratedColumn<int>(
    'level_at_planting',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionXMeta = const VerificationMeta(
    'positionX',
  );
  @override
  late final GeneratedColumn<double> positionX = GeneratedColumn<double>(
    'position_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionYMeta = const VerificationMeta(
    'positionY',
  );
  @override
  late final GeneratedColumn<double> positionY = GeneratedColumn<double>(
    'position_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    plantedAt,
    levelAtPlanting,
    positionX,
    positionY,
    createdAt,
    lastModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trees';
  @override
  VerificationContext validateIntegrity(
    Insertable<TreeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('planted_at')) {
      context.handle(
        _plantedAtMeta,
        plantedAt.isAcceptableOrUnknown(data['planted_at']!, _plantedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_plantedAtMeta);
    }
    if (data.containsKey('level_at_planting')) {
      context.handle(
        _levelAtPlantingMeta,
        levelAtPlanting.isAcceptableOrUnknown(
          data['level_at_planting']!,
          _levelAtPlantingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_levelAtPlantingMeta);
    }
    if (data.containsKey('position_x')) {
      context.handle(
        _positionXMeta,
        positionX.isAcceptableOrUnknown(data['position_x']!, _positionXMeta),
      );
    } else if (isInserting) {
      context.missing(_positionXMeta);
    }
    if (data.containsKey('position_y')) {
      context.handle(
        _positionYMeta,
        positionY.isAcceptableOrUnknown(data['position_y']!, _positionYMeta),
      );
    } else if (isInserting) {
      context.missing(_positionYMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TreeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: $TreesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      plantedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planted_at'],
      )!,
      levelAtPlanting: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_at_planting'],
      )!,
      positionX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}position_x'],
      )!,
      positionY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}position_y'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
    );
  }

  @override
  $TreesTable createAlias(String alias) {
    return $TreesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuestCategory, String, String> $convertercategory =
      const EnumNameConverter<QuestCategory>(QuestCategory.values);
}

class TreeRow extends DataClass implements Insertable<TreeRow> {
  final String id;
  final QuestCategory category;
  final DateTime plantedAt;
  final int levelAtPlanting;
  final double positionX;
  final double positionY;
  final DateTime createdAt;
  final DateTime lastModified;
  const TreeRow({
    required this.id,
    required this.category,
    required this.plantedAt,
    required this.levelAtPlanting,
    required this.positionX,
    required this.positionY,
    required this.createdAt,
    required this.lastModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['category'] = Variable<String>(
        $TreesTable.$convertercategory.toSql(category),
      );
    }
    map['planted_at'] = Variable<DateTime>(plantedAt);
    map['level_at_planting'] = Variable<int>(levelAtPlanting);
    map['position_x'] = Variable<double>(positionX);
    map['position_y'] = Variable<double>(positionY);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_modified'] = Variable<DateTime>(lastModified);
    return map;
  }

  TreesCompanion toCompanion(bool nullToAbsent) {
    return TreesCompanion(
      id: Value(id),
      category: Value(category),
      plantedAt: Value(plantedAt),
      levelAtPlanting: Value(levelAtPlanting),
      positionX: Value(positionX),
      positionY: Value(positionY),
      createdAt: Value(createdAt),
      lastModified: Value(lastModified),
    );
  }

  factory TreeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreeRow(
      id: serializer.fromJson<String>(json['id']),
      category: $TreesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      plantedAt: serializer.fromJson<DateTime>(json['plantedAt']),
      levelAtPlanting: serializer.fromJson<int>(json['levelAtPlanting']),
      positionX: serializer.fromJson<double>(json['positionX']),
      positionY: serializer.fromJson<double>(json['positionY']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(
        $TreesTable.$convertercategory.toJson(category),
      ),
      'plantedAt': serializer.toJson<DateTime>(plantedAt),
      'levelAtPlanting': serializer.toJson<int>(levelAtPlanting),
      'positionX': serializer.toJson<double>(positionX),
      'positionY': serializer.toJson<double>(positionY),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
    };
  }

  TreeRow copyWith({
    String? id,
    QuestCategory? category,
    DateTime? plantedAt,
    int? levelAtPlanting,
    double? positionX,
    double? positionY,
    DateTime? createdAt,
    DateTime? lastModified,
  }) => TreeRow(
    id: id ?? this.id,
    category: category ?? this.category,
    plantedAt: plantedAt ?? this.plantedAt,
    levelAtPlanting: levelAtPlanting ?? this.levelAtPlanting,
    positionX: positionX ?? this.positionX,
    positionY: positionY ?? this.positionY,
    createdAt: createdAt ?? this.createdAt,
    lastModified: lastModified ?? this.lastModified,
  );
  TreeRow copyWithCompanion(TreesCompanion data) {
    return TreeRow(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      plantedAt: data.plantedAt.present ? data.plantedAt.value : this.plantedAt,
      levelAtPlanting: data.levelAtPlanting.present
          ? data.levelAtPlanting.value
          : this.levelAtPlanting,
      positionX: data.positionX.present ? data.positionX.value : this.positionX,
      positionY: data.positionY.present ? data.positionY.value : this.positionY,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreeRow(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('plantedAt: $plantedAt, ')
          ..write('levelAtPlanting: $levelAtPlanting, ')
          ..write('positionX: $positionX, ')
          ..write('positionY: $positionY, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    plantedAt,
    levelAtPlanting,
    positionX,
    positionY,
    createdAt,
    lastModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreeRow &&
          other.id == this.id &&
          other.category == this.category &&
          other.plantedAt == this.plantedAt &&
          other.levelAtPlanting == this.levelAtPlanting &&
          other.positionX == this.positionX &&
          other.positionY == this.positionY &&
          other.createdAt == this.createdAt &&
          other.lastModified == this.lastModified);
}

class TreesCompanion extends UpdateCompanion<TreeRow> {
  final Value<String> id;
  final Value<QuestCategory> category;
  final Value<DateTime> plantedAt;
  final Value<int> levelAtPlanting;
  final Value<double> positionX;
  final Value<double> positionY;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastModified;
  final Value<int> rowid;
  const TreesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.plantedAt = const Value.absent(),
    this.levelAtPlanting = const Value.absent(),
    this.positionX = const Value.absent(),
    this.positionY = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TreesCompanion.insert({
    this.id = const Value.absent(),
    required QuestCategory category,
    required DateTime plantedAt,
    required int levelAtPlanting,
    required double positionX,
    required double positionY,
    this.createdAt = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : category = Value(category),
       plantedAt = Value(plantedAt),
       levelAtPlanting = Value(levelAtPlanting),
       positionX = Value(positionX),
       positionY = Value(positionY);
  static Insertable<TreeRow> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<DateTime>? plantedAt,
    Expression<int>? levelAtPlanting,
    Expression<double>? positionX,
    Expression<double>? positionY,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (plantedAt != null) 'planted_at': plantedAt,
      if (levelAtPlanting != null) 'level_at_planting': levelAtPlanting,
      if (positionX != null) 'position_x': positionX,
      if (positionY != null) 'position_y': positionY,
      if (createdAt != null) 'created_at': createdAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TreesCompanion copyWith({
    Value<String>? id,
    Value<QuestCategory>? category,
    Value<DateTime>? plantedAt,
    Value<int>? levelAtPlanting,
    Value<double>? positionX,
    Value<double>? positionY,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastModified,
    Value<int>? rowid,
  }) {
    return TreesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      plantedAt: plantedAt ?? this.plantedAt,
      levelAtPlanting: levelAtPlanting ?? this.levelAtPlanting,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $TreesTable.$convertercategory.toSql(category.value),
      );
    }
    if (plantedAt.present) {
      map['planted_at'] = Variable<DateTime>(plantedAt.value);
    }
    if (levelAtPlanting.present) {
      map['level_at_planting'] = Variable<int>(levelAtPlanting.value);
    }
    if (positionX.present) {
      map['position_x'] = Variable<double>(positionX.value);
    }
    if (positionY.present) {
      map['position_y'] = Variable<double>(positionY.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('plantedAt: $plantedAt, ')
          ..write('levelAtPlanting: $levelAtPlanting, ')
          ..write('positionX: $positionX, ')
          ..write('positionY: $positionY, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppStateTable appState = $AppStateTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $QuestsTable quests = $QuestsTable(this);
  late final $QuestCompletionsTable questCompletions = $QuestCompletionsTable(
    this,
  );
  late final $DailyQuestRollsTable dailyQuestRolls = $DailyQuestRollsTable(
    this,
  );
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitLogsTable habitLogs = $HabitLogsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $TreesTable trees = $TreesTable(this);
  late final Index idxQuestsCategoryActive = Index(
    'idx_quests_category_active',
    'CREATE INDEX idx_quests_category_active ON quests (category, is_active)',
  );
  late final Index idxQuestsSource = Index(
    'idx_quests_source',
    'CREATE INDEX idx_quests_source ON quests (source)',
  );
  late final Index idxCompletionsDate = Index(
    'idx_completions_date',
    'CREATE INDEX idx_completions_date ON quest_completions (date)',
  );
  late final Index idxCompletionsQuest = Index(
    'idx_completions_quest',
    'CREATE INDEX idx_completions_quest ON quest_completions (quest_id)',
  );
  late final Index idxCompletionsCompletedAt = Index(
    'idx_completions_completed_at',
    'CREATE INDEX idx_completions_completed_at ON quest_completions (completed_at)',
  );
  late final Index idxRollsDate = Index(
    'idx_rolls_date',
    'CREATE INDEX idx_rolls_date ON daily_quest_rolls (date)',
  );
  late final Index idxRollsQuestDate = Index(
    'idx_rolls_quest_date',
    'CREATE UNIQUE INDEX idx_rolls_quest_date ON daily_quest_rolls (quest_id, date)',
  );
  late final Index idxHabitsActive = Index(
    'idx_habits_active',
    'CREATE INDEX idx_habits_active ON habits (is_active)',
  );
  late final Index idxHabitLogsDate = Index(
    'idx_habit_logs_date',
    'CREATE INDEX idx_habit_logs_date ON habit_logs (date)',
  );
  late final Index idxHabitLogsHabitDate = Index(
    'idx_habit_logs_habit_date',
    'CREATE INDEX idx_habit_logs_habit_date ON habit_logs (habit_id, date)',
  );
  late final Index idxTasksDueDate = Index(
    'idx_tasks_due_date',
    'CREATE INDEX idx_tasks_due_date ON tasks (due_date)',
  );
  late final Index idxTasksCompletedAt = Index(
    'idx_tasks_completed_at',
    'CREATE INDEX idx_tasks_completed_at ON tasks (completed_at)',
  );
  late final Index idxTreesPlantedAt = Index(
    'idx_trees_planted_at',
    'CREATE INDEX idx_trees_planted_at ON trees (planted_at)',
  );
  late final Index idxTreesCategory = Index(
    'idx_trees_category',
    'CREATE INDEX idx_trees_category ON trees (category)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appState,
    settings,
    quests,
    questCompletions,
    dailyQuestRolls,
    habits,
    habitLogs,
    tasks,
    journalEntries,
    trees,
    idxQuestsCategoryActive,
    idxQuestsSource,
    idxCompletionsDate,
    idxCompletionsQuest,
    idxCompletionsCompletedAt,
    idxRollsDate,
    idxRollsQuestDate,
    idxHabitsActive,
    idxHabitLogsDate,
    idxHabitLogsHabitDate,
    idxTasksDueDate,
    idxTasksCompletedAt,
    idxTreesPlantedAt,
    idxTreesCategory,
  ];
}

typedef $$AppStateTableCreateCompanionBuilder =
    AppStateCompanion Function({
      Value<int> id,
      Value<int> lifetimeLe,
      Value<DateTime> currentBiomeStartedAt,
      Value<int> biomesCompleted,
      Value<QuestCategory?> pendingTreeCategory,
      Value<DateTime?> lastRerollDate,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
    });
typedef $$AppStateTableUpdateCompanionBuilder =
    AppStateCompanion Function({
      Value<int> id,
      Value<int> lifetimeLe,
      Value<DateTime> currentBiomeStartedAt,
      Value<int> biomesCompleted,
      Value<QuestCategory?> pendingTreeCategory,
      Value<DateTime?> lastRerollDate,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
    });

class $$AppStateTableFilterComposer
    extends Composer<_$AppDatabase, $AppStateTable> {
  $$AppStateTableFilterComposer({
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

  ColumnFilters<int> get lifetimeLe => $composableBuilder(
    column: $table.lifetimeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get currentBiomeStartedAt => $composableBuilder(
    column: $table.currentBiomeStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get biomesCompleted => $composableBuilder(
    column: $table.biomesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestCategory?, QuestCategory, String>
  get pendingTreeCategory => $composableBuilder(
    column: $table.pendingTreeCategory,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get lastRerollDate => $composableBuilder(
    column: $table.lastRerollDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppStateTableOrderingComposer
    extends Composer<_$AppDatabase, $AppStateTable> {
  $$AppStateTableOrderingComposer({
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

  ColumnOrderings<int> get lifetimeLe => $composableBuilder(
    column: $table.lifetimeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get currentBiomeStartedAt => $composableBuilder(
    column: $table.currentBiomeStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get biomesCompleted => $composableBuilder(
    column: $table.biomesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingTreeCategory => $composableBuilder(
    column: $table.pendingTreeCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRerollDate => $composableBuilder(
    column: $table.lastRerollDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppStateTable> {
  $$AppStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lifetimeLe => $composableBuilder(
    column: $table.lifetimeLe,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get currentBiomeStartedAt => $composableBuilder(
    column: $table.currentBiomeStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get biomesCompleted => $composableBuilder(
    column: $table.biomesCompleted,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QuestCategory?, String>
  get pendingTreeCategory => $composableBuilder(
    column: $table.pendingTreeCategory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastRerollDate => $composableBuilder(
    column: $table.lastRerollDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$AppStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppStateTable,
          AppStateRow,
          $$AppStateTableFilterComposer,
          $$AppStateTableOrderingComposer,
          $$AppStateTableAnnotationComposer,
          $$AppStateTableCreateCompanionBuilder,
          $$AppStateTableUpdateCompanionBuilder,
          (
            AppStateRow,
            BaseReferences<_$AppDatabase, $AppStateTable, AppStateRow>,
          ),
          AppStateRow,
          PrefetchHooks Function()
        > {
  $$AppStateTableTableManager(_$AppDatabase db, $AppStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lifetimeLe = const Value.absent(),
                Value<DateTime> currentBiomeStartedAt = const Value.absent(),
                Value<int> biomesCompleted = const Value.absent(),
                Value<QuestCategory?> pendingTreeCategory =
                    const Value.absent(),
                Value<DateTime?> lastRerollDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
              }) => AppStateCompanion(
                id: id,
                lifetimeLe: lifetimeLe,
                currentBiomeStartedAt: currentBiomeStartedAt,
                biomesCompleted: biomesCompleted,
                pendingTreeCategory: pendingTreeCategory,
                lastRerollDate: lastRerollDate,
                createdAt: createdAt,
                lastModified: lastModified,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lifetimeLe = const Value.absent(),
                Value<DateTime> currentBiomeStartedAt = const Value.absent(),
                Value<int> biomesCompleted = const Value.absent(),
                Value<QuestCategory?> pendingTreeCategory =
                    const Value.absent(),
                Value<DateTime?> lastRerollDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
              }) => AppStateCompanion.insert(
                id: id,
                lifetimeLe: lifetimeLe,
                currentBiomeStartedAt: currentBiomeStartedAt,
                biomesCompleted: biomesCompleted,
                pendingTreeCategory: pendingTreeCategory,
                lastRerollDate: lastRerollDate,
                createdAt: createdAt,
                lastModified: lastModified,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppStateTable,
      AppStateRow,
      $$AppStateTableFilterComposer,
      $$AppStateTableOrderingComposer,
      $$AppStateTableAnnotationComposer,
      $$AppStateTableCreateCompanionBuilder,
      $$AppStateTableUpdateCompanionBuilder,
      (AppStateRow, BaseReferences<_$AppDatabase, $AppStateTable, AppStateRow>),
      AppStateRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<bool> liquidFillEnabled,
      Value<JournalFont> journalFont,
      Value<JournalAlignment> journalAlignment,
      Value<int> questsPerDay,
      Value<bool> notificationsEnabled,
      Value<int> morningReminderMin,
      Value<int> eveningReminderMin,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<bool> liquidFillEnabled,
      Value<JournalFont> journalFont,
      Value<JournalAlignment> journalAlignment,
      Value<int> questsPerDay,
      Value<bool> notificationsEnabled,
      Value<int> morningReminderMin,
      Value<int> eveningReminderMin,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
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

  ColumnFilters<bool> get liquidFillEnabled => $composableBuilder(
    column: $table.liquidFillEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JournalFont, JournalFont, String>
  get journalFont => $composableBuilder(
    column: $table.journalFont,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<JournalAlignment, JournalAlignment, String>
  get journalAlignment => $composableBuilder(
    column: $table.journalAlignment,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get questsPerDay => $composableBuilder(
    column: $table.questsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morningReminderMin => $composableBuilder(
    column: $table.morningReminderMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eveningReminderMin => $composableBuilder(
    column: $table.eveningReminderMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
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

  ColumnOrderings<bool> get liquidFillEnabled => $composableBuilder(
    column: $table.liquidFillEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journalFont => $composableBuilder(
    column: $table.journalFont,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journalAlignment => $composableBuilder(
    column: $table.journalAlignment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questsPerDay => $composableBuilder(
    column: $table.questsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morningReminderMin => $composableBuilder(
    column: $table.morningReminderMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eveningReminderMin => $composableBuilder(
    column: $table.eveningReminderMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get liquidFillEnabled => $composableBuilder(
    column: $table.liquidFillEnabled,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<JournalFont, String> get journalFont =>
      $composableBuilder(
        column: $table.journalFont,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<JournalAlignment, String>
  get journalAlignment => $composableBuilder(
    column: $table.journalAlignment,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questsPerDay => $composableBuilder(
    column: $table.questsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get morningReminderMin => $composableBuilder(
    column: $table.morningReminderMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eveningReminderMin => $composableBuilder(
    column: $table.eveningReminderMin,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingsRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> liquidFillEnabled = const Value.absent(),
                Value<JournalFont> journalFont = const Value.absent(),
                Value<JournalAlignment> journalAlignment = const Value.absent(),
                Value<int> questsPerDay = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> morningReminderMin = const Value.absent(),
                Value<int> eveningReminderMin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                liquidFillEnabled: liquidFillEnabled,
                journalFont: journalFont,
                journalAlignment: journalAlignment,
                questsPerDay: questsPerDay,
                notificationsEnabled: notificationsEnabled,
                morningReminderMin: morningReminderMin,
                eveningReminderMin: eveningReminderMin,
                createdAt: createdAt,
                lastModified: lastModified,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> liquidFillEnabled = const Value.absent(),
                Value<JournalFont> journalFont = const Value.absent(),
                Value<JournalAlignment> journalAlignment = const Value.absent(),
                Value<int> questsPerDay = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> morningReminderMin = const Value.absent(),
                Value<int> eveningReminderMin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                liquidFillEnabled: liquidFillEnabled,
                journalFont: journalFont,
                journalAlignment: journalAlignment,
                questsPerDay: questsPerDay,
                notificationsEnabled: notificationsEnabled,
                morningReminderMin: morningReminderMin,
                eveningReminderMin: eveningReminderMin,
                createdAt: createdAt,
                lastModified: lastModified,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingsRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingsRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$QuestsTableCreateCompanionBuilder =
    QuestsCompanion Function({
      Value<String> id,
      required String title,
      Value<String?> description,
      required QuestCategory category,
      required QuestSource source,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });
typedef $$QuestsTableUpdateCompanionBuilder =
    QuestsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<QuestCategory> category,
      Value<QuestSource> source,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

final class $$QuestsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestsTable, Quest> {
  $$QuestsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuestCompletionsTable, List<QuestCompletion>>
  _questCompletionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.questCompletions,
    aliasName: $_aliasNameGenerator(db.quests.id, db.questCompletions.questId),
  );

  $$QuestCompletionsTableProcessedTableManager get questCompletionsRefs {
    final manager = $$QuestCompletionsTableTableManager(
      $_db,
      $_db.questCompletions,
    ).filter((f) => f.questId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _questCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DailyQuestRollsTable, List<DailyQuestRoll>>
  _dailyQuestRollsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyQuestRolls,
    aliasName: $_aliasNameGenerator(db.quests.id, db.dailyQuestRolls.questId),
  );

  $$DailyQuestRollsTableProcessedTableManager get dailyQuestRollsRefs {
    final manager = $$DailyQuestRollsTableTableManager(
      $_db,
      $_db.dailyQuestRolls,
    ).filter((f) => f.questId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyQuestRollsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuestsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestCategory, QuestCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestSource, QuestSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> questCompletionsRefs(
    Expression<bool> Function($$QuestCompletionsTableFilterComposer f) f,
  ) {
    final $$QuestCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questCompletions,
      getReferencedColumn: (t) => t.questId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.questCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyQuestRollsRefs(
    Expression<bool> Function($$DailyQuestRollsTableFilterComposer f) f,
  ) {
    final $$DailyQuestRollsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyQuestRolls,
      getReferencedColumn: (t) => t.questId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyQuestRollsTableFilterComposer(
            $db: $db,
            $table: $db.dailyQuestRolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QuestCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QuestSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  Expression<T> questCompletionsRefs<T extends Object>(
    Expression<T> Function($$QuestCompletionsTableAnnotationComposer a) f,
  ) {
    final $$QuestCompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questCompletions,
      getReferencedColumn: (t) => t.questId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestCompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dailyQuestRollsRefs<T extends Object>(
    Expression<T> Function($$DailyQuestRollsTableAnnotationComposer a) f,
  ) {
    final $$DailyQuestRollsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyQuestRolls,
      getReferencedColumn: (t) => t.questId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyQuestRollsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyQuestRolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestsTable,
          Quest,
          $$QuestsTableFilterComposer,
          $$QuestsTableOrderingComposer,
          $$QuestsTableAnnotationComposer,
          $$QuestsTableCreateCompanionBuilder,
          $$QuestsTableUpdateCompanionBuilder,
          (Quest, $$QuestsTableReferences),
          Quest,
          PrefetchHooks Function({
            bool questCompletionsRefs,
            bool dailyQuestRollsRefs,
          })
        > {
  $$QuestsTableTableManager(_$AppDatabase db, $QuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<QuestCategory> category = const Value.absent(),
                Value<QuestSource> source = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestsCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                source: source,
                isActive: isActive,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required QuestCategory category,
                required QuestSource source,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestsCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                source: source,
                isActive: isActive,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$QuestsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({questCompletionsRefs = false, dailyQuestRollsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (questCompletionsRefs) db.questCompletions,
                    if (dailyQuestRollsRefs) db.dailyQuestRolls,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (questCompletionsRefs)
                        await $_getPrefetchedData<
                          Quest,
                          $QuestsTable,
                          QuestCompletion
                        >(
                          currentTable: table,
                          referencedTable: $$QuestsTableReferences
                              ._questCompletionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestsTableReferences(
                                db,
                                table,
                                p0,
                              ).questCompletionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyQuestRollsRefs)
                        await $_getPrefetchedData<
                          Quest,
                          $QuestsTable,
                          DailyQuestRoll
                        >(
                          currentTable: table,
                          referencedTable: $$QuestsTableReferences
                              ._dailyQuestRollsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestsTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyQuestRollsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestsTable,
      Quest,
      $$QuestsTableFilterComposer,
      $$QuestsTableOrderingComposer,
      $$QuestsTableAnnotationComposer,
      $$QuestsTableCreateCompanionBuilder,
      $$QuestsTableUpdateCompanionBuilder,
      (Quest, $$QuestsTableReferences),
      Quest,
      PrefetchHooks Function({
        bool questCompletionsRefs,
        bool dailyQuestRollsRefs,
      })
    >;
typedef $$QuestCompletionsTableCreateCompanionBuilder =
    QuestCompletionsCompanion Function({
      Value<String> id,
      required String questId,
      required DateTime completedAt,
      required DateTime date,
      Value<int> leAwarded,
      required QuestCategory categoryAtCompletion,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });
typedef $$QuestCompletionsTableUpdateCompanionBuilder =
    QuestCompletionsCompanion Function({
      Value<String> id,
      Value<String> questId,
      Value<DateTime> completedAt,
      Value<DateTime> date,
      Value<int> leAwarded,
      Value<QuestCategory> categoryAtCompletion,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

final class $$QuestCompletionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuestCompletionsTable, QuestCompletion> {
  $$QuestCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuestsTable _questIdTable(_$AppDatabase db) => db.quests.createAlias(
    $_aliasNameGenerator(db.questCompletions.questId, db.quests.id),
  );

  $$QuestsTableProcessedTableManager get questId {
    final $_column = $_itemColumn<String>('quest_id')!;

    final manager = $$QuestsTableTableManager(
      $_db,
      $_db.quests,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuestCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestCompletionsTable> {
  $$QuestCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leAwarded => $composableBuilder(
    column: $table.leAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestCategory, QuestCategory, String>
  get categoryAtCompletion => $composableBuilder(
    column: $table.categoryAtCompletion,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  $$QuestsTableFilterComposer get questId {
    final $$QuestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questId,
      referencedTable: $db.quests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestsTableFilterComposer(
            $db: $db,
            $table: $db.quests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestCompletionsTable> {
  $$QuestCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leAwarded => $composableBuilder(
    column: $table.leAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryAtCompletion => $composableBuilder(
    column: $table.categoryAtCompletion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuestsTableOrderingComposer get questId {
    final $$QuestsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questId,
      referencedTable: $db.quests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestsTableOrderingComposer(
            $db: $db,
            $table: $db.quests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestCompletionsTable> {
  $$QuestCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get leAwarded =>
      $composableBuilder(column: $table.leAwarded, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QuestCategory, String>
  get categoryAtCompletion => $composableBuilder(
    column: $table.categoryAtCompletion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  $$QuestsTableAnnotationComposer get questId {
    final $$QuestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questId,
      referencedTable: $db.quests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestsTableAnnotationComposer(
            $db: $db,
            $table: $db.quests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestCompletionsTable,
          QuestCompletion,
          $$QuestCompletionsTableFilterComposer,
          $$QuestCompletionsTableOrderingComposer,
          $$QuestCompletionsTableAnnotationComposer,
          $$QuestCompletionsTableCreateCompanionBuilder,
          $$QuestCompletionsTableUpdateCompanionBuilder,
          (QuestCompletion, $$QuestCompletionsTableReferences),
          QuestCompletion,
          PrefetchHooks Function({bool questId})
        > {
  $$QuestCompletionsTableTableManager(
    _$AppDatabase db,
    $QuestCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> questId = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> leAwarded = const Value.absent(),
                Value<QuestCategory> categoryAtCompletion =
                    const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestCompletionsCompanion(
                id: id,
                questId: questId,
                completedAt: completedAt,
                date: date,
                leAwarded: leAwarded,
                categoryAtCompletion: categoryAtCompletion,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String questId,
                required DateTime completedAt,
                required DateTime date,
                Value<int> leAwarded = const Value.absent(),
                required QuestCategory categoryAtCompletion,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestCompletionsCompanion.insert(
                id: id,
                questId: questId,
                completedAt: completedAt,
                date: date,
                leAwarded: leAwarded,
                categoryAtCompletion: categoryAtCompletion,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({questId = false}) {
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
                    if (questId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questId,
                                referencedTable:
                                    $$QuestCompletionsTableReferences
                                        ._questIdTable(db),
                                referencedColumn:
                                    $$QuestCompletionsTableReferences
                                        ._questIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$QuestCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestCompletionsTable,
      QuestCompletion,
      $$QuestCompletionsTableFilterComposer,
      $$QuestCompletionsTableOrderingComposer,
      $$QuestCompletionsTableAnnotationComposer,
      $$QuestCompletionsTableCreateCompanionBuilder,
      $$QuestCompletionsTableUpdateCompanionBuilder,
      (QuestCompletion, $$QuestCompletionsTableReferences),
      QuestCompletion,
      PrefetchHooks Function({bool questId})
    >;
typedef $$DailyQuestRollsTableCreateCompanionBuilder =
    DailyQuestRollsCompanion Function({
      Value<String> id,
      required String questId,
      required DateTime date,
      required DateTime rolledAt,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });
typedef $$DailyQuestRollsTableUpdateCompanionBuilder =
    DailyQuestRollsCompanion Function({
      Value<String> id,
      Value<String> questId,
      Value<DateTime> date,
      Value<DateTime> rolledAt,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

final class $$DailyQuestRollsTableReferences
    extends
        BaseReferences<_$AppDatabase, $DailyQuestRollsTable, DailyQuestRoll> {
  $$DailyQuestRollsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuestsTable _questIdTable(_$AppDatabase db) => db.quests.createAlias(
    $_aliasNameGenerator(db.dailyQuestRolls.questId, db.quests.id),
  );

  $$QuestsTableProcessedTableManager get questId {
    final $_column = $_itemColumn<String>('quest_id')!;

    final manager = $$QuestsTableTableManager(
      $_db,
      $_db.quests,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyQuestRollsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyQuestRollsTable> {
  $$DailyQuestRollsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get rolledAt => $composableBuilder(
    column: $table.rolledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  $$QuestsTableFilterComposer get questId {
    final $$QuestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questId,
      referencedTable: $db.quests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestsTableFilterComposer(
            $db: $db,
            $table: $db.quests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestRollsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyQuestRollsTable> {
  $$DailyQuestRollsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get rolledAt => $composableBuilder(
    column: $table.rolledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuestsTableOrderingComposer get questId {
    final $$QuestsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questId,
      referencedTable: $db.quests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestsTableOrderingComposer(
            $db: $db,
            $table: $db.quests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestRollsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyQuestRollsTable> {
  $$DailyQuestRollsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get rolledAt =>
      $composableBuilder(column: $table.rolledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  $$QuestsTableAnnotationComposer get questId {
    final $$QuestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questId,
      referencedTable: $db.quests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestsTableAnnotationComposer(
            $db: $db,
            $table: $db.quests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestRollsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyQuestRollsTable,
          DailyQuestRoll,
          $$DailyQuestRollsTableFilterComposer,
          $$DailyQuestRollsTableOrderingComposer,
          $$DailyQuestRollsTableAnnotationComposer,
          $$DailyQuestRollsTableCreateCompanionBuilder,
          $$DailyQuestRollsTableUpdateCompanionBuilder,
          (DailyQuestRoll, $$DailyQuestRollsTableReferences),
          DailyQuestRoll,
          PrefetchHooks Function({bool questId})
        > {
  $$DailyQuestRollsTableTableManager(
    _$AppDatabase db,
    $DailyQuestRollsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyQuestRollsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyQuestRollsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyQuestRollsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> questId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> rolledAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestRollsCompanion(
                id: id,
                questId: questId,
                date: date,
                rolledAt: rolledAt,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String questId,
                required DateTime date,
                required DateTime rolledAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestRollsCompanion.insert(
                id: id,
                questId: questId,
                date: date,
                rolledAt: rolledAt,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyQuestRollsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({questId = false}) {
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
                    if (questId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questId,
                                referencedTable:
                                    $$DailyQuestRollsTableReferences
                                        ._questIdTable(db),
                                referencedColumn:
                                    $$DailyQuestRollsTableReferences
                                        ._questIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$DailyQuestRollsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyQuestRollsTable,
      DailyQuestRoll,
      $$DailyQuestRollsTableFilterComposer,
      $$DailyQuestRollsTableOrderingComposer,
      $$DailyQuestRollsTableAnnotationComposer,
      $$DailyQuestRollsTableCreateCompanionBuilder,
      $$DailyQuestRollsTableUpdateCompanionBuilder,
      (DailyQuestRoll, $$DailyQuestRollsTableReferences),
      DailyQuestRoll,
      PrefetchHooks Function({bool questId})
    >;
typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> id,
      required String title,
      Value<String?> description,
      required HabitType type,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<HabitType> type,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, Habit> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitLogsTable, List<HabitLog>>
  _habitLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitLogs,
    aliasName: $_aliasNameGenerator(db.habits.id, db.habitLogs.habitId),
  );

  $$HabitLogsTableProcessedTableManager get habitLogsRefs {
    final manager = $$HabitLogsTableTableManager(
      $_db,
      $_db.habitLogs,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HabitType, HabitType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitLogsRefs(
    Expression<bool> Function($$HabitLogsTableFilterComposer f) f,
  ) {
    final $$HabitLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogsTableFilterComposer(
            $db: $db,
            $table: $db.habitLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HabitType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  Expression<T> habitLogsRefs<T extends Object>(
    Expression<T> Function($$HabitLogsTableAnnotationComposer a) f,
  ) {
    final $$HabitLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.habitLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, $$HabitsTableReferences),
          Habit,
          PrefetchHooks Function({bool habitLogsRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<HabitType> type = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                title: title,
                description: description,
                type: type,
                isActive: isActive,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required HabitType type,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                title: title,
                description: description,
                type: type,
                isActive: isActive,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (habitLogsRefs) db.habitLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitLogsRefs)
                    await $_getPrefetchedData<Habit, $HabitsTable, HabitLog>(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._habitLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HabitsTableReferences(db, table, p0).habitLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, $$HabitsTableReferences),
      Habit,
      PrefetchHooks Function({bool habitLogsRefs})
    >;
typedef $$HabitLogsTableCreateCompanionBuilder =
    HabitLogsCompanion Function({
      Value<String> id,
      required String habitId,
      required DateTime date,
      required HabitLogStatus status,
      Value<int> leAwarded,
      required DateTime loggedAt,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });
typedef $$HabitLogsTableUpdateCompanionBuilder =
    HabitLogsCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<DateTime> date,
      Value<HabitLogStatus> status,
      Value<int> leAwarded,
      Value<DateTime> loggedAt,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

final class $$HabitLogsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitLogsTable, HabitLog> {
  $$HabitLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) => db.habits.createAlias(
    $_aliasNameGenerator(db.habitLogs.habitId, db.habits.id),
  );

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HabitLogStatus, HabitLogStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get leAwarded => $composableBuilder(
    column: $table.leAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leAwarded => $composableBuilder(
    column: $table.leAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HabitLogStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get leAwarded =>
      $composableBuilder(column: $table.leAwarded, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitLogsTable,
          HabitLog,
          $$HabitLogsTableFilterComposer,
          $$HabitLogsTableOrderingComposer,
          $$HabitLogsTableAnnotationComposer,
          $$HabitLogsTableCreateCompanionBuilder,
          $$HabitLogsTableUpdateCompanionBuilder,
          (HabitLog, $$HabitLogsTableReferences),
          HabitLog,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitLogsTableTableManager(_$AppDatabase db, $HabitLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<HabitLogStatus> status = const Value.absent(),
                Value<int> leAwarded = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitLogsCompanion(
                id: id,
                habitId: habitId,
                date: date,
                status: status,
                leAwarded: leAwarded,
                loggedAt: loggedAt,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String habitId,
                required DateTime date,
                required HabitLogStatus status,
                Value<int> leAwarded = const Value.absent(),
                required DateTime loggedAt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitLogsCompanion.insert(
                id: id,
                habitId: habitId,
                date: date,
                status: status,
                leAwarded: leAwarded,
                loggedAt: loggedAt,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
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
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable: $$HabitLogsTableReferences
                                    ._habitIdTable(db),
                                referencedColumn: $$HabitLogsTableReferences
                                    ._habitIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$HabitLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitLogsTable,
      HabitLog,
      $$HabitLogsTableFilterComposer,
      $$HabitLogsTableOrderingComposer,
      $$HabitLogsTableAnnotationComposer,
      $$HabitLogsTableCreateCompanionBuilder,
      $$HabitLogsTableUpdateCompanionBuilder,
      (HabitLog, $$HabitLogsTableReferences),
      HabitLog,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      required String title,
      Value<String?> description,
      required DateTime dueDate,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<DateTime> dueDate,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                completedAt: completedAt,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required DateTime dueDate,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                completedAt: completedAt,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<String> id,
      required DateTime date,
      Value<String> body,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> body,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                date: date,
                body: body,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required DateTime date,
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                date: date,
                body: body,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;
typedef $$TreesTableCreateCompanionBuilder =
    TreesCompanion Function({
      Value<String> id,
      required QuestCategory category,
      required DateTime plantedAt,
      required int levelAtPlanting,
      required double positionX,
      required double positionY,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });
typedef $$TreesTableUpdateCompanionBuilder =
    TreesCompanion Function({
      Value<String> id,
      Value<QuestCategory> category,
      Value<DateTime> plantedAt,
      Value<int> levelAtPlanting,
      Value<double> positionX,
      Value<double> positionY,
      Value<DateTime> createdAt,
      Value<DateTime> lastModified,
      Value<int> rowid,
    });

class $$TreesTableFilterComposer extends Composer<_$AppDatabase, $TreesTable> {
  $$TreesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestCategory, QuestCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get plantedAt => $composableBuilder(
    column: $table.plantedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelAtPlanting => $composableBuilder(
    column: $table.levelAtPlanting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get positionX => $composableBuilder(
    column: $table.positionX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get positionY => $composableBuilder(
    column: $table.positionY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TreesTableOrderingComposer
    extends Composer<_$AppDatabase, $TreesTable> {
  $$TreesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plantedAt => $composableBuilder(
    column: $table.plantedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelAtPlanting => $composableBuilder(
    column: $table.levelAtPlanting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get positionX => $composableBuilder(
    column: $table.positionX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get positionY => $composableBuilder(
    column: $table.positionY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TreesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreesTable> {
  $$TreesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QuestCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get plantedAt =>
      $composableBuilder(column: $table.plantedAt, builder: (column) => column);

  GeneratedColumn<int> get levelAtPlanting => $composableBuilder(
    column: $table.levelAtPlanting,
    builder: (column) => column,
  );

  GeneratedColumn<double> get positionX =>
      $composableBuilder(column: $table.positionX, builder: (column) => column);

  GeneratedColumn<double> get positionY =>
      $composableBuilder(column: $table.positionY, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );
}

class $$TreesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreesTable,
          TreeRow,
          $$TreesTableFilterComposer,
          $$TreesTableOrderingComposer,
          $$TreesTableAnnotationComposer,
          $$TreesTableCreateCompanionBuilder,
          $$TreesTableUpdateCompanionBuilder,
          (TreeRow, BaseReferences<_$AppDatabase, $TreesTable, TreeRow>),
          TreeRow,
          PrefetchHooks Function()
        > {
  $$TreesTableTableManager(_$AppDatabase db, $TreesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<QuestCategory> category = const Value.absent(),
                Value<DateTime> plantedAt = const Value.absent(),
                Value<int> levelAtPlanting = const Value.absent(),
                Value<double> positionX = const Value.absent(),
                Value<double> positionY = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TreesCompanion(
                id: id,
                category: category,
                plantedAt: plantedAt,
                levelAtPlanting: levelAtPlanting,
                positionX: positionX,
                positionY: positionY,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required QuestCategory category,
                required DateTime plantedAt,
                required int levelAtPlanting,
                required double positionX,
                required double positionY,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TreesCompanion.insert(
                id: id,
                category: category,
                plantedAt: plantedAt,
                levelAtPlanting: levelAtPlanting,
                positionX: positionX,
                positionY: positionY,
                createdAt: createdAt,
                lastModified: lastModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TreesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreesTable,
      TreeRow,
      $$TreesTableFilterComposer,
      $$TreesTableOrderingComposer,
      $$TreesTableAnnotationComposer,
      $$TreesTableCreateCompanionBuilder,
      $$TreesTableUpdateCompanionBuilder,
      (TreeRow, BaseReferences<_$AppDatabase, $TreesTable, TreeRow>),
      TreeRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppStateTableTableManager get appState =>
      $$AppStateTableTableManager(_db, _db.appState);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$QuestsTableTableManager get quests =>
      $$QuestsTableTableManager(_db, _db.quests);
  $$QuestCompletionsTableTableManager get questCompletions =>
      $$QuestCompletionsTableTableManager(_db, _db.questCompletions);
  $$DailyQuestRollsTableTableManager get dailyQuestRolls =>
      $$DailyQuestRollsTableTableManager(_db, _db.dailyQuestRolls);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitLogsTableTableManager get habitLogs =>
      $$HabitLogsTableTableManager(_db, _db.habitLogs);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$TreesTableTableManager get trees =>
      $$TreesTableTableManager(_db, _db.trees);
}
