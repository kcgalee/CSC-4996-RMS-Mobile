import 'package:flutter/material.dart';

class CustomSubButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;


  const CustomSubButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child:  ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(330, 56),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text( text,
              style: const TextStyle(
                color: Colors.black54,
              ),
            )
        ),
      );

  }
}