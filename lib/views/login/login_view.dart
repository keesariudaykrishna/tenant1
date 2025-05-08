import 'package:apartment_rentals/res/app_widgets/button.dart';
import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/res/routes/routes_name.dart';
import 'package:apartment_rentals/res/app_widgets/text_form_field.dart';
import 'package:apartment_rentals/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../view_models/controllers/auth/auth_view_model.dart';
import '../../view_models/controllers/obsoure_text/visiabilty_view_model.dart';
import '../splash/splash_view.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});

  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  final VisiablilityController _controller =
      Get.put(VisiablilityController()); //! Controller for password visibility

  final AuthService _auth = Get.put(AuthService()); //! AuthService for login

  final Utils utils = Utils(); //! Utility class for field focus management
  final TextEditingController emailController =
      TextEditingController(); //! Controller for email input
  final TextEditingController passwordController =
      TextEditingController(); //! Controller for password input

  final FocusNode emailNode = FocusNode(); //! Focus node for email input
  final FocusNode passwordNode = FocusNode(); //! Focus node for password input
  final FocusNode buttonNode = FocusNode(); //! Focus node for the button

  final _formkey = GlobalKey<FormState>(); //! Form key for validation

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    buttonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary, //! Background color of the screen
      body: Padding(
        padding: EdgeInsets.all(12.h), //! Padding around the screen
        child: SingleChildScrollView(
          child: Column(
            spacing: 20, //! Spacing between widgets
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h, //! Space at the top
              ),
              AppLogo(), //! App logo widget
              SizedBox(
                height: 30.h, //! Space between logo and form
              ),
              Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5.h,
                  children: [
                    AppText.heading(
                        'Email address'), //! Label for the email field
                    MyField(
                        textInputType: TextInputType.emailAddress,
                        hintText:
                            'Enter your email address', //! Email input field
                        controller: emailController,
                        focusNode: emailNode,
                        onFieldSubmitted: (p0) {
                          utils.fieldFocusChange(context, emailNode,
                              passwordNode); //! Change focus to password field
                        },
                        onValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          // Regular expression to validate the email format
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        validatorText:
                            'Enter your email address'), //! Email validation
                    AppText.heading(
                        'Password'), //! Label for the password field
                    Obx(() {
                      //! Obx to reactively update the UI when visibility changes
                      return MyField(
                        hintText:
                            'Enter your password', //! Password input field
                        controller: passwordController,
                        focusNode: passwordNode,
                        obscureText: !_controller
                            .visiablility, //! Toggle password visibility
                        onFieldSubmitted: (p0) {
                          utils.fieldFocusChange(context, passwordNode,
                              buttonNode); //! Change focus to login button
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            _controller.setVisiablility(!_controller
                                .visiablility); //! Toggle visibility
                          },
                          icon: Icon(_controller.visiablility
                              ? Icons.visibility
                              : Icons
                                  .visibility_off), //! Icon for password visibility
                        ),
                        validatorText:
                            'Enter your password', //! Password validation
                      );
                    }),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (emailController.text.isEmpty) {
                              Utils().errorSnackBar('Please enter your email address.');
                            } else {
                              _auth.forgotPassword(emailController.text);
                            }
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.spMin,
                                color: Colors.deepOrange),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    //! Login button
                    Obx(
                      () => MyButton(
                          isLoading: _auth
                              .isLoading, //! Show loading indicator when logging in
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              _auth.login(
                                  emailController.text,
                                  passwordController
                                      .text); //! Call login method
                            }
                          },
                          text: 'LOGIN'),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            "Do't have account? ", //! Text asking if the user doesn't have an account
                            style: TextStyle(
                              fontSize: 18.spMin,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Get.toNamed(RouteName
                                    .sigUpScreen); //! Navigate to sign up screen
                              },
                              child: Text(
                                "Create new account",
                                style: TextStyle(
                                    fontSize: 18.spMin,
                                    fontWeight: FontWeight.bold,
                                    color: kSecondaryLight),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
