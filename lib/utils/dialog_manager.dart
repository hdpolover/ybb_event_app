import 'package:flutter/material.dart';
import 'package:ybb_event_app/components/components.dart';

class DialogManager {
  static void showFullScreenDialog(BuildContext context, Function onConfirm) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          iconPadding: const EdgeInsets.only(top: 30),
          icon: const Icon(
            Icons.warning,
            color: Colors.orange,
            size: 60,
          ),
          content: Text(
            "This website is best viewed fullscreen. Would you like to switch to fullscreen mode? \n(You can always switch back to normal mode by clicking the full screen icon button on the top right or by pressing 'F11' or 'Esc')",
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
                'NO',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // a button to close the dialog with primary color
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              child: const Text(
                'YES',
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

  static void showConfirmationDialog(
      BuildContext context, String message, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          iconPadding: const EdgeInsets.only(top: 30),
          icon: const Icon(
            Icons.warning,
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
                'CANCEL',
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // a button to close the dialog with primary color
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              child: const Text(
                'CONFIRM',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showAlertDialog(BuildContext context, String message,
      {bool? isGreen}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          iconPadding: const EdgeInsets.only(top: 30),
          icon: Icon(
            isGreen == null
                ? Icons.error
                : isGreen
                    ? Icons.check
                    : Icons.error,
            color: isGreen == null
                ? Colors.red
                : isGreen
                    ? Colors.green
                    : Colors.red,
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
