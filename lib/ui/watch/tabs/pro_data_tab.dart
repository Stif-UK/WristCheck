import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
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
    required this.waterResistanceController
  });

  final watchViewController = Get.put(WatchViewController());
  final wristCheckController = Get.put(WristCheckController());
  final TextEditingController caseDiameterController;
  final TextEditingController lugWidthController;
  final TextEditingController lug2lugController;
  final TextEditingController caseThicknessController;
  final TextEditingController waterResistanceController;

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WatchFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          icon: const Icon(FontAwesomeIcons.rulerCombined),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Case Diameter(mm):",
          hintText: "Case Diameter",
          maxLines: 1,
          controller: caseDiameterController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isDouble) {
              return 'Must be numbers only with up to two decimal points';
            }
          },
        ),
        WatchFormField(
          keyboardType: TextInputType.number,
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
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          icon: const Icon(FontAwesomeIcons.ruler),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Lug to Lug(mm):",
          hintText: "Lug to Lug",
          maxLines: 1,
          controller: lug2lugController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isDouble) {
              return 'Must be numbers only with up to two decimal points';
            }
          },
        ),
        WatchFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          icon: const Icon(FontAwesomeIcons.rulerVertical),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Case Thickness(mm):",
          hintText: "Case Thickness",
          maxLines: 1,
          controller: caseThicknessController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isDouble) {
              return 'Must be numbers only with up to two decimal points';
            }
          },
        ),
        WatchFormField(
          keyboardType: TextInputType.number,
          icon: const Icon(FontAwesomeIcons.water),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "Water Resistance (${wristCheckController.waterResistanceUnit.value.name}):",
          hintText: "Water Resistance",
          maxLines: 1,
          controller: waterResistanceController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isServiceNumber) {
              return 'Must be a whole number less than 99';
            }
          },
        ),
      ],
    ),
    );
  }
}
