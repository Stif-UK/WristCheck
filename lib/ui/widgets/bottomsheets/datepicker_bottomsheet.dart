import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/datepicker_controller.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class DatePickerBottomSheet extends StatelessWidget {
  DatePickerBottomSheet({super.key, required this.currentWatch});
  final Watches currentWatch;

  final pickerController = Get.put(DatePickerController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white38,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text("Date Picker"),
              Card(
                child: Obx(() =>
                    SwitchListTile(
                        title: const Text("Selection Mode"),
                        subtitle: pickerController.allowRange.value
                            ? const Text(
                            "Range (select start and end of range)")
                            : const Text("Individual (pick multiple dates)\n"),
                        //TODO: Implement controller to manage this view via GET
                        value: pickerController.allowRange.value,
                        onChanged: (test) {
                          pickerController.toggleAllowRange();
                        }),
                ),
              ),
              Obx(() =>
                  SfDateRangePicker(
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        firstDayOfWeek: WristCheckPreferences
                            .getFirstDayOfWeek()),
                    selectionMode: pickerController.allowRange.value
                        ? DateRangePickerSelectionMode.range
                        : DateRangePickerSelectionMode.multiple,
                    showTodayButton: true,
                    showActionButtons: true,
                    showNavigationArrow: true,
                    //onSelectionChanged: _onSelectionChanged,
                    onSubmit: (dates) async {
                      //TODO: Externalise this into a method call
                      //First check our dates list isn't null
                      if(dates != null) {
                        //Next ensure we have a list of dates
                        if (dates.runtimeType == PickerDateRange) {
                          PickerDateRange subList = dates as PickerDateRange;
                          dates = _getDateListFromRange(subList.startDate, subList.endDate);
                        }
                        //finally add the list of dates to the watch, first checking we now have a list
                        Map<String, List<DateTime>> results = {};
                        if(dates.runtimeType == List<DateTime>){
                          results = await WatchMethods.recordMultipleWearDates(currentWatch, dates as List<DateTime>);
                        }

                        List<DateTime> successes = results["Success"]!;
                        List<DateTime> duplicates = results["Duplicate"]!;
                        List<DateTime> futures = results["In Future"]!;


                        //Close the picker
                        Navigator.pop(context);
                        //Show pop-up if errors identified
                        if(duplicates.isNotEmpty || futures.isNotEmpty){
                          //TODO: Trigger a pop-up with details of failed dates
                          showModalBottomSheet(context: context,
                              builder: (context) => SingleChildScrollView(
                                physics: ClampingScrollPhysics(),
                                child: Container(
                                  //TODO: Improve the UI - "some dates failed to save"
                                  decoration: BoxDecoration(
                                    color: Colors.white38,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Text("There was a problem with some of the dates",
                                          style: Theme.of(context).textTheme.bodyLarge,),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemCount: duplicates.length,
                                          itemBuilder: (context, index) => ListTile(
                                            leading: Icon(FontAwesomeIcons.clone, color: Colors.red,),
                                        subtitle: const Text("Date already exists"),
                                            title: Text(WristCheckFormatter.getFormattedDate(duplicates[index])),
                                                                    )),
                                      ListView.builder(
                                        shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemCount: futures.length,
                                          itemBuilder: (context, index) => ListTile(
                                            leading: Icon(FontAwesomeIcons.hourglass, color: Colors.red,),
                                            subtitle: const Text("Date is in the future"),
                                            title: Text(WristCheckFormatter.getFormattedDate(futures[index])),
                                          ))
                                    ],
                                  ),
                                ),
                              ));
                        }

                    }
                  },
                    onCancel: () => Navigator.pop(context),


                  ),
              )
            ],
          )),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
    print(args.value);
  }

  /// Generates a list of DateTime objects from [start] to [end] inclusive.
  /// Throws [ArgumentError] if start or end is null, or if end is before start.
  List<DateTime> _getDateListFromRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      throw ArgumentError('Start and end dates must not be null.');
    }
    if (end.isBefore(start)) {
      throw ArgumentError('End date must be on or after the start date.');
    }

    List<DateTime> dates = [];
    DateTime current = DateTime(start.year, start.month, start.day);

    while (!current.isAfter(end)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }
}
