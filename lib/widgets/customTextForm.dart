import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  const CustomTextForm({Key? key, required this.hintText, required this.controller,required this.icon, required this.keyboardType, required this.maxLines,required this.maxLength, required AutovalidateMode autovalidateMode, required String? Function(dynamic number) validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: icon,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2),
              ),
              border: OutlineInputBorder()
          ),
        ),
      );

  }
}