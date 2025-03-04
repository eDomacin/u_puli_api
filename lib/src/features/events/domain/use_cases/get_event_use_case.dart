import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';

class GetEventUseCase {
  const GetEventUseCase({
    required EventsRepository eventsRepository,
  }) : _eventsRepository = eventsRepository;

  final EventsRepository _eventsRepository;

  Future<EventModel?> call(int id) async {
    final EventModel? event = await _eventsRepository.getEvent(id);

    return event;
  }
}
