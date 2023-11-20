import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? imgUrl;
  final double? height;

  const CustomImage({super.key, required this.imgUrl, this.height});

  @override
  Widget build(BuildContext context) {
    if (imgUrl == null) {
      return Image.asset(
        'assets/images/alter_image.png',
        width: double.infinity,
        height: height ?? 300,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        imgUrl!,
        width: double.infinity,
        height: height ?? 300,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child; // Here the image loaded successfully
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset(
            'assets/images/alter_image.png',
            width: double.infinity,
            height: height ?? 300,
            fit: BoxFit.cover,
          );
        },
      );
    }
    ;
  }
}
