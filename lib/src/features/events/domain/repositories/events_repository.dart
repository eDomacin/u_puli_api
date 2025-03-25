import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/values/create_event_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/update_event_value.dart';

abstract interface class EventsRepository {
  Future<EventModel?> getEvent(int id);
  Future<List<EventModel>> getEvents();
  Future<int> createEvent(CreateEventValue value);
  Future<void> updateEvent(UpdateEventValue event);
}
