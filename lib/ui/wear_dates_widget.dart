import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/general_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';


class WearDatesWidget extends StatefulWidget {
  final Watches currentWatch;
  final wristCheckController = Get.put(WristCheckController());


  WearDatesWidget({
    Key? key,
    required this.currentWatch});


  @override
  State<WearDatesWidget> createState() => _WearDatesWidgetState();
}

class _WearDatesWidgetState extends State<WearDatesWidget> {
BannerAd? banner;
bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if(!purchaseStatus)
  {
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.datelistBannerAdUnitID,
            //If the device screen is large enough display a larger ad on this screen
            size: AdSize.banner,
            request: const AdRequest(),
            listener: adState.adListener)
          ..load();
      });
    });
  }
}

@override
void initState() {
  analytics.setAnalyticsCollectionEnabled(true);
  super.initState();
}

final watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "watch_calendar");

    widget.wristCheckController.updateSelectedDate(DateTime.now());
    //Initialise a bool on load - this can be checked in the onViewChanged callback to ensure it is not triggered on first load
    bool _pageLoaded = false;

    return Obx(() => Scaffold(
        appBar: AppBar(
          title: Text(widget.currentWatch.model),
          actions:  [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: (){
                WristCheckDialogs.getWearDatesHelpDialog();
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: widget.wristCheckController.showDateList.value? Icon(FontAwesomeIcons.calendarDay) : Icon(FontAwesomeIcons.list),
          onPressed: () => widget.wristCheckController.updateShowCalendar(!widget.wristCheckController.showDateList.value),
        ),
        body: widget.wristCheckController.showDateList.value?
          _buildListView(widget.currentWatch, context)

            : Column(
          children: [
            purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
            Expanded(
              child: Container(
                child: ValueListenableBuilder(
                  valueListenable: watchBox.listenable(),
                  builder: (context, box, _) {
                    return SfCalendar(
                      view: CalendarView.month,
                      dataSource: _getCalendarDataSource(),
                      monthViewSettings: MonthViewSettings(showAgenda: true,
                          showTrailingAndLeadingDates: false,
                          agendaStyle: AgendaStyle(
                              appointmentTextStyle: Theme.of(context).textTheme.bodyLarge)),
                      initialSelectedDate: DateTime.now(),
                      onTap: (CalendarTapDetails details){
                        //if date cell is tapped on, we set the current selected date
                        widget.wristCheckController.updateSelectedDate(details.date);
                        analytics.logEvent(name: "date_clicked");
                        //if an "appointment" is tapped on, show the details of the event
                        if(details.targetElement == CalendarElement.appointment){
                          analytics.logEvent(name: "appointment_dialog");
                          Appointment currentAppointment = details.appointments!.first;
                          String summary = currentAppointment.subject;
                          Get.defaultDialog(
                              title: WristCheckFormatter.getFormattedDateWithDay(details.date!),
                              content: Column(
                                children: [
                                  Text(summary),
                                ],
                              )
                          );
                        }
                      },
                      //when a date is long pressed, show options to add or delete wears
                      onLongPress: (cal) async {
                        analytics.logEvent(name: "date_longpress");
                        //If current date has no matching wear date offer add date,
                        //otherwise offer delete date option.
                        bool matchedDate = false;
                        DateTime? selectedDate = cal.date;
                        if(selectedDate != null) {
                                  for (DateTime date
                                      in widget.currentWatch.wearList) {
                                    if (await GeneralHelper.dateCompare(
                                        date, selectedDate)) {
                                      matchedDate = true;
                                    }
                                    ;
                                  }
                                }
                        String watchTitle = "${widget.currentWatch.manufacturer} ${widget.currentWatch.model}";

                          Get.defaultDialog(
                            titlePadding: EdgeInsets.all(20.0),
                            title: matchedDate? "Delete Wear from Calendar": "Add Wear to Calendar",
                            content: Column(
                              children: [
                                Text("Date: ${WristCheckFormatter.getFormattedDateWithDay(cal.date!)}"),
                                Text("Watch: $watchTitle"),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(child:
                                  matchedDate? Text("Delete Date") : Text("Track Wear"),
                                    onPressed: () async {
                                    if(matchedDate) {
                                      analytics.logEvent(name: "watch_date_removed");
                                      Get.back();
                                      WatchMethods.removeWearDate(cal.date!, widget.currentWatch);
                                    } else {
                                      analytics.logEvent(name: "watch_date_added");
                                      Get.back();
                                      WatchMethods.attemptToRecordWear(widget.currentWatch, cal.date!, false);
                                    }
                                    },),
                                ),
                                TextButton(child: Text("Cancel"),
                                onPressed: (){
                                  Get.back();
                                },)
                              ],
                            ),


                          );



                      },
                      onViewChanged: (ViewChangedDetails details) {
                        //use pageLoaded to ensure this is not run on first load of the page
                        if(_pageLoaded){
                          widget.wristCheckController.updateSelectedDate(null);
                        }
                        _pageLoaded = true;
                      },
                    );
                  },
                )
              ),
            ),
          ],
        )
      ),
    );


      

  }

