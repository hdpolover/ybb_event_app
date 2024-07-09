import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/services/participant_service.dart';
import 'package:ybb_event_app/services/participant_status_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class AchievementSection extends StatefulWidget {
  const AchievementSection({super.key});

  @override
  State<AchievementSection> createState() => _AchievementSectionState();
}

class _AchievementSectionState extends State<AchievementSection> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey _achievementsKey = GlobalKey<FormBuilderFieldState>();
  final GlobalKey _experiencesKey = GlobalKey<FormBuilderFieldState>();

  QuillController _controller = QuillController.basic();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var participantProvider = Provider.of<ParticipantProvider>(context);

    return Padding(
      padding: ScreenSizeHelper.responsiveValue(context,
          mobile: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          desktop: const EdgeInsets.symmetric(vertical: 30, horizontal: 50)),
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 100,
              //   child: QuillProvider(
              //     configurations: QuillConfigurations(
              //       controller: _controller,
              //       sharedConfigurations: const QuillSharedConfigurations(
              //         locale: Locale('en'),
              //       ),
              //     ),
              //     child: Column(
              //       children: [
              //         const QuillToolbar(),
              //         Expanded(
              //           child: QuillEditor.basic(
              //             configurations: const QuillEditorConfigurations(
              //               readOnly: false,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // Text(_controller.getPlainText(), style: TextStyle(fontSize: 16)),
              CommonMethods().buildTextField(
                _achievementsKey,
                'achievements',
                'Achievements or Awards',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
                initial: participantProvider.participant!.achievements,
                desc:
                    "Please list any achievements or awards you have received in the past. This can include academic awards, scholarships, or any other relevant achievements. Input (-) if none.",
                lines: 5,
              ),
              CommonMethods().buildTextField(
                _experiencesKey,
                'experiences',
                'Experiences',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
                initial: participantProvider.participant!.experiences,
                desc:
                    "Please list any experiences you have had in the past. This can include internships, jobs, or any other relevant experiences. Input (-) if none.",
                lines: 5,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Resume / Curriculum Vitae",
              //         style: bodyTextStyle.copyWith(
              //           color: Colors.black,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       const SizedBox(height: 10),
              //       Text(
              //         "You could upload your resume / CV as additional information",
              //         style: bodyTextStyle.copyWith(
              //           color: Colors.red,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       const SizedBox(height: 10),
              //     ],
              //   ),
              // ),
              Align(
                alignment: Alignment.centerRight,
                child: isLoading
                    ? LoadingAnimationWidget.fourRotatingDots(
                        color: primary, size: 40)
                    : CommonMethods().buildCustomButton(
                        width: 200,
                        text: "SAVE",
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            print(_formKey.currentState!.value);

                            setState(() {
                              isLoading = true;
                            });

                            Map<String, dynamic> data =
                                _formKey.currentState!.value;

                            ParticipantModel currentParticipant =
                                participantProvider.participant!;

                            Map<String, dynamic> saveToData = {
                              "achievements": data['achievements'],
                              "experiences": data['experiences'],
                            };

                            ParticipantService()
                                .updateData(currentParticipant.id!, saveToData)
                                .then((value) {
                              participantProvider.setParticipant(value);

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
                                participantProvider.setParticipantStatus(value);

                                DialogManager.showAlertDialog(context,
                                    "Achievements and experiences have been saved successfully!",
                                    isGreen: true);

                                setState(() {
                                  isLoading = false;
                                });
                              });
                            });
                          } else {
                            print("validation failed");
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
