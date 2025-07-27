import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';

class LoadSpEventsUseCase {
  final EventsLoaderRepository _eventsLoaderRepository;

  const LoadSpEventsUseCase({
    required EventsLoaderRepository eventsLoaderRepository,
  }) : _eventsLoaderRepository = eventsLoaderRepository;

  Future<void> call() async {
    await _eventsLoaderRepository.loadSpEvents();
  }
}
