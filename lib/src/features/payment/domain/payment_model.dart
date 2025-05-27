class PaymentDetailModel{
  String idx;
  String token;
  String orderId;
  String customerId;
  String amount;
  String createdAt;
  OrderInfo orderInfo;

  PaymentDetailModel({
    required this.idx,
    required this.token,
    required this.orderId,
    required this.customerId,
    required this.amount,
    required this.createdAt,
    required this.orderInfo,
  });

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      idx: json['idx'] as String,
      token: json['token'] as String,
      orderId: json['orderId'] as String,
      customerId: json['customerId'] as String,
      amount: json['amount'] as String,
      createdAt: json['createdAt'] as String,
      orderInfo: OrderInfo.fromJson(json['orderInfo']),
    );
  }

}

class OrderInfo{
  String price;
  String homeStayId;
  String contact;
  String customerName;
  String? homeStayName;
  String hostId;

  OrderInfo({
    required this.price,
    required this.contact,
    required this.customerName,
    required this.homeStayId,
    this.homeStayName,
    required this.hostId,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      price: json['price'] as String,
      contact: json['contact'] as String,
      customerName: json['customerName'] as String,
      homeStayId: json['homeStayId'] as String,
      homeStayName: json['homeStayName'] as String?,
      hostId: json['hostId'] as String,
    );
  }
}