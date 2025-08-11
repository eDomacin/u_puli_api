import 'package:database_wrapper/database_wrapper.dart' hide EventsConverter;
import 'package:u_puli_api/src/features/events/utils/converters/events_converter.dart';
import 'package:u_puli_api/src/features/search/data/data_sources/search_data_source.dart';
import 'package:u_puli_api/src/features/search/domain/values/search_results_entity_value.dart';
import 'package:u_puli_api/src/wrappers/timezone/timezone_wrapper.dart';

class SearchDataSourceImpl implements SearchDataSource {
  final DatabaseWrapper _databaseWrapper;

  const SearchDataSourceImpl({required DatabaseWrapper databaseWrapper})
    : _databaseWrapper = databaseWrapper;

  @override
  Future<SearchResultsEntityValue> search(String query) async {
    final queryLower = query.toLowerCase();
    final nowDateTime = DateTime.now();
    final fromDateTimeZoned = TimezoneWrapper.toLocationDateInUTC(
      TimezoneLocation.croatia,
      year: nowDateTime.year,
      month: nowDateTime.month,
      day: nowDateTime.day,
      hours: 0,
      minutes: 0,
    );
    /* lets first get events */
    /* TODO for levenstein, we will have to do migration to install fuzzystr */
    /* 
    - https://medium.com/@simeon.emanuilov/levenshtein-distance-in-postgresql-a-practical-guide-ef8262f595ae
    - https://stackoverflow.com/questions/7730027/how-to-create-simple-fuzzy-search-with-postgresql-only
     */

    final eventsSelect = _databaseWrapper.eventsRepo.select();

    // only want stuff from today
    final Expression<bool> fromDateExpression = _databaseWrapper.eventsRepo.date
        .isBiggerOrEqualValue(fromDateTimeZoned);
    eventsSelect.where((tbl) => fromDateExpression);

    // for now, lets use custom expression
    // final isSimilar = select.customExpression(
    //   'LOWER(title) LIKE ? OR LOWER(description) LIKE ?',
    //   [queryLower, queryLower],
    // );

    // TODO: i hope this sanitizes the input
    final queryVariable = Variable.withString(queryLower);
    // final isSimilarExpression = CustomExpression<bool>(
    //   // 'LOWER(title) LIKE ? OR LOWER(description) LIKE ?',
    //   // [queryVariable, queryVariable],
    //   /* TODO description might be too much */
    //   // "lower(title) LIKE '${queryVariable.value}' OR description LIKE '${queryVariable.value}' OR location LIKE '${queryVariable.value}'",
    //   "lower(title) like '%${queryVariable.value}%' OR "
    //   "lower(location) like '%${queryVariable.value}%' OR "
    //   "lower(description) like '%${queryVariable.value}%'",
    //   // no idea what this does
    //   precedence: Precedence.primary,
    // );

    /* this is levensein use
    
          final isSimilarTitleExpression = CustomExpression<bool>(
        // TODO maybe levenhstein is not that good for this - maybe there is better
        "LEVENSHTEIN(title, '${matchTitleVariable.value}') <= 3",
        precedence: Precedence.primary,
      );

      and we need to install extension fuzzystr for this in db

            await db.customStatement("CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;");

            but we should do it in a migration
    
    
     */

    // eventsSelect.where((tbl) => isSimilarExpression);

    // final combinedExpression = Expression.and([
    //   isSimilarExpression,
    //   fromDateExpression,
    // ]);

    final isSimilarExpression =
        _databaseWrapper.eventsRepo.title.lower().like(
          '%${queryVariable.value}%',
        ) |
        _databaseWrapper.eventsRepo.location.lower().like(
          '%${queryVariable.value}%',
        ) |
        _databaseWrapper.eventsRepo.description.lower().like(
          '%${queryVariable.value}%',
        );

    eventsSelect.where((tbl) => isSimilarExpression);

    eventsSelect.orderBy([
      (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.asc),
    ]);

    final events = await eventsSelect.get();
    final eventValues = EventsConverter.entityValuesFromEntityDatas(
      entityDatas: events,
    );

    final searchResults = SearchResultsEntityValue(events: eventValues);

    return searchResults;
  }
}


/* 

select * from event_entity ee 
where lower(title) like '%rojc%'
or lower("location") like '%rojc%' 
or lower(description) like '%rojc%'



 */