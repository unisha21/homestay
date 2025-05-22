import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';

class SearchDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _homestayDb => _firestore.collection('homestays');
  CollectionReference get _userDb => _firestore.collection('users');

  Future<types.User> _getUserDetail(String userId) async {
    try {
      final snapshot = await _userDb.doc(userId).get();
      if (snapshot.exists) {
        final json = snapshot.data() as Map<String, dynamic>;
        // Ensure null safety for metadata fields
        final metadata = json['metadata'] as Map<String, dynamic>? ?? {};
        return types.User(
          id: snapshot.id,
          firstName:
              json['firstName'] as String? ??
              '', // Default to empty string if null
          metadata: {
            'deviceToken': metadata['deviceToken'] as String? ?? '',
            'email': metadata['email'] as String? ?? '',
            'phone': metadata['phone'] as String? ?? '',
            'role': metadata['role'] as String? ?? '',
          },
        );
      } else {
        // Return a default/empty user or throw a more specific error
        // For simplicity, returning a user with an ID indicating not found
        // In a real app, you might want to handle this more gracefully
        // or ensure hostId always corresponds to a valid user.
        return types.User(id: userId, firstName: 'User Not Found');
      }
    } on FirebaseException catch (e) {
      // Log error or handle as appropriate
      print("Error fetching user $userId: $e");
      throw 'Failed to fetch user details: ${e.message}';
    }
  }

  /// Searches homestays where the title starts with the given query.
  ///
  /// Note: Firestore's querying capabilities for partial string matches are limited.
  /// This method uses a common workaround for "starts-with" queries.
  /// For more complex full-text search, consider solutions like Algolia, Typesense,
  /// or structuring your data with an array of keywords for `array-contains` queries.
  Future<List<HomestayModel>> searchHomestays(
    String query, {
    double? minPrice,
    double? maxPrice,
  }) async {
    if (query.trim().isEmpty && minPrice == null && maxPrice == null) {
      return [];
    }
    try {
      final String lowercasedQuery = query.toLowerCase();
      // Start with the base collection
      Query firestoreQuery = _homestayDb;

      // Apply title filter (current case-sensitive approach)
      if (query.isNotEmpty) {
        firestoreQuery = firestoreQuery
            .where('title', isGreaterThanOrEqualTo: query)
            .where('title', isLessThanOrEqualTo: query + '\uf8ff');
      }

      // Apply price filters
      // IMPORTANT: This assumes 'pricePerNight' in Firestore is a NUMBER type.
      if (minPrice != null) {
        firestoreQuery = firestoreQuery.where(
          'pricePerNight',
          isGreaterThanOrEqualTo: minPrice,
        );
      }

      if (maxPrice != null) {
        // Ensure maxPrice is not less than minPrice if both are provided,
        // or handle this logic in the UI/provider.
        // For simplicity, Firestore will handle impossible ranges by returning no results.
        firestoreQuery = firestoreQuery.where(
          'pricePerNight',
          isLessThanOrEqualTo: maxPrice,
        );
      }

      final response = await firestoreQuery.get();

      if (response.docs.isEmpty) {
        return [];
      }

      final searchResults = await Future.wait(
        response.docs.map((doc) async {
          final json = doc.data() as Map<String, dynamic>;
          final hostId = json['hostId'] as String?;

          if (hostId == null) {
            // Handle cases where hostId might be missing, though it's required by your model
            print("Warning: Homestay ${doc.id} is missing hostId.");
            // You might want to skip this item or handle it differently
            return null;
          }

          final user = await _getUserDetail(hostId);

          return HomestayModel.fromJson({
            ...json,
            'id': doc.id,
            'user': user,
            // 'reviews': [], // Assuming reviews are not part of search results for now
          });
        }),
      );
      // Filter out any nulls that might have resulted from missing hostIds
      return searchResults.whereType<HomestayModel>().toList();
    } on FirebaseException catch (e) {
      // Log the error or rethrow a custom exception
      print("Error searching homestays: ${e.message}");
      throw 'Search failed: ${e.message}';
    } catch (e) {
      // Catch any other errors during mapping or processing
      print("An unexpected error occurred during search: $e");
      throw 'An unexpected error occurred during search.';
    }
  }
}
