import 'package:get/get.dart';
import 'package:planet/models/selected_plant_detail_model.dart';
import 'package:planet/services/selected_plant_detail_service.dart';

class SelectedPlantDetailController extends GetxController {

  SelectedPlantDetailService service = Get.put(SelectedPlantDetailService());

  final Rx<SelectedPlantDetailModel> _selectedPlant = SelectedPlantDetailModel().obs;
  SelectedPlantDetailModel get selectedPlant => _selectedPlant.value;

  void selectDetail(int uid, String nickName, String? imgUrl) {
    SelectedPlantDetailModel model = service.selectedDetail(uid: uid, nickName: nickName, imgUrl: imgUrl);
    _selectedPlant(model);
  }


}
