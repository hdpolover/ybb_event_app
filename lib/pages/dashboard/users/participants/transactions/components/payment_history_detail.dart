import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

import '../../../../../../providers/payment_provider.dart';

class PaymentHistoryDetail extends StatefulWidget {
  final PaymentModel payment;
  const PaymentHistoryDetail({super.key, required this.payment});

  @override
  State<PaymentHistoryDetail> createState() => _PaymentHistoryDetailState();
}

class _PaymentHistoryDetailState extends State<PaymentHistoryDetail> {
  buildPaymentHistoryItem(String title, String desc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bodyTextStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          desc,
          style: bodyTextStyle.copyWith(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  buildPaymentProof(String imgUrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Proof",
          style: bodyTextStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(imgUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  getPaymentStatus(String st) {
    String status = "";

    if (st == "0") {
      status = "Created";
    } else if (st == "1") {
      status = "Pending";
    } else if (st == "2") {
      status = "Success";
    } else if (st == "3") {
      status = "Failed";
    }

    return status;
  }

  @override
  Widget build(BuildContext context) {
    var paymentProvider = Provider.of<PaymentProvider>(context);

    String? programPaymentName, paymentMethodName;

    for (var programPayment in paymentProvider.programPayments!) {
      if (programPayment.id == widget.payment.programPaymentId) {
        programPaymentName = programPayment.name;
        break;
      }
    }

    for (var i in paymentProvider.paymentMethods!) {
      print(i.name);
    }

    for (var paymentMethod in paymentProvider.paymentMethods!) {
      if (paymentMethod.id == widget.payment.paymentMethodId) {
        paymentMethodName = paymentMethod.name;
        break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          CommonMethods().buildCommonAppBar(context, "Payment History Detail"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPaymentHistoryItem("Payment Name", programPaymentName!),
              const SizedBox(height: 10),
              buildPaymentHistoryItem("Payment Method",
                  paymentMethodName ??= "Automatic Payment Checking"),
              const SizedBox(height: 10),
              buildPaymentHistoryItem("Amount", widget.payment.amount!),
              const SizedBox(height: 10),
              buildPaymentHistoryItem(
                  "Status", getPaymentStatus(widget.payment.status!)),
              const SizedBox(height: 10),
              buildPaymentHistoryItem(
                  "Date",
                  DateFormat('MMM dd, yyyy HH:mm')
                      .format(widget.payment.createdAt!)),
              const SizedBox(height: 10),
              buildPaymentHistoryItem(
                  "Account Name", widget.payment.accountName ?? "-"),
              const SizedBox(height: 10),
              buildPaymentHistoryItem(
                  "Source Name", widget.payment.sourceName! ?? "-"),
              const SizedBox(height: 10),
              widget.payment.proofUrl == null
                  ? const SizedBox.shrink()
                  : Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.payment.proofUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
