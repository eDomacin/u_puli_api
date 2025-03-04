import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';

abstract interface class EventsDataSource {
  Future<EventEntityValue?> getEvent(int id);
  Future<List<EventEntityValue>> getEvents();
}
