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
  List<ProgramPaymentModel>? shownPayments;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    var paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

    String id = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .id!;

    String participantId =
        Provider.of<ParticipantProvider>(context, listen: false)
            .participant!
            .id!;

    // get payments
    await ProgramPaymentService().getAll(id).then((value) async {
      setState(() {
        payments = value;
      });

      paymentProvider.setProgramPayments(value);

      // get payment methods
      await PaymentMethodService().getAll(id).then((value) async {
        setState(() {
          paymentMethods = value;
        });

        paymentProvider.setPaymentMethods(value);

        // get payments based on participant id
        await PaymentService().getAll(participantId).then((value) {
          setState(() {
            participantPayments = value;
          });

          paymentProvider.setPayments(value);

          showWhichCards();
        });
      });
    });
  }

  showWhichCards() {
    List<ProgramPaymentModel> registration = [];
    List<ProgramPaymentModel> batch1 = [];
    List<ProgramPaymentModel> batch2 = [];

    List<ProgramPaymentModel> tempShownPayments = [];

    for (var a in payments!) {
      switch (a.category) {
        case "registration":
          registration.add(a);
          break;
        case "program_fee_1":
          batch1.add(a);
          break;
        case "program_fee_2":
          batch2.add(a);
          break;
      }
    }

    bool showRegist = false;
    bool isRegistPaid = false;

    // get regist card
    for (var a in registration) {
      if (participantPayments!
          .any((element) => element.programPaymentId == a.id)) {
        tempShownPayments.add(a);
        showRegist = true;

        if (participantPayments!.any((element) =>
            element.programPaymentId == a.id && element.status == "2")) {
          isRegistPaid = true;
        } else {
          isRegistPaid = false;
        }

        break;
      } else {
        // get available registration card
        if (a.endDate!.isAfter(DateTime.now())) {
          tempShownPayments.add(a);
          showRegist = false;
          break;
        }
      }
    }

    if (isRegistPaid) {
      bool isBatch1Paid = false;

      // get batch 1 card
      if (showRegist) {
        for (var a in batch1) {
          if (participantPayments!
              .any((element) => element.programPaymentId == a.id)) {
            tempShownPayments.add(a);

            if (participantPayments!.any((element) =>
                element.programPaymentId == a.id && element.status == "2")) {
              isBatch1Paid = true;
            } else {
              isBatch1Paid = false;
            }
            break;
          } else if (a.startDate!.isBefore(DateTime.now())) {
            tempShownPayments.add(a);
            isBatch1Paid = false;
            break;
          }
        }
      }

      bool isBatch2Paid = false;

      // get batch 2 card
      if (isBatch1Paid) {
        for (var a in batch2) {
          if (participantPayments!
              .any((element) => element.programPaymentId == a.id)) {
            tempShownPayments.add(a);
            isBatch2Paid = true;
            break;
          } else if (a.startDate!.isBefore(DateTime.now())) {
            tempShownPayments.add(a);
            isBatch2Paid = false;
            break;
          }
        }
      }
    }

    setState(() {
      shownPayments = tempShownPayments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Transactions"),
      body: shownPayments == null ||
              paymentMethods == null ||
              participantPayments == null
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: primary, size: 40),
            )
          : shownPayments!.isEmpty
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
                        for (int i = 0; i < shownPayments!.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: PaymentCard(payment: shownPayments![i]),
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
                    itemCount: shownPayments!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: PaymentCard(payment: shownPayments![index]),
                      );
                    },
                  ),
                ),
    );
  }
}
