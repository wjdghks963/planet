import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/controllers/plant_detail_controller.dart';
import 'package:planet/controllers/selected_plant_detail_controller.dart';
import 'package:planet/services/api_diary_form.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/ImageResizer.dart';

class DiaryForm extends StatefulWidget {
  const DiaryForm({super.key});

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {

  final TextEditingController _contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      File imageFile = File(image.path);

      // 이미지 압축 이 데이터를 보낼거임
     // Uint8List? compressedData = await compressImage(imageFile);

      setState(() {
        _pickedImage = XFile(imageFile.path ?? '');
      });
    }
  }

  bool isPublic = false;

  Future<void> postForm(String url, int uid) async {
    // 이미지 압축
    Uint8List? compressedData = await compressImage(_pickedImage as File);

    print(compressedData);

    ApiDiaryForm apiDiaryForm = ApiDiaryForm();
    Response response =
        await apiDiaryForm.postForm(uid, url, compressedData!, "", isPublic);

  }

  @override
  Widget build(BuildContext context) {
    // final PlantDetailViewModel controller = Get.find<PlantDetailViewModel>();
    final SelectedPlantDetailController selectedPlantDetailController =
        Get.find<SelectedPlantDetailController>();

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
                        selectedPlantDetailController.selectedPlant.nickName ??
                            "",
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
                  controller: _contentController,
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
                      borderSide:
                          const BorderSide(color: ColorStyles.mainAccent),
                    ),
                  ),
                  style: const TextStyle(height: 1.5),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextButton(
                  content: "작성 완료",
                  onPressed: () {
                    print("selected ${selectedPlantDetailController.selectedPlant.uid}");
                    postForm(
                        "", selectedPlantDetailController.selectedPlant.uid!);
                  })
            ],
          ),
        ));
  }
}
