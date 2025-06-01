import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:homestay_app/src/api/endpoints.dart';

class ChatDataSource {
  Future<void> sendNotification({
    required String token,
    required String title,
    required String message,
    Map<String, dynamic>? notificationData,
  }) async {
    final dio = Dio(
      BaseOptions(
        headers: {'Content-Type': 'application/json'},
        baseUrl: ApiEndPoints.baseUrl,
      ),
    );
    try {
      await dio.post(
        ApiEndPoints.sendNotification,
        data: {
          "token": token,
          "title": title,
          "body": message,
          "data": notificationData ?? <String, dynamic>{},
        },
      );
    } on DioException catch (e) {
      throw Exception(e.message);
    } on FirebaseException catch (err) {
      throw Exception(err.message);
    }
  }
}