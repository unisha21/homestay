import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_app/src/features/search/data/search_datasource.dart';
import 'package:homestay_app/src/features/search/domain/searc_params.dart'; // Your SearchDataSource

// Provider for the SearchDataSource
final searchDataSourceProvider = Provider<SearchDataSource>((ref) {
  return SearchDataSource();
});

// Provider to search homestays, taking a query as a parameter
// Provider to search homestays, taking SearchParameters
final searchHomestaysProvider = FutureProvider.autoDispose.family<
  List<HomestayModel>,
  SearchParameters
>((ref, params) async {
  // Only trigger search if there's a query text or at least one price filter
  if (params.queryText.trim().isEmpty &&
      params.minPrice == null &&
      params.maxPrice == null) {
    return [];
  }
  final searchService = ref.watch(searchDataSourceProvider);
  return searchService.searchHomestays(
    params.queryText,
    minPrice: params.minPrice,
    maxPrice: params.maxPrice,
  );
});
