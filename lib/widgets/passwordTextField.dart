import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final validator;
  const PasswordTextField({Key? key,required this.hintText, required this.controller, required this.validator, required this.keyboardType, required this.maxLines,required this.maxLength,required this.icon,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          obscureText: true,
          decoration: InputDecoration(
              counter: Offstage(),
              hintText: hintText,
              prefixIcon: icon,
          ),
        ),
      );

  }
}