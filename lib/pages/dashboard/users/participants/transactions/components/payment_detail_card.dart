import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/payment_method_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class PaymentDetailCard extends StatelessWidget {
  final ProgramPaymentModel payment;
  const PaymentDetailCard({super.key, required this.payment});

  buildCategoryChip() {
    return Chip(
      label: Text(
        payment.category!,
        style: bodyTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15,
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

    String startText = "Start Date: $start";
    String endText = "End Date: $end";

    return Column(
      children: [
        Text(
          startText,
          style: bodyTextStyle.copyWith(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          endText,
          style: bodyTextStyle.copyWith(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  buildPaymentPrice(BuildContext context, double usdAmount, double idrAmount) {
    String usd = NumberFormat.simpleCurrency(name: 'USD').format(usdAmount);
    String idr = NumberFormat.simpleCurrency(name: 'IDR').format(idrAmount);

    return Column(
      mainAxisAlignment: ScreenSizeHelper.responsiveValue(context,
          mobile: MainAxisAlignment.start, desktop: MainAxisAlignment.end),
      crossAxisAlignment: ScreenSizeHelper.responsiveValue(context,
          mobile: CrossAxisAlignment.start, desktop: CrossAxisAlignment.end),
      children: [
        RichText(
          text: TextSpan(
            text: usd,
            style: bodyTextStyle.copyWith(
              color: primary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: " (for international participants)",
                style: bodyTextStyle.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: idr,
            style: bodyTextStyle.copyWith(
              color: primary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: " (for Indonesian participants)",
                style: bodyTextStyle.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var paymentMethodProvider = Provider.of<PaymentProvider>(context);

    // copy the payment methods from the provider
    List<PaymentMethodModel> paymentMethods =
        List.from(paymentMethodProvider.paymentMethods!);

    paymentMethods.removeWhere((element) => element.type == "gateway");

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: SizedBox(
        width: ScreenSizeHelper.responsiveValue(context,
            mobile: MediaQuery.sizeOf(context).width, desktop: double.infinity),
        child: Padding(
          padding: ScreenSizeHelper.responsiveValue(context,
              mobile: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              desktop:
                  const EdgeInsets.symmetric(vertical: 40, horizontal: 40)),
          child: Column(
            mainAxisAlignment: ScreenSizeHelper.responsiveValue(context,
                mobile: MainAxisAlignment.start,
                desktop: MainAxisAlignment.center),
            crossAxisAlignment: ScreenSizeHelper.responsiveValue(context,
                mobile: CrossAxisAlignment.start,
                desktop: CrossAxisAlignment.center),
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.name!,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: headlineTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildCategoryChip(),
                      const SizedBox(height: 30),
                      buildPaymentDate(payment.startDate!, payment.endDate!),
                    ],
                  ),
                  ScreenSizeHelper.responsiveValue(
                    context,
                    mobile: const SizedBox.shrink(),
                    desktop: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildPaymentPrice(
                              context,
                              double.parse(payment.usdAmount!),
                              double.parse(payment.idrAmount!)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ScreenSizeHelper.responsiveValue(context,
                  mobile: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      //build payment price for mobile view
                      buildPaymentPrice(
                          context,
                          double.parse(payment.usdAmount!),
                          double.parse(payment.idrAmount!)),
                    ],
                  ),
                  desktop: const SizedBox.shrink()),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Available Payment Methods",
                    style: bodyTextStyle.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Automatic Checking",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontSize: 17,
                      )),
                  const SizedBox(height: 20),
                  Text(
                    "Virtual Accounts, QRIS, Credit Cards, and E-Wallets",
                    style: bodyTextStyle.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Manual Checking",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontSize: 17,
                      )),
                  // horizontal list view of payment methods from payment methods provider
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ScreenSizeHelper.responsiveValue(context,
                          mobile: 2, desktop: 6),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: CommonMethods().buildPaymentMethodCard(
                            context, paymentMethods[index], false),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
