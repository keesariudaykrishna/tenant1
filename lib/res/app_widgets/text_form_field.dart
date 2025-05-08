import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';

class MyField extends StatelessWidget {
  final String hintText;
  final String? validatorText;
  final bool obscureText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChange;
  final String? Function(String?)?
      onValidator; // Updated type to match FormFieldValidator<String>

  const MyField({
    super.key,
    required this.hintText,
    required this.controller,
    this.textInputType = TextInputType.name,
    this.prefixIcon,
    this.suffixIcon,
    this.validatorText = 'Enter a valid Text',
    this.onFieldSubmitted,
    this.focusNode,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChange,
    this.onValidator, // Custom validator function, if provided
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: textInputType,
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      cursorColor: kSecondary,
      style: TextStyle(
        fontSize: 20.spMin,
        fontWeight: FontWeight.bold,
        color: kDark,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        labelText: null,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16.spMin,
          fontWeight: FontWeight.bold,
          color: kGray,
        ),
        filled: true,
        fillColor: kPrimary,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 0.6,
          ),
        ),
      ),
      // Use the onValidator function to handle validation
      validator: onValidator ??
          (value) {
            // Default validation if no custom validator is provided
            if (value == null || value.isEmpty) {
              return validatorText ?? 'Enter a valid text'; // Default message
            }
            return null; // Return null if valid
          },
      onChanged: onChange,
      onFieldSubmitted: onFieldSubmitted, // Use the onFieldSubmitted function
    );
  }
}
