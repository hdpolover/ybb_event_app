import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/competition_category_model.dart';
import 'package:ybb_event_app/models/participant_essay_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/models/program_essay_model.dart';
import 'package:ybb_event_app/models/program_subtheme_model.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/competition_category_service.dart';
import 'package:ybb_event_app/services/participant_competition_category_service.dart';
import 'package:ybb_event_app/services/participant_essay_service.dart';
import 'package:ybb_event_app/services/participant_status_service.dart';
import 'package:ybb_event_app/services/participant_subtheme_service.dart';
import 'package:ybb_event_app/services/program_essay_service.dart';
import 'package:ybb_event_app/services/program_subtheme_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class EssaySection extends StatefulWidget {
  const EssaySection({super.key});

  @override
  State<EssaySection> createState() => _EssaySectionState();
}

class _EssaySectionState extends State<EssaySection> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey _essay1Key = GlobalKey<FormBuilderFieldState>();
  final GlobalKey _essay2Key = GlobalKey<FormBuilderFieldState>();

  List<ProgramSubthemeModel>? subthemes;
  List<ProgramEssayModel>? essays;
  List<CompetitionCategoryModel>? categories;

  String? _categoryResult, _subthemeResult;

  bool isLoading = false;

  final TextEditingController _essay1Controller = TextEditingController();
  final TextEditingController _essay2Controller = TextEditingController();
  final TextEditingController _essay3Controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    getEssays();
  }

  getEssays() {
    String id = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .id!;

    String catId = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .programCategoryId!;

    String participantId =
        Provider.of<ParticipantProvider>(context, listen: false)
            .participant!
            .id!;

    // get essays from database
    ProgramEssayService().getProgramEssays(id).then((value) {
      setState(() {
        essays = value;
      });

      ParticipantEssayService().getById(participantId).then((value) {
        Provider.of<ParticipantProvider>(context, listen: false)
            .setParticipantEssays(value);

        setState(() {
          _essay1Controller.text = value.isEmpty ? "" : value[0].answer ?? "";
          _essay1Controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _essay1Controller.text.length),
          );

          _essay2Controller.text = value.isEmpty ? "" : value[1].answer ?? "";
          _essay2Controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _essay2Controller.text.length),
          );

          _essay3Controller.text = value.isEmpty ? "" : value[2].answer ?? "";
          _essay3Controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _essay3Controller.text.length),
          );
        });
      });
    });

    // get subthemes from database
    ProgramSubthemeService().getProgramSubthemes(id).then((value) {
      setState(() {
        subthemes = value;
      });

      ParticipantSubthemeService().getById(participantId).then((value) {
        Provider.of<ParticipantProvider>(context, listen: false)
            .setParticipantSubtheme(value);

        setState(() {
          _subthemeResult = value.programSubthemeId;
        });
      });
    });

    CompetitionCategoryService().getCompetitionCategories(catId).then((value) {
      setState(() {
        categories = value;
      });

      ParticipantCompetitionCategoryService()
          .getById(participantId)
          .then((value) {
        Provider.of<ParticipantProvider>(context, listen: false)
            .setParticipantCompetitionCategory(value);

        setState(() {
          _categoryResult = value.competitionCategoryId;
        });
      });
    });
  }

  buildCompetitionRadioSection() {
    categories!.sort((a, b) => a.id!.compareTo(b.id!));

    List<Widget> radioList = [];

    for (var item in categories!) {
      radioList.add(RadioListTile(
          title: Text("${item.category!} - ${item.desc!}",
              style: bodyTextStyle.copyWith(color: Colors.black)),
          value: item.id,
          groupValue: _categoryResult,
          onChanged: (value) {
            setState(() {
              _categoryResult = value!;
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

  buildSubthemeRadioSection() {
    categories!.sort((a, b) => a.id!.compareTo(b.id!));

    List<Widget> radioList = [];

    for (var item in subthemes!) {
      radioList.add(RadioListTile(
          title: Text(item.name!,
              style: bodyTextStyle.copyWith(color: Colors.black)),
          value: item.id,
          groupValue: _subthemeResult,
          onChanged: (value) {
            setState(() {
              _subthemeResult = value!;
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

  @override
  Widget build(BuildContext context) {
    var participantProvider = Provider.of<ParticipantProvider>(context);

    String catId = Provider.of<ProgramProvider>(context)
        .currentProgram!
        .programCategoryId!;

    return essays == null || subthemes == null || categories == null
        ? LoadingAnimationWidget.fourRotatingDots(color: primary, size: 20)
        : Padding(
            padding: ScreenSizeHelper.responsiveValue(context,
                mobile:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                desktop:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 50)),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Competition Categories",
                            style: bodyTextStyle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Please select the competition category that you want to participate in",
                            style: bodyTextStyle.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildCompetitionRadioSection()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Program Subthemes",
                            style: bodyTextStyle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Please select the subtheme that you want to write your essays about",
                            style: bodyTextStyle.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildSubthemeRadioSection(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Based on the subtheme that you have selected, complete the fields below",
                      style: bodyTextStyle.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          essays![0].questions!,
                          style: bodyTextStyle.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _essay1Controller,
                          style: bodyTextStyle.copyWith(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Write your essay here",
                            hintStyle:
                                bodyTextStyle.copyWith(color: Colors.grey),
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          essays![1].questions!,
                          style: bodyTextStyle.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _essay2Controller,
                          style: bodyTextStyle.copyWith(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Write your essay here",
                            hintStyle:
                                bodyTextStyle.copyWith(color: Colors.grey),
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                    catId == "2"
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              const SizedBox(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    essays![2].questions!,
                                    style: bodyTextStyle.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _essay3Controller,
                                    style: bodyTextStyle.copyWith(
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "Write your essay here",
                                      hintStyle: bodyTextStyle.copyWith(
                                          color: Colors.grey),
                                      border: const OutlineInputBorder(),
                                    ),
                                    maxLines: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: isLoading
                          ? LoadingAnimationWidget.fourRotatingDots(
                              color: primary, size: 40)
                          : CommonMethods().buildCustomButton(
                              width: 200,
                              text: "SAVE",
                              onPressed: () {
                                if (catId == "2") {
                                  if (_formKey.currentState!
                                          .saveAndValidate() &&
                                      _categoryResult != null &&
                                      _subthemeResult != null &&
                                      _essay1Controller.text.isNotEmpty &&
                                      _essay2Controller.text.isNotEmpty) {
                                    print(_formKey.currentState!.value);

                                    setState(() {
                                      isLoading = true;
                                    });

                                    // saveData();

                                    Map<String, dynamic> data =
                                        _formKey.currentState!.value;

                                    ParticipantModel currentParticipant =
                                        participantProvider.participant!;

                                    ParticipantCompetitionCategoryService()
                                        .save(
                                      {
                                        "participant_id": currentParticipant.id,
                                        "competition_category_id":
                                            _categoryResult,
                                      },
                                    ).then((value) {
                                      participantProvider
                                          .setParticipantCompetitionCategory(
                                              value);

                                      ParticipantSubthemeService().save(
                                        {
                                          "participant_id":
                                              currentParticipant.id,
                                          "program_subtheme_id":
                                              _subthemeResult,
                                        },
                                      ).then((value) {
                                        participantProvider
                                            .setParticipantSubtheme(value);

                                        ParticipantEssayService().save(
                                          {
                                            "participant_id":
                                                currentParticipant.id,
                                            "program_essay_id": essays![0].id,
                                            "answer": _essay1Controller.text,
                                          },
                                        ).then((value) {
                                          ParticipantEssayModel essay1 = value;

                                          ParticipantEssayService().save(
                                            {
                                              "participant_id":
                                                  currentParticipant.id,
                                              "program_essay_id": essays![1].id,
                                              "answer": _essay2Controller.text,
                                            },
                                          ).then((value) {
                                            ParticipantEssayModel essay2 =
                                                value;

                                            participantProvider
                                                .setParticipantEssays([
                                              essay1,
                                              essay2,
                                            ]);

                                            // update participant status
                                            Map<String, dynamic> statusData = {
                                              "form_status": "1",
                                            };

                                            ParticipantStatusService()
                                                .updateStatus(
                                                    participantProvider
                                                        .participantStatus!.id!,
                                                    statusData)
                                                .then((value) {
                                              participantProvider
                                                  .setParticipantStatus(value);

                                              DialogManager.showAlertDialog(
                                                  context,
                                                  "Category, subtheme, and essays have been saved successfully!",
                                                  isGreen: true);

                                              getEssays();

                                              setState(() {
                                                isLoading = false;
                                              });
                                            });
                                          });
                                        });
                                      });
                                    });
                                  }
                                } else {
                                  if (_formKey.currentState!
                                          .saveAndValidate() &&
                                      _subthemeResult != null &&
                                      _categoryResult != null &&
                                      _essay1Controller.text.isNotEmpty &&
                                      _essay2Controller.text.isNotEmpty &&
                                      _essay3Controller.text.isNotEmpty) {
                                    print(_formKey.currentState!.value);

                                    setState(() {
                                      isLoading = true;
                                    });

                                    // saveData();

                                    Map<String, dynamic> data =
                                        _formKey.currentState!.value;

                                    ParticipantModel currentParticipant =
                                        participantProvider.participant!;

                                    ParticipantCompetitionCategoryService()
                                        .save(
                                      {
                                        "participant_id": currentParticipant.id,
                                        "competition_category_id":
                                            _categoryResult,
                                      },
                                    ).then((value) {
                                      participantProvider
                                          .setParticipantCompetitionCategory(
                                              value);

                                      ParticipantSubthemeService().save(
                                        {
                                          "participant_id":
                                              currentParticipant.id,
                                          "program_subtheme_id":
                                              _subthemeResult,
                                        },
                                      ).then((value) {
                                        participantProvider
                                            .setParticipantSubtheme(value);

                                        ParticipantEssayService().save(
                                          {
                                            "participant_id":
                                                currentParticipant.id,
                                            "program_essay_id": essays![0].id,
                                            "answer": _essay1Controller.text,
                                          },
                                        ).then((value) {
                                          ParticipantEssayModel essay1 = value;

                                          ParticipantEssayService().save(
                                            {
                                              "participant_id":
                                                  currentParticipant.id,
                                              "program_essay_id": essays![1].id,
                                              "answer": _essay2Controller.text,
                                            },
                                          ).then((value) {
                                            ParticipantEssayModel essay2 =
                                                value;

                                            ParticipantEssayService().save(
                                              {
                                                "participant_id":
                                                    currentParticipant.id,
                                                "program_essay_id":
                                                    essays![2].id,
                                                "answer":
                                                    _essay3Controller.text,
                                              },
                                            ).then((value) {
                                              ParticipantEssayModel essay3 =
                                                  value;

                                              participantProvider
                                                  .setParticipantEssays([
                                                essay1,
                                                essay2,
                                                essay3,
                                              ]);

                                              // update participant status
                                              Map<String, dynamic> statusData =
                                                  {
                                                "form_status": "1",
                                              };

                                              ParticipantStatusService()
                                                  .updateStatus(
                                                      participantProvider
                                                          .participantStatus!
                                                          .id!,
                                                      statusData)
                                                  .then((value) {
                                                participantProvider
                                                    .setParticipantStatus(
                                                        value);

                                                DialogManager.showAlertDialog(
                                                    context,
                                                    "Category, subtheme, and essay have been saved successfully!",
                                                    isGreen: true);

                                                getEssays();

                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                            });
                                          });
                                        });
                                      });
                                    });
                                  }
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
