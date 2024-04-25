import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

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



  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "calendar_view");

    //initialise date and watch values
    widget.wristCheckController.updateSelectedDate(DateTime.now());
    widget.wristCheckController.updateSelectedWatch(null);

    return  Obx(()=> Column(
      children: [
        widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
        Expanded(
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: _getCalendarDataSource(),
            monthViewSettings: MonthViewSettings(showAgenda: true,
                showTrailingAndLeadingDates: false,
                agendaStyle: AgendaStyle(
                    appointmentTextStyle: Theme.of(context).textTheme.bodyLarge)),
            initialSelectedDate: DateTime.now(),
            onTap: (CalendarTapDetails details){
              widget.wristCheckController.updateSelectedDate(details.date);
            },
            onViewChanged: (ViewChangedDetails details) {
              //TODO: update this to not null the date on initial page load
              //widget.wristCheckController.updateSelectedDate(null);
              print("View swiped - new date: ${widget.wristCheckController.selectedDate.value}");
              },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 25.0),
              child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Track Wear", style: Theme.of(context).textTheme.bodyLarge,),
                    ),
                  onPressed: widget.wristCheckController.selectedDate.value == null || isDateInFuture()? null: (){
                      Get.defaultDialog(
                        title: "Track Wear",
                        content: Obx(
                            ()=>Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Date: ${WristCheckFormatter.getFormattedDateWithDay(widget.wristCheckController.selectedDate.value!)}"),
                                ),
                                widget.wristCheckController.selectedWatch.value == null?
                                ElevatedButton(
                                    child: Text("Pick Watch"),
                                  onPressed:() {
                                      //TODO: Implement ability to select watch
                                    widget.wristCheckController
                                        .updateSelectedWatch(Boxes
                                        .getCollectionWatches()
                                        .first);
                                  }, ):
                                Text("Watch: ${widget.wristCheckController.selectedWatch.value!.model}"),
                            ]),
                        ),
                        textConfirm: "Track",
                        textCancel: "Cancel",
                        onCancel: () async {
                          //Delay prevents the view changing to show the button before the dialog exits
                          Get.back();
                          await Future.delayed(const Duration(milliseconds: 1000));
                          widget.wristCheckController.updateSelectedWatch(null);
                        }

                      );
                  },
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
