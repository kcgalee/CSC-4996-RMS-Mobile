import 'package:flutter/material.dart';

import '../widgets/customTextForm.dart';
import 'Utility/navigation.dart';

class SubmitReview extends StatefulWidget {
  const SubmitReview({Key? key}) : super(key: key);

  @override
  State<SubmitReview> createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> {


  final reviewController = TextEditingController();


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
          Container(

          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: CustomTextForm(
                hintText: 'Type here',
                controller: reviewController,
                validator: null,
                keyboardType: TextInputType.text,
                maxLines: 6,
                maxLength: 100,
                icon: const Icon(Icons.reviews)
            ),
          )
        ],
      ),
    );
  }

}
