// TODO: old - remove it
// class EventEntity {
//   const EventEntity({
//     required this.id,
//     required this.title,
//     required this.date,
//     required this.location,
//   });

//   final int id;
//   final String title;
//   final DateTime date;
//   final String location;
// }

import 'package:drift/drift.dart';

class EventEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text()();

  // TODO add all except id to combined unique index in a migration later
  // @override
  // List<Set<Column<Object>>>? get uniqueKeys => [
  //       {
  //         title,
  //         date,
  //         location,
  //       }
  //     ];
}
