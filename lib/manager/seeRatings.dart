import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_management_system/manager/Utility/selectWaiter.dart';
import 'package:restaurant_management_system/widgets/customBackButton.dart';
import 'Utility/MangerNavigationDrawer.dart';
import 'Utility/ratingTile.dart';
import 'Utility/selectRestaurant.dart';
import 'package:intl/intl.dart';
/*
This page is for displaying rating for restaurant and employee
 */

class SeeRatings extends StatefulWidget {
  final String restaurantID;
  final String restName;
  final bool restaurant;
  final String waiterID, waiterName, prefName;
  SeeRatings({Key? key, required this.restaurantID, required this.restName, required this.restaurant,
    required this.waiterID, required this.waiterName, required this.prefName}) : super(key: key);

  @override
  State<SeeRatings> createState() => _SeeRatings();
}

class _SeeRatings extends State<SeeRatings> {

  @override
  Widget build(BuildContext context) {
    //check if restaurant ratings flag is true
    if (widget.restaurant){
      //Restaurant Ratings
      return Scaffold(
          drawer: const ManagerNavigationDrawer(),
          appBar: AppBar(
            title: Text('Restaurant Ratings'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          //retrieves and displays all restaurant reviews
          body: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('reviews').where('restID', isEqualTo: widget.restaurantID).orderBy('date', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child:
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) => SelectRestaurant(text: 'restaurant ratings')
                                      ));
                                  },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Text(widget.restName,style:TextStyle(fontSize: 30)),
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Center(child: Text("There currently are no reviews for ${widget.restName}."),),
                                )
                            )
                          ]);
                    } else {
                      //calculate average rating for restaurant
                      var sum = 0.0;
                      var count = 0.0;
                      var avg = 0.0;
                      snapshot.data?.docs.forEach((element) {
                        sum += element['restRating'];
                        count++;
                      });
                      avg = sum/count;

                      return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: CustomBackButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectRestaurant(text: 'restaurant ratings')
                                    )
                                );
                              }),
                            ),
                            Text('${widget.restName}',style:TextStyle(fontSize: 30)),

                            RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: avg,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (avg) {
                                avg;
                              },
                            ),
                            SizedBox(height: 20,),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      return RatingTile(
                                        customerName: (snapshot.data?.docs[index]['custName']?? ''),
                                        date: convertTime(snapshot.data?.docs[index]['date']),
                                        rating: snapshot.data?.docs[index]['restRating'] ?? 0,
                                        description: (snapshot.data?.docs[index]['restDescription'] ?? 'N/A'),
                                      );
                                    }
                                ))
                          ]);
                    }
                  })
      );
    } else {
      //Waiter Ratings
      return Scaffold(
          drawer: const ManagerNavigationDrawer(),
          appBar: AppBar(
            title: Text('Waiter Ratings'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          //retrieves and displays all waiter reviews
          body: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('reviews').where('waiterID', isEqualTo: widget.waiterID).orderBy('date', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    var displayName = widget.waiterName;
                    if (widget.prefName != ''){
                    displayName += ' (${widget.prefName})';
                    }
                    if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
                      return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: CustomBackButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectWaiter(restName: widget.restName, restaurantID: widget.restaurantID, restaurant: false)
                                    )
                                );
                              }),
                            ),
                            Text(displayName,style:TextStyle(fontSize: 30)),
                            Expanded(
                                child: Center(child: Text("There currently are no reviews for ${widget.waiterName}."),)
                            )
                          ]);
                    } else {
                      //calculate average rating for restaurant
                      var sum = 0.0;
                      var count = 0.0;
                      var avg = 0.0;
                      snapshot.data?.docs.forEach((element) {
                        sum += element['waiterRating'];
                        count++;
                      });
                      avg = sum/count;

                      return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: CustomBackButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectWaiter(restName: widget.restName, restaurantID: widget.restaurantID, restaurant: false)
                                    )
                                );
                              }),
                            ),
                            Text('$displayName',style: TextStyle(fontSize: 30)),
                            RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: avg,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (avg) {
                                avg;
                              },
                            ),
                            SizedBox(height: 20,),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      return RatingTile(
                                        customerName: (snapshot.data?.docs[index]['custName'] ?? ''),
                                        date: convertTime(snapshot.data?.docs[index]['date']),
                                        rating: (snapshot.data?.docs[index]['waiterRating'] ?? 0),
                                        description: (snapshot.data?.docs[index]['waiterDescription'] ?? 'N/A'),
                                      );
                                    }
                                ))
                          ]);
                    }
                  }
                  ));
    }
  }

  convertTime(time) {
    var formatter = DateFormat('MM-dd-yyyy');
    return formatter.format(time.toDate());
  }
}
