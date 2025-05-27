import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:homestay_app/src/features/order/domain/order_model.dart';

class OrderDatasource {
  final _userDb = FirebaseFirestore.instance.collection('users');
  final _orderDb = FirebaseFirestore.instance.collection('orders');
  final _categoryDb = FirebaseFirestore.instance.collection('categories');
  final _notificationDb = FirebaseFirestore.instance.collection(
    'notifications',
  );
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<String> placeOrder(OrderModel orderModel) async {
    try {
      await _orderDb.add({
        'orderInfo': orderModel.orderDetail.toJson(),
        'advancePayment': orderModel.advancePayment,
        'price': orderModel.price,
        'hostId': orderModel.hostId,
        'homeStayId': orderModel.homeStayId,
        'orderStatus': OrderStatus.pending.index,
      });
      return 'Order Placed Successfully';
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

  Stream<List<OrderModel>> getOrdersStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final data =
          _orderDb.where('orderInfo.customerId', isEqualTo: uid).snapshots();
      final response = data.asyncMap((event) async {
        final data = Future.wait(
          event.docs.map((e) async {
            final json = e.data();
            final userData = await getUserDetail(json['hostId']);
            return OrderModel.fromJson({
              ...json,
              'orderId': e.id,
              'user': userData,
            });
          }).toList(),
        );
        return data;
      });
      return response;
    } on FirebaseException catch (error) {
      throw '$error';
    }
  }

  Stream<OrderModel> getOrderDetail(String orderId) {
    try {
      return _orderDb.doc(orderId).snapshots().asyncMap((orderData) async {
        final json = orderData.data();
        if (json == null) {
          // If the document doesn't exist or has no data, json will be null.
          // Throw an exception as OrderModel.fromJson would likely fail or produce an invalid model.
          throw Exception("Order with ID '$orderId' not found or contains no data.");
        }

        // Ensure orderInfo and customerId exist and are of expected types
        final orderInfo = json['orderInfo'] as Map<String, dynamic>?;
        if (orderInfo == null) {
          throw Exception("Order info is missing for order '$orderId'.");
        }

        final customerId = orderInfo['customerId'] as String?;
        if (customerId == null) {
          throw Exception("Customer ID is missing in order info for order '$orderId'.");
        }

        final userData = await getUserDetail(customerId);
        
        // Now that json is confirmed to be non-null, it can be safely spread.
        return OrderModel.fromJson({
          ...json,
          'orderId': orderData.id,
          'user': userData,
        });
      });
    } on FirebaseException catch (error) {
      // It's often better to throw a more specific error or the original FirebaseException
      throw 'Error fetching order detail for $orderId: ${error.message}';
    }
  }

  Future<types.User> getUserDetail(String userId) async {
    try {
      final snapshot = await _userDb.doc(userId).get();
      if (snapshot.exists) {
        final json = snapshot.data() as Map<String, dynamic>;
        return types.User(
          id: snapshot.id,
          firstName: json['firstName'],
          metadata: {
            'deviceToken': json['metadata']['deviceToken'],
            'email': json['metadata']['email'],
            'phone': json['metadata']['phone'],
            'role': json['metadata']['role'],
          },
        );
      } else {
        throw 'User not found';
      }
    } on FirebaseException catch (error) {
      throw '$error';
    }
  }
}
