import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastVisitsTile extends StatelessWidget {
  late final String taskName;
  var time;

  var newTime = "";
  final String oStatus;

  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = const Color(0xffffebee);
  Color iPColor = const Color(0xfff9fbe7);
  Color dColor = const Color(0xffe8f5e9);

  var restID;
  var restName;
  final VoidCallback? onPressed;

  PastVisitsTile({
    super.key,
    required this.taskName,
    required this.time,
    required this.oStatus,
    required this.restID,
    this.onPressed,
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(330, 100),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black38, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: onPressed,
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0)),
                            ),
                            child: Image.asset('assets/images/pizza.jpg'),
                          ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("$restName",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              Text("\n$newTime",
                                  style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                      ),
                        ],
                      ),
                    )
                  ]),
                ),
              );
            });
      },
    );
  }

  convertTime(time) {
    DateFormat formatter = DateFormat.yMd();
    newTime = formatter.format(time.toDate());
  }

  getRestName() async {
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restID)
        .get()
        .then((element) {
      restName = element['restName'];
    });
  }
}

//converts firebase time into human readable time
