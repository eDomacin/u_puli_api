import 'package:u_puli_api/src/features/search/domain/values/search_results_entity_value.dart';

abstract interface class SearchDataSource {
  Future<SearchResultsEntityValue> search(String query);
}
