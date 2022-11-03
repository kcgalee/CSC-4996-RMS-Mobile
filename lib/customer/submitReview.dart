import 'package:flutter/material.dart';

import '../widgets/customMainButton.dart';
import '../widgets/customTextForm.dart';
import 'Utility/navigation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class SubmitReview extends StatefulWidget {
  const SubmitReview({Key? key}) : super(key: key);

  @override
  State<SubmitReview> createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> {
  final reviewController = TextEditingController();
  String currentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

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
        child:
          Column(
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
              Container(
                padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.topLeft,
                child: const Text("Review by",
                    style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 20,),
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                  alignment: Alignment.topLeft,
                  child: Text(currentDate
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
                  print(rating);
                },
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: CustomTextForm(
                    hintText: 'Share your experience',
                    controller: reviewController,
                    validator: null,
                    keyboardType: TextInputType.text,
                    maxLines: 10,
                    maxLength: 100,
                    icon: const Icon(Icons.reviews)
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomMainButton(
                    text: "SUBMIT REVIEW",
                    onPressed: () {
                    }),
              )
            ],
          ),
      ),
    );
  }

  convertTime(time) {
    var now = DateTime.now();
    var formatter = DateFormat('MM-dd-yyyy');
    String formattedDate = formatter.format(now);
  }

}
