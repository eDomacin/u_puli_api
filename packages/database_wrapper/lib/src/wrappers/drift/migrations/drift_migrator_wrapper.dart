import 'package:database_wrapper/src/wrappers/drift/drift_wrapper.dart';
import 'package:database_wrapper/src/wrappers/drift/migrations/schemas_versions/schema_versions.dart';

class DriftMigratorWrapper {
  DriftMigratorWrapper(DriftWrapper driftWrapper)
    : _driftWrapper = driftWrapper;

  final DriftWrapper _driftWrapper;

  late final MigrationStrategy migrationStrategy = MigrationStrategy(
    beforeOpen: (details) async {
      final EventEntityCompanion companion = EventEntityCompanion.insert(
        title: "title test",
        date: DateTime(2022, 1, 1),
        location: "location test",
      );

      final id = await _driftWrapper.eventEntity.insertOne(
        companion,
        onConflict: DoNothing(
          target: [
            _driftWrapper.eventEntity.title,
            _driftWrapper.eventEntity.date,
            _driftWrapper.eventEntity.location,
          ],
        ),
      );

      print("Inserted id: $id");
    },
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // NOTE: manual migration because `alterTable` is not available for postgres
        // TODO driftWrapper not needed here - we can access customStatement on the m.database object
        await _driftWrapper.customStatement(
          "ALTER TABLE event_entity ADD UNIQUE (title, date, location);",
        );
      },
      from2To3: (m, schema) async {
        await m.createTable(schema.authEntity);
      },
      from3To4: (m, schema) async {
        await m.createTable(schema.userEntity);
      },
      from4To5: (m, schema) async {
        // index gets generated because we used the `@TableIndex` annotation
        // TODO but it does not work unfortunately - issues with the generated code - it generates SQLite specific code it seems
        // await m.createIndex(schema.userEntityAuthIdIdx);
        m.createIndex(
          Index.byDialect("user_entity_auth_id_idx", {
            SqlDialect.postgres:
                // TODO not sure why this needs to be IF NOT EXISTS - this migration should not run if the migraiton index in migration table is higher than this - do research on this
                "CREATE INDEX IF NOT EXISTS user_entity_auth_id_idx ON user_entity (auth_id);",
          }),
        );
      },
    ),
  );
}
