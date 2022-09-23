import 'package:flutter/material.dart';
import 'package:restaurant_management_system/Waiter/Utility/my_button.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({Key? key}) : super(key: key);

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
          TextField( //leftoff 23
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "add new request"
            ),
          ),
          // save and cancel button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            //save
            MyButton(text: "Save", onPressed: (){}),
            const SizedBox(width: 10),
            //cancle button
            MyButton(text: "Cencel", onPressed: (){})
          ],)
        ],),
      ),
    );
  }
}
