import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

enum OrderStatus { pending, accepted, rejected, completed, cancelled }

class OrderModel {
  final String orderId;
  final OrderDetail orderDetail;
  final String advancePayment;
  final String price;
  final String hostId;
  final OrderStatus status;
  final types.User user;

  const OrderModel({
    required this.orderId,
    required this.orderDetail,
    required this.advancePayment,
    required this.price,
    required this.hostId,
    required this.status,
    required this.user,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] as String,
      orderDetail: OrderDetail.fromJson(json['orderInfo']),
      advancePayment: json['advancePayment'] as String,
      price: json['price'] as String,
      hostId: json['hostId'] as String,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      user: types.User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderDetail': orderDetail, // Assuming you have a method to convert this
      'advancePayment': advancePayment,
      'price': price,
      'hostId': hostId,
      'status': status.toString().split('.').last,
      'user': user.toJson(),
    };
  }
}

class OrderDetail {
  final String customerId;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String orderDate;
  final int numberOfNights;
  final int numberOfGuests;
  final String? notes;
  const OrderDetail({
    required this.customerId,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.orderDate,
    required this.numberOfNights,
    required this.numberOfGuests,
    this.notes,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerAddress: json['customerAddress'] as String,
      customerPhone: json['customerPhone'] as String,
      orderDate: json['orderDate'] as String,
      numberOfNights: json['numberOfNights'] as int,
      numberOfGuests: json['numberOfGuests'] as int,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'orderDate': orderDate,
      'numberOfNights': numberOfNights,
      'numberOfGuests': numberOfGuests,
      'notes': notes,
    };
  }
}
