import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/model/enums/month_list.dart';


class BasicFiltersWidget extends StatefulWidget {
  BasicFiltersWidget({super.key});
  final filterController = Get.put(FilterController());


  @override
  State<BasicFiltersWidget> createState() => _BasicFiltersWidgetState();
}

class _BasicFiltersWidgetState extends State<BasicFiltersWidget> {
  @override
  Widget build(BuildContext context) {
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
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                        title: const Text("Since Last Purchase"),
                        value: WearChartOptions.lastPurchase,
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
}
