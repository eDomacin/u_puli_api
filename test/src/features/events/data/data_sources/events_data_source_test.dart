// import 'package:drift/drift.dart' hide isNull;
import 'package:database_wrapper/database_wrapper.dart'
    hide isNull, EventsConverter;
import 'package:test/test.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source_impl.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';
import 'package:u_puli_api/src/features/events/utils/converters/events_converter.dart';
import 'package:u_puli_api/src/features/events/utils/values/get_events_filter_value.dart';

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

  group(EventsDataSource, () {
    group("getEvents", () {
      test("given events do not exist in database "
          "when [getEvents] is called "
          "then should return empty list", () async {
        // setup

        // given

        // when
        final List<EventEntityValue> events = await eventsDataSource.getEvents(
          filter: const GetEventsFilterValue(),
        );

        // then
        expect(events, isEmpty);

        // cleanup
      });

      test("given events exist in database "
          "when [getEvents] is called "
          "then should expected list ", () async {
        // setup
        final dateNow = DateTime.now();
        final eventCompanions = List.generate(10, (index) {
          final date = dateNow.add(Duration(minutes: index));

          final normalizedDate = DateTime(
            date.year,
            date.month,
            date.day,
            date.hour,
            date.minute,
            date.second,
          );

          final EventEntityCompanion eventCompanion = EventEntityCompanion(
            id: Value(index + 100),
            title: Value("title $index"),
            date: Value(normalizedDate),
            location: Value("location $index"),
            url: Value("url $index"),
            imageUrl: Value("imageUrl $index"),
            description: Value("description $index"),
          );

          return eventCompanion;
        });

        // given
        await testDatabaseWrapper.databaseWrapper.eventsRepo.insertAll(
          eventCompanions,
        );

        // for (final eventCompanion in eventCompanions) {
        //   await testDatabaseWrapper.databaseWrapper.eventsRepo.insertOne(
        //     eventCompanion,
        //   );
        // }

        // when
        final List<EventEntityValue> events = await eventsDataSource.getEvents(
          filter: const GetEventsFilterValue(),
        );

        // then
        final List<EventEntityValue> expectedEvents =
            eventCompanions
                .map(
                  (companion) => EventsConverter.entityValueFromEntityData(
                    entityData: EventEntityData(
                      id: companion.id.value,
                      title: companion.title.value,
                      date: companion.date.value,
                      location: companion.location.value,
                      url: companion.url.value,
                      imageUrl: companion.imageUrl.value,
                      description: companion.description.value,
                    ),
                  ),
                )
                .toList();

        expect(events, equals(expectedEvents));

        // cleanup
      });

      test("given events exist in database "
          "when [getEvents] is called with event ids in filter "
          "then should return expected list", () async {
        // setup
        final dateNow = DateTime.now();
        final eventCompanions = List.generate(10, (index) {
          final date = dateNow.add(Duration(minutes: index));

          final normalizedDate = DateTime(
            date.year,
            date.month,
            date.day,
            date.hour,
            date.minute,
            date.second,
          );

          final EventEntityCompanion eventCompanion = EventEntityCompanion(
            id: Value(index + 100),
            title: Value("title $index"),
            date: Value(normalizedDate),
            location: Value("location $index"),
            url: Value("url $index"),
            imageUrl: Value("imageUrl $index"),
            description: Value("description $index"),
          );

          return eventCompanion;
        });

        // given
        await testDatabaseWrapper.databaseWrapper.eventsRepo.insertAll(
          eventCompanions,
        );

        // when
        final List<int> eventIds =
            eventCompanions.sublist(0, 3).map((e) => e.id.value).toList();
        final GetEventsFilterValue filter = GetEventsFilterValue(
          eventIds: eventIds,
        );

        final List<EventEntityValue> events = await eventsDataSource.getEvents(
          filter: filter,
        );

        // then
        final expectedEvents =
            eventCompanions
                .sublist(0, 3)
                .map(
                  (companion) => EventsConverter.entityValueFromEntityData(
                    entityData: EventEntityData(
                      id: companion.id.value,
                      title: companion.title.value,
                      date: companion.date.value,
                      location: companion.location.value,
                      url: companion.url.value,
                      imageUrl: companion.imageUrl.value,
                      description: companion.description.value,
                    ),
                  ),
                )
                .toList();

        expect(events, equals(expectedEvents));

        // cleanup
      });

      test("given events exist in database "
          "when [getEvents] is called with eventIds in filter where some ids are in the past"
          "then should return expected list", () async {
        // setup
        final dateNow = DateTime.now();
        final eventCompanions = List.generate(10, (index) {
          // final date = dateNow.add(Duration(minutes: index));
          final date =
              index == 0
                  ? dateNow.subtract(Duration(minutes: 1))
                  : dateNow.add(Duration(minutes: index));
          final normalizedDate = DateTime(
            date.year,
            date.month,
            date.day,
            date.hour,
            date.minute,
            date.second,
          );

          final EventEntityCompanion eventCompanion = EventEntityCompanion(
            id: Value(index + 100),
            title: Value("title $index"),
            date: Value(normalizedDate),
            location: Value("location $index"),
            url: Value("url $index"),
            imageUrl: Value("imageUrl $index"),
            description: Value("description $index"),
          );
          return eventCompanion;
        });

        // given
        await testDatabaseWrapper.databaseWrapper.eventsRepo.insertAll(
          eventCompanions,
        );

        // when
        final List<int> eventIds =
            eventCompanions.sublist(0, 5).map((e) => e.id.value).toList();
        final GetEventsFilterValue filter = GetEventsFilterValue(
          eventIds: eventIds,
        );

        final List<EventEntityValue> events = await eventsDataSource.getEvents(
          filter: filter,
        );

        // then
        final expectedEvents =
            eventCompanions
                .sublist(1, 5)
                .map(
                  (companion) => EventsConverter.entityValueFromEntityData(
                    entityData: EventEntityData(
                      id: companion.id.value,
                      title: companion.title.value,
                      date: companion.date.value,
                      location: companion.location.value,
                      url: companion.url.value,
                      imageUrl: companion.imageUrl.value,
                      description: companion.description.value,
                    ),
                  ),
                )
                .toList();

        expect(events, equals(expectedEvents));

        // cleanup
      });
    });

    group("getEvent", () {
      test("given event does not exist in database "
          "when [getEvent] is called "
          "then should return null", () async {
        // setup

        // given

        // when
        final EventEntityValue? event = await eventsDataSource.getEvent(1);

        // then
        expect(event, isNull);

        // cleanup
      });

      test("given event exists in database "
          "when [getEvent] is called "
          "then should return expected event", () async {
        // setup
        final date = DateTime(2021, 1, 1);
        final EventEntityCompanion eventCompanion = EventEntityCompanion(
          id: Value(1),
          title: Value("title"),
          date: Value(date),
          location: Value("location"),
          url: Value("url"),
          imageUrl: Value("imageUrl"),
          description: Value("description"),
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
                url: "url",
                imageUrl: "imageUrl",
                description: "description",
              ),
            );
        expect(event, equals(value));

        // cleanup
      });
    });
  });
}
