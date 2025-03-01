import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/data/entities/event_entity.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';
import 'package:u_puli_api/src/features/events/utils/converters/events_converter.dart';

class EventsRepositoryImpl implements EventsRepository {
  const EventsRepositoryImpl({
    required EventsDataSource eventsDataSource,
  }) : _eventsDataSource = eventsDataSource;

  final EventsDataSource _eventsDataSource;

  @override
  Future<EventModel> getEvent(int id) async {
    final EventEntity entity = await _eventsDataSource.getEvent(id);
    final EventModel model = EventsConverter.modelFromEntity(entity: entity);

    return model;
  }

  @override
  Future<List<EventModel>> getEvents() async {
    final List<EventEntity> entities = await _eventsDataSource.getEvents();
    final List<EventModel> models =
        EventsConverter.modelsFromEntities(entities: entities);

    return models;
  }
}
