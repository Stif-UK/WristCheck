import 'dart:ffi';

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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.servicePageBannerAdUnitId,
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
    analytics.setCurrentScreen(screenName: "calendar_view");

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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 25.0),
                child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Track Wear", style: TextStyle()),
                      ),
                    onPressed: widget.wristCheckController.selectedDate.value == null || isDateInFuture()? null: (){
                        widget.wristCheckController.updateSelectedWatch(null);
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
                                  // widget.wristCheckController.selectedWatch.value == null?
                                  // ElevatedButton(
                                  //     child: Text("Pick Watch"),
                                  //   onPressed:() {
                                  //       //TODO: Implement ability to select watch
                                  //     widget.wristCheckController
                                  //         .updateSelectedWatch(Boxes
                                  //         .getCollectionWatches()
                                  //         .first);
                                  //   }, ):
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
                                      dropdownDecoratorProps: DropDownDecoratorProps(
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Pick Watch",
                                          hintText: "Search by watch name"
                                        )
                                      ),
                                      items: Boxes.getCollectionWatches(),
                                      onChanged: (watch){
                                        widget.wristCheckController.updateNullWatchMemo(false);
                                        widget.wristCheckController.updateSelectedWatch(watch as Watches?);
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
                    },
                  ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 25.0),
                child: Container(
                    decoration: BoxDecoration(
                      //: Border.all(color: Colors.blue, width: 4),
                      color: Theme.of(context).buttonTheme.colorScheme?.inversePrimary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(icon: Icon(FontAwesomeIcons.businessTime,
                    color: Colors.white, size:15), onPressed: (){},)),
              ),
            )
          ],
        )

      ],
    )


    );
  }

  //Check if selected date is in the future
  bool isDateInFuture(){
    if(widget.wristCheckController.selectedDate.value != null){
      return widget.wristCheckController.selectedDate.value!.isAfter(DateTime.now());
    }
    return false;
  }

  //Populate the calendar data
  _WatchDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];

    //Rough code -
    // 1. getAllWatches in collection, for each watch add all wear dates to an appointment
    //with the subject as the make + model + worn
    // 2. getServiceSchedule subject: Service Due: subject as make + model + service due
    // 3. TODO: Implement warranty schedule

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

    return _WatchDataSource(appointments);
  }
}

class _WatchDataSource extends CalendarDataSource {
  _WatchDataSource(List<Appointment> source){
    appointments = source;
  }
}