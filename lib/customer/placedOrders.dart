import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/ordersPlacedTile.dart';
import '../widgets/customSubButton.dart';
import 'Utility/navigation.dart';
import 'customerHome.dart';

class PlacedOrders extends StatefulWidget {
  const PlacedOrders({Key? key}) : super(key: key);
  @override
  State<PlacedOrders> createState() => _PlacedOrders();
}

class _PlacedOrders extends State<PlacedOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Current Orders'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if(userSnapshot.hasData) {

                    //===============================
                    //ERROR HANDLING FOR CLOSED TABLE
                    //===============================

                    if(userSnapshot.data!['tableID'] == ''){
                      return Column(
                        children:  [
                          const Text('Table Closed'),

                          CustomSubButton(text: "Back to Home Page",
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerHome()));
                            },
                          ),

                        ],

                      );
                    }

                    return Expanded(

                    child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(
                                    'tables/${userSnapshot.data!['tableID']}/tableOrders')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || (snapshot.data?.size == 0)) {
                                return const Center(
                                    child: Text('You have no active requests'));
                              } else {
                                return ListView.builder(
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index){
                                      return OrdersPlacedTile(
                                          taskName: '\nItem: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                              + '  x ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                              + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '')
                                              + '\nPrice: \$' + (snapshot.data?.docs[index]['price'] ?? ''),
                                          time:(snapshot.data?.docs[index]['timePlaced'] ?? '') ,
                                          oStatus: (snapshot.data?.docs[index]['status'] ?? ''),

                                        //===================================================
                                        //Customer can edit order if no progress has been made
                                        //===================================================
                                        onPressedEdit: (BuildContext ) {

                                           //Check to see if progress has been made
                                          if(snapshot.data?.docs[index]['status'] == 'placed'){

                                          }

                                          else {

                                          }

                                      },
                                        //======================================================
                                        //Customer can delete order if no progress has been made
                                        //======================================================
                                        onPressedDelete: (BuildContext ) {

                                            //check to see if progress has been made
                                            if(snapshot.data?.docs[index]['status'] == 'placed'){
                                              String collectionRef = 'tables/${userSnapshot.data!['tableID']}/tableOrders';
                                              deleteOrder(snapshot.data?.docs[index].id as String, collectionRef);
                                            }

                                            else {

                                            }

                                      },
                                      );


                                    });
                              }
                            }),
                  );
                  }
                  else{
                    return const Text("no data found");
                  }
                })
          ],
        ));
  }

  void deleteOrder(String orderID, String colectionRef){

    FirebaseFirestore.instance.collection('orders').doc(orderID).delete();

    FirebaseFirestore.instance.collection(colectionRef).doc(orderID).delete();

  }
}
