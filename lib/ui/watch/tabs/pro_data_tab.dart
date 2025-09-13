import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/winder_direction_enum.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/watch/rows/case_diameter_row.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class ProDataTab extends StatelessWidget {
  ProDataTab({
    super.key,
    required this.caseDiameterController,
    required this.lugWidthController,
    required this.lug2lugController,
    required this.caseThicknessController,
    required this.waterResistanceController,
    required this.caseMaterialController,
    required this.winderTPDController,
    required this.winderDirectionController,
    required this.dateComplicationController
  });

  final watchViewController = Get.put(WatchViewController());
  final wristCheckController = Get.put(WristCheckController());
  final TextEditingController caseDiameterController;
  final TextEditingController lugWidthController;
  final TextEditingController lug2lugController;
  final TextEditingController caseThicknessController;
  final TextEditingController waterResistanceController;
  final TextEditingController caseMaterialController;
  final TextEditingController winderTPDController;
  final TextEditingController winderDirectionController;
  final TextEditingController dateComplicationController;

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCaseDetailsSection(),
        const Divider(thickness: 2,),
        _buildWinderSettingsRow(),

      ],
    ),
    );
  }

  Widget _buildCaseDetailsSection(){
    return ExpansionTile(
        title: Text("Watch Details",
          textAlign: TextAlign.start,
          style: Theme.of(Get.context!).textTheme.headlineSmall,),
      children: [
        CaseDiameterRow(enabled: watchViewController.inEditState.value, caseDiameterController: caseDiameterController),
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
            if(!val!.isUnboundPositiveInteger) {
              return 'Must be a whole number';
            }
          },
        ),
        _buildCaseMaterialField(),
        _buildDateComplicationField()
      ],
    );
  }

  Widget _buildCaseMaterialField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Case Material:",
          textAlign: TextAlign.start,
          style: Theme.of(Get.context!).textTheme.bodyLarge,),
        Padding(
          padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
          child: DropdownButtonFormField<CaseMaterialEnum>(
              dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
              borderRadius: BorderRadius.circular(24),
              menuMaxHeight: 300,
              value: WristCheckFormatter.getCaseMaterialEnum(watchViewController.caseMaterial.value),
              iconSize: watchViewController.inEditState.value? 24.0: 0.0,
              decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(const Icon(Icons.watch), Get.context!),
              items: CaseMaterialEnum.values.map((material) {
                return DropdownMenuItem<CaseMaterialEnum>(
                    value: material,
                    child: Text(WristCheckFormatter.getCaseMaterialText(material)));
              }).toList(),
              onChanged: watchViewController.inEditState.value? (material){
                watchViewController.updateCaseMaterial(WristCheckFormatter.getCaseMaterialText(material!));
                caseMaterialController.value = TextEditingValue(text:WristCheckFormatter.getCaseMaterialText(material!));
              } : null ),
        ),
      ],
    );
  }

  Widget _buildWinderSettingsRow(){
    return ExpansionTile(
        title: Text("Winder Settings",
          textAlign: TextAlign.start,
          style: Theme.of(Get.context!).textTheme.headlineSmall,),
      children: [
        WatchFormField(
          keyboardType: TextInputType.number,
          icon: const Icon(FontAwesomeIcons.gaugeHigh),
          enabled: watchViewController.inEditState.value,
          fieldTitle: "TPD:",
          hintText: "TPD",
          maxLines: 1,
          controller: winderTPDController,
          textCapitalization: TextCapitalization.none,
          validator: (String? val) {
            if(!val!.isUnboundPositiveInteger) {
              return 'Must be a whole number';
            }
          },
        ),
        _buildWinderDirectionField(),
      ],
    );

  }

  Widget _buildWinderDirectionField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Winder Direction:",
          textAlign: TextAlign.start,
          style: Theme.of(Get.context!).textTheme.bodyLarge,),
        Padding(
          padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
          child: Obx(()=> DropdownButtonFormField<WinderDirectionEnum>(
                dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
                borderRadius: BorderRadius.circular(24),
                menuMaxHeight: 300,
                value: WristCheckFormatter.getWinderDirectionEnum(watchViewController.winderDirection.value),
                iconSize: watchViewController.inEditState.value? 24.0: 0.0,
                decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(WristCheckFormatter.getWinderDirectionIcon(WristCheckFormatter.getWinderDirectionEnum(watchViewController.winderDirection.value)), Get.context!),
                items: WinderDirectionEnum.values.map((direction) {
                  return DropdownMenuItem<WinderDirectionEnum>(
                      value: direction,
                      child: Text(WristCheckFormatter.getWinderDirectionText(direction)));
                }).toList(),
                onChanged: watchViewController.inEditState.value? (direction){
                  watchViewController.updateWinderDirection(WristCheckFormatter.getWinderDirectionText(direction!));
                  winderDirectionController.value = TextEditingValue(text:WristCheckFormatter.getWinderDirectionText(direction!));
                } : null ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateComplicationField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Date Complication:",
          textAlign: TextAlign.start,
          style: Theme.of(Get.context!).textTheme.bodyLarge,),
        Padding(
          padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
          child: DropdownButtonFormField<DateComplicationEnum>(
              dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
              borderRadius: BorderRadius.circular(24),
              menuMaxHeight: 300,
              value: WristCheckFormatter.getDateComplicationEnum(watchViewController.dateComplication.value),
              iconSize: watchViewController.inEditState.value? 24.0: 0.0,
              decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(const Icon(FontAwesomeIcons.calendarDay), Get.context!),
              items: DateComplicationEnum.values.map((dateType) {
                return DropdownMenuItem<DateComplicationEnum>(
                    value: dateType,
                    child: Text(WristCheckFormatter.getDateComplicationName(dateType)));
              }).toList(),
              onChanged: watchViewController.inEditState.value? (dateType){
                watchViewController.updateDateComplication(WristCheckFormatter.getDateComplicationName(dateType!));
                dateComplicationController.value = TextEditingValue(text:WristCheckFormatter.getDateComplicationName(dateType));
              } : null ),
        ),
      ],
    );
  }
}


