import 'package:flutter/material.dart';

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
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20), // Image border
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(25), // Image radius
                                  child:   FadeInImage(
                                      placeholder: const AssetImage('assets/images/RMS_logo.png'),
                                      image: imgURL != '' ?
                                      NetworkImage(imgURL) : const AssetImage('assets/images/RMS_logo.png') as ImageProvider,
                                      fit: BoxFit.cover
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: MediaQuery.of(context).size.height * 0.3,
                                        child: Expanded(
                                            child: Text("$taskName long test name",
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 18,)
                                            ),
                                        )
                                    ),
                                    Row(
                                      children: [
                                        Text("x $quantity",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15,)
                                        ),
                                        Text("\$$price",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15,)
                                        ),
                                      ],
                                    ),
                                    Text("Ordered By: $custName",
                                        style: const TextStyle(
                                            color: Colors.black38,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              );

  }
}



//converts firebase time into human readable time