import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:ybb_event_app/models/agreement_letter_model.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/loading_widget.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class AgreementLetterView extends StatefulWidget {
  final AgreementLetterModel agreementLetter;
  const AgreementLetterView({super.key, required this.agreementLetter});

  @override
  State<AgreementLetterView> createState() => _AgreementLetterViewState();
}

class _AgreementLetterViewState extends State<AgreementLetterView> {
  PdfControllerPinch? pdfController;

  @override
  void initState() {
    super.initState();

    setData();
  }

  setData() async {
    await PdfDocument.openData(
            InternetFile.get(widget.agreementLetter.fileLink!))
        .then((value) {
      setState(() {
        pdfController = PdfControllerPinch(document: Future.value(value));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods().buildCommonAppBar(context, "Agreement Letter"),
      body: pdfController == null
          ? const LoadingWidget()
          : PdfViewPinch(padding: 20, controller: pdfController!),
    );
  }
}
