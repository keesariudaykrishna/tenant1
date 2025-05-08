import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors.dart';

class MyDropdown extends StatelessWidget {
  final String? selectedItem;
  final String hintText;
  final String validaterText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<String> items;
  final FocusNode? focusNode;
  final Function(String?) onChanged;
  final Function(String?)? onSaved;

  const MyDropdown({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    required this.validaterText,
    this.focusNode,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    // If selectedItem is null, we set it to the first item in the list (if available).
    String? initialValue = selectedItem;

    // Ensure the initial value is valid and exists in the list
    if (initialValue == null || !items.contains(initialValue)) {
      initialValue = items.isNotEmpty ? items[0] : null;
    }

    return DropdownButtonFormField<String>(
      value: initialValue,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onSaved: onSaved,
      onChanged: onChanged,
      focusNode: focusNode,
      style: TextStyle(
          fontSize: 20.spMin, fontWeight: FontWeight.bold, color: kDark),
      decoration: InputDecoration(
        hintStyle: TextStyle(
            fontSize: 20.spMin, fontWeight: FontWeight.bold, color: kGray),
        labelText: null,
        hintText: hintText,
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
            color: Colors.black,
            width: 0.6,
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
      validator: (value) => value == null ? validaterText : null,
    );
  }
}
