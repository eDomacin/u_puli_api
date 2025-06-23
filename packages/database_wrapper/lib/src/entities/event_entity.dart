import 'package:drift/drift.dart';

class EventEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text()();
  TextColumn get url => text()();
  TextColumn get imageUrl => text()();

  // make sure same events are not reinserted
  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {title, date, location},
  ];
}
