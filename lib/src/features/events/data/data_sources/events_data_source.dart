import 'package:u_puli_api/src/features/events/domain/values/create_event_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/update_event_value.dart';
import 'package:u_puli_api/src/features/events/utils/values/get_events_filter_value.dart';

abstract interface class EventsDataSource {
  /*  TODO all these should convert its dates to utc
  - so we should receive local data, but we will call utc on it?
   */
  Future<EventEntityValue?> getEvent(int id);
  Future<List<EventEntityValue>> getEvents({
    required GetEventsFilterValue filter,
  });
  Future<int> storeEvent(CreateEventValue value);
  Future<void> updateEvent(UpdateEventValue value);
}
