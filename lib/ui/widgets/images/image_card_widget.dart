import 'dart:io';
import 'package:flutter/material.dart';

class ImageCardWidget extends StatelessWidget {
  const ImageCardWidget({required this.image, super.key});

  final File? image;

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: image == null?  const Icon(Icons.add_a_photo_outlined, size: 85):
        Image.file(image!, fit: BoxFit.cover,),
      );
    }
  }
