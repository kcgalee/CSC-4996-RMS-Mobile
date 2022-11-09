import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/ordersPlacedTile.dart';
import 'Utility/navigation.dart';


class ViewMemberOrder extends StatefulWidget {
  final String custID, custName;
  ViewMemberOrder({Key? key, required this.custID, required this.custName}) : super(key: key);
  @override
  State<ViewMemberOrder> createState() => _ViewMemberOrder();
}

class _ViewMemberOrder extends State<ViewMemberOrder> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:  Text('Orders by ${widget.custName}'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
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
                    return Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(
                              'tables/${userSnapshot.data!['tableID']}/tableOrders')
                              .where('custID', isEqualTo: widget.custID)
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
                                      taskName: '${'\nItem: ' + (snapshot.data?.docs[index]['itemName'] ?? '')
                                          + '  x ' + (snapshot.data?.docs[index]['quantity'].toString() ?? '')
                                          + '\nPlaced by ' + (snapshot.data?.docs[index]['custName'] ?? '')}'
                                          '\nPrice: \$' + (snapshot.data?.docs[index]['price'] ?? ''),
                                      time:(snapshot.data?.docs[index]['timePlaced'] ?? '') ,
                                      oStatus: (snapshot.data?.docs[index]['status'] ?? ''), onPressedEdit: (BuildContext ) {  }, onPressedDelete: (BuildContext ) {  },
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
        )
    );
  }
}
