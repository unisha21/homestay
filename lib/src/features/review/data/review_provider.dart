import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/features/review/data/review_datasource.dart';
import 'package:homestay_app/src/features/review/domain/review_model.dart';

final reviewProvider = StreamProvider.family<List<ReviewModel>, String>(
  (ref, String menuId) => ReviewDataSource().getReviewsStream(menuId),
);
