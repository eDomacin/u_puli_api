import 'package:drift/drift.dart';
import 'package:u_puli_api/src/wrappers/database/database_wrapper.dart';
import 'package:u_puli_api/src/wrappers/drift/drift_wrapper.dart';

class TempScraperDbStorer {
  const TempScraperDbStorer(DatabaseWrapper databaseWrapper)
      : _databaseWrapper = databaseWrapper;

  final DatabaseWrapper _databaseWrapper;

  Future<void> storeEvents(List<StoreEventEntityValue> events) async {
    // this should be a transaction
    final companions = events
        .map((event) => EventEntityCompanion.insert(
              title: event.title,
              date: event.date,
              location: event.location,
            ))
        .toList();

    await _databaseWrapper.eventsRepo.insertAll(companions,
        onConflict: DoNothing(target: [
          _databaseWrapper.eventsRepo.title,
          _databaseWrapper.eventsRepo.date,
          _databaseWrapper.eventsRepo.location,
        ]));
  }
}

class StoreEventEntityValue {
  const StoreEventEntityValue({
    required this.title,
    required this.date,
    required this.location,
  });

  final String title;
  final DateTime date;
  final String location;
}
