import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/models/payment_method_model.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/transactions/components/payment_card.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/payment_method_service.dart';
import 'package:ybb_event_app/services/payment_service.dart';
import 'package:ybb_event_app/services/progam_payment_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List<ProgramPaymentModel>? payments;
  List<PaymentMethodModel>? paymentMethods;
  List<PaymentModel>? participantPayments;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() {
    String id = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .id!;

    String participantId =
        Provider.of<ParticipantProvider>(context, listen: false)
            .participant!
            .id!;

    // get payments
    ProgramPaymentService().getAll(id).then((value) {
      setState(() {
        payments = value;
      });

      Provider.of<PaymentProvider>(context, listen: false)
          .setProgramPayments(value);
    });

    // get payment methods
    PaymentMethodService().getAll(id).then((value) {
      setState(() {
        paymentMethods = value;
      });

      Provider.of<PaymentProvider>(context, listen: false)
          .setPaymentMethods(value);
    });

    // get payments based on participant id
    PaymentService().getAll(participantId).then((value) {
      setState(() {
        participantPayments = value;
      });

      Provider.of<PaymentProvider>(context, listen: false).setPayments(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Transactions"),
      body: payments == null ||
              paymentMethods == null ||
              participantPayments == null
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: primary, size: 40),
            )
          : payments!.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonMethods().buildNothingToShow(
                      "No Transactions Available",
                      "There are no transactions available at the moment. Please check back later.",
                    ),
                  ],
                )
              // build list of payments in a grid view
              : ScreenSizeHelper.responsiveValue(
                  context,
                  mobile: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < payments!.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: PaymentCard(payment: payments![i]),
                          ),
                      ],
                    ),
                  ),
                  desktop: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: payments!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: PaymentCard(payment: payments![index]),
                      );
                    },
                  ),
                ),
    );
  }
}
