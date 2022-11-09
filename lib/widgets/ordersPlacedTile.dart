import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersPlacedTile extends StatelessWidget {
  late final String taskName;
  var time;

  //final bool taskCompleted;
  // Function(bool?)? onChanged;
  //Function(BuildContext)? deleteFunction;

  var newTime = "";
  final String oStatus;

  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = Colors.white;
  Color iPColor = Colors.white;
  Color dColor = Colors.white;

  Color pTextColor = Colors.black;
  Color ipTextColor = Colors.black;
  Color dTextColor = Colors.black;


  OrdersPlacedTile({
    super.key,
    required this.taskName,
    //  required this.taskCompleted,
    //required this.onChanged,
    // required this.deleteFunction,
    required this.time,
    required this.oStatus,
  });

  @override
  Widget build(BuildContext context) {
    var isVisible = true;


    if (oStatus == "in progress"){
      iPColor= Colors.black;
      ipTextColor = Colors.white;
      pColor = Colors.white;
      pTextColor = Colors.black;

    }
    else if (oStatus =="placed"){
      pColor = Colors.black;
      pTextColor = Colors.white;
      ipTextColor = Colors.black;
      iPColor = Colors.white;

    } else {
      dColor = Colors.black;
      dTextColor = Colors.white;
    }


    return FutureBuilder(
      future: convertTime(time),
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
                Text(taskName + '\n' + 'Time Placed $newTime',
                    style: const TextStyle(color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: isVisible,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(5),
                            fixedSize: Size(100, 3),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            backgroundColor: pColor,
                            foregroundColor: pTextColor,
                            side: const BorderSide(
                              color: Colors.black38,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),

                          onPressed: () => "hello",
                          child: Text('Placed')),
                    ),

                    Visibility(
                      visible: isVisible,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(5),
                            fixedSize: Size(100, 30),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            backgroundColor: iPColor,
                            foregroundColor: Colors.black54,
                            side: const BorderSide(
                              color: Colors.black38,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),

                          onPressed: () => "Hello",
                          child: Text('In Progress')),
                    ),

                    Visibility(
                      visible: isVisible,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(5),
                            fixedSize: Size(100, 3),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            backgroundColor: dColor,
                            foregroundColor: Colors.black54,
                            side: const BorderSide(
                              color: Colors.black38,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),

                          onPressed: () => "hello",
                          child: Text('Delivered')),
                    ),

                  ],
                ),

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
