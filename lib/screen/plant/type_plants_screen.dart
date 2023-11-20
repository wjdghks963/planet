import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/home/plant_info_card.dart';
import 'package:planet/controllers/plant/pagenation_plants_controller.dart';
import 'package:planet/models/api/plant/plant_summary_model.dart';
import 'package:planet/theme.dart';

enum PlantType { popular, recent }

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

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);

    if (widget.plantType == PlantType.popular) {
       plantController =
          Get.find<PopularPlantsController>();

      typePlants = plantController.popularPlants;
    } else {
      plantController = Get.find<RecentPlantsController>();
     typePlants = plantController.recentPlants;
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
        title: widget.plantType == PlantType.popular ? "인기" : "최신",
      ),
      body: Container(
        width: double.infinity,
        color: BgColor.mainColor,
        child: Obx(() {
          if (typePlants.isEmpty &&
              plantController.isFetching.value) {
            // 데이터가 없고 로딩 중일 때
            return const Center(child: CircularProgressIndicator());
          } else if (typePlants.isEmpty) {
            // 데이터가 없을 때
            return const Center(child: Text('최신 데이터가 없습니다.'));
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
