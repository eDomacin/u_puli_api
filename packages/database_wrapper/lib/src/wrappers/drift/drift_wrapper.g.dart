// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_wrapper.dart';

// ignore_for_file: type=lint
class $EventEntityTable extends EventEntity
    with TableInfo<$EventEntityTable, EventEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, date, location];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_entity';
  @override
  VerificationContext validateIntegrity(Insertable<EventEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {title, date, location},
      ];
  @override
  EventEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
    );
  }

  @override
  $EventEntityTable createAlias(String alias) {
    return $EventEntityTable(attachedDatabase, alias);
  }
}

class EventEntityData extends DataClass implements Insertable<EventEntityData> {
  final int id;
  final String title;
  final DateTime date;
  final String location;
  const EventEntityData(
      {required this.id,
      required this.title,
      required this.date,
      required this.location});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['date'] = Variable<DateTime>(date);
    map['location'] = Variable<String>(location);
    return map;
  }

  EventEntityCompanion toCompanion(bool nullToAbsent) {
    return EventEntityCompanion(
      id: Value(id),
      title: Value(title),
      date: Value(date),
      location: Value(location),
    );
  }

  factory EventEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventEntityData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      date: serializer.fromJson<DateTime>(json['date']),
      location: serializer.fromJson<String>(json['location']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'date': serializer.toJson<DateTime>(date),
      'location': serializer.toJson<String>(location),
    };
  }

  EventEntityData copyWith(
          {int? id, String? title, DateTime? date, String? location}) =>
      EventEntityData(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
        location: location ?? this.location,
      );
  EventEntityData copyWithCompanion(EventEntityCompanion data) {
    return EventEntityData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      date: data.date.present ? data.date.value : this.date,
      location: data.location.present ? data.location.value : this.location,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventEntityData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('location: $location')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, date, location);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventEntityData &&
          other.id == this.id &&
          other.title == this.title &&
          other.date == this.date &&
          other.location == this.location);
}

class EventEntityCompanion extends UpdateCompanion<EventEntityData> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> date;
  final Value<String> location;
  const EventEntityCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.location = const Value.absent(),
  });
  EventEntityCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime date,
    required String location,
  })  : title = Value(title),
        date = Value(date),
        location = Value(location);
  static Insertable<EventEntityData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? date,
    Expression<String>? location,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
      if (location != null) 'location': location,
    });
  }

  EventEntityCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<DateTime>? date,
      Value<String>? location}) {
    return EventEntityCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventEntityCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('location: $location')
          ..write(')'))
        .toString();
  }
}

