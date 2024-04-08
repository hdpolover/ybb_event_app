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
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/services/participant_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class BasicInformationSection extends StatefulWidget {
  BasicInformationSection({super.key});

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

  final nationalityController = TextEditingController();

  final phoneController = TextEditingController();
  final emergencyPhoneController = TextEditingController();

  String? dialCode;

  XFile? pickedFile;
  String? base64Image;

  fillCurrentData(ParticipantProvider participantProvider) {
    ParticipantModel currentParticipant = participantProvider.participant!;

    if (currentParticipant.fullName != null) {
      _fullNameKey.currentState!.setValue(currentParticipant.fullName);
    }
  }

  Future<void> pickImageForMobileAndWeb() async {
    final ImagePicker picker = ImagePicker();
    // This picks file for both mobile and web platforms
    pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    // Defining the required size for image upload
    const int maxFileSizeInBytes = 5 * 1048; // This equals to 5MB of Size

    if (pickedFile != null) {
      final Uint8List imageByte = await pickedFile!.readAsBytes(); //
      final int fileSize =
          imageByte.length; //Getting the file size of the file uploaded
      if (fileSize < maxFileSizeInBytes) {
        //show snackbar with message 'File size should be 5mb or less'
        return;
      } else {
        final String imageBase64String = base64Encode(
            imageByte); // Encoding the list of byte i.e imageBytes to base64 String

        setState(() {
          base64Image = imageBase64String;
        });

        // Sending the trimmed base64 string to server for validation
        // send the base64 string for validation to server.

//         final bool isValidImageFile = apiResponseForFileType[
//             'valid_file']; //Response from the server after validation

//         if (isValidImageFile) {
//           //Do your actions
//           // To pass to another screen
// // YourClassName(base64String : imageBase64String )
//         } else {
//           print('Not valid file or Image');
//         }
      }
    } else {
      // Navigate safely to required screen
    }
  }

  @override
  Widget build(BuildContext context) {
    var participantProvider = Provider.of<ParticipantProvider>(context);

    ParticipantModel currentParticipant = participantProvider.participant!;

    if (currentParticipant.nationality != null) {
      setState(() {
        nationalityController.text = currentParticipant.nationality;
      });
    }

    if (currentParticipant.phoneNumber != null && dialCode == null) {
      setState(() {
        phoneController.text = currentParticipant.phoneNumber!;
      });
    }

    if (currentParticipant.emergencyAccount != null && dialCode == null) {
      setState(() {
        emergencyPhoneController.text = currentParticipant.emergencyAccount!;
      });
    }

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
              // Column(
              //   children: [
              //     Container(
              //       width: 400,
              //       height: 400,
              //       decoration: BoxDecoration(
              //         color: Colors.grey[200],
              //         // image from net
              //       ),
              //       child: base64Image != null
              //           ? Image.memory(
              //               base64Decode(base64Image!),
              //               fit: BoxFit.cover,
              //             )
              //           : Icon(
              //               Icons.person,
              //               size: 100,
              //               color: Colors.grey[400],
              //             ),
              //     ),
              //     const SizedBox(height: 10),
              //     CommonMethods().buildCustomButton(
              //         width: MediaQuery.of(context).size.width * 0.25,
              //         text: "Edit photo",
              //         onPressed: () async {
              //           await pickImageForMobileAndWeb();
              //         }),
              //     const SizedBox(height: 20),
              //   ],
              // ),

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
                              setState(() {
                                nationalityController.text = country.name;
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone Number (WhatsApp)",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InternationalPhoneNumberInput(
                      initialValue: currentParticipant.phoneNumber == null
                          ? null
                          : PhoneNumber(
                              dialCode: currentParticipant.countryCode,
                              phoneNumber: currentParticipant.phoneNumber,
                            ),
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          dialCode = number.dialCode;
                        });

                        print(number.phoneNumber);
                        print(dialCode);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      // initialValue: number,
                      textFieldController: phoneController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        setState(() {
                          phoneController.text = number.phoneNumber!;
                        });
                        print('On Saved: $number');
                      },
                    ),
                  ],
                ),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Emergency Contact (WhatsApp)",
                      style: bodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InternationalPhoneNumberInput(
                      initialValue: currentParticipant.emergencyAccount == null
                          ? null
                          : PhoneNumber(
                              dialCode: currentParticipant.countryCode,
                              phoneNumber: currentParticipant.emergencyAccount,
                            ),
                      onInputChanged: (PhoneNumber number) {
                        print(number.phoneNumber);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      // initialValue: number,
                      textFieldController: emergencyPhoneController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        setState(() {
                          emergencyPhoneController.text = number.phoneNumber!;
                        });
                        print('On Saved: $number');
                      },
                    ),
                  ],
                ),
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
                          "See Size Chart",
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
                child: CommonMethods().buildCustomButton(
                  width: 200,
                  text: "SAVE",
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate() &&
                        nationalityController.text.isNotEmpty) {
                      print(_formKey.currentState!.value);

                      Map<String, dynamic> data = _formKey.currentState!.value;

                      ParticipantModel currentParticipant =
                          Provider.of<ParticipantProvider>(
                        context,
                        listen: false,
                      ).participant!;

                      Map<String, dynamic> dataToSave = {
                        "full_name": currentParticipant.fullName,
                        "birthdate": currentParticipant.birthdate.toString(),
                        "gender": data['gender'],
                        "country_code": dialCode,
                        "phone_number": phoneController.text,
                        "emergency_account": emergencyPhoneController.text,
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

                      ParticipantService()
                          .updateData(currentParticipant.id!, dataToSave)
                          .then((value) {
                        Provider.of<ParticipantProvider>(context, listen: false)
                            .setParticipant(value);

                        DialogManager.showAlertDialog(context,
                            "Basic information has been saved successfully!",
                            isGreen: true);

                        print(value);
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
