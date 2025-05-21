import 'package:flutter/material.dart';



buildErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 5,
            ),
            Icon(Icons.warning_rounded, size: 70,),
            SizedBox(height: 10,),
            Text(
              'Something went wrong!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 5),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    },
  );
}



Future<void> buildLoadingDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(),
            SizedBox(
              height: 30,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    },
  );
}


buildSuccessDialog(BuildContext context, String message, VoidCallback onPressed) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 5,
            ),
            Icon(Icons.check_circle, size: 70,),
            SizedBox(height: 10,),
            Text(
              'Operation Successful!!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 5),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}