class $AuthEntityTable extends AuthEntity
    with TableInfo<$AuthEntityTable, AuthEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authTypeMeta =
      const VerificationMeta('authType');
  @override
  late final GeneratedColumnWithTypeConverter<AuthType, int> authType =
      GeneratedColumn<int>('auth_type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AuthType>($AuthEntityTable.$converterauthType);
  @override
  List<GeneratedColumn> get $columns => [id, email, password, authType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_entity';
  @override
  VerificationContext validateIntegrity(Insertable<AuthEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    context.handle(_authTypeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password']),
      authType: $AuthEntityTable.$converterauthType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}auth_type'])!),
    );
  }

  @override
  $AuthEntityTable createAlias(String alias) {
    return $AuthEntityTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AuthType, int, int> $converterauthType =
      const EnumIndexConverter<AuthType>(AuthType.values);
}

class AuthEntityData extends DataClass implements Insertable<AuthEntityData> {
  final int id;
  final String email;
  final String? password;
  final AuthType authType;
  const AuthEntityData(
      {required this.id,
      required this.email,
      this.password,
      required this.authType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    {
      map['auth_type'] =
          Variable<int>($AuthEntityTable.$converterauthType.toSql(authType));
    }
    return map;
  }

  AuthEntityCompanion toCompanion(bool nullToAbsent) {
    return AuthEntityCompanion(
      id: Value(id),
      email: Value(email),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      authType: Value(authType),
    );
  }

  factory AuthEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthEntityData(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String?>(json['password']),
      authType: $AuthEntityTable.$converterauthType
          .fromJson(serializer.fromJson<int>(json['authType'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String?>(password),
      'authType': serializer
          .toJson<int>($AuthEntityTable.$converterauthType.toJson(authType)),
    };
  }

  AuthEntityData copyWith(
          {int? id,
          String? email,
          Value<String?> password = const Value.absent(),
          AuthType? authType}) =>
      AuthEntityData(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password.present ? password.value : this.password,
        authType: authType ?? this.authType,
      );
  AuthEntityData copyWithCompanion(AuthEntityCompanion data) {
    return AuthEntityData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      authType: data.authType.present ? data.authType.value : this.authType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthEntityData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('authType: $authType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, password, authType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthEntityData &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.authType == this.authType);
}

class AuthEntityCompanion extends UpdateCompanion<AuthEntityData> {
  final Value<int> id;
  final Value<String> email;
  final Value<String?> password;
  final Value<AuthType> authType;
  const AuthEntityCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.authType = const Value.absent(),
  });
  AuthEntityCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    this.password = const Value.absent(),
    required AuthType authType,
  })  : email = Value(email),
        authType = Value(authType);
  static Insertable<AuthEntityData> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<int>? authType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (authType != null) 'auth_type': authType,
    });
  }

  AuthEntityCompanion copyWith(
      {Value<int>? id,
      Value<String>? email,
      Value<String?>? password,
      Value<AuthType>? authType}) {
    return AuthEntityCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      authType: authType ?? this.authType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (authType.present) {
      map['auth_type'] = Variable<int>(
          $AuthEntityTable.$converterauthType.toSql(authType.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthEntityCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('authType: $authType')
          ..write(')'))
        .toString();
  }
}

class $UserEntityTable extends UserEntity
    with TableInfo<$UserEntityTable, UserEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authIdMeta = const VerificationMeta('authId');
  @override
  late final GeneratedColumn<int> authId = GeneratedColumn<int>(
      'auth_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, firstName, lastName, authId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_entity';
  @override
  VerificationContext validateIntegrity(Insertable<UserEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('auth_id')) {
      context.handle(_authIdMeta,
          authId.isAcceptableOrUnknown(data['auth_id']!, _authIdMeta));
    } else if (isInserting) {
      context.missing(_authIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      authId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}auth_id'])!,
    );
  }

  @override
  $UserEntityTable createAlias(String alias) {
    return $UserEntityTable(attachedDatabase, alias);
  }
}

class UserEntityData extends DataClass implements Insertable<UserEntityData> {
  final int id;
  final String firstName;
  final String lastName;
  final int authId;
  const UserEntityData(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.authId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['auth_id'] = Variable<int>(authId);
    return map;
  }

  UserEntityCompanion toCompanion(bool nullToAbsent) {
    return UserEntityCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      authId: Value(authId),
    );
  }

  factory UserEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntityData(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      authId: serializer.fromJson<int>(json['authId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'authId': serializer.toJson<int>(authId),
    };
  }

  UserEntityData copyWith(
          {int? id, String? firstName, String? lastName, int? authId}) =>
      UserEntityData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        authId: authId ?? this.authId,
      );
  UserEntityData copyWithCompanion(UserEntityCompanion data) {
    return UserEntityData(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      authId: data.authId.present ? data.authId.value : this.authId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntityData(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('authId: $authId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, firstName, lastName, authId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntityData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.authId == this.authId);
}

class UserEntityCompanion extends UpdateCompanion<UserEntityData> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<int> authId;
  const UserEntityCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.authId = const Value.absent(),
  });
  UserEntityCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    required int authId,
  })  : firstName = Value(firstName),
        lastName = Value(lastName),
        authId = Value(authId);
  static Insertable<UserEntityData> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<int>? authId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (authId != null) 'auth_id': authId,
    });
  }

  UserEntityCompanion copyWith(
      {Value<int>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<int>? authId}) {
    return UserEntityCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      authId: authId ?? this.authId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (authId.present) {
      map['auth_id'] = Variable<int>(authId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserEntityCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('authId: $authId')
          ..write(')'))
        .toString();
  }
}

