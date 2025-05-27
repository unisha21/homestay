import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homestay_app/src/features/order/domain/order_model.dart';
import 'package:homestay_app/src/features/payment/domain/payment_model.dart';

class PaymentDataSource{
  final _paymentDb = FirebaseFirestore.instance.collection('payments');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addPayment(OrderModel orderModel, String transactionId, String token) async {
    try {
      await _paymentDb.add(
        {
          'idx': transactionId,
          'token': token,
          'orderId': orderModel.orderId,
          'customerId': orderModel.orderDetail.customerId,
          'amount': orderModel.advancePayment,
          'orderInfo': {
            'price': orderModel.price,
            'contact': orderModel.orderDetail.customerPhone,
            'customerName': orderModel.orderDetail.customerName,
            'homeStayId': orderModel.homeStayId,
            'hostId': orderModel.hostId,
            'homeStayName': orderModel.orderDetail.homeStayName,
          },
          'createdAt': "${DateTime.now()}",
        },
      );
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }


  Future<List<PaymentDetailModel>> getPaymentHistory() async {
    try {
      final snapshot = await _paymentDb.where('customerId', isEqualTo: userId).get();
      final data = snapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data();
        print(data);
        return PaymentDetailModel.fromJson(data);
      }).toList();
      return data;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

}