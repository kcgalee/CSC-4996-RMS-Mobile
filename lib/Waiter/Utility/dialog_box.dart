import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancle;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancle
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue[300],
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // user input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                  ),
                  hintText: "Add new request"
              ),
            ),
            // save and cancel button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //save
                MyButton(text: "Save", onPressed: onSave),
                const SizedBox(width: 10),
                //cancle button
                MyButton(text: "Cencel", onPressed: onCancle)
              ],)
          ],),
      ),
    );
  }
}