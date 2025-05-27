
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/features/payment/data/payment_datasource.dart';
import 'package:homestay_app/src/features/payment/domain/payment_model.dart';

final paymentHistoryProvider = FutureProvider.autoDispose<List<PaymentDetailModel>>((ref) => PaymentDataSource().getPaymentHistory());