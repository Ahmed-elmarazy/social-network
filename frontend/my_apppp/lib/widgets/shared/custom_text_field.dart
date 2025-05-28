import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.controller,
    this.validator,
    this.textColor = const Color(0xff676767),
    this.hintColor = const Color(0xff676767),
    this.fillColor = const Color(0xFFE0E0E0),
    this.borderColor = const Color(0xFFA8A8A9),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: hintColor ?? Colors.grey[400]),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: fillColor != null,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: borderColor ?? const Color(0xFFA8A8A9),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey[300]!,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
