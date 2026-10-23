import 'dart:io';
import 'package:wristcheck/model/watches.dart';

class GalleryImageItem {
  final Watches watch;
  final int imageIndex; // 0 for front, 1 for back, 2 for lume
  final File imageFile;

  GalleryImageItem({
    required this.watch,
    required this.imageIndex,
    required this.imageFile,
  });
}
