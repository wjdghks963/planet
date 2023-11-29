import 'package:flutter/material.dart';

class ComponentTitle extends StatelessWidget {

  final String title;


  ComponentTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return  Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        shadows: [
          const Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 3.0,
            color: Color(0xFF76B947), // 자연스러운 녹색 그림자
          ),
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 8.0,
            color: Color(0xFF76B947).withOpacity(0.7), // 더 부드러운 그림자
          ),
        ],
      ),
    );
  }
}