import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';
import 'package:u_puli_api/src/features/events/domain/values/update_event_value.dart';

class UpdateEventUseCase {
  const UpdateEventUseCase({required EventsRepository eventsRepository})
    : _eventsRepository = eventsRepository;

  final EventsRepository _eventsRepository;

  Future<int> call({
    required int id,
    required String? title,
    required String? location,
    required DateTime? date,
    required Uri? uri,
    required Uri? imageUri,
  }) async {
    final UpdateEventValue value = UpdateEventValue(
      id: id,
      title: title,
      location: location,
      date: date,
      uri: uri,
      imageUri: imageUri,
    );

    return await _eventsRepository.updateEvent(value);
  }
}
