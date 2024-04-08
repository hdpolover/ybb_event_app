import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:ybb_event_app/components/components.dart';

class CommonMethods {
  buildCustomButton(
      {double? width,
      Color? color,
      required String text,
      required Function() onPressed}) {
    return MaterialButton(
      minWidth: width ?? double.infinity,
      height: 60,
      color: color ?? primary,
      // give radius to the button
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPressed,
      child: Text(text, style: buttonTextStyle),
    );
  }

  buildTextField(Key key, String name, String hintText,
      List<FormFieldValidator> validators,
      {String? desc, dynamic initial, int? lines}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: bodyTextStyle.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Visibility(
              visible: desc != null,
              child: Column(
                children: [
                  Text(
                    (desc ?? ""),
                    style: bodyTextStyle.copyWith(color: Colors.red),
                  ),
                  const SizedBox(height: 15),
                ],
              )),
          FormBuilderTextField(
            maxLines: lines ?? 1,
            key: key,
            name: name,
            initialValue: initial,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            validator: FormBuilderValidators.compose(validators),
          ),
        ],
      ),
    );
  }

  buildCommonAppBar(String title) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(title, style: bodyTextStyle.copyWith(color: Colors.black)),
    );
  }

  getEventDate(DateTime start, DateTime end) {
    // format the date to be like "August 10 - 12, 2021"
    String formattedDate = "";

    if (start.month == end.month) {
      // get the month name
      String monthName = DateFormat('MMMM').format(start);

      formattedDate = "$monthName ${start.day} - ${end.day}, ${start.year}";
    } else {
      // get the month name
      String startMonthName = DateFormat('MMMM').format(start);
      String endMonthName = DateFormat('MMMM').format(end);

      formattedDate =
          "$startMonthName ${start.day} - $endMonthName ${end.day}, ${start.year}";
    }

    return formattedDate;
  }

  void showAlertDialog(BuildContext context, String s, String t, String u,
      String v, Null Function() param5) {}
}
