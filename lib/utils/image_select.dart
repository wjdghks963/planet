import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planet/components/common/custom_select_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<bool> requestImgPermission() async {
  PermissionStatus status;

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (androidInfo.version.sdkInt < 33) {
      status = await Permission.storage.status;
    } else {
      status = await Permission.photos.status;
    }
    if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus newStatus;
      try {
        if (Platform.isAndroid && androidInfo.version.sdkInt < 33) {
          newStatus = await Permission.storage.request();
        } else {
          newStatus = await Permission.photos.request();
        }

        if (newStatus.isGranted) {
          return true; // 권한 허용됨
        } else {
          var result = await Get.dialog(const CustomSelectDialog(
            title: '설정',
            content: '앨범 접근에 문제가 있습니다.\n\n설정으로 가시겠습니까?',
          ));
          if (result == true) {
            await openAppSettings();
          }
          return false; // 권한 거부됨
        }
      } catch (e) {
        print(e.toString());
      }
    }
  } else {
    status = await Permission.photos.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus newStatus;
      try {
        newStatus = await Permission.photos.request();
        if (newStatus.isGranted) {
          return true; // 권한 허용됨
        } else {
          var result = await Get.dialog(const CustomSelectDialog(
            title: '설정',
            content: '앨범 접근에 문제가 있습니다.\n\n설정으로 가시겠습니까?',
          ));
          if (result == true) {
            await openAppSettings();
          }
          return false; // 권한 거부됨
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  return true; // 권한 이미 허용됨
}
