import 'package:flutter/material.dart';

class CustomSquareButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;


  const CustomSquareButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child:  SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          height: MediaQuery.of(context).size.height * 0.1,
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                backgroundColor: const Color(0xffc5e1fa),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text( text,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              )
          )
        ),
      );

  }
}