import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:planet/components/home/plant_info_card.dart';
import 'package:planet/models/api/plant/plant_summary_model.dart';

class PlantsCarousel extends StatelessWidget {
  List<PlantSummaryModel> plants;

  PlantsCarousel({super.key, required this.plants});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          key: UniqueKey(),
          carouselController: carouselController,
          items: plants.map((plant) {
            return Builder(
              builder: (BuildContext context) {
                return PlantInfoCard(
                  imgUrl: plant.imgUrl ?? "",
                  nickName: plant.nickName ?? "",
                  heart: plant.heartCount ?? 0,
                  plantId: plant.plantId ?? 1,
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 250,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
