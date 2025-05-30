class ReviewModel {
  String? reviewId;
  String review;
  double rating;
  String userId;
  String hostId;
  String orderId;
  String homeStayId;
  String createdAt;
  String userName;

  ReviewModel({
    this.reviewId,
    required this.review,
    required this.rating,
    required this.userId,
    required this.hostId,
    required this.orderId,
    required this.homeStayId,
    required this.createdAt,
    required this.userName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewId'],
      review: json['review'],
      rating: json['rating'],
      userId: json['userId'],
      hostId: json['hostId'],
      orderId: json['orderId'],
      homeStayId: json['homeStayId'],
      createdAt: json['createdAt'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review': review,
      'rating': rating,
      'userId': userId,
      'hostId': hostId,
      'orderId': orderId,
      'homeStayId': homeStayId,
      'createdAt': createdAt,
      'userName': userName,
    };
  }
}
