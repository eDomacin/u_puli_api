import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';

class LoadEventimEventsUseCase {
  final EventsLoaderRepository _eventsLoaderRepository;

  const LoadEventimEventsUseCase({
    required EventsLoaderRepository eventsLoaderRepository,
  }) : _eventsLoaderRepository = eventsLoaderRepository;

  Future<void> call() async {
    await _eventsLoaderRepository.loadEventimEvents();
  }
}