abstract class _$DriftWrapper extends GeneratedDatabase {
  _$DriftWrapper(QueryExecutor e) : super(e);
  $DriftWrapperManager get managers => $DriftWrapperManager(this);
  late final $EventEntityTable eventEntity = $EventEntityTable(this);
  late final $AuthEntityTable authEntity = $AuthEntityTable(this);
  late final $UserEntityTable userEntity = $UserEntityTable(this);
  late final Index userEntityAuthIdIdx =
      Index.byDialect('user_entity_auth_id_idx', {
    SqlDialect.postgres:
        'CREATE INDEX user_entity_auth_id_idx ON user_entity (auth_id)',
    SqlDialect.sqlite:
        'CREATE INDEX user_entity_auth_id_idx ON user_entity (auth_id)',
  });
  Selectable<String> current_timestamp() {
    return customSelect('SELECT CURRENT_TIMESTAMP AS _c0',
        variables: [],
        readsFrom: {}).map((QueryRow row) => row.read<String>('_c0'));
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [eventEntity, authEntity, userEntity, userEntityAuthIdIdx];
}

typedef $$EventEntityTableCreateCompanionBuilder = EventEntityCompanion
    Function({
  Value<int> id,
  required String title,
  required DateTime date,
  required String location,
});
typedef $$EventEntityTableUpdateCompanionBuilder = EventEntityCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<DateTime> date,
  Value<String> location,
});

class $$EventEntityTableFilterComposer
    extends Composer<_$DriftWrapper, $EventEntityTable> {
  $$EventEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));
}

class $$EventEntityTableOrderingComposer
    extends Composer<_$DriftWrapper, $EventEntityTable> {
  $$EventEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));
}

class $$EventEntityTableAnnotationComposer
    extends Composer<_$DriftWrapper, $EventEntityTable> {
  $$EventEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);
}

