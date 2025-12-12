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
      physics: ClampingScrollPhysics(),
      child: Obx(()=>
          RadioGroup(
            groupValue: widget.filterController.basicWearFilter.value,
            onChanged: (value) async {
              await widget.filterController.updateFilterName(value as WearChartOptions);
            },
            child: Column(
              children: [
                RadioListTile(
                    title: const Text("Show all"),
                    value: WearChartOptions.all,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                          title: const Text("This Month"),
                          value: WearChartOptions.thisMonth,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                          title: const Text("Last Month"),
                          value: WearChartOptions.lastMonth,
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
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                          title: const Text("Last Year"),
                          value: WearChartOptions.lastYear,
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 2,),
                // Row(
                //   children: [
                //     Text("test"),
                //
                //   ],
                // ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                          title: const Text("Last 30 days"),
                          value: WearChartOptions.last30days,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                          title: const Text("Last 90 days"),
                          value: WearChartOptions.last90days,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                          title: const Text("Last 365 days"),
                          value: WearChartOptions.last365days,
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 2,),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                          title: const Text("Since Last Purchase"),
                          value: WearChartOptions.lastPurchase,
                      ),
                    ),
                  ],
                ),
                RadioListTile(
                    title: const Text("Select Month/Year"),
                    value: WearChartOptions.manual,
                ),
                RadioListTile(
                  title: const Text("Between selected dates"),
                  value: WearChartOptions.betweenDates,
                ),
                const Divider(thickness: 2,),
                widget.filterController.basicWearFilter.value == WearChartOptions.manual? _getManualPickers()
                : const SizedBox(height: 0,),
                widget.filterController.basicWearFilter.value == WearChartOptions.betweenDates? _getBetweenDatesPickers()
                    : const SizedBox(height: 0,)
              ],
            ),
          ),
      ),
    );
  }

  Widget _getManualPickers() {
    return Column(
      children: [
      Row(
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
      ]),
      Row(
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
      )
    ]);
  }

  Widget _getBetweenDatesPickers(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text("Start Date:", style: Theme.of(context).textTheme.bodyLarge,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(()=>ElevatedButton(child: Text(WristCheckFormatter.getFormattedDate(widget.filterController.startDate.value)),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(DateTime.now().year -10, DateTime.now().month, DateTime.now().day), lastDate: DateTime.now());
                    if(pickedDate != null) widget.filterController.updateStartDate(pickedDate);
                  },
              ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text("  End Date:", style: Theme.of(context).textTheme.bodyLarge,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(()=> ElevatedButton(child: Text(WristCheckFormatter.getFormattedDate(widget.filterController.endDate.value)),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(DateTime.now().year -10, DateTime.now().month, DateTime.now().day), lastDate: DateTime.now());
                    if(pickedDate != null) widget.filterController.updateEndDate(pickedDate);
                  }, ),
              ),
            ),

          ],
        ),
        const SizedBox(height: 50,)
  ],
      );
}
}
