import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/dairy_info_card.dart';
import 'package:planet/components/common/custom_alert_dialog.dart';
import 'package:planet/screen/diary/add_plant_form.dart';
import 'package:planet/theme.dart';

class DiaryScreen extends StatelessWidget {
  DiaryScreen({super.key});

  int maxItemCount = 1;

  // TODO:: 2개 이상이면 팝업
  Future? goToAddForm() {
    if (maxItemCount > 2) {
    return  Get.dialog(
          CustomAlertDialog(alertContent: "$maxItemCount개 이상은 등록할 수 없습니다."));
    } else {
      return Get.to(
        const AddPlantForm(),
        transition: Transition.rightToLeft,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          color: BgColor.mainColor,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("내 식물",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
              Expanded(
                  child: ListView.builder(
                      itemCount: maxItemCount,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: DairyInfoCard(
                              nickName: "dasdasdas",
                              uid: 1,
                              period: 32,
                            ));
                      })),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddForm,
        tooltip: 'Increment',
        backgroundColor: ColorStyles.mainAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
