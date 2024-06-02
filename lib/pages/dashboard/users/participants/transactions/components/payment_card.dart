import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class PaymentCard extends StatefulWidget {
  final ProgramPaymentModel payment;
  const PaymentCard({super.key, required this.payment});

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  buildCategoryChip() {
    return Chip(
      label: AutoSizeText(
        widget.payment.category!,
        style: bodyTextStyle.copyWith(
          color: Colors.white,
          fontSize: 10.sp,
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
        fontSize: 12.sp,
      ),
    );
  }

  buildPaymentPrice(double usdAmount, double idrAmount) {
    String usd = NumberFormat.simpleCurrency(name: 'USD').format(usdAmount);
    String idr = NumberFormat.simpleCurrency(name: 'IDR').format(idrAmount);

    return Text("$usd / $idr",
        style: bodyTextStyle.copyWith(
          color: primary,
          fontSize: 13.sp,
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
              widget.payment.name!,
              textAlign: TextAlign.center,
              style: headlineTextStyle.copyWith(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            buildCategoryChip(),
            SizedBox(height: 2.h),
            buildPaymentDate(
                widget.payment.startDate!, widget.payment.endDate!),
            SizedBox(height: 1.h),
            buildPaymentPrice(double.parse(widget.payment.usdAmount!),
                double.parse(widget.payment.idrAmount!)),
            ResponsiveBreakpoints.of(context).isMobile
                ? const SizedBox(height: 20)
                : const Spacer(),
            CommonMethods().buildCustomButton(
              text: "View Details",
              onPressed: () {
                // navigate to payment details
                context.pushNamed(paymentDetailRouteName,
                    extra: widget.payment);
              },
            ),
          ],
        ),
      ),
    );
  }
}
