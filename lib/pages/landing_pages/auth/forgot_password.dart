import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:universal_html/html.dart';
import 'package:ybb_event_app/components/colors.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/services/auth_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods().buildCommonAppBar(context, "Reset Password"),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Forgot Password? No worries! Enter your email below and we'll send you a link to reset your password.",
                  style: headlineSecondaryTextStyle.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  key: _emailFieldKey,
                  name: 'email',
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                // create a button with primary color that says "Login", width is 100% of the container
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                            color: primary, size: 40),
                      )
                    : Center(
                        child: MaterialButton(
                          minWidth: ScreenSizeHelper.responsiveValue(context,
                              mobile: double.infinity,
                              desktop: MediaQuery.sizeOf(context).width * 0.5),
                          height: 60,
                          color: primary,
                          // give radius to the button
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () async {
                            if (_formKey.currentState!.saveAndValidate()) {
                              setState(() {
                                isLoading = true;
                              });

                              await AuthService()
                                  .checkEmail(emailController.text)
                                  .then(
                                (value) async {
                                  // send email to reset password
                                  // call the resetPassword function from the AuthService
                                  // if the email is sent successfully, show a snackbar with a message
                                  // if the email is not sent successfully, show a snackbar with an error message
                                  // if the email is not sent successfully, set isLoading to false
                                  await AuthService()
                                      .resetPassword(value.id!)
                                      .then((value) {
                                    DialogManager.showAlertDialog(
                                        context, value, isGreen: true,
                                        pressed: () {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  }).catchError((e) {
                                    DialogManager.showAlertDialog(
                                        context, e.toString(), isGreen: false,
                                        pressed: () {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      Navigator.pop(context);
                                    });
                                  });
                                },
                              ).onError((error, stackTrace) {
                                DialogManager.showAlertDialog(
                                    context, error.toString(), isGreen: false,
                                    pressed: () {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Navigator.pop(context);
                                });
                              });
                            }
                          },
                          child: const AutoSizeText(
                              'Send Email to Reset Password',
                              style: buttonTextStyle),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
