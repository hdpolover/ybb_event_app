import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class PaymentCard extends StatelessWidget {
  final ProgramPaymentModel payment;
  const PaymentCard({super.key, required this.payment});

  buildCategoryChip() {
    return Chip(
      label: AutoSizeText(
        payment.category!,
        style: bodyTextStyle.copyWith(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  buildPaymentDate(DateTime startDate, DateTime endDate) {
    String start = DateFormat('MMM dd, yyyy').format(startDate);
    String end = DateFormat('MMM dd, yyyy').format(endDate);

    String shownText = "";

    DateTime now = DateTime.now();

    if (startDate.isBefore(now) && endDate.isAfter(now)) {
      shownText = "Available until $end";
    } else if (startDate.isAfter(now)) {
      // get difference between now and start date
      Duration difference = startDate.difference(now);
      shownText = "Available in $difference days";
    } else {
      shownText = "Expired on $end";
    }

    return AutoSizeText(
      shownText,
      style: bodyTextStyle.copyWith(
        color: Colors.black,
        fontSize: 12,
      ),
    );
  }

  buildPaymentPrice(double usdAmount, double idrAmount) {
    String usd = NumberFormat.simpleCurrency(name: 'USD').format(usdAmount);
    String idr = NumberFormat.simpleCurrency(name: 'IDR').format(idrAmount);

    return Text("$usd / $idr",
        style: bodyTextStyle.copyWith(
          color: primary,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              payment.name!,
              textAlign: TextAlign.center,
              style: headlineTextStyle.copyWith(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            buildCategoryChip(),
            const SizedBox(height: 20),
            buildPaymentDate(payment.startDate!, payment.endDate!),
            const SizedBox(height: 10),
            buildPaymentPrice(double.parse(payment.usdAmount!),
                double.parse(payment.idrAmount!)),
            ScreenSizeHelper.responsiveValue(context,
                desktop: const Spacer(), mobile: const SizedBox(height: 10)),
            CommonMethods().buildCustomButton(
              text: "View Details",
              onPressed: () {
                // navigate to payment details
                context.pushNamed(paymentDetailRouteName, extra: payment);
              },
            ),
          ],
        ),
      ),
    );
  }
}
