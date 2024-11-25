import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/paper_author_model.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/loading_widget.dart';
import 'package:ybb_event_app/providers/paper_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/paper_author_service.dart';
import 'package:ybb_event_app/services/participant_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class AddEditAuthor extends StatefulWidget {
  final PaperAuthorModel? author;
  const AddEditAuthor({super.key, this.author});

  static String routeName = 'add_edit_author';
  static String pathName = '/add_edit_author';

  @override
  State<AddEditAuthor> createState() => _AddEditAuthorState();
}

class _AddEditAuthorState extends State<AddEditAuthor> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _nameKey = GlobalKey<FormBuilderFieldState>();
  // content key, keywords key
  final _institutionKey = GlobalKey<FormBuilderFieldState>();
  final _emailKey = GlobalKey<FormBuilderFieldState>();
  final _emailCheckKey = GlobalKey<FormBuilderFieldState>();
  final _radioKey = GlobalKey<FormBuilderFieldState>();

  String? name, institution, email;

  String isParticipant = "1";

  bool showRestForm = false;
  bool showCheckEmail = true;

  bool isLoading = false;

  ParticipantModel? foundParticipant;

  @override
  void initState() {
    super.initState();

    // if author is not null, set the initial values
    if (widget.author != null) {
      // set the initial values
      name = widget.author!.name;
      institution = widget.author!.institution;
      email = widget.author!.email;
      isParticipant = widget.author!.isParticipant!;

      showCheckEmail = false;
      showRestForm = true;

      setState(() {});
    }
  }

  // build radio buttons with values 1: yes, 0: no
  _buildRadioButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Is the author a participant?",
          style: bodyTextStyle.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        FormBuilderRadioGroup(
          key: _radioKey,
          name: 'is_participant',
          onChanged: (value) {
            setState(() {
              isParticipant = value.toString();
            });
          },
          initialValue: isParticipant,
          options: const [
            FormBuilderFieldOption(
              value: "1",
              child: Text("Yes"),
            ),
            FormBuilderFieldOption(
              value: "0",
              child: Text("No"),
            ),
          ],
        ),
      ],
    );
  }

  checkEmail() async {
    var programProvider = Provider.of<ProgramProvider>(context, listen: false);

    debugPrint(_formKey.currentState?.value.toString());

    await ParticipantService()
        .checkParticipantByEmailAndProgramId(
      _formKey.currentState?.value['email_check'],
      programProvider.currentProgram!.id,
    )
        .then((participant) {
      if (participant != null) {
        // show the rest of the form
        showRestForm = true;
        isLoading = false;
        showCheckEmail = false;

        foundParticipant = participant;

        setParticipantData(participant);

        setState(() {});

        DialogManager.showAlertDialog(
          context,
          "Participant data found!\nYou will not be able to edit the email to avoid duplication",
          pressed: () {
            Navigator.pop(context);
          },
          isGreen: true,
        );
      } else {
        // show error message
        DialogManager.showAlertDialog(context, "Participant not found",
            pressed: () {
          isLoading = false;

          setState(() {});
          Navigator.pop(context);
        });
      }
    });
  }

  setParticipantData(ParticipantModel participant) {
    // set the data of the participant
    // set the email, name, institution
    // set the values of the text fields
    name = participant.fullName;
    email = participant.email;
    institution = participant.institution;

    setState(() {});
  }

  // _show the rest of form
  _buildRestForm() {
    return Column(
      children: [
        CommonMethods().buildTextField(
          _emailKey,
          'email',
          'Email',
          [
            FormBuilderValidators.required(),
          ],
          initial: email,
          readOnly: isParticipant == "1" ? true : false,
        ),
        CommonMethods().buildTextField(
          _nameKey,
          'name',
          'Name',
          [FormBuilderValidators.required()],
          initial: name,
        ),
        CommonMethods().buildTextField(
          _institutionKey,
          'institution',
          'Institution',
          [FormBuilderValidators.required()],
          initial: institution,
        ),
        const SizedBox(height: 10),
        widget.author == null && isParticipant == "1"
            ? CommonMethods().buildCustomButton(
                text: "Edit Email",
                color: Colors.orange,
                onPressed: () {
                  DialogManager.showConfirmationDialog(
                    context,
                    "Are you sure you want to edit the email? This will clear the data",
                    () {
                      // edit the email
                      showCheckEmail = true;
                      showRestForm = false;

                      // clear the data
                      name = null;
                      email = null;
                      institution = null;

                      setState(() {});
                    },
                  );
                },
              )
            : Container(),
        const SizedBox(height: 10),
        isLoading
            ? const LoadingWidget()
            : CommonMethods().buildCustomButton(
                text: widget.author == null ? "Add Author" : "Edit Author",
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    debugPrint(_formKey.currentState?.value.toString());

                    // save and validate
                    // save the data
                    // if author is null, add author
                    // else edit author
                    isLoading = true;
                    setState(() {});

                    if (widget.author == null) {
                      // save the data
                      // if author is null, add author
                      // else edit author
                      var data = foundParticipant == null
                          ? {
                              "name": _formKey.currentState?.value['name'],
                              "email": _formKey.currentState?.value['email'],
                              "institution":
                                  _formKey.currentState?.value['institution'],
                              "paper_detail_id": Provider.of<PaperProvider>(
                                      context,
                                      listen: false)
                                  .currentPaperDetail!
                                  .id,
                              "is_participant": "0",
                            }
                          : {
                              "name": _formKey.currentState?.value['name'],
                              "email": _formKey.currentState?.value['email'],
                              "institution":
                                  _formKey.currentState?.value['institution'],
                              "participant_id": foundParticipant?.id,
                              "paper_detail_id": Provider.of<PaperProvider>(
                                      context,
                                      listen: false)
                                  .currentPaperDetail!
                                  .id,
                              "is_participant": "1",
                            };

                      await PaperAuthorService().save(data).then((author) {
                        isLoading = false;
                        setState(() {});

                        Provider.of<PaperProvider>(context, listen: false)
                            .addAuthor(author);

                        DialogManager.showAlertDialog(
                          context,
                          "Author added successfully",
                          pressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          isGreen: true,
                        );
                      });
                    } else {
                      // else edit author
                      var data = {
                        "name": _formKey.currentState?.value['name'],
                        "email": _formKey.currentState?.value['email'],
                        "institution":
                            _formKey.currentState?.value['institution'],
                        "paper_detail_id": widget.author!.paperDetailId,
                        "participant_id": widget.author!.participantId,
                        "is_participant": widget.author!.isParticipant,
                      };

                      await PaperAuthorService()
                          .update(data, widget.author!.id!)
                          .then((author) {
                        isLoading = false;
                        setState(() {});

                        DialogManager.showAlertDialog(
                          context,
                          "Author updated successfully",
                          pressed: () {
                            Provider.of<PaperProvider>(context, listen: false)
                                .updateAuthor(author);

                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          isGreen: true,
                        );
                      });
                    }
                  }
                },
              ),
      ],
    );
  }

  _buildForm() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          _buildRadioButtons(),
          // check if radio value is yes
          // if yes, show the following fields
          // if no, hide the following fields
          if (isParticipant == "1" && showCheckEmail)
            Column(
              children: [
                const SizedBox(height: 10),
                CommonMethods().buildTextField(
                  _emailCheckKey,
                  'email_check',
                  'Email',
                  [
                    FormBuilderValidators.required(),
                    (value) {
                      if (!CommonMethods().isEmail(value)) {
                        return "Invalid email";
                      }
                    }
                  ],
                  desc: "Enter the email of the participant",
                ),
                isLoading
                    ? const LoadingWidget()
                    : CommonMethods().buildCustomButton(
                        text: "Check Email",
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            setState(() {
                              isLoading = true;
                            });

                            checkEmail();
                          }
                        },
                      ),
              ],
            ),
          if (showRestForm || isParticipant == "0") _buildRestForm(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(
          context, widget.author == null ? "Add Author" : "Edit Author"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: _buildForm(),
        ),
      ),
    );
  }
}
