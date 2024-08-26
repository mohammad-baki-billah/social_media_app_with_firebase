import 'package:flutter/material.dart';

// display error message to user with duration
void displayMessageToUser(String message, BuildContext context, {int durationInSeconds = 1}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
    ),
  );

  // Auto-close the dialog after the specified duration
  Future.delayed(Duration(seconds: durationInSeconds), () {
    Navigator.pop(context);
  });
}
