import 'package:flutter/material.dart';
import 'package:planet/components/DairyInfoCard.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: const Color(0xFF4CAF50),
        padding: const EdgeInsets.symmetric( horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("내 식물", textAlign: TextAlign.left, style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            )),
            Expanded(child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      child: DairyInfoCard());
                })
            )
          ],
        )
        );
  }
}
