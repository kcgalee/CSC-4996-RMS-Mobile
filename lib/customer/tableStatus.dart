import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_management_system/customer/submitReview.dart';
import 'package:restaurant_management_system/customer/viewMemberOrder.dart';
import 'Utility/navigation.dart';
import 'customerHome.dart';


class TableStatus extends StatefulWidget {
String tableNum, waiterName;
  TableStatus({Key? key, required this.tableNum, required this.waiterName }) :super(key: key);

  @override
  State<TableStatus> createState() => _TableStatusState();
}

class _TableStatusState extends State<TableStatus> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: Text('Table ${widget.tableNum}, Waiter ${widget.waiterName}'),
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

                    //===============================
                    //ERROR HANDLING FOR CLOSED TABLE
                    //===============================

                    if(userSnapshot.data!['tableID'] == ''){
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Your table has been closed'),
                            content: const Text('Thank you for coming!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const CustomerHome())
                                ),
                                child: const Text('Go to Home page'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const SubmitReview())
                                ),
                                child: const Text('Leave a review'),
                              ),
                            ],
                          )
                      );
                    }

                    return Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(
                              'tables/${userSnapshot.data!['tableID']}/tableMembers')
                              .snapshots(),
                          builder: (context, tableSnapshot) {
                            if(tableSnapshot.hasData) {
                              return ListView.builder(
                                  itemCount: tableSnapshot.data?.docs.length,
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                        child: ListTile(
                                          title: Text(tableSnapshot.data?.docs[index]['fName'] ?? ''),
                                          onTap: () {
                                            var custID = tableSnapshot.data?.docs[index]['userID'];
                                            var custName = tableSnapshot.data?.docs[index]['fName'];
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) =>  ViewMemberOrder(custID: custID, custName: custName,)));
                                          },
                                        ),
                                      ),
                                    );

                                  });
                            }
                            else {
                              return const Text('No items to display');
                            }
                          }),
                    );
                  }
                  else{
                    return const Text("No data found");
                  }
                })
          ],
        )

    );

  }
}
