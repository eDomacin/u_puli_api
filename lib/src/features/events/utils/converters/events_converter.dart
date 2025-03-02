import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';

abstract class EventsConverter {
  static EventModel modelFromEntityValue({
    required EventEntityValue value,
  }) {
    final model = EventModel(
      id: value.id,
      title: value.title,
      date: value.date,
      location: value.location,
    );

    return model;
  }

  static List<EventModel> modelsFromEntityValues({
    required List<EventEntityValue> values,
  }) {
    final models =
        values.map((value) => modelFromEntityValue(value: value)).toList();

    return models;
  }
}
