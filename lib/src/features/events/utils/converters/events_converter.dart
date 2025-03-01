import 'package:u_puli_api/src/features/events/data/entities/event_entity.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';

abstract class EventsConverter {
  static EventModel modelFromEntity({
    required EventEntity entity,
  }) {
    final model = EventModel(
      id: entity.id,
      title: entity.title,
      date: entity.date,
      location: entity.location,
    );

    return model;
  }

  static List<EventModel> modelsFromEntities({
    required List<EventEntity> entities,
  }) {
    final models =
        entities.map((entity) => modelFromEntity(entity: entity)).toList();

    return models;
  }
}
