import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planet/components/DairyInfoCard.dart';
import 'package:planet/controllers/plant_detail_controller.dart';
import 'package:planet/theme.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlantDetailViewModel controller = Get.put(PlantDetailViewModel());
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
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: DairyInfoCard(
                              nickName: "dasdasdas",
                              plantId: 1,
                              period: 32,
                            ));
                      })),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("asd"),
        tooltip: 'Increment',
        backgroundColor: ColorStyles.mainAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
