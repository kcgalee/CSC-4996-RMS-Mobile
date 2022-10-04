import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_slidable/flutter_slidable.dart';


class RequestTile extends StatelessWidget {

 final String taskName;
 var time;
  //final bool taskCompleted;
 // Function(bool?)? onChanged;
  //Function(BuildContext)? deleteFunction;
  var newTime = "";

  RequestTile({
    super.key,
    required this.taskName,
  //  required this.taskCompleted,
    //required this.onChanged,
   // required this.deleteFunction,
    required this.time,

  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: convertTime(time),
      builder: (context, snapshot) {
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

                  //task name and time
                  Text(taskName + '\n' + newTime,
                  style: TextStyle(color: Colors.white,fontSize: 15)),
                ],
              ),
            ),
          );
      },
    );
  }

  //converts firebase time into human readable time
  convertTime(time) {
    DateFormat formatter = DateFormat('MMM d, yyyy \nh:mm:s a');
    //var ndate = new DateTime.fromMillisecondsSinceEpoch(time.toDate() * 1000);
    newTime = formatter.format(time.toDate());
  }
}
