import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
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
        _manufacturerRow(),
        _modelRow(),
        _buildCategoryField(),
        _serialNumberRow(),
        _referenceNumberRow(),
        _buildMovementField()
      ],
    );
  }

  Widget _manufacturerRow(){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.building),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Manufacturer:",
      hintText: "Manufacturer",
      maxLines: 1,
      controller: manufacturerFieldController,
      textCapitalization: TextCapitalization.words,
      validator: (String? val) {
        if(!val!.isAlphaNumericIncAccentsAndSymbolsAndNotEmpty) {
          return 'Manufacturer missing or invalid characters included';
        }
      },
    );
  }

  Widget _modelRow(){
    return WatchFormField(
      icon: const Icon(Icons.watch),
      enabled: watchViewController.inEditState.value,
      fieldTitle: "Model:",
      hintText: "Model",
      maxLines: 1,
      controller: modelFieldController,
      textCapitalization: TextCapitalization.words,
      validator: (String? val) {
        if(!val!.isAlphaNumericIncAccentsAndSymbolsAndNotEmpty) {
          return 'Model is missing or invalid characters included';
        }
      },
    );
  }

  Widget _serialNumberRow(){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.barcode),
      enabled: watchViewController.inEditState.value,
      fieldTitle: watchViewController.watchViewState.value == WatchViewEnum.add? "Serial Number (Optional)": "Serial Number:",
      hintText: "Serial Number",
      maxLines: 1,
      controller: serialNumberFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isAlphaNumericWithSymbolsOrEmpty) {
          return 'Serial Number contains invalid characters';
        }
      },
    );
  }

  Widget _referenceNumberRow(){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.hashtag),
      enabled: watchViewController.inEditState.value,
      fieldTitle: watchViewController.watchViewState.value == WatchViewEnum.add? "Reference Number (Optional)": "Reference Number:",
      hintText: "Reference Number",
      maxLines: 1,
      controller: referenceNumberFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isAlphaNumericWithSymbolsOrEmpty) {
          return 'Reference Number is missing or invalid characters included';
        }
      },
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
