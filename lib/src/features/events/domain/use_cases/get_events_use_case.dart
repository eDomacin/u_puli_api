import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';
import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';
import 'package:u_puli_api/src/features/events/utils/values/get_events_filter_value.dart';

class GetEventsUseCase {
  const GetEventsUseCase({required EventsRepository eventsRepository})
    : _eventsRepository = eventsRepository;

  final EventsRepository _eventsRepository;

  Future<List<EventModel>> call({
    required DateTime? fromDate,
    required List<int>? eventIds,
  }) async {
    final GetEventsFilterValue filter = GetEventsFilterValue(
      fromDate: fromDate,
      eventIds: eventIds,
    );
    final List<EventModel> events = await _eventsRepository.getEvents(
      filter: filter,
    );

    return events;
  }
}
