import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/features/homestay/data/datasource/homestay_datasource.dart';
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';

final homeStayProvider = FutureProvider.autoDispose<List<HomestayModel>>(
  (ref) => HomestayDatasource().getHomeStay(),
);
