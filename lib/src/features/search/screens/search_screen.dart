import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/common/route_manager.dart';
import 'package:homestay_app/src/features/search/data/search_data_provider.dart';
import 'package:homestay_app/src/features/search/domain/searc_params.dart';
import 'package:homestay_app/src/themes/export_themes.dart';
import 'package:homestay_app/src/themes/extensions.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  Timer? _debounce;

  SearchParameters _currentSearchParams = SearchParameters(queryText: '');

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchCriteriaChanged);
    _minPriceController.addListener(_onSearchCriteriaChanged);
    _maxPriceController.addListener(_onSearchCriteriaChanged);
  }

  // void _onSearchChanged() {
  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     if (mounted) {
  //       setState(() {
  //         _query = _searchController.text;
  //       });
  //     }
  //   });
  // }

  void _onSearchCriteriaChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 750), () {
      // Increased debounce slightly
      if (mounted) {
        final minPrice = double.tryParse(_minPriceController.text);
        final maxPrice = double.tryParse(_maxPriceController.text);

        // Basic validation: if maxPrice is less than minPrice, consider maxPrice null or handle error
        double? effectiveMaxPrice = maxPrice;
        if (minPrice != null && maxPrice != null && maxPrice < minPrice) {
          effectiveMaxPrice = null; // Or show an error to the user
        }

        setState(() {
          _currentSearchParams = SearchParameters(
            queryText: _searchController.text,
            minPrice: minPrice,
            maxPrice: effectiveMaxPrice,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchCriteriaChanged);
    _searchController.dispose();
    _minPriceController.removeListener(_onSearchCriteriaChanged);
    _minPriceController.dispose();
    _maxPriceController.removeListener(_onSearchCriteriaChanged);
    _maxPriceController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchResults = ref.watch(searchHomestaysProvider(_currentSearchParams));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search Homestays')),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextField(
                  autofocus: true,
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        color: context.theme.colorScheme.secondary,
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      size: 28,
                      color: theme.colorScheme.onSurface,
                    ),
                    hintText: 'Search by homestay title...',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    suffixIcon:
                        _searchController.text.isEmpty
                            ? const SizedBox()
                            : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                // _onSearchChanged will be called by listener,
                                // or call setState({_query = '';}) directly if preferred
                              },
                              icon: const Icon(Icons.close),
                            ),
                  ),
                  // onChanged is handled by the listener for debouncing
                ),
                SizedBox(height: 20),
                Expanded(
                  child: searchResults.when(
                    data: (homestays) {
                      if (_searchController.text.isEmpty) {
                        return Center(
                          child: Text(
                            'Start typing to search for homestays.',
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }
                      if (homestays.isEmpty && _currentSearchParams.queryText.isNotEmpty) {
                        return Center(
                          child: Text(
                            'No homestays found matching "${_currentSearchParams.queryText}".',
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: homestays.length,
                        itemBuilder: (context, index) {
                          final homestay = homestays[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading:
                                  homestay.images.isNotEmpty
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.network(
                                          homestay.images.first,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.home, size: 40),
                                        ),
                                      )
                                      : Icon(Icons.home, size: 40),
                              title: Text(homestay.title),
                              subtitle: Text(
                                'Host: ${homestay.user.firstName ?? 'N/A'}\nLocation: ${homestay.location}',
                              ),
                              isThreeLine: true,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.serviceDetailRoute,
                                  arguments: homestay,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    error:
                        (error, stack) => Center(
                          child: Text(
                            'Error loading results: ${error.toString()}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder for HomestayDetailScreen if you don't have one yet
// class HomestayDetailScreen extends StatelessWidget {
//   final HomestayModel homestay;
//   const HomestayDetailScreen({super.key, required this.homestay});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(homestay.title)),
//       body: Center(child: Text('Details for ${homestay.title}')),
//     );
//   }
// }
