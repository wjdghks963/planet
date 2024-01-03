import 'package:get/get.dart';
import 'package:planet/models/api/plant/plant_summary_model.dart';
import 'package:planet/services/plant_api_service.dart';

class RecentPlantsController extends GetxController {
  var currentPage = 0;
  var lastPageOfData = false.obs;
  var recentPlants = <PlantSummaryModel>[].obs;
  var isFetching = false.obs;
  var reachedEndOfPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecentPlants();
  }

  void fetchRecentPlants() async {
    if (isFetching.value) return;
    isFetching.value = true;

    final plantsApiClient = PlantsApiClient();

    final response = await plantsApiClient.getRecentPlants(currentPage);

    if (response.statusCode == 200) {
      final newPlants = (response.body as List)
          .map((e) => PlantSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      recentPlants.addAll(newPlants);

      if (newPlants.length < 4) {
        lastPageOfData.value = true;
      } else {
        currentPage++;
      }
    }
    isFetching.value = false;
  }

  void incrementPage() {
    if (!isFetching.value) {
      if (lastPageOfData.value == false && reachedEndOfPage.value) {
        fetchRecentPlants();
      }
      reachedEndOfPage.value = false; // 상태 초기화
    }
  }
}

class PopularPlantsController extends GetxController {
  var currentPage = 0;
  var lastPageOfData = false.obs;
  var popularPlants = <PlantSummaryModel>[].obs;
  var isFetching = false.obs;
  var reachedEndOfPage = false.obs;




  void fetchPopularPlants() async {
    if (isFetching.value) return;
    isFetching.value = true;

    final plantsApiClient = PlantsApiClient();

    final response = await plantsApiClient.getPopularPlants(currentPage);


    if (response.statusCode == 200) {
      final newPlants = (response.body as List)
          .map((e) => PlantSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      popularPlants.addAll(newPlants);

      if (newPlants.length < 4) {
        lastPageOfData.value = true;
      } else {
        currentPage++;
      }
    }
    isFetching.value = false;
  }

  void incrementPage() {
    if (!isFetching.value) {
      if (lastPageOfData.value == false && reachedEndOfPage.value) {
        fetchPopularPlants();
      }
      reachedEndOfPage.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPopularPlants();
  }
}



class HeartPlantsController extends GetxController {
  var currentPage = 0;
  var lastPageOfData = false.obs;
  var heartPlants = <PlantSummaryModel>[].obs;
  var isFetching = false.obs;
  var reachedEndOfPage = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchHeartPlants();
  }

  void fetchHeartPlants() async {
    if (isFetching.value) return;
    isFetching.value = true;

    final plantsApiClient = PlantsApiClient();

    final response = await plantsApiClient.getHeartPlants(currentPage);


    if (response.statusCode == 200) {
      final newPlants = (response.body as List)
          .map((e) => PlantSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      heartPlants.addAll(newPlants);

      if (newPlants.length < 4) {
        lastPageOfData.value = true;
      } else {
        currentPage++;
      }
    }
    isFetching.value = false;
  }

  void incrementPage() {
    if (!isFetching.value) {
      if (lastPageOfData.value == false && reachedEndOfPage.value) {
        fetchHeartPlants();
      }
      reachedEndOfPage.value = false;
    }
  }
}