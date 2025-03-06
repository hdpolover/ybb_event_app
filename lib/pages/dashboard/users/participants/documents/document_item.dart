import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/agreement_letter_model.dart';
import 'package:ybb_event_app/models/program_document_model.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/loading_widget.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/services/program_document_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';
import 'package:ybb_event_app/utils/utils.dart';

class DocumentItem extends StatefulWidget {
  final ProgramDocumentModel doc;
  const DocumentItem({super.key, required this.doc});

  @override
  State<DocumentItem> createState() => _DocumentItemState();
}

class _DocumentItemState extends State<DocumentItem> {
  bool isLoading = false;
  AgreementLetterModel? agreementLetter;

  @override
  void initState() {
    super.initState();

    getAgreementLetter();
  }

  getAgreementLetter() async {
    if (widget.doc.isUpload == "1") {
      // get agreement letter
      await ProgramDocumentService()
          .getAgreementLetter(
              Provider.of<ParticipantProvider>(context, listen: false)
                  .participant!
                  .id!)
          .then((value) {
        setState(() {
          agreementLetter = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // create card for each document
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: ScreenSizeHelper.responsiveValue(context,
            mobile: const EdgeInsets.all(20),
            desktop: const EdgeInsets.symmetric(vertical: 30, horizontal: 30)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // do not use list tile
              Text(widget.doc.name!,
                  textAlign: TextAlign.center,
                  style: headlineTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              const SizedBox(height: 20),
              Text(widget.doc.desc!, style: bodyTextStyle),
              const SizedBox(height: 30),
              // create a button with a download icon and text
              isLoading
                  ? const LoadingWidget()
                  : SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (widget.doc.isGenerated == "1") {
                            setState(() {
                              isLoading = true;
                            });
                            await ProgramDocumentService()
                                .getInvitationLetter(
                              Provider.of<ParticipantProvider>(context,
                                      listen: false)
                                  .participant!
                                  .id!,
                              widget.doc.id!,
                            )
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              // convert content type application/pdf to unit8list
                              final Uint8List data = Uint8List.fromList(value);

                              // Step 1: Load document to controller
                              // final PdfControllerPinch pdfPinchController =
                              //     PdfControllerPinch(
                              //         document: PdfDocument.openData(data));

                              context.pushNamed(documentPdfViewerRouteName,
                                  extra: data);
                            });
                          } else {
                            String link = widget.doc.driveUrl == null
                                ? widget.doc.fileUrl!
                                : widget.doc.driveUrl!;

                            openUrl(link);
                          }
                        },
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                        label: const Text("Download"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              // upload
              widget.doc.isUpload == "0"
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (agreementLetter == null) {
                            context.pushNamed(
                              agreementLetterUploadRouteName,
                            );
                          } else {
                            context.pushNamed(
                              agreementLetterViewRouteName,
                              extra: agreementLetter,
                            );
                          }
                        },
                        icon: Icon(
                          agreementLetter == null
                              ? Icons.upload
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        label:
                            Text(agreementLetter == null ? "Upload" : "View"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              agreementLetter == null ? primary : Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
