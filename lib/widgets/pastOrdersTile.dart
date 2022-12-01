import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastOrdersTile extends StatelessWidget {
  late final String taskName;



  //pColor for placed  iPColor for in progress button, dColor for delivered button
  Color pColor = const Color(0xffffebee);
  Color iPColor = const Color(0xfff9fbe7);
  Color dColor = const Color(0xffe8f5e9);

  var restID;
  var restName;
  var comment;
  var price;
  var quantity;
  var imgURL;
  var custName;


  PastOrdersTile({
    super.key,
    required this.taskName,
    required this.comment,
    required this.price,
    required this.quantity,
    required this.imgURL,
    required this.custName
  });

  @override
  Widget build(BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    bottomLeft: Radius.circular(12.0)),
                              ),
                              child: Image.asset('assets/images/pizza.jpg'),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$taskName",
                                    style: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 20,)
                                ),
                                Text("\n\$$price",
                                    style: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 15,)
                                ),
                                Text("\n$quantity",
                                    style: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 15,)
                                ),
                                Text("\nOrdered By: $custName",
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)
                                ),

                              ],
                            ),
                          ],
                        ),
                      ]),
                ),
              );

  }
}



//converts firebase time into human readable time