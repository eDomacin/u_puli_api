import 'package:event_scraper/src/domain/repositories/events_loader_repository.dart';

class LoadRojcEventsUseCase {
  const LoadRojcEventsUseCase({
    required EventsLoaderRepository eventsLoaderRepository,
  }) : _eventsLoaderRepository = eventsLoaderRepository;

  final EventsLoaderRepository _eventsLoaderRepository;

  Future<void> call() async {
    await _eventsLoaderRepository.loadRojcEvents();
  }
}
