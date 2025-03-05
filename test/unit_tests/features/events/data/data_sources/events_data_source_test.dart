// import 'package:drift/drift.dart' hide isNull;
import 'package:database_wrapper/database_wrapper.dart' hide isNull;
import 'package:test/test.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source_impl.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';
import 'package:u_puli_api/src/features/events/utils/converters/events_converter.dart';

import '../../../../../helpers/database/test_database_wrapper.dart';

void main() {
  final TestDatabaseWrapper testDatabaseWrapper = getTestDatabaseWrapper();
  final EventsDataSource eventsDataSource = EventsDataSourceImpl(
    databaseWrapper: testDatabaseWrapper.databaseWrapper,
  );

  tearDown(() async {
    await testDatabaseWrapper.clearAll();
  });

  tearDownAll(() async {
    await testDatabaseWrapper.close();
  });

  group(
    EventsDataSource,
    () {
      group("getEvent", () {
        test(
          "given event does not exist in database "
          "when [getEvent] is called "
          "then should return null",
          () async {
            // setup

            // given

            // when
            final EventEntityValue? event = await eventsDataSource.getEvent(1);

            // then
            expect(event, isNull);

            // cleanup
          },
        );

        test(
          "given event exists in database "
          "when [getEvent] is called "
          "then should return expected event",
          () async {
            // setup
            final date = DateTime(2021, 1, 1);
            final EventEntityCompanion eventCompanion = EventEntityCompanion(
              id: Value(1),
              title: Value("title"),
              date: Value(date),
              location: Value("location"),
            );

            // given
            await testDatabaseWrapper.databaseWrapper.eventsRepo.insertOne(
              eventCompanion,
            );

            // when
            final EventEntityValue? event = await eventsDataSource.getEvent(1);

            // then
            final EventEntityValue value =
                EventsConverter.entityValueFromEntityData(
              entityData: EventEntityData(
                id: 1,
                title: "title",
                date: date,
                location: "location",
              ),
            );
            expect(event, equals(value));

            // cleanup
          },
        );
      });
    },
  );
}
