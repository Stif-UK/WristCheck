import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/string_extension.dart';

class ProDataTab extends StatelessWidget {
  ProDataTab({
    super.key,
    required this.caseDiameterController,
    required this.lugWidthController,
    required this.lug2lugController,
    required this.caseThicknessController,
  });

  final watchViewController = Get.put(WatchViewController());
  final TextEditingController caseDiameterController;
  final TextEditingController lugWidthController;
  final TextEditingController lug2lugController;
  final TextEditingController caseThicknessController;

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WatchFormField(
          icon: const Icon(FontAwesomeIcons.rulerCombined),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Case Diameter(mm):",
          hintText: "Case Diameter",
          maxLines: 1,
          controller: caseDiameterController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isDouble) {
              return 'Must be numbers only with up to one decimal point';
            }
          },
        ),
        WatchFormField(
          icon: const Icon(FontAwesomeIcons.rulerHorizontal),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Lug Width(mm):",
          hintText: "Lug Width",
          maxLines: 1,
          controller: lugWidthController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isServiceNumber) {
              return 'Must be a whole number less than 99';
            }
          },
        ),
        WatchFormField(
          icon: const Icon(FontAwesomeIcons.ruler),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Lug to Lug(mm):",
          hintText: "Lug to Lug",
          maxLines: 1,
          controller: lug2lugController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isDouble) {
              return 'Must be numbers only with up to one decimal point';
            }
          },
        ),
        WatchFormField(
          icon: const Icon(FontAwesomeIcons.rulerVertical),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Case Thickness(mm):",
          hintText: "Case Thickness",
          maxLines: 1,
          controller: caseThicknessController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isDouble) {
              return 'Must be numbers only with up to one decimal point';
            }
          },
        ),
      ],
    ),
    );
  }
}
