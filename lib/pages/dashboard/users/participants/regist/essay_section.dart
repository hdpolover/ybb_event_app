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
import 'package:ybb_event_app/services/participant_subtheme_service.dart';
import 'package:ybb_event_app/services/program_essay_service.dart';
import 'package:ybb_event_app/services/program_subtheme_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

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

  @override
  void initState() {
    super.initState();

    getEssays();
  }

  getEssays() {
    String id = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .id!;

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
      });
    });

    CompetitionCategoryService().getCompetitionCategories(id).then((value) {
      setState(() {
        categories = value;
      });

      ParticipantCompetitionCategoryService()
          .getById(participantId)
          .then((value) {
        Provider.of<ParticipantProvider>(context, listen: false)
            .setParticipantCompetitionCategory(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var participantProvider = Provider.of<ParticipantProvider>(context);

    return essays == null || subthemes == null || categories == null
        ? LoadingAnimationWidget.fourRotatingDots(color: primary, size: 20)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
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
                          FormBuilderRadioGroup(
                            name: 'categories',
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              isDense: false,
                            ),
                            initialValue: participantProvider
                                        .participantCompetitionCategory ==
                                    null
                                ? null
                                : participantProvider
                                    .participantCompetitionCategory!.id,
                            validator: FormBuilderValidators.required(),
                            options: categories!
                                .map((item) => FormBuilderFieldOption(
                                      value: item.id,
                                      child: Text(
                                        "${item.category!} - ${item.desc!}",
                                        style: bodyTextStyle.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ))
                                .toList(growable: false),
                          ),
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
                          FormBuilderRadioGroup(
                            name: 'subthemes',
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              isDense: false,
                            ),
                            initialValue:
                                participantProvider.participantSubtheme == null
                                    ? null
                                    : participantProvider
                                        .participantSubtheme!.id,
                            validator: FormBuilderValidators.required(),
                            options: subthemes!
                                .map((subtheme) => FormBuilderFieldOption(
                                      value: subtheme.id,
                                      child: Text(
                                        subtheme.name!,
                                        style: bodyTextStyle.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ))
                                .toList(growable: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Based on the subtheme that you have selected, write essays related to your ideas about the following questions below with a maximum of 200 words",
                      style: bodyTextStyle.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CommonMethods().buildTextField(
                      _essay1Key,
                      'essay1',
                      essays![0].questions!,
                      [
                        FormBuilderValidators.required(),
                      ],
                      initial: participantProvider.participantEssays == null
                          ? null
                          : participantProvider.participantEssays![0].answer,
                      lines: 5,
                    ),
                    CommonMethods().buildTextField(
                      _essay2Key,
                      'essay2',
                      essays![1].questions!,
                      [
                        FormBuilderValidators.required(),
                      ],
                      initial: participantProvider.participantEssays == null
                          ? null
                          : participantProvider.participantEssays![1].answer,
                      lines: 5,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CommonMethods().buildCustomButton(
                        width: 200,
                        text: "SAVE",
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            print(_formKey.currentState!.value);

                            Map<String, dynamic> data =
                                _formKey.currentState!.value;

                            ParticipantModel currentParticipant =
                                participantProvider.participant!;

                            ParticipantCompetitionCategoryService().save(
                              {
                                "participant_id": currentParticipant.id,
                                "competition_category_id": data['categories'],
                              },
                            ).then((value) {
                              participantProvider
                                  .setParticipantCompetitionCategory(value);

                              ParticipantSubthemeService().save(
                                {
                                  "participant_id": currentParticipant.id,
                                  "program_subtheme_id": data['subthemes'],
                                },
                              ).then((value) {
                                participantProvider
                                    .setParticipantSubtheme(value);

                                ParticipantEssayService().save(
                                  {
                                    "participant_id": currentParticipant.id,
                                    "program_essay_id": essays![0].id,
                                    "answer": data['essay1'],
                                  },
                                ).then((value) {
                                  ParticipantEssayModel essay1 = value;

                                  ParticipantEssayService().save(
                                    {
                                      "participant_id": currentParticipant.id,
                                      "program_essay_id": essays![1].id,
                                      "answer": data['essay2'],
                                    },
                                  ).then((value) {
                                    ParticipantEssayModel essay2 = value;

                                    participantProvider.setParticipantEssays([
                                      essay1,
                                      essay2,
                                    ]);

                                    DialogManager.showAlertDialog(context,
                                        "Categories, Subtheme and Essays have been saved successfully!",
                                        isGreen: true);
                                  });
                                });
                              });
                            });
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
