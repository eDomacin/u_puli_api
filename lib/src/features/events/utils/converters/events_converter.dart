import 'package:database_wrapper/database_wrapper.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';
// import 'package:u_puli_api/src/wrappers/drift/drift_wrapper.dart';

abstract class EventsConverter {
  static EventEntityValue entityValueFromEntityData({
    required EventEntityData entityData,
  }) {
    final EventEntityValue value = EventEntityValue(
      id: entityData.id,
      title: entityData.title,
      date: entityData.date,
      location: entityData.location,
    );

    return value;
  }

  static List<EventEntityValue> entityValuesFromEntityDatas({
    required List<EventEntityData> entityDatas,
  }) {
    final List<EventEntityValue> values = entityDatas
        .map((entityData) => entityValueFromEntityData(entityData: entityData))
        .toList();

    return values;
  }

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
