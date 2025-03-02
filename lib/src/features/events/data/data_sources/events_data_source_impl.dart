import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';

class EventsDataSourceImpl implements EventsDataSource {
  @override
  Future<EventEntityValue> getEvent(int id) async {
    final event = events.firstWhere((event) => event.id == id);

    return event;
  }

  @override
  Future<List<EventEntityValue>> getEvents() async {
    return events;
  }
}

final List<EventEntityValue> events = List.generate(
  10,
  (index) => EventEntityValue(
    id: index + 1,
    title: 'Event ${index + 1}',
    date: DateTime.now().add(Duration(days: index)),
    location: 'Location ${index + 1}',
  ),
);
