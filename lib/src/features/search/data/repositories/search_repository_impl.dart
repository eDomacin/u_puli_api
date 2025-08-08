import 'package:u_puli_api/src/features/events/utils/converters/events_converter.dart';
import 'package:u_puli_api/src/features/search/data/data_sources/search_data_source.dart';
import 'package:u_puli_api/src/features/search/domain/repositories/search_repository.dart';
import 'package:u_puli_api/src/features/search/domain/values/search_results_model_value.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDataSource _searchDataSource;

  SearchRepositoryImpl({required SearchDataSource searchDataSource})
    : _searchDataSource = searchDataSource;

  @override
  Future<SearchResultsModelValue> search(String query) async {
    final results = await _searchDataSource.search(query);
    final eventModels = EventsConverter.modelsFromEntityValues(
      values: results.events,
    );

    return SearchResultsModelValue(events: eventModels);
  }
}
