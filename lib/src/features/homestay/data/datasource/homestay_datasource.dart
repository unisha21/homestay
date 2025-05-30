import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_app/src/features/review/domain/review_model.dart';

class HomestayDatasource {
  final homestayDb = FirebaseFirestore.instance.collection('homestays');
  final _userDb = FirebaseFirestore.instance.collection('users');
  final _reviewDb = FirebaseFirestore.instance.collection('reviews');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<HomestayModel>> getHomeStay() async {
    try {
      final response = await homestayDb.get();
      final homeStayList = await Future.wait(
        response.docs.map((doc) async {
          final json = doc.data();
          final user = await getUserDetail(json['hostId']);
          final reviews = await getReview(doc.id);
          return HomestayModel.fromJson({
            ...json,
            'id': doc.id,
            'user': user,
            'reviews': reviews,
          });
        }),
      );
      return homeStayList;
    } on FirebaseException catch (err) {
      throw '$err';
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

  Future<List<ReviewModel>> getReview(String homeStayId) async {
    try {
      final response = await _reviewDb.where('homeStayId', isEqualTo: homeStayId).get();
      final reviewList = await Future.wait(
        response.docs.map((doc) async {
          final json = doc.data();
          return ReviewModel.fromJson({...json, 'reviewId': doc.id});
        }),
      );
      return reviewList;
    } on FirebaseException catch (err) {
      throw '$err';
    }
  }
}
