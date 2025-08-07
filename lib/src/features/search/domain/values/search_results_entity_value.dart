import 'package:equatable/equatable.dart';
import 'package:u_puli_api/src/features/events/domain/values/event_entity_value.dart';

class SearchResultsEntityValue extends Equatable {
  final List<EventEntityValue> events;
  // TODO: in future, we will get maybe other types of data to search, or some pagination and stuff like that

  const SearchResultsEntityValue({required this.events});

  @override
  List<Object?> get props => [events];
}
