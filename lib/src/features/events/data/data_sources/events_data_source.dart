import 'package:u_puli_api/src/features/events/domain/values/create_event_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/update_event_value.dart';
import 'package:u_puli_api/src/features/events/utils/values/get_events_filter_value.dart';

abstract interface class EventsDataSource {
  Future<EventEntityValue?> getEvent(int id);
  Future<List<EventEntityValue>> getEvents({
    required GetEventsFilterValue filter,
  });
  Future<int> storeEvent(CreateEventValue value);
  Future<void> updateEvent(UpdateEventValue value);
}
