import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/dairy_info_card.dart';
import 'package:planet/components/home/plant_info_card.dart';
import 'package:planet/controllers/plant_controller.dart';
import 'package:planet/theme.dart';

class RecentPlantsScreen extends StatefulWidget {
  const RecentPlantsScreen({super.key});

  @override
  State<RecentPlantsScreen> createState() => _RecentPlantsScreenState();
}

class _RecentPlantsScreenState extends State<RecentPlantsScreen> {
  final PlantController plantController = Get.find<PlantController>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      plantController.reachedEndOfPage.value = true;
      plantController.incrementPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "최신",
      ),
      body: Container(
        width: double.infinity,
        color: BgColor.mainColor,
        child: Obx(() {
          if (plantController.recentPlants.isEmpty &&
              plantController.isFetching) {
            // 데이터가 없고 로딩 중일 때
            return const Center(child: CircularProgressIndicator());
          } else if (plantController.recentPlants.isEmpty) {
            // 데이터가 없을 때
            return const Center(child: Text('최신 데이터가 없습니다.'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  controller: scrollController,
                  itemCount: plantController.recentPlants.length,
                  itemBuilder: (context, index) {
                    final plant = plantController.recentPlants[index];
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: PlantInfoCard(
                          nickName: plant.nickName,
                          plantId: plant.plantId,
                          imgUrl:
                              'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
                          heart: plant.heartCount,
                        ));
                  },
                ),
              ),
              if (plantController.isFetching)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
