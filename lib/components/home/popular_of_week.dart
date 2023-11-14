import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:planet/components/home/plant_info_card.dart';

class PopularWeekCarousel extends StatefulWidget {
  const PopularWeekCarousel({super.key});

  @override
  State<PopularWeekCarousel> createState() => _PopularWeekCarouselState();
}

class _PopularWeekCarouselState extends State<PopularWeekCarousel> {
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          // Set carousel controller
          carouselController: carouselController,
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return PlantInfoCard(
                  imgUrl:
                      'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
                  nickName: "asdadsdsdsa",
                  heart: 123123,
                  uid: 12,
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            // Set the height of each carousel item
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
      ],
    );
  }
}
