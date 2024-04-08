import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/participant_model.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/auth_image_section.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/auth_service.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';
import 'package:ybb_event_app/services/progam_photo_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  ProgramPhotoModel? programPhoto;

  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();

  bool isObscure = true;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() {
    String id = Provider.of<ProgramProvider>(context, listen: false)
        .programInfo!
        .programCategoryId!;

    // get the program photos
    ProgramPhotoService().getProgramPhotos("").then((value) {
      List<ProgramPhotoModel> tempPhotos = [];

      /// only get the first photo which has the same program category id
      for (var element in value) {
        if (element.programCategoryId == id) {
          tempPhotos.add(element);
        }
      }

      setState(() {
        programPhoto =
            tempPhotos.elementAt(Random().nextInt(tempPhotos.length));
      });
    });
  }

  signin(Map<String, dynamic>? value) {
    Map<String, dynamic> data = {
      "email": value!['email'],
      "password": value['password'],
      "program_category_id":
          Provider.of<ProgramProvider>(context, listen: false)
              .programInfo!
              .programCategoryId!,
    };

    // sign in the user

    AuthService().participantSignIn(data).then((participants) {
      if (participants.isNotEmpty) {
        // save the user data to shared preferences
        AuthUserModel currentUser = AuthUserModel(
          id: participants[0].userId!,
          fullName: participants[0].fullName!,
          email: value['email']!,
        );

        Provider.of<AuthProvider>(context, listen: false)
            .setAuthUser(currentUser);

        Provider.of<ParticipantProvider>(context, listen: false)
            .setParticipants(participants);

        List<ParticipantModel>? tempList =
            Provider.of<ParticipantProvider>(context, listen: false)
                .participants;

        for (var i in tempList!) {
          if (i.programId ==
              Provider.of<ProgramProvider>(context, listen: false)
                  .programInfo!
                  .id) {
            Provider.of<ParticipantProvider>(context, listen: false)
                .setParticipant(i);
          }
        }

        // navigate to home page
        context.pushNamed(dashboardRouteName, extra: "participant");
      } else {
        DialogManager.showAlertDialog(context,
            "There is no participant with this email and password. Please try again.");
      }
    }).onError((error, stackTrace) {
      DialogManager.showAlertDialog(context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var programProvider = Provider.of<ProgramProvider>(context);

    return Scaffold(
      body: programPhoto == null
          ? const LoadingPage()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuthImageSection(
                  programPhoto: programPhoto!,
                  programInfo: programProvider.programInfo!,
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.07,
                          vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Welcome to ${programProvider.programInfo!.name!}",
                              textAlign: TextAlign.center,
                              style: headlineTextStyle.copyWith(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02,
                                vertical: 30),
                            child: FormBuilder(
                              key: _formKey,
                              child: Column(
                                children: [
                                  FormBuilderTextField(
                                    key: _emailFieldKey,
                                    name: 'email',
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.email(),
                                    ]),
                                  ),
                                  const SizedBox(height: 20),
                                  FormBuilderTextField(
                                    name: 'password',
                                    decoration: InputDecoration(
                                      // give an eye icon to show the password
                                      suffixIcon: IconButton(
                                        icon: isObscure
                                            ? const FaIcon(FontAwesomeIcons.eye)
                                            : const FaIcon(
                                                FontAwesomeIcons.eyeSlash),
                                        onPressed: () {
                                          // show the password
                                          setState(() {
                                            isObscure = !isObscure;
                                          });
                                        },
                                      ),
                                      labelText: 'Password',
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                    obscureText: isObscure,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.minLength(6),
                                    ]),
                                  ),
                                  const SizedBox(height: 20),
                                  // align the text to the right
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        // navigate to forgot password page
                                      },
                                      child: Text("Forgot password?",
                                          style: bodyTextStyle.copyWith(
                                              color: primary)),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // create a button with primary color that says "Login", width is 100% of the container
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    color: primary,
                                    // give radius to the button
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () {
                                      if (_formKey.currentState
                                              ?.saveAndValidate() ??
                                          false) {
                                        debugPrint(_formKey.currentState?.value
                                            .toString());

                                        signin(_formKey.currentState?.value);
                                      }
                                    },
                                    child: const Text('Sign in',
                                        style: buttonTextStyle),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? ",
                                  style: smallHeadlineTextStyle.copyWith(
                                      fontWeight: FontWeight.normal)),
                              InkWell(
                                onTap: () {
                                  context.pushNamed(signUpRouteName);
                                },
                                child: Text("Sign up",
                                    style: smallHeadlineTextStyle.copyWith(
                                        color: primary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Part of our ambassadors? ",
                                  style: smallHeadlineTextStyle.copyWith(
                                      fontWeight: FontWeight.normal)),
                              InkWell(
                                onTap: () {
                                  // navigate to forgot password page
                                  context.pushNamed(ambassadorSigninRouteName);
                                },
                                // what's the other catchy phrase for login as ambassador?
                                child: Text("Join here",
                                    style: smallHeadlineTextStyle.copyWith(
                                        color: primary)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
