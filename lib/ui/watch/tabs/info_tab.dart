import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/watch/rows/manufacturer_row.dart';
import 'package:wristcheck/ui/watch/rows/model_row.dart';
import 'package:wristcheck/ui/watch/rows/reference_number_row.dart';
import 'package:wristcheck/ui/watch/rows/serial_number_row.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/list_tile_helper.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class InfoTab extends StatelessWidget {
  InfoTab({super.key,
    required this.manufacturerFieldController,
    required this.modelFieldController,
    required this.serialNumberFieldController,
    required this.referenceNumberFieldController,
    required this.movementFieldController,
    required this.categoryFieldController,
    required this.bodyLarge,
    required this.context,
  });

  final watchViewController = Get.put(WatchViewController());
  final TextEditingController manufacturerFieldController;
  final TextEditingController modelFieldController;
  final TextEditingController serialNumberFieldController;
  final TextEditingController referenceNumberFieldController;
  final TextEditingController movementFieldController;
  final TextEditingController categoryFieldController;
  final TextStyle? bodyLarge;
  final BuildContext context; //Passing context is bad practice! Only used to determine app theme


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ManufacturerRow(enabled: watchViewController.inEditState.value, manufacturerFieldController: manufacturerFieldController),
        ModelRow(enabled: watchViewController.inEditState.value, modelFieldController: modelFieldController),
        _buildCategoryField(),
        SerialNumberRow(serialNumberFieldController: serialNumberFieldController, enabled: watchViewController.inEditState.value, viewState: watchViewController.watchViewState.value),
        ReferenceNumberRow(enabled: watchViewController.inEditState.value, referenceNumberFieldController: referenceNumberFieldController, viewState: watchViewController.watchViewState.value),
        _buildMovementField()
      ],
    );
  }

  Widget _buildMovementField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Movement:",
          textAlign: TextAlign.start,
          style: bodyLarge,),
        Padding(
          padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
          child: DropdownButtonFormField<MovementEnum>(
              dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
              borderRadius: BorderRadius.circular(24),
              menuMaxHeight: 300,
              value: WristCheckFormatter.getMovementEnum(watchViewController.movement.value),
              iconSize: watchViewController.inEditState.value? 24.0: 0.0,
              decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(const Icon(FontAwesomeIcons.gears,), context),
              items: MovementEnum.values.map((movement) {
                return DropdownMenuItem<MovementEnum>(
                    value: movement,
                    child: Text(WristCheckFormatter.getMovementText(movement)));
              }).toList(),
              onChanged: watchViewController.inEditState.value? (movement){
                watchViewController.updateMovement(WristCheckFormatter.getMovementText(movement!));
                movementFieldController.value = TextEditingValue(text:WristCheckFormatter.getMovementText(movement!));
              } : null ),
        ),
      ],
    );
  }

  Widget _buildCategoryField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category:",
          textAlign: TextAlign.start,
          style: bodyLarge,),
        Padding(
          padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
          child: Obx(()=> DropdownButtonFormField<CategoryEnum>(
                dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
                borderRadius: BorderRadius.circular(24),
                menuMaxHeight: 300,
                value: WristCheckFormatter.getCategoryEnum(watchViewController.category.value),
                iconSize: watchViewController.inEditState.value? 24.0: 0.0,
                decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(ListTileHelper.getCategoryIcon(WristCheckFormatter.getCategoryEnum(categoryFieldController.value.text)), context),
                items: CategoryEnum.values.map((category) {
                  return DropdownMenuItem<CategoryEnum>(
                      value: category,
                      child: Text(WristCheckFormatter.getCategoryText(category)));
                }).toList(),
                onChanged: watchViewController.inEditState.value? (category){
                  watchViewController.updateCategory(WristCheckFormatter.getCategoryText(category!));
                  categoryFieldController.value = TextEditingValue(text:WristCheckFormatter.getCategoryText(category!));
                } : null ),
          ),
        ),
      ],
    );
  }

}
