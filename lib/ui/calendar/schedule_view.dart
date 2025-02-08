import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ScheduleView extends StatefulWidget {
  ScheduleView({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!purchaseStatus)
    {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.calendarAdUnitID,
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
    analytics.logScreenView(screenName: "calendar_view");

    //initialise date and watch values
    widget.wristCheckController.updateSelectedDate(DateTime.now());
    widget.wristCheckController.updateSelectedWatch(null);
    //Initialise a bool on load - this can be checked in the onViewChanged callback to ensure it is not triggered on first load
    bool _pageLoaded = false;

    return  Obx(()=> Column(
      children: [
        widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
        Expanded(
          child: ValueListenableBuilder(
        valueListenable: watchBox.listenable(),
        builder: (context, box, _) {
          return Obx(()=> SfCalendar(
              firstDayOfWeek: widget.wristCheckController.firstDayOfWeek.value,
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
                //if an "appointment" is tapped on, show the details of the event
                if(details.targetElement == CalendarElement.appointment){
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
              onViewChanged: (ViewChangedDetails details) {
                //use pageLoaded to ensure this is not run on first load of the page
                if(_pageLoaded){
                  print("tracking view change");
                  widget.wristCheckController.updateSelectedDate(null);
                  print("View swiped - new date: ${widget.wristCheckController.selectedDate.value}");
                }
                print("setting page loaded to true");
                _pageLoaded = true;
              },
            ),
          );

        },


        )


        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
                child: const SizedBox(width: 0,)),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Remove Wear", style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodySmall?.fontSize
                        )),
                      ),
                      onPressed: widget.wristCheckController.selectedDate.value == null || areWearsEmpty()? null: () async {
                        widget.wristCheckController.updateSelectedWatch(null);
                        _generateDeleteDialog();
                        await analytics.logEvent(name: "calendar_remove_wear");
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 25.0),
                    child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Track Wear", style: TextStyle()),
                          ),
                        onPressed: widget.wristCheckController.selectedDate.value == null || isDateInFuture()? null: () async {
                            widget.wristCheckController.updateSelectedWatch(null);
                            _generateTrackDialog();
                            await analytics.logEvent(name: "calendar_wear");
                        },
                      ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 25.0),
                child: Container(
                    decoration: BoxDecoration(
                      //: Border.all(color: Colors.blue, width: 4),
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(icon: Icon(FontAwesomeIcons.businessTime,
                    color: Colors.white,size: 20),
                      onPressed: () async {
                      widget.wristCheckController.updateCalendarOrService(false);
                      await analytics.logEvent(name: "change_cal_view",
                      parameters: {
                        "open_cal": false
                      });
                      },)),
              ),
            )
          ],
        )

      ],
    )


    );
  }

  //Tracking dialog pop-up
  _generateTrackDialog(){
    Get.defaultDialog(
        title: "Track Wear",
        barrierDismissible: false,
        content: Obx(
              ()=>Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Date: ${WristCheckFormatter.getFormattedDateWithDay(widget.wristCheckController.selectedDate.value!)}"),
                ),
                widget.wristCheckController.nullWatchMemo.value ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Please select a watch",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                )
                    : SizedBox(height: 0,),
                //Implement watch picker
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownSearch<Watches>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                    ),
                    decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            labelText: "Pick Watch",
                            hintText: "Search by watch name"
                        )
                    ),

                    items: (filter, infiniteScrollProps) =>  Boxes.sortWatchBox(Boxes.getCollectionWatches(), widget.wristCheckController.watchboxOrder.value!),
                    onChanged: (watch){
                      widget.wristCheckController.updateNullWatchMemo(false);
                      widget.wristCheckController.updateSelectedWatch(watch);
                      print(widget.wristCheckController.selectedWatch.value);
                    },


                  ),
                )
              ]),
        ),
        textConfirm: "Track",
        textCancel: "Cancel",
        onConfirm: (){
          //Code to track wear
          if(widget.wristCheckController.selectedWatch.value == null){
            widget.wristCheckController.updateNullWatchMemo(true);
            print("No watch selected");
            //Please select a watch
          } else {
            widget.wristCheckController.updateNullWatchMemo(false);
            print("Attempting to track wear");
            Get.back();
            WatchMethods.attemptToRecordWear(
                widget.wristCheckController
                    .selectedWatch.value!,
                widget.wristCheckController
                    .selectedDate.value!,
                false);

          }
        },
        onCancel: () async {
          //Delay prevents the view changing to show the button before the dialog exits
          Get.back();
          await Future.delayed(const Duration(milliseconds: 1000));
          widget.wristCheckController.updateNullWatchMemo(false);
          widget.wristCheckController.updateSelectedWatch(null);
        }

    );
  }

  //Tracking dialog pop-up
   _generateDeleteDialog(){
    Get.defaultDialog(
        title: "Delete Wear Record",
        barrierDismissible: false,
        content: Obx(
              ()=>Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Date: ${WristCheckFormatter.getFormattedDateWithDay(widget.wristCheckController.selectedDate.value!)}"),
                ),
                widget.wristCheckController.nullWatchMemo.value ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Please select a watch",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                )
                    : SizedBox(height: 0,),
                //Implement watch picker
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownSearch<Watches>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                    ),
                    decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                            labelText: "Pick Watch",
                            hintText: "Search by watch name"
                        )
                    ),
                    //Only display watches with a date that matches
                    items: (filter, infiniteScrollProps) => Boxes.getWatchesWornOnDate(Boxes.getCollectionAndSoldWatches(),
                        widget.wristCheckController.selectedDate.value!.year,
                        widget.wristCheckController.selectedDate.value!.month,
                        widget.wristCheckController.selectedDate.value!.day),
                    onChanged: (watch){
                      widget.wristCheckController.updateNullWatchMemo(false);
                      widget.wristCheckController.updateSelectedWatch(watch);
                      print(widget.wristCheckController.selectedWatch.value);
                    },


                  ),
                )
              ]),
        ),
        textConfirm: "Remove Date",
        textCancel: "Cancel",
        onConfirm: (){
          //Code to delete wear
          if(widget.wristCheckController.selectedWatch.value == null){
            widget.wristCheckController.updateNullWatchMemo(true);
            print("No watch selected");
            //Please select a watch
          } else {
            widget.wristCheckController.updateNullWatchMemo(false);
            print("Attempting to delete wear");
            Get.back();
            //TODO: Remove wear code
            WatchMethods.removeWearDate(widget.wristCheckController.selectedDate.value!, widget.wristCheckController.selectedWatch.value!);

          }
        },
        onCancel: () async {
          //Delay prevents the view changing to show the button before the dialog exits
          Get.back();
          await Future.delayed(const Duration(milliseconds: 1000));
          widget.wristCheckController.updateNullWatchMemo(false);
          widget.wristCheckController.updateSelectedWatch(null);
        }

    );
  }

  //Check if selected date is in the future
  bool isDateInFuture(){
    if(widget.wristCheckController.selectedDate.value != null){
      return widget.wristCheckController.selectedDate.value!.isAfter(DateTime.now());
    }
    return false;
  }

  //Check if data has wears
  bool areWearsEmpty(){
    List<Watches> watchList = Boxes.getCollectionAndSoldWatches();
    if(widget.wristCheckController.selectedDate.value == null){
      return true;
    }
    int? Day = widget.wristCheckController.selectedDate.value?.day;
    int? Month = widget.wristCheckController.selectedDate.value?.month;
    int? Year = widget.wristCheckController.selectedDate.value?.year;
    for(Watches watch in watchList){
      for(DateTime date in watch.wearList){
        if(date.day == Day && date.month == Month && date.year == Year){
          return false;
        }
      }
    }

    return true;
  }

  //Populate the calendar data
  _WatchDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];


    List<Watches> watchSchedule = Boxes.getCollectionWatches();
    for(Watches watch in watchSchedule){
      String watchTitle = "${watch.manufacturer} ${watch.model}";

      for(DateTime wearDate in watch.wearList){
        appointments.add(Appointment(
          isAllDay: true,
            startTime: wearDate,
           endTime: wearDate,
          subject: "$watchTitle"
        ));
      }
    }

    List<Watches> soldSchedule = Boxes.getSoldWatches();
    for(Watches watch in soldSchedule){
      String watchTitle = "${watch.manufacturer} ${watch.model}";

      for(DateTime wearDate in watch.wearList){
        appointments.add(Appointment(
            isAllDay: true,
            startTime: wearDate,
            endTime: wearDate,
            subject: "$watchTitle (Sold)",
            color: Colors.deepOrangeAccent
        ));
      }
    }

    List<Watches> serviceSchedule = Boxes.getServiceSchedule();
    for(Watches watch in serviceSchedule){
      String watchTitle = "${watch.manufacturer} ${watch.model}";
      appointments.add(Appointment(
          isAllDay: true,
          startTime: watch.nextServiceDue!,
          endTime: watch.nextServiceDue!,
        subject: "$watchTitle Service Due",
        color: Colors.red

      ));
    }

    List<Watches> warrantySchedule = Boxes.getWarrantySchedule();
    for(Watches watch in warrantySchedule){
      String watchTitle = "${watch.manufacturer} ${watch.model}";
      appointments.add(Appointment(
          isAllDay: true,
          startTime: watch.warrantyEndDate!,
          endTime: watch.warrantyEndDate!,
          subject: "$watchTitle Warranty Expires",
          color: Colors.deepPurpleAccent

      ));
    }

    return _WatchDataSource(appointments);
  }
}

class _WatchDataSource extends CalendarDataSource {
  _WatchDataSource(List<Appointment> source){
    appointments = source;
  }
}
