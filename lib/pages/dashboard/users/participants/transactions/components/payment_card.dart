import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class PaymentCard extends StatefulWidget {
  final ProgramPaymentModel payment;
  const PaymentCard({super.key, required this.payment});

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  PaymentModel? currentPayment;
  @override
  void initState() {
    super.initState();

    checkStatus();
  }

  checkStatus() {
    var paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

    print(paymentProvider.payments!.length);

    for (var a in paymentProvider.payments!) {
      if (a.programPaymentId == widget.payment.id) {
        print("Payment ${widget.payment.id} is paid");
        setState(() {
          currentPayment = a;
        });
      }
    }
  }

  buildStatusChip() {
    var paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

    Color color = Colors.green;
    String statusText = "";

    if (currentPayment == null) {
      color = Colors.red;
      statusText = "Unpaid";
    } else {
      bool isPaid = paymentProvider.payments!.any((element) =>
          element.programPaymentId == widget.payment.id &&
          element.status == "2");

      if (isPaid) {
        color = Colors.green;
        statusText = "Paid";
      } else {
        color = Colors.orange;
        statusText = "Processing";
      }
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        label: AutoSizeText(
          statusText,
          style: bodyTextStyle.copyWith(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  buildPaymentDate(DateTime startDate, DateTime endDate) {
    String start = DateFormat('MMM dd, yyyy').format(startDate);
    String end = DateFormat('MMM dd, yyyy').format(endDate);

    String shownText = "";
    Color color = Colors.black;

    DateTime now = DateTime.now();

    if (startDate.isBefore(now) && endDate.isAfter(now)) {
      shownText = "Available until $end";
    } else if (startDate.isAfter(now)) {
      // get difference between now and start date
      Duration difference = startDate.difference(now);
      shownText = "Available in $difference days";
    } else {
      shownText = "Due on $end";
      color = Colors.red;
    }

    return AutoSizeText(
      shownText,
      style: bodyTextStyle.copyWith(
        color: color,
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
          fontSize: 16,
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
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildStatusChip(),
            const SizedBox(height: 30),
            Text(
              widget.payment.name!,
              textAlign: TextAlign.center,
              softWrap: true,
              style: headlineTextStyle.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            buildPaymentPrice(double.parse(widget.payment.usdAmount!),
                double.parse(widget.payment.idrAmount!)),
            const SizedBox(height: 10),

            // const SizedBox(height: 20),
            buildPaymentDate(
                widget.payment.startDate!, widget.payment.endDate!),
            const SizedBox(height: 10),

            ScreenSizeHelper.responsiveValue(context,
                desktop: const Spacer(), mobile: const SizedBox(height: 10)),
            CommonMethods().buildCustomUnderlineButton(
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
