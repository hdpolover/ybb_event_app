import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_announcement_model.dart';

class DialogManager {
  static void showAnnouncementDialog(
      BuildContext context, ProgramAnnouncementModel announcement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          iconPadding: const EdgeInsets.only(top: 30),
          icon: Image.network(
            announcement.imgUrl!,
            width: MediaQuery.sizeOf(context).width * 0.5,
            height: MediaQuery.sizeOf(context).height * 0.3,
            fit: BoxFit.cover,
          ),
          content: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title!,
                  style: bodyTextStyle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                Text(
                  "Published on ${DateFormat('dd MMMM yyyy').format(announcement.createdAt!)}",
                  style: bodyTextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.35,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HtmlWidget(
                          announcement.description!,
                          textStyle: bodyTextStyle.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // a button to close the dialog with primary color
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CLOSE',
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

  static void showVerifyAlert(
      BuildContext context, String message, Function onResend, Function onOk) {
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
                onOk();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // a button to close the dialog with primary color
            TextButton(
              onPressed: () {
                onResend();
              },
              child: const Text(
                'RESEND EMAIL',
                style: TextStyle(
                  color: Colors.green,
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
      {bool? isGreen, Function()? pressed}) {
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
              onPressed: pressed ??
                  () {
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
