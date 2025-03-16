import 'package:u_puli_api/src/features/events/domain/repositories/events_repository.dart';
import 'package:u_puli_api/src/features/events/domain/values/create_event_value.dart';

class CreateEventUseCase {
  const CreateEventUseCase({required EventsRepository eventsRepository})
    : _eventsRepository = eventsRepository;

  final EventsRepository _eventsRepository;

  Future<int> call({
    required String title,
    required String location,
    required DateTime date,
    required Uri uri,
    required Uri imageUri,
  }) async {
    final CreateEventValue value = CreateEventValue(
      title: title,
      location: location,
      date: date,
      uri: uri,
      imageUri: imageUri,
    );

    return await _eventsRepository.createEvent(value);
  }
}
