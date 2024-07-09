import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class PaymentHistoryTile extends StatefulWidget {
  final PaymentModel? payment;
  const PaymentHistoryTile({super.key, this.payment});

  @override
  State<PaymentHistoryTile> createState() => _PaymentHistoryTileState();
}

class _PaymentHistoryTileState extends State<PaymentHistoryTile> {
  buildChip(String status) {
    Color color = Colors.grey;
    String text = "";

    if (status == "0" || status == "1") {
      color = Colors.orange;
      text = "Pending";
    } else if (status == "2") {
      color = Colors.green;
      text = "Success";
    } else if (status == "3" || status == "4") {
      color = Colors.red;
      text = "Rejected/Failed";
    }

    return Chip(
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var paymentProvider = Provider.of<PaymentProvider>(context);

    String paymentName = "";
    String paymentMethodName = "";

    // lakukan perulangan pada list program payment dan cari yang idnya sama dengan payment id
    // jika ada, maka tampilkan program payment tersebut
    // jika tidak, maka tampilkan program payment yang lain
    for (var programPayment in paymentProvider.programPayments!) {
      if (programPayment.id == widget.payment!.programPaymentId) {
        paymentName = programPayment.name!;
        break;
      } else {
        paymentName = "Unknown Payment";
      }
    }

    for (var paymentMethod in paymentProvider.paymentMethods!) {
      if (paymentMethod.id == widget.payment!.paymentMethodId) {
        paymentMethodName = paymentMethod.name!;
        break;
      } else {
        paymentMethodName = "Unknown Payment Method";
      }
    }

    // format date to be like "April 14, 2024 10:00:00"
    String paymentDate =
        DateFormat('MMM dd, yyyy HH:mm').format(widget.payment!.createdAt!);

    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        horizontalTitleGap:
            ScreenSizeHelper.responsiveValue(context, mobile: 0, desktop: 30),
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: ScreenSizeHelper.responsiveValue(context,
            mobile: const SizedBox.shrink(),
            desktop: buildChip(widget.payment!.status!)),
        title: ScreenSizeHelper.responsiveValue(context,
            desktop: Text(
              paymentName,
              style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            mobile: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildChip(widget.payment!.status!),
                const SizedBox(height: 10),
                Text(
                  paymentName,
                  style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(paymentMethodName),
                const SizedBox(height: 5),
                Text(paymentDate)
              ],
            )),
        subtitle: ScreenSizeHelper.responsiveValue(context,
            mobile: const SizedBox.shrink(), desktop: Text(paymentMethodName)),
        trailing: ScreenSizeHelper.responsiveValue(context,
            mobile: const SizedBox.shrink(), desktop: Text(paymentDate)),
        onTap: () {
          context.pushNamed(paymentHistoryDetailRouteName,
              extra: widget.payment!);
        },
      ),
    );
  }
}
