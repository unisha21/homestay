class SearchParameters {
  final String queryText;
  final double? minPrice;
  final double? maxPrice;

  SearchParameters({required this.queryText, this.minPrice, this.maxPrice});

  // Optional: For provider to correctly identify changes if you use ==
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParameters &&
          runtimeType == other.runtimeType &&
          queryText == other.queryText &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice;

  @override
  int get hashCode =>
      queryText.hashCode ^ minPrice.hashCode ^ maxPrice.hashCode;
}
