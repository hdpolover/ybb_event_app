import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:ybb_event_app/models/program_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/pages/landing_pages/auth/auth_image_section.dart';
import 'package:ybb_event_app/pages/loading_page.dart';
import 'package:ybb_event_app/providers/auth_provider.dart';
import 'package:ybb_event_app/providers/participant_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/auth_service.dart';
import 'package:ybb_event_app/services/landing_page_service.dart';
import 'package:ybb_event_app/services/participant_status_service.dart';
import 'package:ybb_event_app/services/progam_photo_service.dart';
import 'package:ybb_event_app/services/program_service.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

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

  bool isLoading = false;

  List<Widget> children = [];

  ProgramInfoByUrlModel? programInfo;
  ProgramModel? currentProgram;

  @override
  void initState() {
    super.initState();

    LandingPageService().getProgramInfo(mainUrl).then((value) async {
      //set program info to provider
      Provider.of<ProgramProvider>(context, listen: false)
          .setProgramInfo(value);

      setState(() {
        programInfo = value;
      });

      ProgramService().getProgramById(programInfo!.id!).then((value) async {
        //set current program to provider
        Provider.of<ProgramProvider>(context, listen: false)
            .setCurrentProgram(value);

        setState(() {
          currentProgram = value;
        });

        getData();
      });
    });

    // add 3 seconds delay to show the program is inactive
    Future.delayed(const Duration(seconds: 3), () {
      showProgramInactive();
    });
  }

  showProgramInactive() {
    bool isProgramInactive =
        Provider.of<ProgramProvider>(context, listen: false)
                .programInfo!
                .isActive ==
            "0";

    if (isProgramInactive) {
      DialogManager.showAlertDialog(context,
          "This program has already ended. You will not be able to sign up. But you can still sign in if you participated in this program before.");
    }
  }

  setChildren() {
    var programProvider = Provider.of<ProgramProvider>(context, listen: false);

    return ScreenSizeHelper.responsiveValue(
      context,
      desktop: Row(
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
                      AutoSizeText(
                          "Welcome to ${programProvider.programInfo!.name!}",
                          textAlign: TextAlign.center,
                          style: headlineTextStyle.copyWith(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
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
                                    context.pushNamed(forgotPasswordRouteName);
                                  },
                                  child: AutoSizeText("Forgot password?",
                                      style: bodyTextStyle.copyWith(
                                          color: primary)),
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                        // Map<String, dynamic> data = {
                                        //   "email": "hendrapolover@gmail.com",
                                        //   "password": "12344321",
                                        // };

                                        // signin(data);

                                        if (_formKey.currentState
                                                ?.saveAndValidate() ??
                                            false) {
                                          debugPrint(_formKey
                                              .currentState?.value
                                              .toString());

                                          setState(() {
                                            isLoading = true;
                                          });

                                          signin(_formKey.currentState?.value);
                                        }
                                      },
                                      child: const AutoSizeText('Sign in',
                                          style: buttonTextStyle),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: programProvider.programInfo!.isActive == "1",
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText("Don't have an account? ",
                                    style: smallHeadlineTextStyle.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    )),
                                InkWell(
                                  onTap: () {
                                    context.pushNamed(signUpRouteName);
                                  },
                                  child: AutoSizeText("Sign up",
                                      style: smallHeadlineTextStyle.copyWith(
                                          color: primary, fontSize: 17)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText("Part of our ambassadors? ",
                              style: smallHeadlineTextStyle.copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 17)),
                          InkWell(
                            onTap: () {
                              // navigate to forgot password page
                              context.pushNamed(ambassadorSigninRouteName);
                            },
                            // what's the other catchy phrase for login as ambassador?
                            child: AutoSizeText("Join here",
                                style: smallHeadlineTextStyle.copyWith(
                                    color: primary, fontSize: 17)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
      mobile: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
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
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                    // add logo here from network
                    GestureDetector(
                      onTap: () {
                        context.goNamed(homeRouteName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Image.network(
                          programProvider.programInfo!.logoUrl!,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                      ),
                    ),
                    AutoSizeText(
                        "Welcome to ${programProvider.programInfo!.name!}",
                        textAlign: TextAlign.center,
                        style: headlineTextStyle.copyWith(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                      : const FaIcon(FontAwesomeIcons.eyeSlash),
                                  onPressed: () {
                                    // show the password
                                    setState(() {
                                      isObscure = !isObscure;
                                    });

                                    print(isObscure);
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
                            // align the text to the right
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  // navigate to forgot password page
                                  context.pushNamed(forgotPasswordRouteName);
                                },
                                child: AutoSizeText("Forgot password?",
                                    style:
                                        bodyTextStyle.copyWith(color: primary)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // align the text to the right
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: InkWell(
                            //     onTap: () {
                            //       // navigate to forgot password page
                            //     },
                            //     child: AutoSizeText("Forgot password?",
                            //         style: bodyTextStyle.copyWith(
                            //             color: primary)),
                            //   ),
                            // ),
                            // const SizedBox(height: 20),
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
                                      // Map<String, dynamic> data = {
                                      //   "email": "hendrapolover@gmail.com",
                                      //   "password": "Hendra123@",
                                      // };

                                      // signin(data);

                                      if (_formKey.currentState
                                              ?.saveAndValidate() ??
                                          false) {
                                        debugPrint(_formKey.currentState?.value
                                            .toString());

                                        setState(() {
                                          isLoading = true;
                                        });

                                        signin(_formKey.currentState?.value);
                                      }
                                    },
                                    child: const AutoSizeText('Sign in',
                                        style: buttonTextStyle),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: programProvider.programInfo!.isActive == "1",
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText("Don't have an account? ",
                                  style: smallHeadlineTextStyle.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  )),
                              InkWell(
                                onTap: () {
                                  context.pushNamed(signUpRouteName);
                                },
                                child: AutoSizeText("Sign up",
                                    style: smallHeadlineTextStyle.copyWith(
                                        color: primary, fontSize: 17)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText("Part of our ambassadors? ",
                            style: smallHeadlineTextStyle.copyWith(
                                fontWeight: FontWeight.normal, fontSize: 17)),
                        InkWell(
                          onTap: () {
                            // navigate to forgot password page
                            context.pushNamed(ambassadorSigninRouteName);
                          },
                          // what's the other catchy phrase for login as ambassador?
                          child: AutoSizeText("Join here",
                              style: smallHeadlineTextStyle.copyWith(
                                  color: primary, fontSize: 17)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getData() {
    String id = Provider.of<ProgramProvider>(context, listen: false)
        .programInfo!
        .programCategoryId!;

    // get the program photos
    ProgramPhotoService().getProgramPhotos(id).then((value) {
      List<ProgramPhotoModel> tempPhotos = [];

      /// only get the first photo which has the same program category id
      for (var element in value) {
        if (element.programCategoryId == id) {
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
    });
  }

  signin(Map<String, dynamic>? value) async {
    Map<String, dynamic> data = {
      "email": value!['email'],
      "password": value['password'],
      "program_category_id":
          Provider.of<ProgramProvider>(context, listen: false)
              .programInfo!
              .programCategoryId!,
    };

    // sign in the user
    await AuthService().participantSignIn(data).then((p) async {
      // check if the program needs verification
      if (Provider.of<ProgramProvider>(context, listen: false)
              .programInfo!
              .verificationRequired! ==
          "1") {
        // check if verified
        if (p.isVerified == "0") {
          DialogManager.showVerifyAlert(context,
              "Your account is not verified yet. Please check your email inbox to continue.",
              () async {
            await AuthService().sendVerifEmail(p.userId!).then((value) {
              Navigator.of(context).pop();
            });
          }, () {
            Navigator.of(context).pop();
          });

          setState(() {
            isLoading = false;
          });
        } else {
          // save the user data to shared preferences
          AuthUserModel currentUser = AuthUserModel(
            id: p.id!,
            fullName: p.fullName!,
            email: value['email']!,
          );

          Provider.of<AuthProvider>(context, listen: false)
              .setAuthUser(currentUser);

          Provider.of<ParticipantProvider>(context, listen: false)
              .setParticipant(p);

          await ParticipantStatusService()
              .getByParticipantId(p.id)
              .then((value) {
            setState(() {
              isLoading = false;
            });

            Provider.of<ParticipantProvider>(context, listen: false)
                .setParticipantStatus(value);

            // navigate to home page
            context.goNamed(dashboardRouteName, extra: "participant");
          }).onError((error, stackTrace) {
            DialogManager.showAlertDialog(context, error.toString());

            setState(() {
              isLoading = false;
            });
          });
        }
      } else {
        // save the user data to shared preferences
        AuthUserModel currentUser = AuthUserModel(
          id: p.id!,
          fullName: p.fullName!,
          email: value['email']!,
        );

        Provider.of<AuthProvider>(context, listen: false)
            .setAuthUser(currentUser);

        Provider.of<ParticipantProvider>(context, listen: false)
            .setParticipant(p);

        await ParticipantStatusService().getByParticipantId(p.id).then((value) {
          setState(() {
            isLoading = false;
          });

          Provider.of<ParticipantProvider>(context, listen: false)
              .setParticipantStatus(value);

          // navigate to home page
          context.pushNamed(dashboardRouteName, extra: "participant");
        }).onError((error, stackTrace) {
          DialogManager.showAlertDialog(context, error.toString());

          setState(() {
            isLoading = false;
          });
        });
      }
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });

      DialogManager.showAlertDialog(context,
          "This email is not registered for this program. Please sign up first.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: programPhoto == null ? const LoadingPage() : setChildren());
  }
}
