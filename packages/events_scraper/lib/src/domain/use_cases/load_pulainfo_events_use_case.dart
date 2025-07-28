import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';

class LoadPulainfoEventsUseCase {
  final EventsLoaderRepository _eventsLoaderRepository;

  const LoadPulainfoEventsUseCase({
    required EventsLoaderRepository eventsLoaderRepository,
  }) : _eventsLoaderRepository = eventsLoaderRepository;

  Future<void> call() async {
    await _eventsLoaderRepository.loadPulainfoEvents();
  }
}
