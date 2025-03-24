abstract class EventsLoaderRepository {
  Future<void> loadNarancaEvents();
  Future<void> loadGkpuEvents();
  Future<void> loadInkEvents();
  Future<void> loadKotacEvents();
  Future<void> loadRojcEvents();
  Future<void> loadPDPUEvents();
}
