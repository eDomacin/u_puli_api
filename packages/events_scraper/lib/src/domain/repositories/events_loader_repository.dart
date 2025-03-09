abstract class EventsLoaderRepository {
  Future<void> loadNarancaEvents();
  Future<void> loadGkpuEvents();
  Future<void> loadInkEvents();
}
