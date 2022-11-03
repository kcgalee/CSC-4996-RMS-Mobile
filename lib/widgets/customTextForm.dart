import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final validator;
  const CustomTextForm({Key? key,required this.hintText, required this.controller, required this.validator, required this.keyboardType, required this.maxLines,required this.maxLength,required this.icon,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Expanded(
        child:
          Align(
            alignment: Alignment.bottomCenter,
            child:
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validator,
                  decoration: InputDecoration(
                      counter: Offstage(),
                      hintText: hintText,
                      prefixIcon: icon,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                      border: OutlineInputBorder()
                  ),
                ),
              ),
          ),
      );

  }
}