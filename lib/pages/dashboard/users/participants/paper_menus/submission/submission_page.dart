import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/paper_abstract_model.dart';
import 'package:ybb_event_app/models/paper_author_model.dart';
import 'package:ybb_event_app/models/paper_detail_model.dart';
import 'package:ybb_event_app/models/paper_revision_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/abstract/abstract_detail.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/abstract/add_edit_abstract.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/author/add_edit_author.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/author/author_item.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/loading_widget.dart';
import 'package:ybb_event_app/providers/paper_provider.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/paper_abstract_service.dart';
import 'package:ybb_event_app/services/paper_detail_service.dart';
import 'package:ybb_event_app/services/paper_revision_service.dart';
import 'package:ybb_event_app/services/payment_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

import '../../../../../../services/paper_author_service.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  PaperAuthorModel? currentAuthor;
  List<PaperRevisionModel> revisions = [];

  bool showAbstractButton = false;
  bool hasRevisions = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    checkPayment();
    getAuthorById();
  }

  getRevisions(String paperDetailId) async {
    // get the user's revisions
    await PaperRevisionService().getRevisions(paperDetailId).then((value) {
      setState(() {
        revisions = value;
      });

      if (revisions.isNotEmpty) {
        setState(() {
          showAbstractButton = true;
          hasRevisions = true;
        });
      }
    });
  }

  // get author
  getAuthorById() async {
    var participantProvider =
        Provider.of<ParticipantProvider>(context, listen: false);

    ParticipantModel p = participantProvider.participant!;

    await PaperAuthorService().getAll(p.id).then((value) async {
      setState(() {
        currentAuthor = value;
      });

      if (currentAuthor != null) {
        Provider.of<PaperProvider>(context, listen: false)
            .setCurrentAuthor(currentAuthor!);

        String? paperDetailId =
            Provider.of<PaperProvider>(context, listen: false)
                .currentAuthor!
                .paperDetailId;

        if (paperDetailId != null) {
          await PaperAuthorService()
              .getAllByPaperDetailId(paperDetailId)
              .then((value) async {
            Provider.of<PaperProvider>(context, listen: false)
                .setAuthors(value);

            // get paper details
            await PaperDetailService()
                .getById(paperDetailId)
                .then((value) async {
              Provider.of<PaperProvider>(context, listen: false)
                  .setCurrentPaperDetail(value);

              if (value.paperAbstractId != null) {
                // show abstract add button
                setState(() {
                  showAbstractButton = false;
                });

                // get abstract details
                await PaperAbstractService()
                    .getById(value.paperAbstractId)
                    .then((value) {
                  if (value != null) {
                    Provider.of<PaperProvider>(context, listen: false)
                        .setCurrentPaperAbstract(value);

                    getRevisions(paperDetailId);
                  }
                });
              } else {
                // show abstract add button
                setState(() {
                  showAbstractButton = true;
                });
              }
            });
          });
        }
      } else {
        setState(() {
          showAbstractButton = false;
        });
      }
    });
  }

  // check if the user has made a payment
  void checkPayment() async {
    // get the user's data
    var participantProvider =
        Provider.of<ParticipantProvider>(context, listen: false);

    ParticipantModel p = participantProvider.participant!;

    // get the user's payment
    await PaymentService().getAll(p.id).then((value) {
      // check if the user has made a payment
      if (value.isEmpty) {
        // if the user has made a payment, show an alert dialog to inform the user that they have made a payment
        DialogManager.showAlertDialog(
          context,
          "You need to make a payment before you can submit your abstract and paper.",
          isGreen: false,
          pressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      }
    });
  }

  // save the first author
  saveFirstAuthor() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> paperDetailData = {
      "program_id": Provider.of<ProgramProvider>(context, listen: false)
          .currentProgram!
          .id,
    };

    await PaperDetailService().save(paperDetailData).then((value) async {
      Provider.of<PaperProvider>(context, listen: false)
          .setCurrentPaperDetail(value);

      ParticipantModel p =
          Provider.of<ParticipantProvider>(context, listen: false).participant!;

      Map<String, dynamic> data = {
        "participant_id": p.id,
        "name": p.fullName,
        "email": p.email,
        "institution": p.institution ?? "institution",
        "paper_detail_id": value.id,
        "is_participant": "1",
      };

      await PaperAuthorService().save(data).then((value) {
        DialogManager.showAlertDialog(
            context, "You have successfully added yourself as an author.",
            pressed: () {
          Provider.of<PaperProvider>(context, listen: false).addAuthor(value);

          Provider.of<PaperProvider>(context, listen: false)
              .setCurrentAuthor(value);

          setState(() {
            isLoading = false;

            showAbstractButton = true;
          });

          Navigator.pop(context);
        }, isGreen: true);
      });
    });
  }

  _buildTitleItem(String title, Widget? button) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 70,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: bodyTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          button ?? Container(),
        ],
      ),
    );
  }

  _buildAuthorSection(List<PaperAuthorModel> authors) {
    return Column(
      children: [
        _buildTitleItem(
          "Authors",
          // show add author button if authors contain participant same id
          authors.isNotEmpty &&
                  Provider.of<PaperProvider>(context).currentAuthor != null
              ? CommonMethods().buildCustomButton(
                  width: 200,
                  color: Colors.green,
                  text: "Add Author",
                  onPressed: () {
                    context.pushNamed(
                      AddEditAuthor.routeName,
                    );
                  },
                )
              : Container(),
        ),
        const SizedBox(height: 10),
        // build the author section
        authors.isEmpty
            ? Padding(
                padding: blockPadding(context),
                child: Column(
                  children: [
                    Text(
                      "No data available.\nYou need to add yourself as an author first to start adding/editing your abstract.",
                      style: bodyTextStyle.copyWith(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const LoadingWidget()
                        : CommonMethods().buildCustomButton(
                            width: 300,
                            color: Colors.green,
                            text: "Add Myself as Author",
                            onPressed: () async {
                              saveFirstAuthor();
                            },
                          ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: authors.length,
                itemBuilder: (context, index) {
                  return AuthorItem(
                    paperAuthor: authors[index],
                  );
                },
              ),
      ],
    );
  }

  _buildAbstractSection() {
    PaperAbstractModel? currentAbstract =
        Provider.of<PaperProvider>(context).currentPaperAbstract;

    return Column(
      children: [
        _buildTitleItem(
          "Abstract",
          showAbstractButton
              ? CommonMethods().buildCustomButton(
                  width: 200,
                  color: hasRevisions ? Colors.orange : Colors.green,
                  text: hasRevisions ? "Edit Abstract" : "Add Abstract",
                  onPressed: () {
                    if (hasRevisions) {
                      context.pushNamed(
                        AddEditAbstract.routeName,
                        extra: currentAbstract,
                      );
                    } else {
                      setState(() {
                        showAbstractButton = false;
                      });

                      context.pushNamed(
                        AddEditAbstract.routeName,
                      );
                    }
                  },
                )
              : Container(),
        ),
        const SizedBox(height: 10),
        // build the abstract section
        currentAbstract == null
            ? Padding(
                padding: blockPadding(context),
                child: Text(
                  "You will need to add at least 1 author to start adding/editing your abstract.",
                  style: bodyTextStyle.copyWith(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : AbstractDetail(abstract: currentAbstract),
      ],
    );
  }

  _buildRevisionSection() {
    return Column(
      children: [
        _buildTitleItem("Revisions", null),
        const SizedBox(height: 10),
        // build the revision section
        revisions.isEmpty
            ? Padding(
                padding: blockPadding(context),
                child: Text(
                  "You will see revisions made by the reviewers about your abstract here once available.",
                  style: bodyTextStyle.copyWith(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: revisions.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              revisions[index].comment!,
                              style: bodyTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Comment by ${revisions[index].name} on ${CommonMethods().formatDate(revisions[index].createdAt)}",
                              style: bodyTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ));
                }),
      ],
    );
  }

  _buildPaperSection() {
    return Column(
      children: [
        _buildTitleItem("Paper", null),
        const SizedBox(height: 10),
        // build the paper section
        Padding(
          padding: blockPadding(context),
          child: Text(
            "You can start adding/editing your paper once your abstract has been approved.",
            style: bodyTextStyle.copyWith(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var paperProvider = Provider.of<PaperProvider>(context);

    var authors = paperProvider.authors!;
    // create a tab controller
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, "Submission"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildAuthorSection(authors),
              const SizedBox(height: 20),
              _buildAbstractSection(),
              const SizedBox(height: 20),
              _buildRevisionSection(),
              const SizedBox(height: 20),
              _buildPaperSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
