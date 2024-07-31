import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/components/payment_detail_card.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/components/payment_history_tile.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class PaymentDetailPage extends StatefulWidget {
  final ProgramPaymentModel? payment;
  const PaymentDetailPage({super.key, this.payment});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  buildPaymentList(List<PaymentModel> payments) {
    // sort payments by created at
    payments.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    payments.removeWhere((element) => element.isDeleted == "1");

    bool showButton = false;

    payments.any((element) => element.status == "2")
        ? showButton = false
        : showButton = true;

    List<Widget> paymentTiles =
        payments.map((e) => PaymentHistoryTile(payment: e)).toList();

    return Column(
      children: [
        ...paymentTiles,
        const SizedBox(height: 20),
        showButton
            ? CommonMethods().buildCustomButton(
                width: MediaQuery.of(context).size.width * 0.3,
                color: primary,
                text: "Make Another Payment",
                onPressed: () {
                  context.pushNamed(proceedPaymentRouteName,
                      extra: widget.payment!);
                },
              )
            : Container(),
      ],
    );
  }

  checkIfExpired() {
    if (widget.payment!.endDate!.isBefore(DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }

  buildPaymentHistorySection(List<PaymentModel> payments) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        const SizedBox(height: 20),
        const Text(
          "Payment History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
            "If you have a pending payment, please wait for it to be processed. Until then, you can't make another payment.",
            style: bodyTextStyle.copyWith(
              color: Colors.red,
              fontSize: 12,
            )),
        const SizedBox(height: 10),
        payments.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "No payment history available",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // button to add payment
                    checkIfExpired()
                        ? Text(
                            "This payment is already due. You cannot make payment for this.",
                            style: headlineTextStyle.copyWith(
                                fontSize: 20, color: Colors.red),
                          )
                        : CommonMethods().buildCustomButton(
                            width: MediaQuery.of(context).size.width * 0.3,
                            color: primary,
                            text: "Make Payment",
                            onPressed: () {
                              context.pushNamed(proceedPaymentRouteName,
                                  extra: widget.payment!);
                            },
                          ),
                  ],
                ),
              )
            : buildPaymentList(payments),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var paymentProvider = Provider.of<PaymentProvider>(context);

    // get all payments based on the payment id
    List<PaymentModel> payments = paymentProvider.payments!
        .where((element) => element.programPaymentId == widget.payment!.id)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Payment Detail"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaymentDetailCard(payment: widget.payment!),
              const SizedBox(height: 20),
              buildPaymentHistorySection(payments),
            ],
          ),
        ),
      ),
    );
  }
}
