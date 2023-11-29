import 'package:flutter/material.dart';
import 'package:planet/components/home/plant_info_card.dart';
import 'package:planet/models/api/plant/plant_summary_model.dart';

class PlantsGrid extends StatelessWidget {
  final List<PlantSummaryModel> plants;

  const PlantsGrid({super.key, required this.plants});

  @override
  Widget build(BuildContext context) {

    return GridView.count(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: plants.map((plant) {
        return PlantInfoCard(
            plantId: plant.plantId,
            imgUrl: plant.imgUrl,
            nickName: plant.nickName,
            heart: plant.heartCount);
      }).toList(),
    );
  }
}
