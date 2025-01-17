import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final birdY;
  final double birdWidth; // Normal double value for width 
  final double birdHeight;

  MyBird({this.birdY, required this.birdWidth, required this.birdHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
      'lib/Images/MyFace.png',
      width: MediaQuery.of(context).size.width * birdWidth / 2,
      height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
      fit: BoxFit.fill,
      ));
  }
}