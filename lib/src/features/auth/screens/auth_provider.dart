
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/features/auth/data/auth_repo_impl.dart';
import 'package:homestay_app/src/features/auth/domain/auth_repo.dart';

final authProvider = Provider<AuthRepository>((ref) {
  return AuthRepoImpl();
});

final authStream = StreamProvider.autoDispose((ref) => FirebaseAuth.instance.authStateChanges());