import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/customMainButton.dart';
import '../widgets/customTextForm.dart';
import 'Utility/navigation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'customerHome.dart';

class SubmitReview extends StatefulWidget {
  const SubmitReview({Key? key}) : super(key: key);

  @override
  State<SubmitReview> createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> {
  final reviewController = TextEditingController();
  String currentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
  var starRating;
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
                  return  Column(
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
                              starRating = rating;
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: CustomTextForm(
                            hintText: 'Share your experience',
                            controller: reviewController,
                            validator: null,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            maxLength: 100,
                            icon: const Icon(Icons.reviews)
                        ),
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
                              starRating = rating;
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: CustomTextForm(
                            hintText: 'Share your experience',
                            controller: reviewController,
                            validator: null,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            maxLength: 100,
                            icon: const Icon(Icons.reviews)
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomMainButton(
                            text: "SUBMIT REVIEW",
                            onPressed: () {
                              addReview(reviewController.text.toString(), starRating,
                                  userSnapshot.data!.id, userSnapshot.data!['fName'], userSnapshot.data!['restID']);

                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CustomerHome()));
                            }),
                      )
                    ],
                  );
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

  void addReview(String comment, double rating, String uid, String custName, String restID){
    var now = DateTime.now();
    FirebaseFirestore.instance.collection('reviews').doc().set({
      'description' : comment,
      'restID' : restID,
      'custName' : custName,
      'custID' : uid,
      'rating' : rating,
      'date' : DateTime.now()
    });

  }

}
