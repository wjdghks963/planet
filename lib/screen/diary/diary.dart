import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/controllers/plant_detail_controller.dart';
import 'package:planet/screen/diary/diary_form.dart';
import 'package:planet/theme.dart';

class Diary extends StatefulWidget {
  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  @override
  Widget build(BuildContext context) {
    bool readOnly = true;

    final PlantDetailViewModel controller = Get.find<PlantDetailViewModel>();

    return Scaffold(
        appBar: CustomAppBar(
          title: "일지",
          rightComponent: InkWell(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.create, color: Colors.black),
            ),
            onTap: () => Get.off(const DiaryForm(), arguments: {"date":Get.arguments["date"]}),
          ),
        ),
        body: Container(
          color: BgColor.mainColor,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        controller.selectedPlant.nickName ?? "",
                        style: TextStyles.whiteTitleStyle,
                      ),
                      Text(
                        Get.arguments["date"] ?? "",
                        style: TextStyles.whiteTitleStyle,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
                child: Image.network(
                  'https://www.urbanbrush.net/web/wp-content/uploads/edd/2022/11/urbanbrush-20221108214712319041.jpg',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 400,
                child: TextField(
                  readOnly: readOnly,
                  maxLines: 200,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                          color:
                              ColorStyles.mainAccent), // 초점이 맞춰진 상태의 테두리 색상 설정
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
