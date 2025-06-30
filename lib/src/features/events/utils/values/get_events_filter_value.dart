/* TODO check if values can be in utils */
// TODO this is experminte to see if fliter would work here
import 'package:equatable/equatable.dart';

class GetEventsFilterValue extends Equatable {
  final DateTime? fromDate;
  final List<int>? eventIds;

  const GetEventsFilterValue({this.fromDate, this.eventIds});

  @override
  List<Object?> get props => [fromDate, eventIds];
}
