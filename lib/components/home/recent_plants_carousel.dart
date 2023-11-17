import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/home/plant_info_card.dart';
import 'package:planet/controllers/plant_controller.dart';

class RecentPlantsCarousel extends StatefulWidget {
  const RecentPlantsCarousel({super.key});

  @override
  State<RecentPlantsCarousel> createState() => _RecentPlantsCarouselState();
}

class _RecentPlantsCarouselState extends State<RecentPlantsCarousel> {
  CarouselController carouselController = CarouselController();
  final plantController = Get.find<PlantController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          carouselController: carouselController,
          items: plantController.recentPlants.map((plant) {
            return Builder(
              builder: (BuildContext context) {
                return PlantInfoCard(
                  //imgUrl: plant.imgUrl,
                  // TODO:: 이미지 바꿔야함
                  imgUrl:
                  'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',

                  nickName: plant.nickName,
                  heart: plant.heartCount,
                  plantId: plant.plantId,
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 250,

// Set the size of each carousel item
// if height is not specified
            aspectRatio: 16 / 9,

// Set how much space current item widget
// will occupy from current page view
            viewportFraction: 0.8,

// Set the initial page
            initialPage: 0,

// Set carousel to repeat when reaching the end
            enableInfiniteScroll: true,

// Set carousel to scroll in opposite direction
            reverse: false,

// Set carousel to display next page automatically
            autoPlay: true,

// Set the duration of which carousel slider will wait
// in current page utill it moves on to the next
            autoPlayInterval: const Duration(seconds: 5),

// Set the duration of carousel slider
// scrolling to the next page
            autoPlayAnimationDuration: const Duration(milliseconds: 800),

// Set the carousel slider animation
            autoPlayCurve: Curves.fastOutSlowIn,

// Set the current page to be displayed
// bigger than previous or next page
            enlargeCenterPage: true,

// Do actions for each page change
            onPageChanged: (index, reason) {},

// Set the scroll direction
            scrollDirection: Axis.horizontal,
          ),
        ),
        // ... 여기에 추가 위젯들
      ],
    ));
  }
}
