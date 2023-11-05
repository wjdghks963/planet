import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/controllers/plant_detail_controller.dart';
import 'package:planet/theme.dart';

class DiaryForm extends StatefulWidget {
  const DiaryForm({super.key});

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _pickedImage = image;
    });
  }

  bool isPublic = false;

  @override
  Widget build(BuildContext context) {
    final PlantDetailViewModel controller = Get.find<PlantDetailViewModel>();

    return Scaffold(
        appBar: CustomAppBar(
          title: "일지 작성",
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
                  Column(
                    children: [
                      const Text(
                        "공개",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Switch(
                          value: isPublic,
                          activeColor: ColorStyles.mainAccent,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value;
                            });
                          })
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  child: _pickedImage != null
                      ? InkWell(
                          onTap: () => getImage(ImageSource.camera),
                          child: Image.file(
                            File(_pickedImage!.path),
                            fit: BoxFit.fitWidth,
                            height: 300,
                          ),
                        )
                      : InkWell(
                          onTap: () => getImage(ImageSource.camera),
                          child: Container(
                            color: Colors.white,
                            height: 300,
                            padding: EdgeInsets.all(100),
                            child: SvgPicture.asset('assets/icons/image.svg'),
                          ),
                        )),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 400,
                child: TextField(
                  maxLines: 200,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "기록하고 싶은 내용을 입력하세요.",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                          color:
                              ColorStyles.mainAccent),
                    ),
                  ),
                  style: TextStyle(height: 1.5),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // 원하는 라운드 값을 설정
                    ),
                    backgroundColor: ColorStyles.mainAccent),
                onPressed: () {
                  // 버튼을 누를 때 수행할 동작
                },
                child: const Text(
                  '작성 완료',
                  style: TextStyles.buttonTextStyle,
                ),
              )
            ],
          ),
        ));
  }
}
