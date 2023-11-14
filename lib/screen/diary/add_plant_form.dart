import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planet/components/common/CustomAppBar.dart';
import 'package:planet/components/common/custom_text_button.dart';
import 'package:planet/components/common/form_textfield.dart';
import 'package:planet/controllers/plant_detail_controller.dart';
import 'package:planet/theme.dart';

class AddPlantForm extends StatefulWidget {
  const AddPlantForm({super.key});

  @override
  State<AddPlantForm> createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<AddPlantForm> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  void getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _pickedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nickNameController = TextEditingController();
    TextEditingController scientificNameController = TextEditingController();

    final PlantDetailViewModel controller = Get.find<PlantDetailViewModel>();

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
              CustomTextButton(content: "작성 완료", onPressed: () {})
            ],
          ),
        ));
  }
}
