abstract interface class EventsScraperDataSource {
  abstract final Uri url;
  abstract final String name;
  // TODO should not be dynamic
  Future<List<dynamic>> getEvents();
}
