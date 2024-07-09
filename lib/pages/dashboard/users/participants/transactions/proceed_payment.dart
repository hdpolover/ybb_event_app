import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/models/payment_method_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/payment_provider.dart';
import 'package:ybb_event_app/services/payment_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class ProceedPayment extends StatefulWidget {
  final ProgramPaymentModel payment;
  const ProceedPayment({super.key, required this.payment});

  @override
  State<ProceedPayment> createState() => _ProceedPaymentState();
}

class _ProceedPaymentState extends State<ProceedPayment> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _accountNameKey = GlobalKey<FormBuilderFieldState>();
  final _amountKey = GlobalKey<FormBuilderFieldState>();
  final _sourceNameKey = GlobalKey<FormBuilderFieldState>();

  FilePickerResult? proofFile;
  Uint8List? fileBytes;
  String? fileName;
  bool isLoading = false;

  List<String> paymentTypes = ["Manual", "Automatic"];
  String? _selectedPaymentType;
  String? _selectedAmount;

  buildPaymentDetailItem(String title, String desc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bodyTextStyle.copyWith(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          desc,
          style: bodyTextStyle.copyWith(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  buildPaymentType() {
    List<Widget> radioList = [];

    for (var item in paymentTypes) {
      radioList.add(RadioListTile(
          title: Text(item, style: bodyTextStyle.copyWith(color: Colors.black)),
          value: item,
          groupValue: _selectedPaymentType,
          onChanged: (value) {
            setState(() {
              _selectedPaymentType = value!;
            });
          }));
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: radioList,
      ),
    );
  }

  buildPaymentAmountDropdown() {
    List<Widget> radioList = [];

    String usd = NumberFormat.simpleCurrency(name: 'USD')
        .format(double.parse(widget.payment.usdAmount!));
    String idr = NumberFormat.simpleCurrency(name: 'IDR')
        .format(double.parse(widget.payment.idrAmount!));

    Map<String, dynamic> data = {
      usd: widget.payment.usdAmount,
      idr: widget.payment.idrAmount,
    };

    // loop through the data and add radio buttons
    data.forEach((key, value) {
      radioList.add(
        RadioListTile(
          title: Text(key, style: bodyTextStyle.copyWith(color: Colors.black)),
          value: value,
          groupValue: _selectedAmount,
          onChanged: (value) {
            setState(() {
              _selectedAmount = value!;
            });
          },
        ),
      );
    });

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: radioList,
      ),
    );
  }

  buildForManual(List<PaymentMethodModel> paymentMethods,
      PaymentMethodModel? selectedMethod) {
    return Column(
      children: [
        const Text(
          "Select Payment Method",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        // payment method card
        SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) {
              return CommonMethods().buildPaymentMethodCard(
                context,
                paymentMethods[index],
                true,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // container to show payment method description
        selectedMethod == null
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HtmlWidget(
                  selectedMethod.description!,
                  textStyle: bodyTextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
      ],
    );
  }

  buildPaymentDetailCard(
      ProgramPaymentModel payment,
      List<PaymentMethodModel> paymentMethods,
      PaymentMethodModel? selectedMethod) {
    String usd = NumberFormat.simpleCurrency(name: 'USD')
        .format(double.parse(payment.usdAmount!));
    String idr = NumberFormat.simpleCurrency(name: 'IDR')
        .format(double.parse(payment.idrAmount!));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // payment details card
            buildPaymentDetailItem("Name", payment.name!),
            const SizedBox(height: 10),
            buildPaymentDetailItem("Category", payment.category!),
            const SizedBox(height: 10),
            buildPaymentDetailItem("Amount", "$usd / $idr"),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Type of Payment",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // build radio buttons for payment methods
            buildPaymentType(),
            const SizedBox(height: 30),
            // payment method card
            _selectedPaymentType == null
                ? const SizedBox.shrink()
                : _selectedPaymentType!.toLowerCase() == "manual"
                    ? buildForManual(paymentMethods, selectedMethod)
                    : isLoading
                        ? Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                                color: primary, size: 50),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: CommonMethods().buildCustomButton(
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: primary,
                              text: "Proceed Payment",
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                Map<String, dynamic> data = {
                                  'participant_id':
                                      Provider.of<ParticipantProvider>(context,
                                              listen: false)
                                          .participant!
                                          .id,
                                  'program_payment_id': payment.id,
                                  'amount': payment.idrAmount,
                                  'payment_method_id': "12",
                                  'payer_email': Provider.of<AuthProvider>(
                                          context,
                                          listen: false)
                                      .authUser!
                                      .email!,
                                  'account_name':
                                      Provider.of<ParticipantProvider>(context,
                                              listen: false)
                                          .participant!
                                          .fullName!,
                                  'program_id': payment.programId,
                                  'description': payment.name,
                                };

                                print(data);

                                await PaymentService()
                                    .xenditPay(data)
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  String xenditUrl = value!;

                                  // get payments based on participant id
                                  PaymentService()
                                      .getAll(Provider.of<ParticipantProvider>(
                                              context,
                                              listen: false)
                                          .participant!
                                          .id)
                                      .then((value) {
                                    Provider.of<PaymentProvider>(context,
                                            listen: false)
                                        .setPayments(value);

                                    context.pushNamed(paymentWebviewRouteName,
                                        extra: xenditUrl);
                                  });
                                });
                              },
                            ),
                          ),
          ],
        ),
      ),
    );
  }

  buildPaymentProofCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Payment Information",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CommonMethods().buildTextField(
                _accountNameKey,
                "account_name",
                "Account Name",
                [
                  FormBuilderValidators.required(),
                ],
              ),
              CommonMethods().buildTextField(
                _sourceNameKey,
                "source_name",
                "Source Name",
                desc:
                    "Please input the name of the bank or payment source. E.g. BCA, BNI, Paypal, etc.",
                [
                  FormBuilderValidators.required(),
                ],
              ),
              const Text(
                "Payment Amount (IDR/USD)",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              buildPaymentAmountDropdown(),
              const SizedBox(height: 20),
              Text(
                "Payment Proof",
                style: bodyTextStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // upload payment proof
                    var temp = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                    );

                    setState(() {
                      proofFile = temp;
                      fileBytes = temp!.files.single.bytes!;
                      fileName = temp.files.single.name;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: proofFile == null
                        ? Center(
                            child: Text(
                              "Upload Payment Proof",
                              style: bodyTextStyle.copyWith(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          )
                        : Image.memory(
                            proofFile!.files.first.bytes!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: primary, size: 50),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: CommonMethods().buildCustomButton(
                        width: MediaQuery.of(context).size.width * 0.5,
                        color: primary,
                        text: "Proceed Payment",
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            PaymentMethodModel? selectedMethod =
                                Provider.of<PaymentProvider>(context,
                                        listen: false)
                                    .selectedPaymentMethod;
                            if (selectedMethod == null) {
                              DialogManager.showAlertDialog(
                                context,
                                "Please select a payment method.",
                                isGreen: false,
                              );
                              return;
                            }

                            if (_selectedAmount == null) {
                              DialogManager.showAlertDialog(
                                context,
                                "Please select the payment amount.",
                                isGreen: false,
                              );
                              return;
                            }

                            Map<String, dynamic> tempData =
                                _formKey.currentState!.value;

                            setState(() {
                              isLoading = true;
                            });

                            ParticipantModel currentParticipant =
                                Provider.of<ParticipantProvider>(context,
                                        listen: false)
                                    .participant!;

                            Map<String, dynamic> saveData = {
                              'account_name': tempData['account_name'],
                              'source_name': tempData['source_name'],
                              'amount': _selectedAmount,
                              'participant_id': currentParticipant.id,
                              'program_payment_id': widget.payment.id,
                              'payment_method_id': selectedMethod.id,
                              'file_bytes': fileBytes!,
                              'file_name': fileName,
                            };

                            PaymentService()
                                .savePayment(saveData)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });

                              // get payments based on participant id
                              PaymentService()
                                  .getAll(currentParticipant.id)
                                  .then((value) {
                                Provider.of<PaymentProvider>(context,
                                        listen: false)
                                    .setPayments(value);

                                DialogManager.showAlertDialog(
                                  context,
                                  "Payment has been submitted successfully!",
                                  isGreen: true,
                                  pressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                );
                              });
                            }).onError((error, stackTrace) {
                              setState(() {
                                isLoading = false;
                              });

                              DialogManager.showAlertDialog(
                                context,
                                "Failed to submit payment. Please try again.",
                                isGreen: false,
                              );
                            });
                          }
                        },
                      )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var paymentProvider = Provider.of<PaymentProvider>(context);

    List<PaymentMethodModel> paymentMethods =
        List.from(paymentProvider.paymentMethods!);

    paymentMethods.removeWhere((element) => element.type == "gateway");

    PaymentMethodModel? selectedMethod = paymentProvider.selectedPaymentMethod;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Proceed Payment"),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPaymentDetailCard(
                  widget.payment,
                  paymentMethods,
                  selectedMethod,
                ),
                const SizedBox(height: 10),
                _selectedPaymentType != null
                    ? _selectedPaymentType!.toLowerCase() == "manual" &&
                            selectedMethod != null
                        ? buildPaymentProofCard()
                        : const SizedBox.shrink()
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
