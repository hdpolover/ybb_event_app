import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/ambassador_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/ambassador_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/utils.dart';

import '../../../../../services/participant_service.dart';

class MiscellaneousSection extends StatefulWidget {
  const MiscellaneousSection({super.key});

  @override
  State<MiscellaneousSection> createState() => _MiscellaneousSectionState();
}

class _MiscellaneousSectionState extends State<MiscellaneousSection> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey _sourceAccountNameKey = GlobalKey<FormBuilderFieldState>();
  final GlobalKey _twibbonLinkKey = GlobalKey<FormBuilderFieldState>();
  final GlobalKey _shareRequirementKey = GlobalKey<FormBuilderFieldState>();

  final _refCodeController = TextEditingController();

  AmbassadorModel? ambassador;

  checkRefCode(String code) {
    // check if the code is valid
    AmbassadorService().validateCode(code).then((value) {
      setState(() {
        ambassador = value;
      });

      DialogManager.showAlertDialog(
        context,
        "You have a valid referral code from ${ambassador!.name!}! (${ambassador!.refCode!.toUpperCase()})",
        isGreen: true,
      );
    }).onError((error, stackTrace) {
      _refCodeController.clear();

      DialogManager.showAlertDialog(
        context,
        error.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);
    var participantProvider = Provider.of<ParticipantProvider>(context);

    if (participantProvider.participant!.refCodeAmbassador != null) {
      setState(() {
        _refCodeController.text =
            participantProvider.participant!.refCodeAmbassador!.toUpperCase();
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How do you know about this program?",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderRadioGroup(
                      name: 'knowledge_source',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        isDense: false,
                      ),
                      initialValue:
                          participantProvider.participant!.knowledgeSource,
                      validator: FormBuilderValidators.required(),
                      options: [
                        'Instagram',
                        'Facebook',
                        'Twitter',
                        'LinkedIn',
                        'Friends/Family',
                        'Others',
                      ]
                          .map((lang) => FormBuilderFieldOption(value: lang))
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
              CommonMethods().buildTextField(
                _sourceAccountNameKey,
                'source_account_name',
                'Source Account Name',
                [
                  FormBuilderValidators.required(),
                ],
                initial: participantProvider.participant!.sourceAccountName,
                desc:
                    "Input the name of the account you know the program from. Example: https://www.instagram.com/youthbreaktheboundaries/",
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "You can share a twibbon of the program to your social media account to show your support!",
                    style: bodyTextStyle.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      String twibbonLink =
                          Provider.of<ProgramProvider>(context, listen: false)
                              .currentProgram!
                              .twibbon!;

                      openUrl(twibbonLink);
                    },
                    child: const Text(
                      "View Twibbon",
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              CommonMethods().buildTextField(
                _twibbonLinkKey,
                'twibbon_link',
                'Twibbon Link',
                [
                  FormBuilderValidators.required(),
                ],
                initial: participantProvider.participant!.twibbonLink,
                desc: "Input the link to the twibbon of the program",
              ),
              const SizedBox(height: 10),
              HtmlWidget(programProvider.currentProgram!.shareDesc!),
              CommonMethods().buildTextField(
                _shareRequirementKey,
                'share_requirement',
                'Share Requirement Proof Link',
                [
                  FormBuilderValidators.required(),
                ],
                initial: participantProvider.participant!.requirementLink,
                desc: "Input the link to the proof of the share requirement",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ambassador Referral Code",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "If you have a referral code from our ambassador, please input it here. If you don't have one, you can leave this field empty.",
                      style: bodyTextStyle.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    Visibility(
                      visible: ambassador != null,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            ambassador == null
                                ? "-"
                                : "You have a valid referral code from ${ambassador!.name!.toUpperCase()}! (${ambassador!.refCode!.toUpperCase()})",
                            style: bodyTextStyle.copyWith(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _refCodeController,
                      decoration: InputDecoration(
                        suffixIcon: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primary,
                            ),
                            onPressed: () {
                              checkRefCode(_refCodeController.text);
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("SAVE CODE")),
                        hintText: "Referral Code",
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CommonMethods().buildCustomButton(
                  width: 200,
                  text: "SAVE",
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      print(_formKey.currentState!.value);

                      Map<String, dynamic> data = _formKey.currentState!.value;

                      ParticipantModel currentParticipant =
                          Provider.of<ParticipantProvider>(
                        context,
                        listen: false,
                      ).participant!;

                      Map<String, dynamic> saveToData = {
                        "knowledge_source": data['knowledge_source'],
                        "source_account_name": data['source_account_name'],
                        "twibbon_link": data['twibbon_link'],
                        "requirement_link": data['share_requirement'],
                        "ref_code_ambassador": _refCodeController.text,
                      };

                      ParticipantService()
                          .updateData(currentParticipant.id!, saveToData)
                          .then((value) {
                        Provider.of<ParticipantProvider>(context, listen: false)
                            .setParticipant(value);

                        DialogManager.showAlertDialog(context,
                            "Miscelaneous information has been saved successfully!",
                            isGreen: true);

                        print(value);
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
