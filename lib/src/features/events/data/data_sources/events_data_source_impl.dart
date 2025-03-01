import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/data/entities/event_entity.dart';

class EventsDataSourceImpl implements EventsDataSource {
  @override
  Future<EventEntity> getEvent(int id) async {
    final event = events.firstWhere((event) => event.id == id);

    return event;
  }

  @override
  Future<List<EventEntity>> getEvents() async {
    return events;
  }
}

final List<EventEntity> events = List.generate(
  10,
  (index) => EventEntity(
    id: index + 1,
    title: 'Event ${index + 1}',
    date: DateTime.now().add(Duration(days: index)),
    location: 'Location ${index + 1}',
  ),
);
