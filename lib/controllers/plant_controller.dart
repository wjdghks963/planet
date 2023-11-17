import 'package:get/get.dart';
import 'package:planet/models/api/plant/plant_summary_model.dart';
import 'package:planet/services/api_manager.dart';
import 'package:planet/services/plant_api_service.dart';

class PlantController extends GetxController {


  var myPlants = <PlantSummaryModel>[].obs;
  var randomPlants = <PlantSummaryModel>[].obs;
  var recentPlants = <PlantSummaryModel>[].obs;
  var reachedEndOfPage = false.obs;
  bool isFetching = false;



  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    fetchPlants();
    fetchRandomPlants();
    fetchRecentPlants();
  }

  // List<PlantSummaryModel>

  void fetchPlants() async {
    final apiManager = ApiManager();
    final plantsApiClient = PlantsAipClient();


    final response =
        await apiManager.performApiCall(() => plantsApiClient.getPlants());

    myPlants.value = (response?.body as List)
        .map((e) => PlantSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void fetchRandomPlants() async {
    final plantsApiClient = PlantsAipClient();

    final response = await plantsApiClient.getRandomPlants();

    randomPlants.value = (response.body as List)
        .map((e) => PlantSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void fetchRecentPlants() async {
    if (isFetching) return;
    isFetching = true;

    final plantsApiClient = PlantsAipClient();

    final response = await plantsApiClient.getRecentPlants(currentPage);

    if (response.statusCode == 200) {
      final newPlants = (response.body as List)
          .map((e) => PlantSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (newPlants.isNotEmpty) {
        recentPlants.addAll(newPlants);
        currentPage++;
      }
    }
    isFetching = false;
  }



  void incrementPage() {
    if (!isFetching && reachedEndOfPage.value) {
      fetchRecentPlants();
      reachedEndOfPage.value = false; // 상태 초기화
    }
  }

}
