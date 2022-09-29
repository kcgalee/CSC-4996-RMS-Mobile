import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class RequestTile extends StatelessWidget {

 final String taskName;
  //final bool taskCompleted;
 // Function(bool?)? onChanged;
  //Function(BuildContext)? deleteFunction;


  RequestTile({
    super.key,
    required this.taskName,
  //  required this.taskCompleted,
    //required this.onChanged,
   // required this.deleteFunction,


  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25,top: 25),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [

            //checkbox
            /*Checkbox(
              value: taskCompleted,
              onChanged: onChanged,
              activeColor: Colors.black,
            ),*/

            //task name
            Text(taskName,
            style: TextStyle(color: Colors.white,fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
