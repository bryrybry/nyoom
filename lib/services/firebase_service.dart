import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum RegisterUserResult { success, authFailed, unknown }

enum LoginUserResult {
  success,
  noUser,
  invalidEmail,
  emailNotFound,
  wrongPassword,
  unknown,
}

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

  static Future<LoginUserResult> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      final user = userCredential.user;
      if (user == null) return LoginUserResult.unknown;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email.trim(),
      }, SetOptions(merge: true));
      return LoginUserResult.success;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      switch (e.code) {
        case 'invalid-email':
          return LoginUserResult.invalidEmail;
        case 'user-not-found':
          return LoginUserResult.emailNotFound;
        case 'wrong-password':
          return LoginUserResult.wrongPassword;
        default:
          return LoginUserResult.unknown;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return LoginUserResult.unknown;
    }
  }
}
