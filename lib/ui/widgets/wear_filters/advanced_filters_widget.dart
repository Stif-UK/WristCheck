import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class AdvancedFiltersWidget extends StatefulWidget {
  AdvancedFiltersWidget({super.key});
  final filterController = Get.put(FilterController());
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<AdvancedFiltersWidget> createState() => _AdvancedFiltersWidgetState();
}

class _AdvancedFiltersWidgetState extends State<AdvancedFiltersWidget> {
  @override
  Widget build(BuildContext context) {
    return  ListView(
      children: [
        ListTile(
          title: Text("Reset to Defaults"),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(FontAwesomeIcons.filterCircleXmark),
          ),
          onTap: () => widget.filterController.resetToDefaults(),
        ),
        const Divider(thickness: 2,),
        Obx(()=> SwitchListTile(
          title: Text("Chart Grouping"),
          value: widget.filterController.pickGrouping.value,
          onChanged: (newValue){
            widget.filterController.updatePickGrouping(newValue);
            //When grouping is de-selected, reset grouping selection to default watch view
            if(!newValue){
              widget.filterController.updateChartGrouping(ChartGrouping.watch);
            }
          },

        ),
        ),
        Obx(() => widget.filterController.pickGrouping.value? _buildGroupingSelection(): const SizedBox(height: 0,)),
        const Divider(thickness: 2,),
        Obx(()=> SwitchListTile(
          title: Text("Include Current Collection"),
          value: widget.filterController.includeCollection.value,
          onChanged: (newValue){
            widget.filterController.updateIncludeCollection(newValue);
          },
        )

        ),
        const Divider(thickness: 2,),
        Obx(()=> SwitchListTile(
          title: Text("Include Sold Watches"),
          value: widget.filterController.includeSold.value ,
          onChanged: (newValue){
            widget.filterController.updateIncludeSold(newValue);
          },
        ),
        ),
        const Divider(thickness: 2,),
        Obx(()=> SwitchListTile(
          title: Text("Include Retired Watches"),
          value: widget.filterController.includeRetired.value ,
          onChanged: (newValue){
            widget.filterController.updateIncludeRetired(newValue);
          },
        ),
        ),
        const Divider(thickness: 2,),
        Obx(()=> SwitchListTile(
          title: Text("Include Archived Watches"),
          value: widget.filterController.includeArchived.value ,
          onChanged: (newValue){
            widget.filterController.updateIncludeArchived(newValue);
          },
        ),
        ),
        const Divider(thickness: 2,),
        Obx(()=> SwitchListTile(
          title: Text("Filter by Category"),
          value: widget.filterController.filterByCategory.value,
          onChanged: (newValue){
            widget.filterController.updateFilterByCategory(newValue);
            if(!newValue){
              widget.filterController.resetCategoryFilter();
            }
          },
        )
        ),
        const Divider(thickness: 2,),
        Obx(() => widget.filterController.filterByCategory.value? _buildCategorySelection() : const SizedBox(height: 0,),),
        Obx(() => widget.filterController.filterByCategory.value? const Divider(thickness: 2,): const SizedBox(height: 0,)),

        Obx(()=> SwitchListTile(
          title: Text("Filter by Movement"),
          value: widget.filterController.filterByMovement.value,
          onChanged: (newValue){
            widget.filterController.updateFilterByMovement(newValue);
            if(!newValue){
              widget.filterController.resetMovementFilter();
            }
          },
        )
        ),
        const Divider(thickness: 2,),
        Obx(() => widget.filterController.filterByMovement.value? _buildMovementSelection() : const SizedBox(height: 0,),),
        Obx(() => widget.filterController.filterByMovement.value? const Divider(thickness: 2,): const SizedBox(height: 0,)),

      ],
    );
  }

  Widget _buildGroupingSelection(){

    //Create a list of grouping values, minus the 'Pro' values
    //if the app is non-pro this is used in place of the full list in the chip choice
    List<ChartGrouping> groupList = List.from(ChartGrouping.values);
    groupList.remove(ChartGrouping.caseDiameter);
    groupList.remove(ChartGrouping.lug2lug);
    groupList.remove(ChartGrouping.lugWidth);
    groupList.remove(ChartGrouping.caseThickness);

    void setSelectedValue(ChartGrouping? grouping){
      widget.filterController.updateChartGrouping(grouping!);
    }

    return Column(
      children: [
        InlineChoice.single(
            clearable: true,
            value: widget.filterController.chartGrouping.value,
            itemCount: widget.wristCheckController.isAppPro.value? ChartGrouping.values.length : groupList.length,
            onChanged: setSelectedValue,
            itemBuilder: (state, i) {
              return ChoiceChip(
                selectedColor: Colors.red,
                selected: state.selected(ChartGrouping.values[i]),
                onSelected: state.onSelected(ChartGrouping.values[i]),
                label: Text(WristCheckFormatter.getChartGroupingText(ChartGrouping.values[i])),
              );
            },
            listBuilder: ChoiceList.createWrapped()
        )
      ],
    );
  }

  Widget _buildCategorySelection(){

    void setSelectedValue(List<CategoryEnum> value) {
      widget.filterController.updateSelectedCategories(value);
    }
    return Column(
      children: [
        InlineChoice<CategoryEnum>.multiple(
            clearable: true,
            value: widget.filterController.selectedCategories,
            itemCount: CategoryEnum.values.length,
            onChanged: setSelectedValue,
            itemBuilder: (state, i) {
              return ChoiceChip(
                selectedColor: Colors.red,
                selected: state.selected(CategoryEnum.values[i]),
                onSelected: state.onSelected(CategoryEnum.values[i]),
                label: Text(WristCheckFormatter.getCategoryText(CategoryEnum.values[i])),
              );
            },
            listBuilder: ChoiceList.createWrapped()
        )
      ],
    );
  }

  Widget _buildMovementSelection(){

    void setSelectedValue(List<MovementEnum> value) {
      widget.filterController.updateSelectedMovements(value);
    }

    return Column(
      children: [
        InlineChoice<MovementEnum>.multiple(
            clearable: true,
            value: widget.filterController.selectedMovements,
            itemCount: MovementEnum.values.length,
            onChanged: setSelectedValue,
            itemBuilder: (state, i) {
              return ChoiceChip(
                selectedColor: Colors.red,
                selected: state.selected(MovementEnum.values[i]),
                onSelected: state.onSelected(MovementEnum.values[i]),
                label: Text(WristCheckFormatter.getMovementText(MovementEnum.values[i])),
              );
            },
            listBuilder: ChoiceList.createWrapped()
        )
      ],
    );
  }
}
