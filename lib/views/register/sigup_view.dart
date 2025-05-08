// // ignore_for_file: unused_element

// import 'package:apartment_rentals/res/app_widgets/button.dart';
// import 'package:apartment_rentals/res/app_widgets/drop_down.dart';
// import 'package:apartment_rentals/res/app_widgets/text.dart';
// import 'package:apartment_rentals/res/colors.dart';
// import 'package:apartment_rentals/res/routes/routes_name.dart';
// import 'package:apartment_rentals/res/app_widgets/text_form_field.dart';
// import 'package:apartment_rentals/utils/utils.dart';
// import 'package:apartment_rentals/views/splash/splash_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../view_models/controllers/auth/auth_view_model.dart';
// import '../../view_models/controllers/obsoure_text/visiabilty_view_model.dart';

// class SigUpScreen extends StatefulWidget {
//   const SigUpScreen({super.key});

//   @override
//   State<SigUpScreen> createState() => _SigUpScreenState();
// }

// class _SigUpScreenState extends State<SigUpScreen> {
//   // ! Controller for managing password visibility
//   final VisiablilityController _controller = Get.put(VisiablilityController());

//   final Utils utils = Utils(); // ! Utility class for common functions
//   final AuthService _auth =
//       Get.put(AuthService()); // ! Authentication service for sign up
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   final FocusNode nameNode = FocusNode();
//   final FocusNode emailNode = FocusNode();
//   final FocusNode passwordNode = FocusNode();
//   final FocusNode buttonNode = FocusNode();
//   final FocusNode phoneNode = FocusNode();
//   final FocusNode roleNode = FocusNode();

//   final _formkey = GlobalKey<FormState>(); // ! Form key for form validation

//   String? selectedRole = ''; // ! Role selection
//   final List<String> roles = [
//     'Renter',
//     'Landlord'
//   ]; // ! List of available roles

