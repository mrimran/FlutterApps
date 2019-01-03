import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final text;

  MyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}