import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  double fontSize;
  MyText({
    super.key,
    required this.text,
    this.fontSize = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        height: 1.3,
      ),
    );
  }
}
