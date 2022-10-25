import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastOrdersTile extends StatelessWidget {
  late final String taskName;
  var time;
  //final bool taskCompleted;
  // Function(bool?)? onChanged;
  //Function(BuildContext)? deleteFunction;

  var newTime = "";
  final String oStatus;

  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = Color(0xffffebee);
  Color iPColor = Color(0xfff9fbe7);
  Color dColor = Color(0xffe8f5e9);



  PastOrdersTile({
    super.key,
    required this.taskName,
    required this.time,
    required this.oStatus,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: convertTime(time),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,top: 25),
          child: Container(
            padding: const EdgeInsets.only(right: 15,left: 10,bottom: 10,top: 10),
            decoration: BoxDecoration(color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //task name and time
                Text(taskName + '\n' + newTime,
                    style: const TextStyle(color: Colors.black54,fontSize: 15, fontWeight: FontWeight.bold)),


              ],
            ),
          ),
        );
      },
    );
  }

  convertTime(time) {
    DateFormat formatter = DateFormat('h:mm:ss a');
    //var ndate = new DateTime.fromMillisecondsSinceEpoch(time.toDate() * 1000);
    newTime = formatter.format(time.toDate());
  }



}





//converts firebase time into human readable time
