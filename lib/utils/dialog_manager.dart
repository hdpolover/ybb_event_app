import 'package:flutter/material.dart';
import 'package:ybb_event_app/components/components.dart';

class DialogManager {
  static void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          iconPadding: const EdgeInsets.only(top: 30),
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            size: 60,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: bodyTextStyle.copyWith(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // a button to close the dialog with primary color
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
