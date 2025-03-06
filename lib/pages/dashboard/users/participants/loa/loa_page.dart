import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/loading_widget.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/services/program_loa_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'dart:html' as html;

class LoaPage extends StatefulWidget {
  const LoaPage({super.key});

  @override
  State<LoaPage> createState() => _LoaPageState();
}

class _LoaPageState extends State<LoaPage> {
  bool isLoaAvailable = false;
  bool isLoading = true;

  Uint8List? pdfData;

  @override
  void initState() {
    super.initState();

    getLoa();
  }

  void downloadPdf(BuildContext context, Uint8List pdfData) {
    String participantName =
        Provider.of<ParticipantProvider>(context, listen: false)
            .participant!
            .fullName!
            .toUpperCase();
    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'INVITATION LETTER ($participantName).pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  getLoa() async {
    // get participant id
    String participantId =
        Provider.of<ParticipantProvider>(context, listen: false)
            .participant!
            .id!;

    // program id
    String programId = Provider.of<ParticipantProvider>(context, listen: false)
        .participant!
        .programId!;

    if (programId == "4") {
      // get details
      await ProgramLoaService().getDetails(participantId).then((value) async {
        String paperTitle = value['paper_title']!;
        String authorNames = value['author_names']!;

        Map<String, dynamic> data = {
          "paper_title": paperTitle,
          "author_names": authorNames,
        };

        // get loa
        await ProgramLoaService().generateLoa(programId, data).then((value) {
          setState(() {
            pdfData = value;
            isLoaAvailable = true;
            isLoading = false;
          });
        });
      }).onError((error, stackTrace) {
        setState(() {
          isLoaAvailable = false;
          isLoading = false;
        });
      });
    } else {
      ParticipantModel participant =
          Provider.of<ParticipantProvider>(context, listen: false).participant!;

      Map<String, dynamic> data = {
        "name": participant.fullName!,
        "institution": participant.institution!,
      };

      // get loa
      await ProgramLoaService().generateLoa(programId, data).then((value) {
        setState(() {
          pdfData = value;
          isLoaAvailable = true;
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          isLoaAvailable = false;
          isLoading = false;
        });
      });
    }
  }

  buildLoaView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.7,
          child: PdfViewPinch(
            padding: 20,
            controller: PdfControllerPinch(
                document: PdfDocument.openData(pdfData!),
                viewportFraction: 0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => downloadPdf(context, pdfData!),
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              ),
              label: const Text("Download"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          CommonMethods().buildCommonAppBar(context, "Letter of Acceptance"),
      body: isLoading
          ? LoadingWidget()
          : isLoaAvailable
              ? buildLoaView()
              : Center(
                  child: Text(
                    "No LOA available",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
    );
  }
}
