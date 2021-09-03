import 'package:firebase_learning_project/components/text_field_container.dart';
import 'package:firebase_learning_project/constants.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const RoundedInputField({Key? key, this.hintText, this.icon, this.validator, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }
}
