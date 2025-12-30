import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum RegisterUserResult { success, authFailed, unknown }

class FirebaseService {
  static Future<RegisterUserResult> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      final user = userCredential.user;
      if (user == null) return RegisterUserResult.unknown;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email.trim(),
        'username': username.trim(),
      });
      return RegisterUserResult.success;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return RegisterUserResult.authFailed;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return RegisterUserResult.unknown;
    }
  }
}
