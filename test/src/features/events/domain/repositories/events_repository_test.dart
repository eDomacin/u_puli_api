import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository_impl.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';

void main() {
  final EventsDataSource mockEventsDataSource = _MockEventsDataSource();

  tearDown(() async {
    reset(mockEventsDataSource);
  });

  group(
    EventsRepository,
    () {
      group(
        "getEvent",
        () {
          test(
            "given [EventsDataSource.getEvent] returns null "
            "when [getEvent] is called "
            "then should return null and call [EventsDataSource.getEvent]",
            () async {
              // setup
              final EventsRepositoryImpl repository = EventsRepositoryImpl(
                eventsDataSource: mockEventsDataSource,
              );

              // given
              when(() => mockEventsDataSource.getEvent(any())).thenAnswer(
                (_) async => null,
              );

              // when
              final event = await repository.getEvent(1);

              // then
              expect(event, isNull);
              verify(() => mockEventsDataSource.getEvent(1)).called(1);

              // cleanup
            },
          );

          test(
            "given [EventsDataSource.getEvent] returns event "
            "when [getEvent] is called "
            "then should return expected event and call [EventsDataSource.getEvent]",
            () async {
              // setup
              final EventsRepositoryImpl repository = EventsRepositoryImpl(
                eventsDataSource: mockEventsDataSource,
              );

              // given
              final EventEntityValue eventValue = EventEntityValue(
                id: 1,
                title: "title",
                date: DateTime(2021, 1, 1),
                location: "location",
              );
              when(() => mockEventsDataSource.getEvent(any())).thenAnswer(
                (_) async => eventValue,
              );

              // when
              final EventModel? event = await repository.getEvent(1);

              // then
              final expectedEvent = EventModel(
                id: 1,
                title: "title",
                date: DateTime(2021, 1, 1),
                location: "location",
              );
              expect(event, equals(expectedEvent));

              verify(() => mockEventsDataSource.getEvent(1)).called(1);

              // cleanup
            },
          );
        },
      );
    },
  );
}

class _MockEventsDataSource extends Mock implements EventsDataSource {}
