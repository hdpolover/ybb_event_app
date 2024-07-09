import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class DocumentPdfViewer extends StatelessWidget {
  Uint8List? pdfData;

  DocumentPdfViewer({super.key, required this.pdfData});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods().buildCommonAppBar(context, "Document Viewer"),
      body: Column(
        children: [
          Expanded(
            child: PdfViewPinch(
              padding: 20,
              controller:
                  PdfControllerPinch(document: PdfDocument.openData(pdfData!)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () => downloadPdf(context, pdfData!),
                icon: const Icon(Icons.download),
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
      ),
    );
  }
}
