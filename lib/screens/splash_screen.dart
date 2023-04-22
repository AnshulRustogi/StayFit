import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/after_login_screen.dart';
import '../screens/login_screen.dart';
import 'package:get/get.dart';
import '../helpers/Globals.dart';
import '../services/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

enum AuthStatus { notSignedIn, signedIn }

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    AuthService().getCurrentUserId().then((userId) {
      if (userId != null) {
        Globals.currentUserID = userId;
        openHomePage();
      } else {
        openAuthPage();
      }
      setState(() {
        _authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  openHomePage() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, () {
      Get.to(() => const AfterLoginScreen());
    });
  }

  openAuthPage() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, () {
      Get.to(() => const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: const Text(
            "StayFit",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
