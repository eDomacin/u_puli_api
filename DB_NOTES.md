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





- add migrations