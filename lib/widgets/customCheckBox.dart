import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  bool value;
  String title;
  final ValueChanged onChanged;

  CustomCheckBox({Key? key,required this.title, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: CheckboxListTile(
        title: Text(title),
        controlAffinity: ListTileControlAffinity.leading,
        value: value,
        onChanged: onChanged,
        activeColor: Colors.black,
        checkColor: Colors.white,
      ),
    );

  }
}