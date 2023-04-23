// ignore: unused_import
import 'dart:io' show Platform;
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:StayFit/screens/after_login_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:StayFit/helpers/Globals.dart';

class AuthService {
  Future<void> signInWithGoogle(BuildContext ctx) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final User? currentFirebaseUser = userCredential.user;

    if (currentFirebaseUser != null) {}

    Get.to(() => const AfterLoginScreen());
  }

  Stream<User?> get user {
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<String?> getCurrentUserId() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      Globals.currentUserID = currentUser.uid;
      return currentUser.uid;
    } else {
      return null;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
