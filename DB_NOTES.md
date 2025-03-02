1. INSTALL DEPS
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


- database wrapper