import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Utility/navigation.dart';


class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _Order();
}

class _Order extends State<Order> {
  String restaurantName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text("Menu"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: FutureBuilder(
          future: getName(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(26),
                      child: Text(restaurantName,
                        style: const TextStyle(fontSize: 25,),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO SHOW ALL APPETIZERS
                        },
                        child: const Text('APPETIZERS',),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO SHOW ALL ENTREES
                        },
                        child: const Text('ENTREES',),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO SHOW ALL DESSERTS
                        },
                        child: const Text('DESSERTS',),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO SHOW ALL DRINKS
                        },
                        child: const Text("DRINKS"),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 26,right: 26),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          fixedSize: const Size(330, 56),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.black38,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          //TODO
                          //SHOW ALL CONDIMENTS
                        },
                        child: const Text("CONDIMENTS"),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        fixedSize: const Size(330, 56),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                        side: const BorderSide(
                          color: Colors.black38,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        //TODO
                        //SHOW ALL UTENSILS
                      },
                      child: const Text("UTENSILS"),
                    ),
                    ElevatedButton(
                        child: const Text("REQUEST WAITER"),
                        onPressed: () {
                          //TODO
                          //SEND REQUEST FOR WAITER
                        }),

                    ElevatedButton(
                        child: const Text("REQUEST BILL"),
                        onPressed: () {
                          //TODO
                          //REQUEST BILL FROM WAITER
                        }),
                  ], //Children
                ));
          },
        ));
  }

  //TODO DELETE THIS AFTER PASSING RESTAURANT NAME FROM QR SCANNER
  Future getName() async {
    await FirebaseFirestore.instance.collection('restaurants').where('restaurantName', isEqualTo: "Apple Bees").get().then(
            (element) {
          restaurantName = "Apple Bees";
        }
    );
  }


}
