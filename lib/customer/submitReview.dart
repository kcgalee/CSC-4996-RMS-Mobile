import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/customMainButton.dart';
import '../widgets/customTextForm.dart';
import 'Utility/navigation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'customerHome.dart';

/*
This page gets the restaurantID and waiterID from the users document
and allows them to leave a review.  The review for the restaurant and
waiter are saved in the same document in the reviews collection of the
database.
 */

class SubmitReview extends StatefulWidget {
  const SubmitReview({Key? key}) : super(key: key);

  @override
  State<SubmitReview> createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> {
  final restReviewController = TextEditingController();
  final waiterReviewController = TextEditingController();

  String currentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
  var restStarRating;
  var waiterStarRating;
  var restName= '', waiterName = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text("Submit Review"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(

          child: StreamBuilder (
              stream: FirebaseFirestore.instance.collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if(userSnapshot.hasData) {
                  return FutureBuilder (
                    future: getInfo(userSnapshot.data!['restID'], userSnapshot.data!['waiterID']),
                  builder: (build, context2) {
                  return Column(
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
                      Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(20.0),
                              alignment: Alignment.topLeft,
                              child:  Text("Review by ${userSnapshot.data!['fName']}",
                              )
                          ),
                          const Spacer(),
                          Container(
                              padding: const EdgeInsets.all(20.0),
                              alignment: Alignment.topLeft,
                              child: Text(currentDate
                              )
                          ),
                        ],
                      ),

                      Text('$restName\n',
                          style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 20,)
                      ),

                      Row(

                        children: [

                          Container(
                              padding: const EdgeInsets.only(top: 20.0, right: 10, left: 20.0, bottom: 20.0),
                              alignment: Alignment.topLeft,
                              child:  const Text("Restaurant Review",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 15,),
                              )
                          ),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              restStarRating = rating;
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Column (
                          children: [
                        CustomTextForm(
                            hintText: 'Share your experience',
                            controller: restReviewController,
                            validator: null,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            maxLength: 100,
                            icon: const Icon(Icons.reviews)
                        ),

                            const Text('Max length 250 characters'),
                    ]
                        ),
                      ),

                      Text('$waiterName\n',
                        style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 20,)
                      ),

                      Row(
                        children: [


                          Container(
                              padding: const EdgeInsets.only(top: 20.0, right: 40.0, left: 20.0, bottom: 20.0),
                              alignment: Alignment.topLeft,
                              child:  const Text("Waiter Review",
                                style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 15,),
                              )
                          ),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              waiterStarRating = rating;
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                        children: [
                        CustomTextForm(
                            hintText: 'Share your experience',
                            controller: waiterReviewController,
                            validator: null,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            maxLength: 250,
                            icon: const Icon(Icons.reviews)
                        ),
                          const Text('Max length 250 characters'),
                        ]
                    ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomMainButton(
                            text: "SUBMIT REVIEW",
                            onPressed: () {
                              addRestReview(restReviewController.text.toString(), restStarRating, waiterReviewController.text.toString(),
                                 waiterStarRating, userSnapshot.data!.id, userSnapshot.data!['fName'], userSnapshot.data!['restID'], userSnapshot.data!['waiterID']);

                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CustomerHome()));
                            }),
                      )
                    ],
                  );
                  });
                }

                else {
                  return const Text('No data to show');
                }

              }
          )
      ),
    );
  }

  convertTime(time) {
    var now = DateTime.now();
    var formatter = DateFormat('MM-dd-yyyy');
    String formattedDate = formatter.format(now);
  }

  void addRestReview(String restComment, double restRating, String waiterComment, double waiterRating, String uid, String custName, String restID, String waiterID){
    FirebaseFirestore.instance.collection('reviews').doc().set({
      'restDescription' : restComment,
      'restID' : restID,
      'custName' : custName,
      'custID' : uid,
      'restRating' : restRating,
      'waiterID' : waiterID,
      'waiterDescription' : waiterComment,
      'waiterRating' : waiterRating,
      'date' : DateTime.now()
    });

  }

  Future<void> getInfo(String restID, String waiterID) async {

    //get rest name
    await FirebaseFirestore.instance.collection('restaurants').doc(restID).get().then(
            (element) {
          restName = element['restName'].toString();
        });

    //get waiter name
    await FirebaseFirestore.instance.collection('users').doc(waiterID).get().then(
            (element) {
          waiterName = element['prefName'].toString();
        });


  }
}
