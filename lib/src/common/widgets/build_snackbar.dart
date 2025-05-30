import 'package:flutter/material.dart';

class BuildSnackBar {
  static SnackBar buildSnackBar(String message, {Color color = Colors.green}) {
    return SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      content: Center(child: Text(message)),
    );
  }
}
