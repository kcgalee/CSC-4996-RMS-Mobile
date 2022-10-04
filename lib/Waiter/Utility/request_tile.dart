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
        decoration: BoxDecoration(color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black38)
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
            style: TextStyle(color: Colors.black54,fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
