import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/manager/Utility/managerTile.dart';
import 'package:restaurant_management_system/widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/selectRestaurant.dart';
import 'package:intl/intl.dart';


class SeeRatings extends StatefulWidget {
  final String restaurantID;
  final String restName;
  SeeRatings({Key? key, required this.restaurantID, required this.restName}) : super(key: key);

  @override
  State<SeeRatings> createState() => _SeeRatings();
}

class _SeeRatings extends State<SeeRatings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ManagerNavigationDrawer(),
        appBar: AppBar(
          title: Text('Ratings'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: CustomBackButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => SelectRestaurant(text: 'ratings')
                    )
                );
              }),
            ),
            Text(widget.restName),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('reviews').where('restID', isEqualTo: widget.restaurantID).orderBy('date', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Center(child: Text("You currently have no reviews for ${widget.restName}."),);
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ManagerTile(
                                taskName: 'Rating: ' + (snapshot.data?.docs[index]['rating'].toString() ?? ''),
                                subTitle: 'Date: ' + (convertTime(snapshot.data?.docs[index]['date'])
                                    + '\nDescription: ' + (snapshot.data?.docs[index]['description'].toString() ?? '')),
                                onPressedEdit:  (p0) => {
                                },
                                onPressedDelete: (p0) =>   {
                                }
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

  convertTime(time) {
    var formatter = DateFormat('MM-dd-yyyy');
    return formatter.format(time.toDate());
  }
}
