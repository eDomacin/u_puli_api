import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';

class LoadValliEventsUseCase {
  final EventsLoaderRepository _eventsLoaderRepository;

  const LoadValliEventsUseCase({
    required EventsLoaderRepository eventsLoaderRepository,
  }) : _eventsLoaderRepository = eventsLoaderRepository;

  Future<void> call() async {
    await _eventsLoaderRepository.loadValliEvents();
  }
}
