import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/participant_status_service.dart';
import 'package:ybb_event_app/services/payment_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class PreviewSection extends StatefulWidget {
  const PreviewSection({super.key});

  @override
  State<PreviewSection> createState() => _PreviewSectionState();
}

class _PreviewSectionState extends State<PreviewSection> {
  PaymentModel? participantRegistPayment;

  bool isLoading = false;
  bool isAgree = false;

  @override
  void initState() {
    super.initState();

    getParticipantRegistPayment();
  }

  getParticipantRegistPayment() {
    String? submitStatus =
        Provider.of<ParticipantProvider>(context, listen: false)
            .participantStatus!
            .formStatus;

    print(submitStatus.toString().toLowerCase() + "status");

    if (submitStatus == "2") {
      setState(() {
        isAgree = true;
      });
    } else {
      setState(() {
        isAgree = false;
      });
    }

    List<ProgramPaymentModel> payments =
        Provider.of<PaymentProvider>(context, listen: false).programPayments!;

    List<ProgramPaymentModel> registPayment = [];

    // gett program payment that has category of registration
    for (int i = 0; i < payments.length; i++) {
      if (payments[i].category == "registration") {
        setState(() {
          registPayment.add(payments[i]);
        });
      }
    }

    String? id = Provider.of<ParticipantProvider>(context, listen: false)
        .participant!
        .id;

    print(id);

    PaymentService().getAll(id).then((value) {
      for (var item in value) {
        for (var registPayment in registPayment) {
          if (registPayment.id == item.programPaymentId &&
              item.participantId == id) {
            setState(() {
              participantRegistPayment = item;
            });

            print(participantRegistPayment!.status);
          }
        }
      }
    });
  }

  buildSubmitStatusSection(bool isReady) {
    String? paymentStatus;
    Color? color;
    String? text;
    String? buttonText;

    if (participantRegistPayment != null) {
      paymentStatus = participantRegistPayment!.status;
    } else {
      paymentStatus = "-1";
    }

    if (paymentStatus == "2") {
      return isLoading
          ? LoadingAnimationWidget.fourRotatingDots(color: primary, size: 40)
          : CommonMethods().buildCustomButton(
              width: 300,
              text: "SUBMIT REGISTRATION FORM",
              onPressed: () {
                if (isReady) {
                  setState(() {
                    isLoading = true;
                  });

                  // update participant status
                  Map<String, dynamic> statusData = {
                    "form_status": "2",
                    "general_status": "1",
                  };

                  ParticipantStatusService()
                      .updateStatus(
                          Provider.of<ParticipantProvider>(context,
                                  listen: false)
                              .participantStatus!
                              .id!,
                          statusData)
                      .then((value) {
                    Provider.of<ParticipantProvider>(context, listen: false)
                        .setParticipantStatus(value);

                    DialogManager.showAlertDialog(context,
                        "Registration form has been submitted successfully!",
                        isGreen: true);

                    setState(() {
                      isLoading = false;
                    });
                  });
                } else {
                  DialogManager.showAlertDialog(context,
                      "Please check the agreement box to submit the registration form.",
                      isGreen: false);
                }
              },
            );
    } else {
      if (paymentStatus == "-1") {
        color = Colors.red;
        text =
            "To submit the registration form, please make the registration payment first.";
        buttonText = "MAKE PAYMENT";
      } else if (paymentStatus == "0" || paymentStatus == "1") {
        color = Colors.orange;
        text =
            "Your registration payment is being processed. Please wait for it to be reviewed.";
        buttonText = "VIEW PAYMENT";
      } else if (paymentStatus == "3") {
        color = Colors.red;
        text =
            "Your registration payment has been cancelled. Please make the payment again.";
        buttonText = "MAKE PAYMENT";
      } else if (paymentStatus == "4") {
        color = Colors.red;
        text =
            "Your registration payment has been rejected. Please make the payment again.";
        buttonText = "MAKE PAYMENT";
      }

      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        // shape
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Text(
              text!,
              softWrap: true,
              style: bodyTextStyle.copyWith(color: color),
            ),
            const SizedBox(height: 20),
            CommonMethods().buildCustomButton(
              width: 300,
              text: buttonText!,
              onPressed: () {
                context.pushNamed(transactionsRouteName);
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);
    var participantProvider = Provider.of<ParticipantProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: ScreenSizeHelper.responsiveValue(context,
            mobile: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            desktop: const EdgeInsets.symmetric(vertical: 30, horizontal: 50)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              FancyShimmerImage(
                imageUrl: programProvider.currentProgram!.logoUrl!,
                boxFit: BoxFit.contain,
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Center(
                  child: HtmlWidget(
                      programProvider.currentProgram!.confirmationDesc!),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: FormBuilderCheckbox(
                    name: 'accept_terms',
                    initialValue: isAgree,
                    validator: FormBuilderValidators.required(),
                    onChanged: (v) {
                      setState(() {
                        isAgree = v!;
                      });
                    },
                    title: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'I agree to participate in the ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: programProvider.currentProgram!.name!,
                            style: const TextStyle(color: primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: participantProvider.participantStatus!.formStatus == "2"
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40),
                        // shape
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                    "Registration form has been submitted successfully!",
                                    softWrap: true,
                                    style: bodyTextStyle.copyWith(
                                        color: Colors.green)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : buildSubmitStatusSection(isAgree),
              ),
            ]),
      ),
    );
  }
}
