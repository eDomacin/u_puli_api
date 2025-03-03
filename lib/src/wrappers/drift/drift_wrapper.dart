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
  DriftWrapper(super.e);

  final DriftMigratorWrapper _migratorWrapper = DriftMigratorWrapper();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => _migratorWrapper.migrationStrategy;
}
