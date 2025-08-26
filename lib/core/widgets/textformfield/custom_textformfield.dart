import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.isObsecure,
    required this.hintText,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.backGorundColor = Colors.white,
    this.borderColor = Colors.white,
    required this.textInputType,
    this.readOnly = false,
  });
  final TextEditingController controller;
  final bool? isObsecure;
  final String hintText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color backGorundColor;
  final Color borderColor;
  final TextInputType textInputType;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      keyboardType: textInputType,
      controller: controller,
      obscureText: isObsecure == null ? false : isObsecure!,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        fillColor: backGorundColor,
        filled: true,
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
