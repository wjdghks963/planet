import 'package:get/get.dart';
import 'package:planet/models/plant_detail_model.dart';
import 'package:planet/services/plant_detail_service.dart';

class PlantDetailViewModel extends GetxController {
  PlantDetailService service = Get.put(PlantDetailService());

  RxBool isDataFetching = false.obs;

  final Rx<PlantDetailModel> _selectedPlant = PlantDetailModel().obs;
  PlantDetailModel get selectedPlant => _selectedPlant.value;

  final RxList<PlantDetailModel> _plantDetailModels = <PlantDetailModel>[].obs;

  List<PlantDetailModel> get plantDetailModels => _plantDetailModels.value;

  @override
  void onInit() {
    super.onInit();
    fetchPlantDetail();
  }

  void selectDetail(int uid, String nickName, String? imgUrl) {
    PlantDetailModel model = service.selectedDetail(uid, nickName, imgUrl);
    _selectedPlant(model);
  }

  void fetchPlantDetail() async {
    isDataFetching(true);

    List<PlantDetailModel>? plantDetailModels = await service.fetchDetail();

    isDataFetching(false);

    _plantDetailModels(plantDetailModels);
  }
}
