import 'package:u_puli_api/src/features/search/domain/values/search_results_model_value.dart';

abstract interface class SearchRepository {
  Future<SearchResultsModelValue> search(String query);
}
