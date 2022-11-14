
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



class RatingTile extends StatelessWidget {
  final String customerName;
  String description;
  String date;
  double rating;

  RatingTile({
    super.key,
    required this.customerName,
    required this.description,
    required this.date,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,bottom: 15),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54,width: 2)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15,top: 10),
                      child: Text(customerName,
                          style: const TextStyle(color: Colors.black,fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5,top: 10),
                      child: Text(date,
                          style: const TextStyle(color: Colors.black,fontSize: 15)),
                    ),
                  ],
                ),
                Divider(thickness: 1,color: Colors.black,),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: RatingBar.builder(
                    itemSize: 20,
                    ignoreGestures: true,
                    initialRating: rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.red,
                    ),
                    onRatingUpdate: (avg) {
                      avg;
                    },
                  ),
                ),
                SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.only(right: 5,left: 15,bottom: 10),
                  child: Text(description,
                      style: const TextStyle(color: Colors.black,fontSize: 15)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
