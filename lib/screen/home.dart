import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return

    Container(
        width: double.infinity,
        color: const Color(0xFF4CAF50),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
         children: [
           Container(
               width: double.infinity,
               child: const Text("주간 인기",  textAlign: TextAlign.left, style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
               ))

           )
         ],
        ),
    );
  }
}