import 'dart:io';
import 'package:flutter/material.dart';

class ImageCardWidget extends StatelessWidget {
  const ImageCardWidget({required this.image, super.key});

  final File? image;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final int targetCacheWidth = (screenWidth * 0.9 * devicePixelRatio).round().clamp(400, 1200);

    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: image == null
          ? const Icon(Icons.add_a_photo_outlined, size: 85)
          : Image.file(
              image!,
              cacheWidth: targetCacheWidth,
              fit: BoxFit.cover,
            ),
    );
  }
}
