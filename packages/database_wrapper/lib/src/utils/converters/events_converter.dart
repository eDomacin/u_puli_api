// TODO decide which converters should live here and which in packages that consume this package

import 'package:database_wrapper/database_wrapper.dart';

abstract class EventsConverter {
  static EventEntityCompanion insertCompanionFromStoreEntityValue({
    required StoreEventEntityValue storeEventEntityValue,
  }) {
    final EventEntityCompanion companion = EventEntityCompanion.insert(
      title: storeEventEntityValue.title,
      date: storeEventEntityValue.date,
      location: storeEventEntityValue.location,
      url: storeEventEntityValue.uri.toString(),
      imageUrl: storeEventEntityValue.imageUri.toString(),
      // TODO need migration to actually insert this
      // TODO this means that that constraint will need to be dropped, and new one will need to be created
      // TODO because we have to remove it, next one would be good to create with specifying constraint key
      // uri: storeEventEntityValue.uri,
      // imageUri: storeEventEntityValue.imageUri,
    );

    return companion;
  }

  static List<EventEntityCompanion> insertCompanionsFromStoreEntityValues({
    required List<StoreEventEntityValue> storeEventEntityValues,
  }) {
    final List<EventEntityCompanion> companions =
        storeEventEntityValues
            .map(
              (storeEventEntityValue) => insertCompanionFromStoreEntityValue(
                storeEventEntityValue: storeEventEntityValue,
              ),
            )
            .toList();

    return companions;
  }
}
