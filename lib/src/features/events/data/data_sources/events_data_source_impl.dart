import 'package:database_wrapper/database_wrapper.dart' hide EventsConverter;
import 'package:u_puli_api/src/features/events/data/data_sources/events_data_source.dart';
import 'package:u_puli_api/src/features/events/domain/values/create_event_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';
import 'package:u_puli_api/src/features/events/domain/values/update_event_value.dart';
import 'package:u_puli_api/src/features/events/utils/converters/events_converter.dart';
import 'package:u_puli_api/src/features/events/domain/values/get_events_filter_value.dart';
// import 'package:u_puli_api/src/wrappers/database/database_wrapper.dart';
// import 'package:u_puli_api/src/wrappers/drift/drift_wrapper.dart';

class EventsDataSourceImpl implements EventsDataSource {
  final DatabaseWrapper _databaseWrapper;

  const EventsDataSourceImpl({required DatabaseWrapper databaseWrapper})
    : _databaseWrapper = databaseWrapper;

  @override
  Future<void> updateEvent(UpdateEventValue value) async {
    final EventEntityCompanion companion = EventEntityCompanion(
      id: Value(value.id),
      title: value.title == null ? Value.absent() : Value(value.title!),
      date: value.date == null ? Value.absent() : Value(value.date!),
      location:
          value.location == null ? Value.absent() : Value(value.location!),
      url: value.uri == null ? Value.absent() : Value(value.uri!.toString()),
      imageUrl:
          value.imageUri == null
              ? Value.absent()
              : Value(value.imageUri!.toString()),
      description:
          value.description == null
              ? Value.absent()
              : Value(value.description!),
    );

    final UpdateStatement<$EventEntityTable, EventEntityData> update =
        _databaseWrapper.eventsRepo.update();
    final UpdateStatement<$EventEntityTable, EventEntityData> updateEvent =
        update..where((tbl) => tbl.id.equals(value.id));

    await updateEvent.write(companion);
  }

  @override
  Future<int> storeEvent(CreateEventValue value) async {
    final EventEntityCompanion companion = EventEntityCompanion.insert(
      title: value.title,
      date: value.date,
      location: value.location,
      url: value.uri.toString(),
      imageUrl: value.imageUri.toString(),
      description: value.description,
      // TODO will need to add other fields too
    );

    final int id = await _databaseWrapper.eventsRepo.insertOne(companion);

    return id;
  }

  @override
  Future<EventEntityValue?> getEvent(int id) async {
    final SimpleSelectStatement<$EventEntityTable, EventEntityData> select =
        _databaseWrapper.eventsRepo.select();

    final SimpleSelectStatement<$EventEntityTable, EventEntityData> findEvent =
        select..where((tbl) => tbl.id.equals(id));

    final EventEntityData? event = await findEvent.getSingleOrNull();
    if (event == null) {
      return null;
    }

    final EventEntityValue eventValue =
        EventsConverter.entityValueFromEntityData(entityData: event);
    return eventValue;
  }

  @override
  Future<List<EventEntityValue>> getEvents({
    required GetEventsFilterValue filter,
  }) async {
    // filters
    // final DateTime nowDate = DateTime.now();
    // TODO this should actually using utc datetime now
    final DateTime fromDate = filter.fromDate ?? DateTime.now();
    final List<int>? eventIds = filter.eventIds;

    SimpleSelectStatement<$EventEntityTable, EventEntityData> select =
        _databaseWrapper.eventsRepo.select();

    // TODO when we have filters, fromDate could be derived from filters
    // final DateTime fromDate = nowDate;

    final Expression<bool> fromDateExpression = _databaseWrapper.eventsRepo.date
        .isBiggerOrEqualValue(fromDate);
    // filter by fromDate
    // this works as well
    // select = select..where((tbl) => fromDateExpression);
    select.where((tbl) => fromDateExpression);

    // filter by event ids
    if (eventIds != null) {
      final eventIdsExpression = _databaseWrapper.eventsRepo.id.isIn(eventIds);
      // select = select..where((tbl) => eventIdsExpression);
      select.where((tbl) => eventIdsExpression);
    }

    // filter by order - closest event is shown first
    select =
        select..orderBy([
          (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.asc),
        ]);

    final List<EventEntityData> events = await select.get();
    final eventValues = EventsConverter.entityValuesFromEntityDatas(
      entityDatas: events,
    );

    return eventValues;
  }
}
