import 'package:database_wrapper/src/wrappers/drift/drift_wrapper.dart';
import 'package:database_wrapper/src/wrappers/drift/migrations/schemas_versions/schema_versions.dart';
import 'package:drift/drift.dart';

class DriftMigratorWrapper {
  DriftMigratorWrapper(DriftWrapper driftWrapper)
    : _driftWrapper = driftWrapper;

  final DriftWrapper _driftWrapper;

  late final MigrationStrategy migrationStrategy = MigrationStrategy(
    beforeOpen: (details) async {
      // final EventEntityCompanion companion = EventEntityCompanion.insert(
      //   title: "title test",
      //   date: DateTime(2022, 1, 1),
      //   location: "location test",
      // );

      // final id = await _driftWrapper.eventEntity.insertOne(
      //   companion,
      //   onConflict: DoNothing(
      //     target: [
      //       _driftWrapper.eventEntity.title,
      //       _driftWrapper.eventEntity.date,
      //       _driftWrapper.eventEntity.location,
      //     ],
      //   ),
      // );

      // print("Inserted id: $id");
    },
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // NOTE: manual migration because `alterTable` is not available for postgres
        await _driftWrapper.customStatement(
          "ALTER TABLE event_entity ADD UNIQUE (title, date, location);",
        );
      },
      from2To3: (m, schema) async {
        await m.createTable(schema.authEntity);
      },
    ),
  );
}
