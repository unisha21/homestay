import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:homestay_app/src/features/order/data/order_datasource.dart';
import 'package:homestay_app/src/features/order/domain/order_model.dart';

final orderProvider = StreamProvider.autoDispose<List<OrderModel>>(
  (ref) => OrderDatasource().getOrdersStream(),
);

final orderDetailProvider = StreamProvider.family<OrderModel, String>(
  (ref, String id) => OrderDatasource().getOrderDetail(id),
);

final cancelOrderProvider = FutureProvider.family<String, String>(
  (ref, String orderId) => OrderDatasource().cancelOrder(orderId: orderId),
);

final userDetailProvider = FutureProvider.family<types.User, String>(
  (ref, String userId) => OrderDatasource().getUserDetail(userId),
);