//   @override
//   void dispose() {
//     // Dispose controllers and focus nodes to avoid memory leaks
//     emailController.dispose();
//     nameController.dispose();
//     nameNode.dispose();
//     passwordController.dispose();
//     emailNode.dispose();
//     passwordNode.dispose();
//     buttonNode.dispose();
//     phoneController.dispose();
//     phoneNode.dispose();
//     roleNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimary, // ! Set background color for the screen
//       body: Padding(
//         padding: EdgeInsets.all(12.h), // Padding for the whole body
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment:
//                 MainAxisAlignment.center, // Center the content vertically
//             crossAxisAlignment:
//                 CrossAxisAlignment.center, // Center the content horizontally
//             spacing: 20,
//             children: [
//               SizedBox(
//                 height: 10.h,
//               ),
//               AppLogo(),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Form(
//                 // ! The form key for validating the form
//                 key: _formkey,
//                 child: Column(
//                   mainAxisAlignment:
//                       MainAxisAlignment.center, // Center form elements
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start, // Align form fields to the left
//                   spacing: 12,
//                   children: [
//                     // ! full name
//                     AppText.heading('Full Name'), // Label for name field
//                     MyField(
//                       hintText: 'Enter your name', // Hint for name input field
//                       controller:
//                           nameController, // Controller for the name field
//                       focusNode: nameNode, // Focus node for the name field
//                       onFieldSubmitted: (p0) {
//                         utils.fieldFocusChange(context, nameNode,
//                             emailNode); // ! Move focus to the email field on submit
//                       },
//                       validatorText:
//                           'Enter your name', // Validation text for the name field
//                     ),
//                     // ! email address
//                     AppText.heading('Email address'), // Label for email field
//                     MyField(
//                       hintText:
//                           'Enter your email address', // Hint for email input field
//                       controller:
//                           emailController, // Controller for the email field
//                       focusNode: emailNode, // Focus node for the email field
//                       onFieldSubmitted: (p0) {
//                         utils.fieldFocusChange(context, emailNode,
//                             passwordNode); // ! Move focus to the password field on submit
//                       },
//                       validatorText:
//                           'Enter your email address', // Validation text for the email field
//                     ),
//                     // ! phone number
//                     AppText.heading('Phone Number'), // Label for password field
//                     MyField(
//                       textInputType: TextInputType.phone,
//                       hintText:
//                           'Enter your phone number', // Hint for email input field
//                       controller:
//                           phoneController, // Controller for the email field
//                       focusNode: phoneNode, // Focus node for the email field
//                       onFieldSubmitted: (p0) {
//                         utils.fieldFocusChange(context, phoneNode,
//                             passwordNode); // ! Move focus to the password field on submit
//                       },
//                       validatorText:
//                           'Enter your email address', // Validation text for the email field
//                     ),
//                     AppText.heading('Password'), // Label for password field
//                     Obx(() {
//                       // ! Obx widget to reactively rebuild when visibility changes
//                       return MyField(
//                         hintText: 'Enter your password',
//                         controller:
//                             passwordController, // Controller for the password field
//                         focusNode:
//                             passwordNode, // Focus node for the password field
//                         obscureText: !_controller
//                             .visiablility, // Toggle password visibility
//                         onFieldSubmitted: (p0) {
//                           utils.fieldFocusChange(context, passwordNode,
//                               roleNode); // ! Move focus to the button on submit
//                         },
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             _controller.setVisiablility(!_controller
//                                 .visiablility); // ! Toggle password visibility
//                           },
//                           icon: Icon(_controller.visiablility
//                               ? Icons.visibility // Show password icon
//                               : Icons.visibility_off), // Hide password icon
//                         ),
//                         validatorText:
//                             'Enter your password', // Validation text for the password field
//                       );
//                     }),
//                     // SizedBox(height: 20.h), // Unused spacing, commented out
//                     AppText.heading(
//                         'Select User Type'), // Label for gender field
//                     MyDropdown(
//                         onSaved: (p0) {
//                           utils.fieldFocusChange(context, roleNode,
//                               buttonNode); // ! Move focus to the password field on submit
//                         },
//                         focusNode: roleNode,
//                         selectedItem: selectedRole, // Selected gender role
//                         items: roles, // Gender options
//                         onChanged: (String? value) {
//                           setState(() {
//                             selectedRole = value; // Set selected role on change
//                           });
//                         },
//                         hintText: 'Select Any option', // Hint for the dropdown
//                         validaterText:
//                             'Please select any option'), // Validation text for the dropdown

//                     SizedBox(
//                         height: 20.h), // Add space before the submit button
//                     // ! Button for the sign up
//                     Obx(
//                       () => MyButton(
//                         isLoading: _auth.isLoading,
//                         onTap: () {
//                           // ! Check if form is valid before calling sign up method
//                           if (_formkey.currentState!.validate() &&
//                                   selectedRole != null ||
//                               selectedRole != '') {
//                             _auth.signUp(
//                                 nameController.text.trim(),
//                                 emailController.text.trim(),
//                                 passwordController.text.trim(),
//                                 selectedRole.toString(),
//                                 passwordController.text
//                                     .trim()); // ! Call sign up function
//                           }
//                         },
//                         text: 'Sign Up', // Button text
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment.center, // Center the row contents
//                       children: [
//                         Text(
//                           "Already have an account? ",
//                           style: TextStyle(
//                               fontSize: 18.spMin,
//                               fontWeight: FontWeight.w600,
//                               color: kDark),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Get.toNamed(RouteName
//                                 .loginScreen); // ! Navigate to the login screen
//                           },
//                           child: Text(
//                             "Sign In", // Text for "Sign In" link
//                             style: TextStyle(
//                                 fontSize: 18.spMin,
//                                 fontWeight: FontWeight.bold,
//                                 color: kSecondaryLight),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:apartment_rentals/res/app_widgets/button.dart';
import 'package:apartment_rentals/res/app_widgets/drop_down.dart';
import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/res/routes/routes_name.dart';
import 'package:apartment_rentals/res/app_widgets/text_form_field.dart';
import 'package:apartment_rentals/utils/utils.dart';
import 'package:apartment_rentals/views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// Import for TextInputFormatter

import '../../view_models/controllers/auth/auth_view_model.dart';
import '../../view_models/controllers/obsoure_text/visiabilty_view_model.dart';

class SigUpScreen extends StatefulWidget {
  const SigUpScreen({super.key});

  @override
  State<SigUpScreen> createState() => _SigUpScreenState();
}

class _SigUpScreenState extends State<SigUpScreen> {
  // ! Controller for managing password visibility
  final VisiablilityController _controller = Get.put(VisiablilityController());

  final Utils utils = Utils(); // ! Utility class for common functions
  final AuthService _auth =
      Get.put(AuthService()); // ! Authentication service for sign up
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode buttonNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode roleNode = FocusNode();

  final _formkey = GlobalKey<FormState>(); // ! Form key for form validation

  String? selectedRole = ''; // ! Role selection
  final List<String> roles = [
    'Renter',
    'Landlord'
  ]; // ! List of available roles

  @override
  void dispose() {
    // Dispose controllers and focus nodes to avoid memory leaks
    emailController.dispose();
    nameController.dispose();
    nameNode.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    buttonNode.dispose();
    phoneController.dispose();
    phoneNode.dispose();
    roleNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary, // ! Set background color for the screen
      body: Padding(
        padding: EdgeInsets.all(12.h), // Padding for the whole body
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the content horizontally
            spacing: 20,
            children: [
              SizedBox(
                height: 10.h,
              ),
              AppLogo(),
              SizedBox(
                height: 5.h,
              ),
              Form(
                // ! The form key for validating the form
                key: _formkey,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center form elements
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align form fields to the left
                  spacing: 12,
                  children: [
                    // ! full name
                    AppText.heading('Full Name'), // Label for name field
                    MyField(
                      hintText: 'Enter your name', // Hint for name input field
                      controller:
                          nameController, // Controller for the name field
                      focusNode: nameNode, // Focus node for the name field
                      onFieldSubmitted: (p0) {
                        utils.fieldFocusChange(context, nameNode,
                            emailNode); // ! Move focus to the email field on submit
                      },
                      validatorText:
                          'Enter your name', // Validation text for the name field
                    ),
                    // ! email address
                    AppText.heading('Email address'), // Label for email field
                    MyField(
                      hintText:
                          'Enter your email address', // Hint for email input field
                      controller:
                          emailController, // Controller for the email field
                      focusNode: emailNode, // Focus node for the email field
                      onFieldSubmitted: (p0) {
                        utils.fieldFocusChange(context, emailNode,
                            passwordNode); // ! Move focus to the password field on submit
                      },
                      validatorText:
                          'Enter your email address', // Validation text for the email field
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
                    ),
                    // ! phone number
                    AppText.heading('Phone Number'), // Label for password field
                    MyField(
                      textInputType: TextInputType.phone,
                      hintText:
                          'Enter your phone number', // Hint for phone number input field
                      controller:
                          phoneController, // Controller for the phone field
                      focusNode: phoneNode, // Focus node for the phone field
                      onFieldSubmitted: (p0) {
                        utils.fieldFocusChange(context, phoneNode,
                            passwordNode); // ! Move focus to the password field on submit
                      },
                      validatorText:
                          'Enter your phone number', // Validation text for the phone field
                      onValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.length != 12) {
                          return 'Phone number must be 12 digits';
                        }
                        return null;
                      },
                    ),
                    AppText.heading('Password'), // Label for password field
                    Obx(() {
                      // ! Obx widget to reactively rebuild when visibility changes
                      return MyField(
                        hintText: 'Enter your password',
                        controller:
                            passwordController, // Controller for the password field
                        focusNode:
                            passwordNode, // Focus node for the password field
                        obscureText: !_controller
                            .visiablility, // Toggle password visibility
                        onFieldSubmitted: (p0) {
                          utils.fieldFocusChange(context, passwordNode,
                              roleNode); // ! Move focus to the button on submit
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            _controller.setVisiablility(!_controller
                                .visiablility); // ! Toggle password visibility
                          },
                          icon: Icon(_controller.visiablility
                              ? Icons.visibility // Show password icon
                              : Icons.visibility_off), // Hide password icon
                        ),
                        validatorText:
                            'Enter your password', // Validation text for the password field
                        onValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          // Password validation: at least one uppercase, one lowercase, one number, and at least 8 characters
                          if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$')
                              .hasMatch(value)) {
                            return 'Password must be at least 8 characters, with at least one uppercase letter, one lowercase letter, and one digit';
                          }
                          return null;
                        },
                      );
                    }),
                    // SizedBox(height: 20.h), // Unused spacing, commented out
                    AppText.heading(
                        'Select User Type'), // Label for gender field
                    MyDropdown(
                        onSaved: (p0) {
                          utils.fieldFocusChange(context, roleNode,
                              buttonNode); // ! Move focus to the button on submit
                        },
                        focusNode: roleNode,
                        selectedItem: selectedRole, // Selected gender role
                        items: roles, // Gender options
                        onChanged: (String? value) {
                          setState(() {
                            selectedRole = value; // Set selected role on change
                          });
                        },
                        hintText: 'Select Any option', // Hint for the dropdown
                        validaterText:
                            'Please select any option'), // Validation text for the dropdown

                    SizedBox(
                        height: 20.h), // Add space before the submit button
                    // ! Button for the sign up
                    Obx(
                      () => MyButton(
                        isLoading: _auth.isLoading,
                        onTap: () {
                          // ! Check if form is valid before calling sign up method
                          if (_formkey.currentState!.validate() &&
                                  selectedRole != null ||
                              selectedRole != '') {
                            _auth.signUp(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                selectedRole.toString(),
                                passwordController.text
                                    .trim()); // ! Call sign up function
                          }
                        },
                        text: 'Sign Up', // Button text
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the row contents
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                              fontSize: 18.spMin,
                              fontWeight: FontWeight.w600,
                              color: kDark),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RouteName
                                .loginScreen); // ! Navigate to the login screen
                          },
                          child: Text(
                            "Sign In", // Text for "Sign In" link
                            style: TextStyle(
                                fontSize: 18.spMin,
                                fontWeight: FontWeight.bold,
                                color: kSecondaryLight),
                          ),
                        ),
                      ],
                    ),
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
