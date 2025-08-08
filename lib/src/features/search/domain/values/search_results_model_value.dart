import 'package:equatable/equatable.dart';
import 'package:u_puli_api/src/features/events/domain/models/event_model.dart';

class SearchResultsModelValue extends Equatable {
  final List<EventModel> events;
  // TODO: in future, we will get maybe other types of data to search, or some pagination and stuff like that

  const SearchResultsModelValue({required this.events});

  @override
  List<Object?> get props => [events];
}
