import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homestay_app/src/features/auth/screens/status_screen.dart';
import 'package:homestay_app/src/themes/extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StatusScreen()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text(
              "Mount'n Stay",
              style: context.theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                color: const Color.fromARGB(255, 241, 220, 28),
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
