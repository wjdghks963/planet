import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List?> compressImage(File file) async {
  Uint8List? compressedData = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    quality: 80, // 조절 가능한 품질
    minWidth: 500, // 최소 너비
    minHeight: 500, // 최소 높이
  );

  return compressedData;
}