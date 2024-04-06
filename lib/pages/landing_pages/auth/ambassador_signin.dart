import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/auth_image_section.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/auth_service.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';
import 'package:ybb_event_app/services/progam_photo_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class AmbassadorSignin extends StatefulWidget {
  const AmbassadorSignin({super.key});

  @override
  State<AmbassadorSignin> createState() => _AmbassadorSigninState();
}

class _AmbassadorSigninState extends State<AmbassadorSignin> {
  ProgramPhotoModel? programPhoto;

  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final _refCodeFieldKey = GlobalKey<FormBuilderFieldState>();

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
      "ref_code": value['ref_code'],
    };

    // sign in the user
    try {
      AuthService().ambassadorSignIn(data).then((value) {
        // save the user data to shared preferences
        // String id = value.id!;
        // String fullName = value.name!;
        // String email = value.email!;

        // SpManager.setString("id", id);
        // SpManager.setString("full_name", fullName);
        // SpManager.setString("email", email);
        AuthUserModel currentUser = AuthUserModel(
          id: value.id!,
          fullName: value.name!,
          email: value.email!,
        );

        Provider.of<AuthProvider>(context, listen: false)
            .setAuthUser(currentUser);

        // navigate to home page
        context.pushNamed(dashboardRouteName, extra: "ambassador");
      }).onError((error, stackTrace) {
        // show error message
        DialogManager.showAlertDialog(context, error.toString());
      });
    } catch (e) {
      // show error message
    }
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
                              "Welcome back, ${programProvider.programInfo!.name!} Ambassador!",
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
                                    key: _refCodeFieldKey,
                                    name: 'ref_code',
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: const InputDecoration(
                                      labelText: 'Referral Code',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
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
                              Text(
                                  "A ${programProvider.programInfo!.name!} participant? ",
                                  style: smallHeadlineTextStyle.copyWith(
                                      fontWeight: FontWeight.normal)),
                              InkWell(
                                onTap: () {
                                  // navigate to forgot password page
                                  context.pushNamed(authRouteName);
                                },
                                // what's the other catchy phrase for login as ambassador?
                                child: Text("Sign in here",
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
