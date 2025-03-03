import 'package:drift/drift.dart';
import 'package:u_puli_api/src/wrappers/drift/drift_wrapper.dart';
import 'package:u_puli_api/src/wrappers/drift/migrations/schemas_versions/schema_versions.dart';

class DriftMigratorWrapper {
  DriftMigratorWrapper(DriftWrapper driftWrapper)
      : _driftWrapper = driftWrapper;

  final DriftWrapper _driftWrapper;

  late final MigrationStrategy migrationStrategy = MigrationStrategy(
      beforeOpen: (details) async {
        final EventEntityCompanion companion = EventEntityCompanion.insert(
          title: "title test",
          date: DateTime.now(),
          location: "location test",
        );

        final id = await _driftWrapper.eventEntity.insertOne(companion);

        print("Inserted event entity with id: $id");
      },
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: stepByStep());
}
