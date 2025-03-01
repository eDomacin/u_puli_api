import 'package:u_puli_api/src/features/events/data/entities/event_entity.dart';

abstract interface class EventsDataSource {
  Future<EventEntity> getEvent(int id);
  Future<List<EventEntity>> getEvents();
}
