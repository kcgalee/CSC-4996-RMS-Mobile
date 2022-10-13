import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyButton({
    super.key,
    required this.text,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(

          fixedSize: const Size(330, 56),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black54,
          side: const BorderSide(width: 2, color: Colors.black38,),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(text),

      ),
    );
  }
}