class $$EventEntityTableTableManager extends RootTableManager<
    _$DriftWrapper,
    $EventEntityTable,
    EventEntityData,
    $$EventEntityTableFilterComposer,
    $$EventEntityTableOrderingComposer,
    $$EventEntityTableAnnotationComposer,
    $$EventEntityTableCreateCompanionBuilder,
    $$EventEntityTableUpdateCompanionBuilder,
    (
      EventEntityData,
      BaseReferences<_$DriftWrapper, $EventEntityTable, EventEntityData>
    ),
    EventEntityData,
    PrefetchHooks Function()> {
  $$EventEntityTableTableManager(_$DriftWrapper db, $EventEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventEntityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventEntityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventEntityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> location = const Value.absent(),
          }) =>
              EventEntityCompanion(
            id: id,
            title: title,
            date: date,
            location: location,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required DateTime date,
            required String location,
          }) =>
              EventEntityCompanion.insert(
            id: id,
            title: title,
            date: date,
            location: location,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EventEntityTableProcessedTableManager = ProcessedTableManager<
    _$DriftWrapper,
    $EventEntityTable,
    EventEntityData,
    $$EventEntityTableFilterComposer,
    $$EventEntityTableOrderingComposer,
    $$EventEntityTableAnnotationComposer,
    $$EventEntityTableCreateCompanionBuilder,
    $$EventEntityTableUpdateCompanionBuilder,
    (
      EventEntityData,
      BaseReferences<_$DriftWrapper, $EventEntityTable, EventEntityData>
    ),
    EventEntityData,
    PrefetchHooks Function()>;
typedef $$AuthEntityTableCreateCompanionBuilder = AuthEntityCompanion Function({
  Value<int> id,
  required String email,
  Value<String?> password,
  required AuthType authType,
});
typedef $$AuthEntityTableUpdateCompanionBuilder = AuthEntityCompanion Function({
  Value<int> id,
  Value<String> email,
  Value<String?> password,
  Value<AuthType> authType,
});

class $$AuthEntityTableFilterComposer
    extends Composer<_$DriftWrapper, $AuthEntityTable> {
  $$AuthEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AuthType, AuthType, int> get authType =>
      $composableBuilder(
          column: $table.authType,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$AuthEntityTableOrderingComposer
    extends Composer<_$DriftWrapper, $AuthEntityTable> {
  $$AuthEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get authType => $composableBuilder(
      column: $table.authType, builder: (column) => ColumnOrderings(column));
}

class $$AuthEntityTableAnnotationComposer
    extends Composer<_$DriftWrapper, $AuthEntityTable> {
  $$AuthEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AuthType, int> get authType =>
      $composableBuilder(column: $table.authType, builder: (column) => column);
}

class $$AuthEntityTableTableManager extends RootTableManager<
    _$DriftWrapper,
    $AuthEntityTable,
    AuthEntityData,
    $$AuthEntityTableFilterComposer,
    $$AuthEntityTableOrderingComposer,
    $$AuthEntityTableAnnotationComposer,
    $$AuthEntityTableCreateCompanionBuilder,
    $$AuthEntityTableUpdateCompanionBuilder,
    (
      AuthEntityData,
      BaseReferences<_$DriftWrapper, $AuthEntityTable, AuthEntityData>
    ),
    AuthEntityData,
    PrefetchHooks Function()> {
  $$AuthEntityTableTableManager(_$DriftWrapper db, $AuthEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthEntityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthEntityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthEntityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String?> password = const Value.absent(),
            Value<AuthType> authType = const Value.absent(),
          }) =>
              AuthEntityCompanion(
            id: id,
            email: email,
            password: password,
            authType: authType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String email,
            Value<String?> password = const Value.absent(),
            required AuthType authType,
          }) =>
              AuthEntityCompanion.insert(
            id: id,
            email: email,
            password: password,
            authType: authType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthEntityTableProcessedTableManager = ProcessedTableManager<
    _$DriftWrapper,
    $AuthEntityTable,
    AuthEntityData,
    $$AuthEntityTableFilterComposer,
    $$AuthEntityTableOrderingComposer,
    $$AuthEntityTableAnnotationComposer,
    $$AuthEntityTableCreateCompanionBuilder,
    $$AuthEntityTableUpdateCompanionBuilder,
    (
      AuthEntityData,
      BaseReferences<_$DriftWrapper, $AuthEntityTable, AuthEntityData>
    ),
    AuthEntityData,
    PrefetchHooks Function()>;
typedef $$UserEntityTableCreateCompanionBuilder = UserEntityCompanion Function({
  Value<int> id,
  required String firstName,
  required String lastName,
  required int authId,
});
typedef $$UserEntityTableUpdateCompanionBuilder = UserEntityCompanion Function({
  Value<int> id,
  Value<String> firstName,
  Value<String> lastName,
  Value<int> authId,
});

class $$UserEntityTableFilterComposer
    extends Composer<_$DriftWrapper, $UserEntityTable> {
  $$UserEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get authId => $composableBuilder(
      column: $table.authId, builder: (column) => ColumnFilters(column));
}

class $$UserEntityTableOrderingComposer
    extends Composer<_$DriftWrapper, $UserEntityTable> {
  $$UserEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get authId => $composableBuilder(
      column: $table.authId, builder: (column) => ColumnOrderings(column));
}

class $$UserEntityTableAnnotationComposer
    extends Composer<_$DriftWrapper, $UserEntityTable> {
  $$UserEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<int> get authId =>
      $composableBuilder(column: $table.authId, builder: (column) => column);
}

class $$UserEntityTableTableManager extends RootTableManager<
    _$DriftWrapper,
    $UserEntityTable,
    UserEntityData,
    $$UserEntityTableFilterComposer,
    $$UserEntityTableOrderingComposer,
    $$UserEntityTableAnnotationComposer,
    $$UserEntityTableCreateCompanionBuilder,
    $$UserEntityTableUpdateCompanionBuilder,
    (
      UserEntityData,
      BaseReferences<_$DriftWrapper, $UserEntityTable, UserEntityData>
    ),
    UserEntityData,
    PrefetchHooks Function()> {
  $$UserEntityTableTableManager(_$DriftWrapper db, $UserEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserEntityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserEntityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserEntityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<int> authId = const Value.absent(),
          }) =>
              UserEntityCompanion(
            id: id,
            firstName: firstName,
            lastName: lastName,
            authId: authId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String firstName,
            required String lastName,
            required int authId,
          }) =>
              UserEntityCompanion.insert(
            id: id,
            firstName: firstName,
            lastName: lastName,
            authId: authId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserEntityTableProcessedTableManager = ProcessedTableManager<
    _$DriftWrapper,
    $UserEntityTable,
    UserEntityData,
    $$UserEntityTableFilterComposer,
    $$UserEntityTableOrderingComposer,
    $$UserEntityTableAnnotationComposer,
    $$UserEntityTableCreateCompanionBuilder,
    $$UserEntityTableUpdateCompanionBuilder,
    (
      UserEntityData,
      BaseReferences<_$DriftWrapper, $UserEntityTable, UserEntityData>
    ),
    UserEntityData,
    PrefetchHooks Function()>;

class $DriftWrapperManager {
  final _$DriftWrapper _db;
  $DriftWrapperManager(this._db);
  $$EventEntityTableTableManager get eventEntity =>
      $$EventEntityTableTableManager(_db, _db.eventEntity);
  $$AuthEntityTableTableManager get authEntity =>
      $$AuthEntityTableTableManager(_db, _db.authEntity);
  $$UserEntityTableTableManager get userEntity =>
      $$UserEntityTableTableManager(_db, _db.userEntity);
}
