import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/components/common/form_textfield.dart';
import 'package:planet/models/api/plant/plant_add.dart';
import 'package:planet/services/plant_api_service.dart';
import 'package:planet/theme.dart';
import 'package:planet/utils/image_resizer.dart';

class AddPlantForm extends StatefulWidget {
  const AddPlantForm({super.key});

  @override
  State<AddPlantForm> createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<AddPlantForm> {
  late TextEditingController nickNameController;
  late TextEditingController scientificNameController;

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _pickedImage = image;
    });
  }

  Future<void> submitPlant() async {
    if (_pickedImage == null) {
      // 이미지가 선택되지 않았다면 경고 메시지 표시
      // 예: ScaffoldMessenger.of(context).showSnackBar(...)
      return;
    }

    String? compressedData = await compressImage(_pickedImage!);

    PlantAdd newPlant = PlantAdd(
      nickNameController.text,
      scientificNameController.text,
      compressedData!,
    );

    // API 호출
    final response = await PostPlantApiClient().addPlant(newPlant);

    if(response.statusCode == 200){
      Get.back();
    }else{
      //TODO:: plant 추가 실패 예외처리
    }

  }

  @override
  void initState() {
    nickNameController = TextEditingController();
    scientificNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nickNameController.dispose();
    scientificNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "식물 추가",
        ),
        body: Container(
          color: BgColor.mainColor,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              Column(
                children: [
                  FormTextField(
                      controller: nickNameController,
                      hintText: "별명",
                      labelText: "이름 (별명)"),
                  const SizedBox(
                    height: 20,
                  ),
                  FormTextField(
                      controller: scientificNameController,
                      hintText: "정확하지 않아도 괜찮습니다.",
                      labelText: "식물 학명"),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  child: _pickedImage != null
                      ? InkWell(
                          onTap: () => getImage(ImageSource.gallery),
                          child: Image.file(
                            File(_pickedImage!.path),
                            fit: BoxFit.fitWidth,
                            height: 300,
                          ),
                        )
                      : InkWell(
                          onTap: () => getImage(ImageSource.gallery),
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
              CustomTextButton(
                  content: "작성 완료",
                  onPressed: () {
                    submitPlant();
                  })
            ],
          ),
        ));
  }
}
