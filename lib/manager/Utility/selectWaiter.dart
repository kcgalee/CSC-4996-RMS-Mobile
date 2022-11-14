import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/selectRestaurant.dart';
import '../../widgets/customBackButton.dart';
import '../seeRatings.dart';
import 'MangerNavigationDrawer.dart';



class SelectWaiter extends StatefulWidget {
  final String restaurantID;
  final String restName;
  final bool restaurant;
  SelectWaiter({Key? key, required this.restaurantID, required this.restName, required this.restaurant}) : super(key: key);
  @override
  _SelectWaiter createState() => _SelectWaiter();

}
class _SelectWaiter extends State<SelectWaiter> {
  final uID = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ManagerNavigationDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Select Waiter'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: CustomBackButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => SelectRestaurant(text: 'waiter ratings')
                    )
                );
              }),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.
                  collection('users')
                      .where('restID', isEqualTo: widget.restaurantID)
                      .where('type', isEqualTo: 'waiter')
                      .where('isActive', isEqualTo: true)
                      .orderBy('fName')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: Text('You currently have no waiters at ${widget.restName}'),);
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 24,right: 24,bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.only(right: 5,bottom: 5,top: 5),
                                decoration: BoxDecoration(color: Colors.grey[100],
                                    border: Border.all(color: Colors.black54,width: 2),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(snapshot.data?.docs[index]['fName'] + ' ' + snapshot.data?.docs[index]['lName'],style: TextStyle(fontWeight: FontWeight.bold,),),
                                      Text((snapshot.data?.docs[index]['email'] ?? '') + '\n' + (snapshot.data?.docs[index]['phone'] ?? ''), ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SeeRatings(restaurantID: widget.restaurantID, restName: widget.restName,
                                        restaurant: false, waiterID: snapshot.data?.docs[index].id ?? '',
                                      waiterName: (snapshot.data?.docs[index]['fName'] ?? '') + ' ' + (snapshot.data?.docs[index]['lName'] ?? ''),
                                      prefName: (snapshot.data?.docs[index]['prefName'] ?? ''))));
                                  },
                                ),
                              ),
                            );
                          }
                      );
                    }
                  }),
            ),
          ],
        )
    );
  }

}