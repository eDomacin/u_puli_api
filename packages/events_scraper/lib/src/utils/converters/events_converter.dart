import 'package:database_wrapper/database_wrapper.dart';
import 'package:event_scraper/src/data/entities/scraped_event_entity.dart';

abstract class EventsConverter {
  static StoreEventEntityValue storeEntityValueFromScrapedEntity({
    required ScrapedEventEntity scrapedEventEntity,
  }) {
    final StoreEventEntityValue value = StoreEventEntityValue(
      title: scrapedEventEntity.title,
      date: scrapedEventEntity.date,
      location: scrapedEventEntity.venue,
      uri: scrapedEventEntity.uri,
      imageUri: scrapedEventEntity.imageUri,
      description: scrapedEventEntity.description,
    );

    return value;
  }

  static List<StoreEventEntityValue> storeEntityValuesFromScrapedEntities({
    required Iterable<ScrapedEventEntity> scrapedEventEntities,
  }) {
    final List<StoreEventEntityValue> values =
        scrapedEventEntities
            .map(
              (scrapedEventEntity) => storeEntityValueFromScrapedEntity(
                scrapedEventEntity: scrapedEventEntity,
              ),
            )
            .toList();

    return values;
  }
}
