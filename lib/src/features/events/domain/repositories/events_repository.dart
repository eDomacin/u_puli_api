import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';

abstract interface class EventsRepository {
  Future<EventModel> getEvent(int id);
  Future<List<EventModel>> getEvents();
}
