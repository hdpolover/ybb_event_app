import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/payment_method_model.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';

class CommonMethods {
  buildCustomButton(
      {double? width,
      Color? color,
      required String text,
      required Function() onPressed}) {
    return MaterialButton(
      minWidth: width ?? double.infinity,
      height: 50,
      color: color ?? primary,
      // give radius to the button
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPressed,
      child: AutoSizeText(text, style: buttonTextStyle),
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

  buildNothingToShow(String title, String desc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // show an icon of no data in general
          const Icon(
            Icons.hourglass_empty,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: headlineTextStyle.copyWith(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Text(desc,
              style: bodyTextStyle.copyWith(
                color: Colors.grey,
                fontSize: 15,
              )),
          const SizedBox(height: 20),
          // CommonMethods().buildCustomButton(
          //   width: 200,
          //   color: Colors.blue,
          //   text: "Make a transaction",
          //   onPressed: () {
          //     // navigate to the transaction page
          //   },
          // ),
        ],
      ),
    );
  }

  buildCommonAppBar(BuildContext context, String title) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // pop the current page
          Navigator.of(context).pop();
        },
      ),
      automaticallyImplyLeading: true,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      elevation: 5,
      title: Text(
        title,
      ),
    );
  }

  buildPaymentMethodCard(BuildContext context, PaymentMethodModel paymentMethod,
      bool? isClickable) {
    isClickable ??= false;

    bool isClicked = false;

    return MouseRegion(
      cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: InkWell(
        onTap: isClickable
            ? () {
                Provider.of<PaymentProvider>(context, listen: false)
                    .setSelectedPaymentMethod(paymentMethod);

                isClicked = !isClicked;
              }
            : null,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: isClicked ? primary : Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  paymentMethod.imgUrl!,
                  height: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                AutoSizeText(
                  paymentMethod.name!,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: isClicked
                      ? bodyTextStyle.copyWith(color: Colors.white)
                      : bodyTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
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
