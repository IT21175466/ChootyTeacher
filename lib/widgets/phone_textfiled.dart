import 'package:flutter/material.dart';
import 'package:koreanlms/constants/app_colors.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final String hintText;
  final GestureDetector prefix;

  const PhoneTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefix,
    this.isPassword = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      height: 50,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText, //"71XXXXXXX"
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.grayColor,
              width: 0.5,
            ),
          ),
          prefixIcon: prefix,
          labelText: labelText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        ),
      ),
    );
  }
}
