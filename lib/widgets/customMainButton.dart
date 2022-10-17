import 'package:flutter/material.dart';

class CustomMainButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;


  const CustomMainButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        Padding(
          padding: const EdgeInsets.only(bottom: 26,),
          child:  ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(330, 56),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Colors.black38,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text( text,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
          ),
    );

  }
}