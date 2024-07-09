import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/models/agreement_letter_model.dart';
import 'package:ybb_event_app/models/program_document_model.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/documents/document_item.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/loading_widget.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/services/program_document_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  List<ProgramDocumentModel>? docs;
  AgreementLetterModel? agreementLetter;

  @override
  void initState() {
    super.initState();

    getDocs();
  }

  getDocs() async {
    await ProgramDocumentService()
        .getAll(Provider.of<ParticipantProvider>(context, listen: false)
            .participant!
            .id!)
        .then((value) async {
      // sort by name
      value.sort((a, b) => a.name!.compareTo(b.name!));

      setState(() {
        docs = value;
      });
    }).onError((error, stackTrace) {
      setState(() {
        docs = [];
      });
    });
  }

  buildForMobile() {
    return ListView.builder(
      itemCount: docs!.length,
      itemBuilder: (context, index) {
        return DocumentItem(doc: docs![index]);
      },
    );
  }

  buildForDesktop() {
    // make it a grid view of cardss
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: docs!.length,
      itemBuilder: (context, index) {
        return DocumentItem(doc: docs![index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var participantProvider = Provider.of<ParticipantProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Documents"),
      body: docs == null
          ? const LoadingWidget()
          : docs!.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonMethods().buildNothingToShow(
                      "No Documents Available",
                      "There are no documents available at the moment. Please check back later.",
                    ),
                  ],
                )
              : ScreenSizeHelper.responsiveValue(
                  context,
                  mobile: buildForMobile(),
                  desktop: buildForDesktop(),
                ),
    );
  }
}
