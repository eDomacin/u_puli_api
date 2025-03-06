import 'package:database_wrapper/database_wrapper.dart';
import 'package:event_scraper/src/data/data_sources/events_storer/events_storer_data_source.dart';

class EventsStorerDataSourceImpl implements EventsStorerDataSource {
  const EventsStorerDataSourceImpl({required DatabaseWrapper databaseWrapper})
    : _databaseWrapper = databaseWrapper;

  final DatabaseWrapper _databaseWrapper;
  @override
  Future<void> storeEvents(List<StoreEventEntityValue> events) async {
    final companions = EventsConverter.insertCompanionsFromStoreEntityValues(
      storeEventEntityValues: events,
    );

    await _databaseWrapper.eventsRepo.insertAll(
      companions,
      onConflict: DoNothing(
        target: [
          _databaseWrapper.eventsRepo.title,
          _databaseWrapper.eventsRepo.date,
          _databaseWrapper.eventsRepo.location,
        ],
      ),
    );
  }
}
