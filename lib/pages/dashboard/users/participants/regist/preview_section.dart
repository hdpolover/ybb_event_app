import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class PreviewSection extends StatefulWidget {
  const PreviewSection({super.key});

  @override
  State<PreviewSection> createState() => _PreviewSectionState();
}

class _PreviewSectionState extends State<PreviewSection> {
  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FancyShimmerImage(
              imageUrl: programProvider.currentProgram!.logoUrl!,
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child:
                  HtmlWidget(programProvider.currentProgram!.confirmationDesc!),
            ),
            const SizedBox(height: 20),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: MediaQuery.of(context).size.width * 0.1),
            //   child: FormBuilderCheckbox(
            //     name: 'accept_terms',
            //     initialValue: false,
            //     onChanged: (v) {
            //       // setState(() {
            //       //   programProvider.acceptTerms = !programProvider.acceptTerms;
            //       // });
            //     },
            //     title: RichText(
            //       text: TextSpan(
            //         children: [
            //           const TextSpan(
            //             text: 'I have read and agree to participate in the ',
            //             style: TextStyle(color: Colors.black),
            //           ),
            //           TextSpan(
            //             text: programProvider.currentProgram!.name!,
            //             style: const TextStyle(color: primary),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: CommonMethods().buildCustomButton(
                width: 300,
                text: "SAVE REGISTRATION FORM",
                onPressed: () {
                  DialogManager.showAlertDialog(
                      context, "Registration form has been saved successfully!",
                      isGreen: true);
                },
              ),
            ),
          ]),
    );
  }
}
