import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';

class GetEventsUseCase {
  const GetEventsUseCase({
    required EventsRepository eventsRepository,
  }) : _eventsRepository = eventsRepository;

  final EventsRepository _eventsRepository;

  Future<List<EventModel>> call() async {
    final List<EventModel> events = await _eventsRepository.getEvents();

    return events;
  }
}
