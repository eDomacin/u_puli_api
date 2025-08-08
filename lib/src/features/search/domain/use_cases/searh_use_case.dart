import 'package:u_puli_api/src/features/search/domain/repositories/search_repository.dart';
import 'package:u_puli_api/src/features/search/domain/values/search_results_model_value.dart';

class SearchUseCase {
  final SearchRepository _searchRepository;

  const SearchUseCase({required SearchRepository searchRepository})
    : _searchRepository = searchRepository;

  Future<SearchResultsModelValue> call(String query) async {
    return await _searchRepository.search(query);
  }
}
