// lib/widget/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utility/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final double? height;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? lineNumber;
  final void Function(String?) onSave;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextAlign textAlign;
  final TextDirection? textDirection;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.onSave,
    this.inputType = TextInputType.text,
    this.lineNumber = 1,
    this.validator,
    required this.controller,
    this.height,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.textDirection = TextDirection.ltr, // Force LTR typing
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Directionality(
          textDirection: TextDirection.ltr, // Force LTR for all text fields
          child: TextFormField(
            controller: controller,
            maxLines: lineNumber,
            obscureText: obscureText,
            textAlign: TextAlign.left, // Force left alignment
            textDirection: TextDirection.ltr, // Force LTR typing
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColor.darkOrange),
              ),
            ),
            keyboardType: inputType,
            onSaved: (value) {
              onSave(value?.isEmpty ?? true ? null : value);
            },
            validator: validator,
            inputFormatters: [
              LengthLimitingTextInputFormatter(700),
              if (inputType == TextInputType.number)
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
            ],
          ),
        ),
      ),
    );
  }
}