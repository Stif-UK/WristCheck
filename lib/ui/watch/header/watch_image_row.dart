import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/images_util.dart';

class WatchImageRow extends StatefulWidget {
  WatchImageRow({super.key, required this.currentWatch});
  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;


  @override
  State<WatchImageRow> createState() => _WatchImageRowState();
}

class _WatchImageRowState extends State<WatchImageRow> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      File? image;
      if (widget.watchViewController.watchViewState.value != WatchViewEnum.add) {
        if (widget.currentWatch != null) {
          image = ImagesUtil.getImageSync(widget.currentWatch!, 0);
        }
      } else {
        image = widget.watchViewController.front.value
            ? widget.watchViewController.frontImage.value
            : widget.watchViewController.backImage.value;
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 2,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 6,
            child: Obx(
              () => Container(
                height: 180,
                margin: const EdgeInsets.all(20),
                padding: image == null ? const EdgeInsets.all(40) : null,
                decoration: image == null
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 2,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      )
                    : null,
                child: image == null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.camera_alt, size: 75),
                          widget.watchViewController.front.value
                              ? const Text("Front")
                              : const Text("Back"),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          image,
                          cacheWidth: 500,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                InkWell(
                  child: const Icon(Icons.add_a_photo_outlined),
                  onTap: () async {
                    var imageSource = await ImagesUtil.imageSourcePopUp(context);
                    if (widget.watchViewController.watchViewState.value != WatchViewEnum.add) {
                      await ImagesUtil.pickAndSaveImage(
                        source: imageSource!,
                        currentWatch: widget.currentWatch!,
                        index: 0,
                      );
                    } else {
                      if (widget.watchViewController.front.value) {
                        imageSource != null
                            ? widget.watchViewController.updateFrontImage(
                                await ImagesUtil.pickImage(source: imageSource))
                            : null;
                      } else {
                        imageSource != null
                            ? widget.watchViewController.updateBackImage(
                                await ImagesUtil.pickImage(source: imageSource))
                            : null;
                      }
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: 25),
                IconButton(
                  icon: const Icon(Icons.flip_camera_android_rounded),
                  onPressed: () {
                    widget.watchViewController.updateFrontValue(!widget.watchViewController.front.value);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}