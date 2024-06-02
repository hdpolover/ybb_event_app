import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/services/participant_service.dart';
import 'package:ybb_event_app/services/participant_status_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class BasicInformationSection extends StatefulWidget {
  const BasicInformationSection({super.key});

  @override
  State<BasicInformationSection> createState() =>
      _BasicInformationSectionState();
}

class _BasicInformationSectionState extends State<BasicInformationSection> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _fullNameKey = GlobalKey<FormBuilderFieldState>();

  final _occupationKey = GlobalKey<FormBuilderFieldState>();

  final _originAddressKey = GlobalKey<FormBuilderFieldState>();

  final _currentAddressKey = GlobalKey<FormBuilderFieldState>();

  final _institutionKey = GlobalKey<FormBuilderFieldState>();

  final _organizationKey = GlobalKey<FormBuilderFieldState>();

  final _contactRelationKey = GlobalKey<FormBuilderFieldState>();

  final _instagramAccountKey = GlobalKey<FormBuilderFieldState>();

  final _diseaseHistory = GlobalKey<FormBuilderFieldState>();
  final _phoneNumberKey = GlobalKey<FormBuilderFieldState>();
  final _emergencyContactKey = GlobalKey<FormBuilderFieldState>();

  final nationalityController = TextEditingController();

  String? dialCode;

  bool isLoading = false;

  PhoneNumber? phoneNumber;
  PhoneNumber? emergencyPhoneNumber;

  FilePickerResult? photoFile;
  Uint8List? fileBytes;
  String? fileName;
  String? profileUrl;

  fillCurrentData(ParticipantProvider participantProvider) {
    ParticipantModel currentParticipant = participantProvider.participant!;

    if (currentParticipant.fullName != null) {
      _fullNameKey.currentState!.setValue(currentParticipant.fullName);
    }

    if (currentParticipant.nationality != null) {
      setState(() {
        nationalityController.text = currentParticipant.nationality;
      });
    }

    if (currentParticipant.countryCode != null) {
      setState(() {
        dialCode = currentParticipant.countryCode;
      });
    }

    if (currentParticipant.pictureUrl != null) {
      setState(() {
        profileUrl = currentParticipant.pictureUrl;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // give delayed time to fill the current data by 3 second
    Future.delayed(const Duration(seconds: 2), () {
      fillCurrentData(Provider.of<ParticipantProvider>(context, listen: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    var participantProvider = Provider.of<ParticipantProvider>(context);

    ParticipantModel currentParticipant = participantProvider.participant!;

    //fillCurrentData(participantProvider);

    return // Personal Information
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // build a container to upload profile picture
              Column(
                children: [
                  Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: photoFile == null
                        ? profileUrl == null
                            ? Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.grey[400],
                              )
                            : Image.network(
                                profileUrl!,
                                fit: BoxFit.cover,
                              )
                        : Image.memory(
                            photoFile!.files.first.bytes!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 10),
                  CommonMethods().buildCustomButton(
                      width: MediaQuery.of(context).size.width * 0.25,
                      text: "Edit photo",
                      onPressed: () async {
                        // upload payment proof
                        await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                        ).then((value) {
                          // check if the file size is more than 2MB, add error message saying for file efficiency it cannot exceed 2 mb
                          if (value!.files.single.size > 2000000) {
                            DialogManager.showAlertDialog(context,
                                "File size is too large. Please upload a file with size less than 2MB.",
                                isGreen: false);
                          } else {
                            if (value.files.single.extension != "jpg" &&
                                value.files.single.extension != "jpeg" &&
                                value.files.single.extension != "png") {
                              DialogManager.showAlertDialog(context,
                                  "Invalid file type. Please upload a file with extension .jpg, .jpeg, or .png.",
                                  isGreen: false);
                            } else {
                              setState(() {
                                photoFile = value;
                                fileBytes = value.files.single.bytes!;
                                fileName = value.files.single.name;
                              });
                            }
                          }
                        });
                      }),
                  const SizedBox(height: 20),
                ],
              ),
              CommonMethods().buildTextField(
                _fullNameKey,
                'full_name',
                'Full Name',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
                initial: currentParticipant.fullName,
                desc:
                    "This name will be used for your certificates and ID card",
              ),
              // radio button for gender
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gender",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderRadioGroup(
                      name: 'gender',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        isDense: false,
                      ),
                      // capitalize the first letter of the gender
                      initialValue: currentParticipant.gender,
                      validator: FormBuilderValidators.required(),
                      options: [
                        'male',
                        'female',
                      ]
                          .map((lang) => FormBuilderFieldOption(value: lang))
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
                      "Date of Birth",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDateTimePicker(
                      style: bodyTextStyle.copyWith(color: Colors.black),
                      name: "date_of_birth",
                      format: DateFormat("MMMM d, yyyy"),
                      inputType: InputType.date,
                      lastDate: DateTime.now(),
                      initialValue: currentParticipant.birthdate,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        hintText:
                            DateFormat("MMMM d, yyyy").format(DateTime.now()),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
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
                      "Nationality",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode:
                                false, // optional. Shows phone code before the country name.
                            onSelect: (Country country) {
                              print(country);
                              setState(() {
                                nationalityController.text = country.name;
                                dialCode = country.phoneCode;
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  nationalityController.text.isNotEmpty
                                      ? nationalityController.text
                                      : "Select Country",
                                  style: bodyTextStyle.copyWith(
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              CommonMethods().buildTextField(
                _originAddressKey,
                'origin_address',
                'Origin Address',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
                initial: currentParticipant.originAddress,
              ),
              CommonMethods().buildTextField(
                _currentAddressKey,
                'current_address',
                'Current Address',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
                initial: currentParticipant.currentAddress,
              ),
              CommonMethods().buildTextField(
                _occupationKey,
                'occupation',
                'Occupation',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
                initial: currentParticipant.occupation,
              ),
              CommonMethods().buildTextField(
                _institutionKey,
                'institution',
                'Institution/Workplace',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
                initial: currentParticipant.institution,
              ),
              CommonMethods().buildTextField(
                _organizationKey,
                'organization',
                'Organizations/Communities',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ],
                initial: currentParticipant.organizations,
              ),
              CommonMethods().buildTextField(
                _phoneNumberKey,
                'phone_number',
                'Personal Phone Number (WhatsApp)',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(10),
                ],
                initial: currentParticipant.phoneNumber,
                desc:
                    "Please provide your WhatsApp phone number with the country code. Example for an Indonesian number: +6281234567890",
              ),

              CommonMethods().buildTextField(
                _instagramAccountKey,
                'instagram_account',
                'Instagram Account',
                [
                  FormBuilderValidators.required(),
                ],
                initial: currentParticipant.instagramAccount,
                desc:
                    "Please only provide your Instagram account username without '@' symbol. Example: youthbreaktheboundaries",
              ),
              CommonMethods().buildTextField(
                  _diseaseHistory,
                  'disease_history',
                  'Disease History',
                  [
                    FormBuilderValidators.required(),
                  ],
                  initial: currentParticipant.diseaseHistory,
                  desc:
                      "Please provide your disease history if any. Input (-) if none."),
              CommonMethods().buildTextField(
                _emergencyContactKey,
                'emergency_contact',
                'Emergency Contact Phone Number (WhatsApp)',
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(10),
                ],
                initial: currentParticipant.emergencyAccount,
                desc:
                    "Please provide your emergency contact phone number with the country code. Example for an Indonesian number: +6281234567890",
              ),
              CommonMethods().buildTextField(
                  _contactRelationKey,
                  'contact_relation',
                  'Contact Relation',
                  [
                    FormBuilderValidators.required(),
                  ],
                  initial: currentParticipant.contactRelation,
                  desc:
                      "Please provide your relationship with the emergency contact. Example: Mother, Father, etc."),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "T-Shirt Size",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                        onPressed: () {
                          // show size chart as a dialog with image asset
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/tshirt_chart.jpg"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Text(
                          "Size Chart",
                          style: buttonTextStyle.copyWith(color: primary),
                        )),
                    const SizedBox(height: 10),
                    FormBuilderRadioGroup(
                      name: 'tshirt_size',
                      initialValue: currentParticipant.tshirtSize,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        isDense: false,
                      ),
                      validator: FormBuilderValidators.required(),
                      options: [
                        'S',
                        'M',
                        'L',
                        'XL',
                        '2XL',
                        'Others: Contact Admin'
                      ]
                          .map((lang) => FormBuilderFieldOption(value: lang))
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // create save button
              Align(
                alignment: Alignment.centerRight,
                child: isLoading
                    ? LoadingAnimationWidget.fourRotatingDots(
                        color: primary, size: 40)
                    : CommonMethods().buildCustomButton(
                        width: 200,
                        text: "SAVE",
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate() &&
                              nationalityController.text.isNotEmpty) {
                            if (photoFile == null) {
                              setState(() {
                                isLoading = true;
                              });

                              // show loading animation while saving data full screen

                              Map<String, dynamic> data =
                                  _formKey.currentState!.value;

                              ParticipantModel currentParticipant =
                                  participantProvider.participant!;

                              Map<String, dynamic> dataToSave = {
                                "full_name": data['full_name'],
                                "birthdate": data['date_of_birth'].toString(),
                                "gender": data['gender'],
                                "country_code": dialCode,
                                "phone_number": data['phone_number'],
                                "emergency_account": data['emergency_contact'],
                                "origin_address": data['origin_address'],
                                "current_address": data['current_address'],
                                "nationality": nationalityController.text,
                                "occupation": data['occupation'],
                                "institution": data['institution'],
                                "organizations": data['organization'],
                                "disease_history": data['disease_history'],
                                "tshirt_size": data['tshirt_size'],
                                "contact_relation": data['contact_relation'],
                                "instagram_account": data['instagram_account'],
                              };

                              print(dataToSave);

                              ParticipantService()
                                  .updateBasicInformationDataWithoutPhoto(
                                      currentParticipant.id!, dataToSave)
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
                                  participantProvider
                                      .setParticipantStatus(value);

                                  DialogManager.showAlertDialog(context,
                                      "Basic information has been saved successfully!",
                                      isGreen: true);

                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              }).onError((error, stackTrace) {
                                print(error.toString() +
                                    " " +
                                    stackTrace.toString() +
                                    "without photo");

                                DialogManager.showAlertDialog(context,
                                    "Failed to save data. Please try again later.",
                                    isGreen: false);

                                setState(() {
                                  isLoading = false;
                                });
                              });
                            } else {
                              setState(() {
                                isLoading = true;
                              });

                              // show loading animation while saving data full screen

                              Map<String, dynamic> data =
                                  _formKey.currentState!.value;

                              ParticipantModel currentParticipant =
                                  participantProvider.participant!;

                              Map<String, dynamic> dataToSave = {
                                "full_name": data['full_name'],
                                "birthdate": data['date_of_birth'].toString(),
                                "gender": data['gender'],
                                "country_code": dialCode,
                                "phone_number": data['phone_number'],
                                "emergency_account": data['emergency_contact'],
                                "origin_address": data['origin_address'],
                                "current_address": data['current_address'],
                                "nationality": nationalityController.text,
                                "occupation": data['occupation'],
                                "institution": data['institution'],
                                "organizations": data['organization'],
                                "disease_history": data['disease_history'],
                                "tshirt_size": data['tshirt_size'],
                                "contact_relation": data['contact_relation'],
                                "instagram_account": data['instagram_account'],
                                "file_bytes": fileBytes,
                                "file_name": fileName,
                              };

                              print(dataToSave);

                              ParticipantService()
                                  .updateBasicInformationDataWithPhoto(
                                      currentParticipant.id!, dataToSave)
                                  .then((value) {
                                participantProvider.setParticipant(value);

                                DialogManager.showAlertDialog(context,
                                    "Basic information has been saved successfully!",
                                    isGreen: true);

                                setState(() {
                                  isLoading = false;
                                });
                              }).onError((error, stackTrace) {
                                print(error.toString() +
                                    " " +
                                    stackTrace.toString() +
                                    "with photo");

                                DialogManager.showAlertDialog(context,
                                    "Failed to save data. Please try again later.",
                                    isGreen: false);

                                setState(() {
                                  isLoading = false;
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
