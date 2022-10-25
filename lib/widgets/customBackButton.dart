import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;


  const CustomBackButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child:
      IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black87,
        ),
      ),
    );

  }
}