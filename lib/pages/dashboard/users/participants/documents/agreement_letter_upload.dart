import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/loading_widget.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/services/program_document_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class AgreementLetterUpload extends StatefulWidget {
  const AgreementLetterUpload({super.key});

  @override
  State<AgreementLetterUpload> createState() => _AgreementLetterUploadState();
}

class _AgreementLetterUploadState extends State<AgreementLetterUpload> {
  FilePickerResult? pdfFile;
  Uint8List? fileBytes;
  String? fileName;

  PdfController? pdfController;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonMethods().buildCommonAppBar(context, "Agreement Letter Upload"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // add container for file upload
              InkWell(
                onTap: () async {
                  // upload payment proof
                  await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  ).then((value) {
                    // check if the file size is more than 2MB, add error message saying for file efficiency it cannot exceed 2 mb
                    if (value!.files.single.size > 2000000) {
                      DialogManager.showAlertDialog(context,
                          "File size is too large. Please upload a file with size less than 2MB.",
                          isGreen: false);
                    } else {
                      if (value.files.single.extension != "pdf") {
                        DialogManager.showAlertDialog(context,
                            "Invalid file type. Please upload a file with extension .pdf",
                            isGreen: false);
                      } else {
                        setState(() {
                          pdfFile = value;
                          fileBytes = value.files.single.bytes!;
                          fileName = value.files.single.name;

                          pdfController = PdfController(
                            document: PdfDocument.openData(fileBytes!),
                          );
                        });
                      }
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.75,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: fileBytes != null
                      ? PdfView(controller: pdfController!)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Select a PDF file to upload",
                              style: bodyTextStyle,
                            ),
                            SizedBox(height: 20),
                            FaIcon(
                              FontAwesomeIcons.filePdf,
                              size: 50,
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                fileName ?? "No file selected",
                style: bodyTextStyle,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const LoadingWidget()
                  : MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      color: primary,
                      // give radius to the button
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        if (pdfFile == null) {
                          DialogManager.showAlertDialog(
                              context, "Please select a file to upload",
                              isGreen: false);
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        Map<String, dynamic> dataToSave = {
                          "file_bytes": fileBytes,
                          "file_name": fileName,
                        };

                        await ProgramDocumentService()
                            .agreementLetterUpload(
                                Provider.of<ParticipantProvider>(context,
                                        listen: false)
                                    .participant!
                                    .id!,
                                dataToSave)
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          DialogManager.showAlertDialog(
                              context, "Agreement letter uploaded successfully",
                              isGreen: true);
                        }).onError((error, stackTrace) {
                          setState(() {
                            isLoading = false;
                          });

                          DialogManager.showAlertDialog(
                              context, "Failed to upload agreement letter",
                              isGreen: false);
                        });
                      },
                      child: const Text('Upload', style: buttonTextStyle),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
