import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:planet/components/common/component_title.dart';
import 'package:planet/components/common/custom_ad_widget.dart';
import 'package:planet/components/common/more_button.dart';
import 'package:planet/components/home/plants_carousel.dart';
import 'package:planet/components/home/plants_grid.dart';
import 'package:planet/controllers/plant/pagenation_plants_controller.dart';
import 'package:planet/controllers/plant/plant_controller.dart';
import 'package:planet/screen/plant/type_plants_screen.dart';
import 'package:planet/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void goToPopular() {
    Get.to(
      () => const TypePlantsScreen(plantType: PlantType.popular),
      transition: Transition.rightToLeft,
    );
  }

  void goToRecent() {
    Get.to(
      () => const TypePlantsScreen(plantType: PlantType.recent),
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentPlantsController = Get.put(RecentPlantsController());
    final popularPlantsController = Get.put(PopularPlantsController());
    final randomPlantsController = Get.put(RandomPlantsController());

    return Container(
        width: double.infinity,
        color: BgColor.mainColor,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const CustomAdWidget(),
            const SizedBox(
              height: 25.0,
            ),
            Column(
              children: [
                 SizedBox(
                    width: double.infinity,
                    child: ComponentTitle("랜덤")),
                const SizedBox(
                  height: 20.0,
                ),
                Obx(() {
                  if (randomPlantsController.isLoading.value) {
                    return Center(
                        child:
                            Lottie.asset('assets/lotties/loading_lottie.json'));
                  } else {
                    return PlantsCarousel(
                        plants: randomPlantsController.randomPlants);
                  }
                })
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       ComponentTitle("최신"),
                        MoreButton(
                          onPressed: goToRecent,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                Obx(() {
                  if (recentPlantsController.isFetching.value) {
                    return Center(
                        child:
                            Lottie.asset('assets/lotties/loading_lottie.json'));
                  } else {
                    return PlantsGrid(
                        plants: recentPlantsController.recentPlants);
                  }
                })
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ComponentTitle("인기"),
                        MoreButton(
                          onPressed: goToPopular,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                Obx(() {
                  if (popularPlantsController.isFetching.value) {
                    return Center(
                        child:
                            Lottie.asset('assets/lotties/loading_lottie.json'));
                  } else {
                    return PlantsGrid(
                        plants: popularPlantsController.popularPlants);
                  }
                }),
                const SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ],
        ));
  }
}
