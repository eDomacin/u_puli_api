import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';
import 'package:u_puli_api/src/features/events/domain/values/create_event_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/update_event_value.dart';
import 'package:u_puli_api/src/features/events/utils/converters/events_converter.dart';
import 'package:u_puli_api/src/features/events/domain/values/get_events_filter_value.dart';

/* TODO repositories should be moved to data layer */
class EventsRepositoryImpl implements EventsRepository {
  const EventsRepositoryImpl({required EventsDataSource eventsDataSource})
    : _eventsDataSource = eventsDataSource;

  final EventsDataSource _eventsDataSource;

  @override
  Future<void> updateEvent(UpdateEventValue value) async {
    await _eventsDataSource.updateEvent(value);
  }

  @override
  Future<int> createEvent(CreateEventValue value) async {
    final int id = await _eventsDataSource.storeEvent(value);

    return id;
  }

  @override
  Future<EventModel?> getEvent(int id) async {
    final EventEntityValue? value = await _eventsDataSource.getEvent(id);
    if (value == null) {
      return null;
    }

    final EventModel model = EventsConverter.modelFromEntityValue(value: value);

    return model;
  }

  @override
  Future<List<EventModel>> getEvents({
    required GetEventsFilterValue filter,
  }) async {
    final List<EventEntityValue> values = await _eventsDataSource.getEvents(
      filter: filter,
    );
    final List<EventModel> models = EventsConverter.modelsFromEntityValues(
      values: values,
    );

    return models;
  }
}
