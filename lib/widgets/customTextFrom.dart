import 'package:flutter/material.dart';

class CustomTextFrom extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;


  const CustomTextFrom({Key? key, required this.hintText, required this.controller,required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: icon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2),
              ),
              border: OutlineInputBorder()
          ),
        ),
      );

  }
}