import 'package:database_wrapper/database_wrapper.dart';

abstract interface class EventsStorerDataSource {
  Future<void> storeEvents(List<StoreEventEntityValue> events);
}
