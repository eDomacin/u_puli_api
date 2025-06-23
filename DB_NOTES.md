1. INSTALL DEPS
+   postgres: ^3.5.4   
1. install postgres dep
2. add build.yaml with only postgres 
3. create table and database like this 
- table 

import 'package:drift/drift.dart';

class EventEnwtity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text()();

  // TODO add all except id to combined unique index in a migration later
  // @override
  // List<Set<Column<Object>>>? get uniqueKeys => [
  //       {
  //         title,
  //         date,
  //         location,
  //       }
  //     ];
}

- migrator wrapper

class DriftMigratorWrapper {
  final MigrationStrategy migrationStrategy = MigrationStrategy();
}

- drift wrapper 

import 'package:drift/drift.dart';
import 'package:u_puli_api/src/features/events/data/entities/event_entity.dart';
import 'package:u_puli_api/src/wrappers/drift/migrations/drift_migrator_wrapper.dart';

part "drift_wrapper.g.dart";

@DriftDatabase(tables: [
  EventEntity,
], queries: {
  "current_timestamp": "SELECT CURRENT_TIMESTAMP;",
})
class DriftWrapper extends _$DriftWrapper {
  // TODO check if this can be constant
  DriftWrapper(super.e);

  final DriftMigratorWrapper _migratorWrapper = DriftMigratorWrapper();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => _migratorWrapper.migrationStrategy;
}

- add makefile stuff
.PHONY: default dart_version
default: welcome

welcome:
	@echo "Welcome to 'U Puli api' project"

dart_version: 
	dart --version

generate:
	dart run build_runner build --delete-conflicting-outputs

- run code gen

- then create queryexecutre for psql


class PsqlQueryExecutorWrapper {
  const PsqlQueryExecutorWrapper(EnvVarsDBWrapper envVarsDBWrapper)
      : _envVarsDBWrapper = envVarsDBWrapper;

  final EnvVarsDBWrapper _envVarsDBWrapper;

  QueryExecutor get queryExecuter {
    final PgDatabase pgDatabase = PgDatabase(
      endpoint: Endpoint(
        host: _envVarsDBWrapper.pgHost,
        port: _envVarsDBWrapper.pgPort,
        username: _envVarsDBWrapper.pgUser,
        password: _envVarsDBWrapper.pgPassword,
        database: _envVarsDBWrapper.pgDatabase,
      ),
      settings: ConnectionSettings(
        sslMode: SslMode.require,
        onOpen: (connection) async {
          print("Connected to database");
        },
      ),
    );

    return pgDatabase;
  }
}


- create database wrapper

class DatabaseWrapper {
  DatabaseWrapper._(this._executor);
  final QueryExecutor _executor;

  factory DatabaseWrapper.app({
    required EnvVarsDBWrapper envVarsDBWrapper,
  }) {
    final PsqlQueryExecutorWrapper executor =
        PsqlQueryExecutorWrapper(envVarsDBWrapper);

    return DatabaseWrapper._(executor.queryExecuter);
  }

  late final DriftWrapper driftWrapper;

  void initialize() {
    try {
      driftWrapper = DriftWrapper(_executor);
    } catch (e) {
      print("There was an error initializing the database: $e");
      rethrow;
    }
  }

  // repos
  $EventEntityTable get eventsRepo => driftWrapper.eventEntity;
}

!!! IMPORTANT !!!
- have to make this initial migration steps first, before connecting to db first time
- if not, when try to insert firest data, it will say no table present
- if this happen, delete schema table from db, and start over


- make initial migration
- prepare first sczema from here - https://drift.simonbinder.eu/Migrations/exports/
- create folder for drfit schemas 
-- somwhere in migrations folder
- create folder for scheam versions
-- somwhere in migrations folder

- then you have command to generate db schema
generate_db_schema:
	dart run drift_dev schema dump lib/src/wrappers/drift/drift_wrapper.dart lib/src/wrappers/drift/migrations/schemas/



- now command for migrations steps
generate_db_migration_steps: 
	dart run drift_dev schema steps lib/src/wrappers/drift/migrations/schemas/ lib/src/wrappers/drift/migrations/schemas_versions/schema_versions.dart

- and then run it


- adjust migrator

class DriftMigratorWrapper {
  DriftMigratorWrapper(DriftWrapper driftWrapper)
      : _driftWrapper = driftWrapper;

  final DriftWrapper _driftWrapper;

  late final MigrationStrategy migrationStrategy = MigrationStrategy(
      beforeOpen: (details) async {
      },
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: stepByStep());
}




- add migrations
-- need create migration for version 1
- and then for version 2


--------
- add database for tests
-- need docker compose for this

version: '3.8'
services:
  postgres:
    container_name: container_postgres
    image: postgres:15.7
    hostname: localhost
    ports:
      - '5432:5432'
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: root
      POSTGRES_DB: defaultdb
    # TODO maybe no need to mount volume for tests - we will see
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

# TODO not needed for now
# pgadmin:
#   container_name: container-pgadmin
#   image: dpage/pgadmin4
#   depends_on:
#     - postgres
#   ports:
#     - '5050:80'
#   environment:
#     PGADMIN_DEFAULT_EMAIL: admin@admin.com
#     PGADMIN_DEFAULT_PASSWORD: root
#   restart: unless-stopped

# might not be needed
volumes:
  postgres-data:

<!-- -------------- -->
## How to do db migrations v2
1. make sure version 1 schema exists
   1. wiuth migration 1
   2. if not, create it with maake generate_migrations_schema
2. make changes 
- add new table
- or add new column
- or change column type
- - or some such
- add table to app database
  - it might show some const constructor error - restart VSC
1. increase "schemaVersion" on AppDatabase by 1
<!-- 2. run make generate --> -> maybe not this
1. run the following command
```
make generate_migrations_schema
```
1. run the following command
```
make generate_migrations_steps
```
1. add next migration to migration_wrapper that matches your db modification. for example:
```
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // await m.addColumn(schema.users, schema.users.nickname);
        await m.createTable(schema.matchEntity);
      },
      from2To3: (m, schema) async {
        // await m.createTable(schema.somethingElse);
        await m.addColumn(schema.matchEntity, schema.matchEntity.title);
      },
    ),

```
6. run the following command
```
make generate
```
7. add in tests when delete this table now
- make sure it does not reference anything - if it does, you will have to delete its contents before deltingthe tabel that is referenced

<!-- TODO possibly deprecated -->
## How to do db migrations
1. make sure version 1 schema exists
   1. wiuth migration 1
   2. if not, create it with maake generate_migrations_schema
2. make changes 
- add new table
- or add new column
- or change column type
- - or some such
1. increase "schemaVersion" on AppDatabase by 1
<!-- 2. run make generate --> -> maybe not this
3. run the following command
```
maake generate_migrations_schema -> not this really 
```
1. run the following command
```
make generate_migrations_steps -> not this really
```

1. can run this to generate schema nad steps in one go
```make migrate_db
```
1. add next migration to migration_wrapper that matches your db modification. for example:
```
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // await m.addColumn(schema.users, schema.users.nickname);
        await m.createTable(schema.matchEntity);
      },
      from2To3: (m, schema) async {
        // await m.createTable(schema.somethingElse);
        await m.addColumn(schema.matchEntity, schema.matchEntity.title);
      },
    ),

```
6. run the following command
```
generate_db
```



