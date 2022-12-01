import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/ordersPlacedTile.dart';
import 'Utility/navigation.dart';

/*
This page wil display all the orders placed by the user selected on the
tableStatus page. The orders are selected from this path:
tables collection ->tableID document -> tableOrders. Each tile is tappable
and will display the item info.
 */

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
                                          + '\nCustomer: ' + (snapshot.data?.docs[index]['custName'] ?? '')}',
                                      price: snapshot.data?.docs[index]['price'],
                                      time:(snapshot.data?.docs[index]['timePlaced'] ?? '') ,
                                      oStatus: (snapshot.data?.docs[index]['status'] ?? ''),
                                      onPressedEdit: (BuildContext ) {  },
                                      onPressedDelete: (BuildContext ) {  },
                                      onTap: () {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('restaurants/${userSnapshot.data!['restID']}/menu')
                                                    .doc(snapshot.data?.docs[index]['itemID'])
                                                    .snapshots(),
                                                builder: (build, itemSnapshot) {
                                                  if(itemSnapshot.hasData) {
                                                    var price = 'Free';
                                                    if (itemSnapshot.data!['price'] != '0.00'){
                                                      price = '\$' + itemSnapshot.data!['price'];
                                                    }
                                                    return AlertDialog(
                                                      title:  Text(itemSnapshot.data!['itemName'].toString()),
                                                      content: SingleChildScrollView(
                                                        child: ListBody(
                                                          children:  <Widget>[
                                                            Text(itemSnapshot.data!['description']),
                                                            Text(price),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text('Approve'),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  else {
                                                    return Text('no data to show');
                                                  }
                                                });
                                          },
                                        );
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
        )
    );
  }
}
