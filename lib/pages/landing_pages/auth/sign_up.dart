import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/main.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/models/user_model.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/auth_image_section.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/auth_service.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';
import 'package:ybb_event_app/services/progam_photo_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ProgramInfoByUrlModel? programInfo;
  ProgramPhotoModel? programPhoto;

  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();

  bool isObscure = true;

  bool isLoading = false;

  List<Widget> children = [];

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() {
    LandingPageService().getProgramInfo(mainUrl).then((value) {
      setState(() {
        programInfo = value;
      });

      // get the program photos
      ProgramPhotoService()
          .getProgramPhotos(programInfo!.programCategoryId!)
          .then((value) {
        List<ProgramPhotoModel> tempPhotos = [];

        /// only get the first photo which has the same program category id
        for (var element in value) {
          if (element.programCategoryId == programInfo!.programCategoryId) {
            tempPhotos.add(element);
          }
        }

        if (tempPhotos.isEmpty) {
          setState(() {
            programPhoto = value.elementAt(Random().nextInt(value.length));
          });
        } else {
          setState(() {
            programPhoto =
                tempPhotos.elementAt(Random().nextInt(tempPhotos.length));
          });
        }

        setChildren();
      });
    });
  }

  signUp(Map<String, dynamic>? value) {
    // call the sign up function
    UserModel user = UserModel(
      fullName: value!['full_name'],
      email: value['email'],
      password: value['password'],
      programId: programInfo!.id,
      programCategoryId: programInfo!.programCategoryId,
      refCode: "",
    );

    try {
      // call the sign up function
      // if the sign up is successful, navigate to the home page
      // if the sign up is failed, show an error message
      AuthService().participantSignUp(user).then((value) {
        if (value != null) {
          String verifRequired =
              Provider.of<ProgramProvider>(context, listen: false)
                  .programInfo!
                  .verificationRequired!;

          if (verifRequired == "0") {
            setState(() {
              isLoading = false;
            });

            // show dialog to verify email
            DialogManager.showAlertDialog(context,
                "Account registered successfully. Please sign in to continue.",
                isGreen: true, pressed: () {
              context.goNamed(authRouteName);
            });
          } else {
            AuthService().sendVerifEmail(value.id!).then((value) {
              setState(() {
                isLoading = false;
              });

              // show dialog to verify email
              DialogManager.showAlertDialog(context,
                  "Please verify your email to continue. Check your inbox or spam folder.",
                  pressed: () {
                context.goNamed(authRouteName);
              });
            });
          }
        } else {
          // show dialog to verify email
          DialogManager.showAlertDialog(
            context,
            "Something went wrong. Please try again.",
          );
        }
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });

        DialogManager.showAlertDialog(context, e.toString());
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      DialogManager.showAlertDialog(context, e.toString());
      // show an error message
    }
  }

  setChildren() {
    return ScreenSizeHelper.responsiveValue(
      context,
      mobile: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                    vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.1,
                    ),
                    // add logo here from network
                    GestureDetector(
                      onTap: () {
                        context.goNamed(homeRouteName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Image.network(
                          programInfo!.logoUrl!,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ),
                    ),
                    Text("Create a New Account",
                        textAlign: TextAlign.center,
                        style: headlineTextStyle.copyWith(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: 30),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            // form for full name
                            FormBuilderTextField(
                              name: 'full_name',
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              key: _emailFieldKey,
                              name: 'email',
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                                // emails allowed are only gmail.com, yahoo.com, and outlook.com, icloud.com is not allowed
                                (value) => value!.endsWith('@icloud.com')
                                    ? 'Only Gmail, Yahoo, and Outlook emails are allowed'
                                    : null,
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
                                      : const FaIcon(FontAwesomeIcons.eyeSlash),
                                  onPressed: () {
                                    // show the password
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                ),
                                labelText: 'Password',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              obscureText: isObscure,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: 'confirm_password',
                              decoration: InputDecoration(
                                // give an eye icon to show the password
                                suffixIcon: IconButton(
                                  icon: isObscure
                                      ? const FaIcon(FontAwesomeIcons.eye)
                                      : const FaIcon(FontAwesomeIcons.eyeSlash),
                                  onPressed: () {
                                    // show the password
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                ),
                                labelText: 'Confirm Password',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              obscureText: isObscure,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                                // give an error if the password doesn't match
                                (value) => _formKey.currentState
                                            ?.fields['password']?.value !=
                                        value
                                    ? 'Passwords do not match'
                                    : null,
                              ]),
                            ),

                            const SizedBox(height: 20),
                            //build check box for terms and conditions
                            // FormBuilderCheckbox(
                            //   name: 'accept_terms',
                            //   title: RichText(
                            //     text: TextSpan(
                            //       text: 'I accept the',
                            //       style: bodyTextStyle.copyWith(
                            //           color: Colors.black),
                            //       children: <TextSpan>[
                            //         TextSpan(
                            //           text: ' Terms and Conditions',
                            //           style: bodyTextStyle.copyWith(
                            //               color: primary),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //   validator: FormBuilderValidators.compose([
                            //     FormBuilderValidators.required(
                            //         errorText:
                            //             'You must accept terms and conditions to continue'),
                            //   ]),
                            // ),
                            // create a button with primary color that says "Login", width is 100% of the container
                            isLoading
                                ? LoadingAnimationWidget.fourRotatingDots(
                                    color: primary, size: 40)
                                : MaterialButton(
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

                                        setState(() {
                                          isLoading = true;
                                        });

                                        signUp(_formKey.currentState?.value);
                                      }
                                    },
                                    child: const Text('Sign up',
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
                        Text("Already have an account? ",
                            style: smallHeadlineTextStyle.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            )),
                        InkWell(
                          onTap: () {
                            context.pushNamed(authRouteName);
                          },
                          child: Text("Sign in",
                              style: smallHeadlineTextStyle.copyWith(
                                color: primary,
                                fontSize: 17,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Part of our ambassadors? ",
                            style: smallHeadlineTextStyle.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            )),
                        InkWell(
                          onTap: () {
                            // navigate to forgot password page
                            context.pushNamed(ambassadorSigninRouteName);
                          },
                          // what's the other catchy phrase for login as ambassador?
                          child: Text("Join here",
                              style: smallHeadlineTextStyle.copyWith(
                                color: primary,
                                fontSize: 17,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AuthImageSection(
            programPhoto: programPhoto,
            programInfo: programInfo,
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
                    Text("Create a New Account",
                        textAlign: TextAlign.center,
                        style: headlineTextStyle.copyWith(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: 30),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            // form for full name
                            FormBuilderTextField(
                              name: 'full_name',
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              key: _emailFieldKey,
                              name: 'email',
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                                // emails allowed are only gmail.com, yahoo.com, and outlook.com, icloud.com is not allowed
                                (value) => value!.endsWith('@icloud.com')
                                    ? 'Only Gmail, Yahoo, and Outlook emails are allowed'
                                    : null,
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
                                      : const FaIcon(FontAwesomeIcons.eyeSlash),
                                  onPressed: () {
                                    // show the password
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                ),
                                labelText: 'Password',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              obscureText: isObscure,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: 'confirm_password',
                              decoration: InputDecoration(
                                // give an eye icon to show the password
                                suffixIcon: IconButton(
                                  icon: isObscure
                                      ? const FaIcon(FontAwesomeIcons.eye)
                                      : const FaIcon(FontAwesomeIcons.eyeSlash),
                                  onPressed: () {
                                    // show the password
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                ),
                                labelText: 'Confirm Password',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              obscureText: isObscure,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                                // give an error if the password doesn't match
                                (value) => _formKey.currentState
                                            ?.fields['password']?.value !=
                                        value
                                    ? 'Passwords do not match'
                                    : null,
                              ]),
                            ),

                            const SizedBox(height: 20),
                            //build check box for terms and conditions
                            // FormBuilderCheckbox(
                            //   name: 'accept_terms',
                            //   title: RichText(
                            //     text: TextSpan(
                            //       text: 'I accept the',
                            //       style: bodyTextStyle.copyWith(
                            //           color: Colors.black),
                            //       children: <TextSpan>[
                            //         TextSpan(
                            //           text: ' Terms and Conditions',
                            //           style: bodyTextStyle.copyWith(
                            //               color: primary),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //   validator: FormBuilderValidators.compose([
                            //     FormBuilderValidators.required(
                            //         errorText:
                            //             'You must accept terms and conditions to continue'),
                            //   ]),
                            // ),
                            // create a button with primary color that says "Login", width is 100% of the container
                            isLoading
                                ? LoadingAnimationWidget.fourRotatingDots(
                                    color: primary, size: 40)
                                : MaterialButton(
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

                                        setState(() {
                                          isLoading = true;
                                        });

                                        signUp(_formKey.currentState?.value);
                                      }
                                    },
                                    child: const Text('Sign up',
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
                        Text("Already have an account? ",
                            style: smallHeadlineTextStyle.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            )),
                        InkWell(
                          onTap: () {
                            context.pushNamed(authRouteName);
                          },
                          child: Text("Sign in",
                              style: smallHeadlineTextStyle.copyWith(
                                color: primary,
                                fontSize: 17,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Part of our ambassadors? ",
                            style: smallHeadlineTextStyle.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            )),
                        InkWell(
                          onTap: () {
                            // navigate to forgot password page
                            context.pushNamed(ambassadorSigninRouteName);
                          },
                          // what's the other catchy phrase for login as ambassador?
                          child: Text("Join here",
                              style: smallHeadlineTextStyle.copyWith(
                                color: primary,
                                fontSize: 17,
                              )),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: programInfo == null || programPhoto == null
          ? const LoadingPage()
          : setChildren(),
    );
  }
}
