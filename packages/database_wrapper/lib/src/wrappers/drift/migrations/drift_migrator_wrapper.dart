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
        url:
            "https://unsplash.com/photos/woman-in-white-and-black-striped-shirt-standing-on-yellow-sunflower-field-during-daytime-RNiBLy7aHck",
        imageUrl:
            "https://images.unsplash.com/photo-1591035897819-f4bdf739f446?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        description: "description test",
      );

      final id = await _driftWrapper.eventEntity.insertOne(
        companion,
        onConflict: DoNothing(
          target: [
            _driftWrapper.eventEntity.title,
            _driftWrapper.eventEntity.date,
            _driftWrapper.eventEntity.location,
            _driftWrapper.eventEntity.url,
            _driftWrapper.eventEntity.imageUrl,
            _driftWrapper.eventEntity.description,
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
      from5To6: (m, schema) async {
        await m.addColumn(schema.eventEntity, schema.eventEntity.url);
        await m.addColumn(schema.eventEntity, schema.eventEntity.imageUrl);
      },
      from6To7: (m, schema) async {
        // this as a reference: https://stackoverflow.com/a/63733203/9661910
        await m.database.customStatement(
          'ALTER TABLE event_entity DROP CONSTRAINT IF EXISTS event_entity_title_date_location_key;',
        );

        await m.database.customStatement(
          'ALTER TABLE event_entity ADD CONSTRAINT event_entity_title_date_location_url_image_url_key UNIQUE (title, date, location, url, image_url);',
        );
      },
      from7To8: (m, schema) async {
        await m.addColumn(schema.eventEntity, schema.eventEntity.description);
      },
      from8To9: (m, schema) async {
        await m.database.customStatement(
          'ALTER TABLE event_entity DROP CONSTRAINT IF EXISTS event_entity_title_date_location_url_image_url_key;',
        );

        await m.database.customStatement(
          'ALTER TABLE event_entity ADD CONSTRAINT event_entity_title_date_location_url_image_url_description_key UNIQUE (title, date, location, url, image_url, description);',
        );
      },
    ),
  );
}
