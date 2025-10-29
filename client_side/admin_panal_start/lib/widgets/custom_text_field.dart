// lib/widgets/custom_text_field.dart - Updated
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utility/constants.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? lineNumber;
  final void Function(String?) onSave;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.onSave,
    this.inputType = TextInputType.text,
    this.lineNumber = 1,
    this.validator,
    required this.controller,
    this.enabled = true,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        maxLines: lineNumber,
        enabled: enabled,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red.shade400),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          filled: true,
          fillColor: enabled ? Colors.transparent : Colors.grey.shade800,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: ResponsiveUtils.isMobile(context) ? 12 : 16,
          ),
          suffixIcon: suffixIcon,
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
        style: TextStyle(
          fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
          color: enabled ? Colors.white : Colors.grey.shade400,
        ),
      ),
    );
  }
}
