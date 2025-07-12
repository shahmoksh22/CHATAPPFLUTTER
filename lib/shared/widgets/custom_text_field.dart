import 'package:flutter/material.dart';

/// A customizable text input field widget.
///
/// This widget provides a consistent look and feel for text input fields
/// across the application with options for hint text, obscurity, keyboard type,
/// and a suffix icon.
class CustomTextField extends StatelessWidget {
  /// The controller for the text field, used to manage the text.
  final TextEditingController controller;

  /// The hint text to display when the text field is empty.
  final String hintText;

  /// Whether the text should be obscured (e.g., for passwords).
  final bool obscureText;

  /// The type of keyboard to use for text input.
  final TextInputType keyboardType;

  /// An optional widget to display at the end of the text field.
  final Widget? suffixIcon;

  /// Constructs a [CustomTextField] with the given parameters.
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }
}
