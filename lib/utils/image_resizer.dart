import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<String?> compressImage(XFile xFile) async {

  File file = File(xFile.path);
  Uint8List? compressedData = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    quality: 40, // 조절 가능한 품질
    minWidth: 500, // 최소 너비
    minHeight: 500, // 최소 높이
  );

  return base64Encode(compressedData!);
}