//Populate the calendar data
_WatchDataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  String watchTitle = "${widget.currentWatch.manufacturer} ${widget.currentWatch.model}";

  for(DateTime date in widget.currentWatch.wearList){
    appointments.add(
      Appointment(
        isAllDay: true,
          startTime: date,
          endTime: date,
      subject: "$watchTitle worn")
    );
  }
  if(widget.currentWatch.warrantyEndDate != null) {
    appointments.add(
        Appointment(
            isAllDay: true,
            startTime: widget.currentWatch.warrantyEndDate!,
            endTime: widget.currentWatch.warrantyEndDate!,
            subject: "Warranty Expires",
            color: Colors.red
        )
    );
  }
    if(widget.currentWatch.nextServiceDue != null){
      appointments.add(
          Appointment(
              isAllDay: true,
              startTime: widget.currentWatch.nextServiceDue!,
              endTime: widget.currentWatch.nextServiceDue!,
              subject: "Service Due",
              color: Colors.deepPurpleAccent
          )
      );
  }

  return _WatchDataSource(appointments);
}
}

Widget _buildListView(Watches watch, BuildContext context) {
  final wristCheckController = Get.put(WristCheckController());
  var dateList = watch.wearList;
  wristCheckController.updateDateListLength(dateList.length);


  return watch.wearList.length == 0? Center(
    child: Text("No dates recorded for this watch."),
  ): SingleChildScrollView(
    child: Obx(()=> Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("All dates worn", style: Theme.of(context).textTheme.headlineSmall,),
                ),
              ),
              IconButton(
                  icon: wristCheckController.dateAscenting.value? Icon(FontAwesomeIcons.arrowDown91): Icon(FontAwesomeIcons.arrowUp19),
                onPressed: () {
                  wristCheckController.updateDateAscending(!wristCheckController.dateAscenting.value);
                },
              )
            ],
          ),
          Divider(thickness: 2,),
          ListView.builder(
            reverse: wristCheckController.dateAscenting.value,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
            itemCount: wristCheckController.dateListLength.value,//dateList.length,
              itemBuilder: (BuildContext context, int index){
              return Dismissible(
                key: Key(watch.wearList[index].toString()),
                onDismissed: (direction){
                  watch.wearList.removeAt(index);
                  watch.save();
                  wristCheckController.updateDateListLength(watch.wearList.length);
                },
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.calendarDay),
                  title: Text("${WristCheckFormatter.getFormattedDate(watch.wearList[index])}"),
                ),
                background: Container(
                  alignment: Alignment.center,color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Deleting"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(FontAwesomeIcons.trashCan),
                      )
                    ],
                  ),),
              );
              }
          ),
        ],
      ),
    ),
  );
}



class _WatchDataSource extends CalendarDataSource {
  _WatchDataSource(List<Appointment> source){
    appointments = source;
  }
}
