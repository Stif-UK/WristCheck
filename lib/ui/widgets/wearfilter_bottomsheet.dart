import 'package:choice/choice.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/month_list.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/ui/chart_options.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class WearFilterBottomSheet extends StatefulWidget {
  WearFilterBottomSheet({Key? key}) : super(key: key);
  final filterController = Get.put(FilterController());

  @override
  State<WearFilterBottomSheet> createState() => _WearFilterBottomSheetState();
}

class _WearFilterBottomSheetState extends State<WearFilterBottomSheet> with SingleTickerProviderStateMixin{
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final List<Tab> myTabs = <Tab>[
    Tab(
      icon: Icon(FontAwesomeIcons.chartSimple),
      text: "Basic" ,
      iconMargin: EdgeInsets.only(bottom: 5),),
    Tab(
        icon: Icon(FontAwesomeIcons.magnifyingGlassChart),
        text: "Advanced",
        iconMargin: EdgeInsets.only(bottom: 5),)
  ];

  late TabController _tabController;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    _tabController = TabController(length: myTabs.length, vsync: this);
    super.initState();
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "wearchart_bottomsheet");
    _tabController.index = widget.filterController.lastFilterTabIndex.value;


    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height*0.8,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text("Wear Chart Filters",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.gear),
                  onPressed: (){
                  Get.to(() => ChartOptions());
                  }),
            ],
          ),
          const Divider(thickness: 2,),
          Expanded(
            //height: 550,
            //width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    labelColor: Theme.of(context).textTheme.bodyMedium!.color,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50), // Creates border
                        color: Theme.of(context).highlightColor,),
                  tabs: myTabs,
                  onTap: (index) {
                    widget.filterController.updateLastFilterTabIndex(index);
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: myTabs.map((Tab tab){
                      return Center(
                        child: tab.text == "Basic"? _buildBasicFilter(): _buildAdvancedFilter()
                      );
                    }).toList(),
                  ),
                )
              ],
            )
          )
          //Header#
          ]
      ),

    );
  }

  Widget _buildBasicFilter() {

    return SingleChildScrollView(
      child: Obx(()=>
        Column(
          children: [
            RadioListTile(
                title: const Text("Show all"),
                value: WearChartOptions.all,
                groupValue: widget.filterController.basicWearFilter.value,
                onChanged: (value) async {
                  await widget.filterController.updateFilterName(value as WearChartOptions);
                }
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                      title: const Text("This Month"),
                      value: WearChartOptions.thisMonth,
                      groupValue: widget.filterController.basicWearFilter.value,
                      onChanged: (value) async {
                        await widget.filterController.updateFilterName(value as WearChartOptions);
                      }
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                      title: const Text("Last Month"),
                      value: WearChartOptions.lastMonth,
                      groupValue: widget.filterController.basicWearFilter.value,
                      onChanged: (value) async {
                        await widget.filterController.updateFilterName(value as WearChartOptions);
                      }
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                      title: const Text("This Year"),
                      value: WearChartOptions.thisYear,
                      groupValue: widget.filterController.basicWearFilter.value,
                      onChanged: (value) async {
                        await widget.filterController.updateFilterName(value as WearChartOptions);
                      }
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                      title: const Text("Last Year"),
                      value: WearChartOptions.lastYear,
                      groupValue: widget.filterController.basicWearFilter.value,
                      onChanged: (value) async {
                        await widget.filterController.updateFilterName(value as WearChartOptions);
                      }
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                      title: const Text("Last 30 days"),
                      value: WearChartOptions.last30days,
                      groupValue: widget.filterController.basicWearFilter.value,
                      onChanged: (value) async {
                        await widget.filterController.updateFilterName(value as WearChartOptions);
                      }
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                      title: const Text("Last 90 days"),
                      value: WearChartOptions.last90days,
                      groupValue: widget.filterController.basicWearFilter.value,
                      onChanged: (value) async {
                        await widget.filterController.updateFilterName(value as WearChartOptions);
                      }
                  ),
                ),
              ],
            ),
            RadioListTile(
                title: const Text("Select Month/Year"),
                value: WearChartOptions.manual,
                groupValue: widget.filterController.basicWearFilter.value,
                onChanged: (value) async {
                  await widget.filterController.updateFilterName(value as WearChartOptions);
                }
            ),
            widget.filterController.basicWearFilter.value == WearChartOptions.manual? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Month:", style: Theme.of(context).textTheme.bodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: DropdownButton(
                    value: widget.filterController.selectedMonth.value,
                    items: MonthList.values.map((month) => DropdownMenuItem(
                      value: month,
                        child:Text(WristCheckFormatter.getMonthText(month),) )).toList(),
                    onChanged: (month){
                      widget.filterController.updateSelectedMonth(month as MonthList);
                    },
                  ),
                )
              ],
            ): const SizedBox(height: 0,),
            widget.filterController.basicWearFilter.value == WearChartOptions.manual? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Year:", style: Theme.of(context).textTheme.bodyLarge,),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: DropdownButton(
                    value: widget.filterController.selectedYear.value,
                    items: widget.filterController.yearList.map((year) => DropdownMenuItem(
                        value: year,
                        child:Text(year) )).toList(),
                    onChanged: (year){
                      widget.filterController.updateSelectedYear(year as String);
                    },
                  ),
                )
              ],
            ): const SizedBox(height: 0,)
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFilter() {
    // return Center(
    //   child: Text("Page 2"),
    // );
    return ListView(
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
    void setSelectedValue(ChartGrouping? grouping){
      widget.filterController.updateChartGrouping(grouping!);
    }

    return Column(
      children: [
        InlineChoice.single(
          clearable: true,
          value: widget.filterController.chartGrouping.value,
            itemCount: ChartGrouping.values.length,
            onChanged: setSelectedValue,
            itemBuilder: (state, i) {
              return ChoiceChip(
                selectedColor: Colors.red,
                selected: state.selected(ChartGrouping.values[i]),
                onSelected: state.onSelected(ChartGrouping.values[i]),
                label: Text(ChartGrouping.values[i].name),
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
            value: widget.filterController.selectedCategories.value,
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
