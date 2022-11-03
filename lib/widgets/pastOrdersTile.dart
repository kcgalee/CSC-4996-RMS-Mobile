import 'package:cloud_firestore/cloud_firestore.dart';
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
  //final String restName;

  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = Color(0xffffebee);
  Color iPColor = Color(0xfff9fbe7);
  Color dColor = Color(0xffe8f5e9);

  var restID;
  var restName;



  PastOrdersTile({
    super.key,
    required this.taskName,
    required this.time,
    required this.oStatus,
    required this.restID,
    //required this.restName
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: convertTime(time),
      builder: (context, snapshot) {
        return FutureBuilder(
            future: getRestName(),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
                child: Container(
                  padding: const EdgeInsets.only(
                      right: 15, left: 10, bottom: 10, top: 10),
                  decoration: BoxDecoration(color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black54)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //task name and time
                      Text("$restName \n $taskName \n $newTime",
                          style: const TextStyle(color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),


                    ],
                  ),
                ),
              );
            }
              );
      },
    );
  }

  convertTime(time) {
    DateFormat formatter = DateFormat.yMd();
    //var ndate = new DateTime.fromMillisecondsSinceEpoch(time.toDate() * 1000);
    newTime = formatter.format(time.toDate());
  }

  getRestName() async {
    await FirebaseFirestore.instance.collection('restaurants').doc(restID).get().then(
            (element) {
          restName = element['restName'];
        });
  }


}





//converts firebase time into human readable time
