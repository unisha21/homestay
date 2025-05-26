import 'package:flutter/foundation.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

@immutable
class BookingModel {
  final String homestayId;
  final String userName;
  final String userPhone;
  final DateTime checkInDate;
  final int numberOfNights;
  final int numberOfGuests;
  final double pricePerNight;
  final double totalPrice;
  final String? notes;
  const BookingModel({
    required this.homestayId,
    required this.userName,
    required this.userPhone,
    required this.checkInDate,
    required this.numberOfNights,
    required this.numberOfGuests,
    required this.pricePerNight,
    required this.totalPrice,
    this.notes,
  });

  //copyWith method
  BookingModel copyWith({
    String? id,
    String? homestayId,
    String? userId,
    String? userName,
    String? userPhone,
    DateTime? checkInDate,
    int? numberOfNights,
    int? numberOfGuests,
    double? pricePerNight,
    double? totalPrice,
    String? notes,
    BookingStatus? status,
    DateTime? createdAt,
    String? paymentId,
  }) {
    return BookingModel(
      homestayId: homestayId ?? this.homestayId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      checkInDate: checkInDate ?? this.checkInDate,
      numberOfNights: numberOfNights ?? this.numberOfNights,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      notes: notes ?? this.notes,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  // For JSON serialization if you plan to use with Firestore/API
  Map<String, dynamic> toJson() {
    return {
      'homestayId': homestayId,
      'userName': userName,
      'userPhone': userPhone,
      'checkInDate': checkInDate.toIso8601String(),
      'numberOfNights': numberOfNights,
      'numberOfGuests': numberOfGuests,
      'pricePerNight': pricePerNight,
      'notes': notes,
      'totalPrice': totalPrice,
    };
  }

  // For JSON deserialization
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      homestayId: json['homestayId'] as String,
      userName: json['userName'] as String,
      userPhone: json['userPhone'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      numberOfNights: json['numberOfNights'] as int,
      numberOfGuests: json['numberOfGuests'] as int,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      notes: json['notes'] as String?,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}