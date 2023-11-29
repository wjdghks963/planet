import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/home/plant_info_card.dart';
import 'package:planet/controllers/plant/pagenation_plants_controller.dart';
import 'package:planet/models/api/plant/plant_summary_model.dart';
import 'package:planet/theme.dart';

enum PlantType { popular, recent, hearts }

class TypePlantsScreen extends StatefulWidget {
  final PlantType plantType;

  const TypePlantsScreen({super.key, required this.plantType});

  @override
  State<TypePlantsScreen> createState() => _TypePlantsScreenState();
}

class _TypePlantsScreenState extends State<TypePlantsScreen> {
  late final dynamic plantController;
  late List<PlantSummaryModel> typePlants;
  final ScrollController scrollController = ScrollController();

  String getTitleForPlantType(PlantType plantType) {
    switch (plantType) {
      case PlantType.popular:
        return "인기";
      case PlantType.recent:
        return "최신";
      case PlantType.hearts:
        return "내가 좋아하는";
      default:
        return "";
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);

    if (widget.plantType == PlantType.popular) {
      plantController = Get.put(PopularPlantsController());
      typePlants = plantController.popularPlants;
    } else if (widget.plantType == PlantType.recent) {
      plantController = Get.put(RecentPlantsController());
      typePlants = plantController.recentPlants;
    } else {
      plantController = Get.put(HeartPlantsController());
      typePlants = plantController.heartPlants;
    }
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
        title: getTitleForPlantType(widget.plantType),
      ),
      body: Container(
        width: double.infinity,
        color: BgColor.mainColor,
        child: Obx(() {
          if (typePlants.isEmpty && plantController.isFetching.value) {
            // 데이터가 없고 로딩 중일 때
            return const Center(child: CircularProgressIndicator());
          } else if (typePlants.isEmpty) {
            // 데이터가 없을 때
            return const Center(child: Text('데이터가 없습니다.'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  controller: scrollController,
                  itemCount: typePlants.length,
                  itemBuilder: (context, index) {
                    final plant = typePlants[index];
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: PlantInfoCard(
                          nickName: plant.nickName,
                          plantId: plant.plantId,
                          imgUrl: plant.imgUrl,
                          heart: plant.heartCount,
                        ));
                  },
                ),
              ),
              if (plantController.isFetching.value)
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
