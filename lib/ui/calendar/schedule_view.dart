import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
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
  //Initialise a bool on load - this can be checked in the onViewChanged callback to ensure it is not triggered on first load
  bool _pageLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!purchaseStatus && banner == null) {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        if (!mounted || banner != null) return;
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
    analytics.logScreenView(screenName: "calendar_view");
    widget.wristCheckController.updateSelectedDate(DateTime.now());
    widget.wristCheckController.updateSelectedWatch(null);
    widget.wristCheckController.updateNullWatchMemo(false);
    super.initState();
  }

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  final watchBox = Boxes.getWatches();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Obx(() {
      final bool isExpanded = widget.wristCheckController.isCalendarExpanded.value;

      return LayoutBuilder(
        builder: (context, constraints) {
          double calendarHeight;
          if (isExpanded) {
            calendarHeight = constraints.maxHeight - 250;
            if (calendarHeight < 550) {
              calendarHeight = 550;
            }
          } else {
            calendarHeight = constraints.maxHeight - 250;
            if (calendarHeight < 200) {
              calendarHeight = 200;
            }
          }

          return SingleChildScrollView(
            physics: isExpanded ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value
                    ? const SizedBox(height: 0)
                    : AdWidgetHelper.buildSmallAdSpace(banner, context),
                SizedBox(
                  height: calendarHeight,
                  child: ValueListenableBuilder(
                    valueListenable: watchBox.listenable(),
                    builder: (context, box, _) {
                      return Obx(
                        () => SfCalendar(
                          key: const ValueKey('schedule_sf_calendar'),
                          firstDayOfWeek: widget.wristCheckController.firstDayOfWeek.value,
                          view: CalendarView.month,
                          dataSource: _getCalendarDataSource(),
                          monthViewSettings: MonthViewSettings(
                            showAgenda: true,
                            showTrailingAndLeadingDates: false,
                            agendaStyle: AgendaStyle(
                              appointmentTextStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          initialSelectedDate: DateTime.now(),
                          onTap: (CalendarTapDetails details) {
                            //if date cell is tapped on, we set the current selected date
                            widget.wristCheckController.updateSelectedDate(details.date);
                            //if an "appointment" is tapped on, show the details of the event
                            if (details.targetElement == CalendarElement.appointment) {
                              Appointment currentAppointment = details.appointments!.first;
                              String summary = currentAppointment.subject;
                              Get.defaultDialog(
                                title: WristCheckFormatter.getFormattedDateWithDay(details.date!),
                                content: Column(
                                  children: [
                                    Text(summary),
                                  ],
                                ),
                              );
                            }
                          },
                          onViewChanged: (ViewChangedDetails details) {
                            //use pageLoaded to ensure this is not run on first load of the page
                            if (_pageLoaded) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  widget.wristCheckController.updateSelectedDate(null);
                                }
                              });
                            }
                            _pageLoaded = true;
                          },
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).buttonTheme.colorScheme?.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: FaIcon(
                              isExpanded ? FontAwesomeIcons.compress : FontAwesomeIcons.expand,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () async {
                              widget.wristCheckController.toggleCalendarExpanded();
                              await analytics.logEvent(
                                name: "toggle_calendar_expand",
                                parameters: {
                                  "expanded": widget.wristCheckController.isCalendarExpanded.value ? "true" : "false",
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(l!.trackWear, textAlign: TextAlign.center),
                              ),
                              onPressed: widget.wristCheckController.selectedDate.value == null || isDateInFuture()
                                  ? null
                                  : () async {
                                      final DateTime? targetDate = widget.wristCheckController.selectedDate.value;
                                      if (targetDate == null) return;
                                      _generateTrackDialog(targetDate);
                                      await analytics.logEvent(name: "calendar_wear");
                                    },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 25.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  l.removeWear,
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: widget.wristCheckController.selectedDate.value == null || areWearsEmpty()
                                  ? null
                                  : () async {
                                      final DateTime? targetDate = widget.wristCheckController.selectedDate.value;
                                      if (targetDate == null) return;
                                      _generateDeleteDialog(targetDate);
                                      await analytics.logEvent(name: "calendar_remove_wear");
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
                            color: Theme.of(context).buttonTheme.colorScheme?.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.businessTime,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () async {
                              widget.wristCheckController.updateCalendarOrService(false);
                              await analytics.logEvent(
                                name: "change_cal_view",
                                parameters: {"open_cal": false},
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 90),
              ],
            ),
          );
        },
      );
    });
  }

  //Tracking dialog pop-up
  void _generateTrackDialog(DateTime selectedDate) {
    final l = AppLocalizations.of(context)!;
    Watches? dialogSelectedWatch;
    bool showNullWatchError = false;
    StateSetter? dialogSetState;

    Get.defaultDialog(
      title: l.trackWear,
      barrierDismissible: false,
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          dialogSetState = setDialogState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${l.date} ${WristCheckFormatter.getFormattedDateWithDay(selectedDate)}"),
              ),
              if (showNullWatchError)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    l.pleaseSelectAWatch,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                )
              else
                const SizedBox(height: 0),
              //Implement watch picker
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<Watches>(
                  selectedItem: dialogSelectedWatch,
                  compareFn: (watch1, watch2) => watch1.key == watch2.key,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: l.pickWatch,
                      hintText: l.searchByName,
                    ),
                  ),
                  items: (filter, infiniteScrollProps) => Boxes.sortWatchBox(
                    Boxes.getCollectionAndOnLoanWatches(),
                    widget.wristCheckController.watchboxOrder.value!,
                  ),
                  onChanged: (watch) {
                    setDialogState(() {
                      showNullWatchError = false;
                      dialogSelectedWatch = watch;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
      textConfirm: l.track,
      textCancel: l.cancel,
      onConfirm: () async {
        //Code to track wear
        if (dialogSelectedWatch == null) {
          dialogSetState?.call(() {
            showNullWatchError = true;
          });
          //Please select a watch
        } else {
          final chosenWatch = dialogSelectedWatch!;
          Get.back();
          await WatchMethods.attemptToRecordWear(
            chosenWatch,
            selectedDate,
            false,
          );
        }
      },
      onCancel: () {},
    );
  }

  //Tracking dialog pop-up
  void _generateDeleteDialog(DateTime selectedDate) {
    final l = AppLocalizations.of(context)!;
    Watches? dialogSelectedWatch;
    bool showNullWatchError = false;
    StateSetter? dialogSetState;

    Get.defaultDialog(
      title: l.deleteWear,
      barrierDismissible: false,
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          dialogSetState = setDialogState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${l.date} ${WristCheckFormatter.getFormattedDateWithDay(selectedDate)}"),
              ),
              if (showNullWatchError)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    l.pleaseSelectAWatch,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                )
              else
                const SizedBox(height: 0),
              //Implement watch picker
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<Watches>(
                  selectedItem: dialogSelectedWatch,
                  compareFn: (watch1, watch2) => watch1.key == watch2.key,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: l.pickWatch,
                      hintText: l.searchByName,
                    ),
                  ),
                  //Only display watches with a date that matches
                  items: (filter, infiniteScrollProps) => Boxes.getWatchesWornOnDate(
                    Boxes.getValidToHaveWornWatches(),
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                  ),
                  onChanged: (watch) {
                    setDialogState(() {
                      showNullWatchError = false;
                      dialogSelectedWatch = watch;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
      textConfirm: l.removeDate,
      textCancel: l.cancel,
      onConfirm: () {
        //Code to delete wear
        if (dialogSelectedWatch == null) {
          dialogSetState?.call(() {
            showNullWatchError = true;
          });
          //Please select a watch
        } else {
          final chosenWatch = dialogSelectedWatch!;
          Get.back();
          WatchMethods.removeWearDate(selectedDate, chosenWatch);
        }
      },
      onCancel: () {},
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
    List<Watches> watchList = Boxes.getValidToHaveWornWatches();
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
    final l = AppLocalizations.of(context);
    List<Appointment> appointments = <Appointment>[];


    List<Watches> watchSchedule = Boxes.getCollectionWatches();
    for(Watches watch in watchSchedule){

      for(DateTime wearDate in watch.wearList){
        appointments.add(Appointment(
          isAllDay: true,
            startTime: wearDate,
           endTime: wearDate,
          subject: watch.toString()
        ));
      }
    }

    List<Watches> soldSchedule = Boxes.getSoldWatches();
    for(Watches watch in soldSchedule){

      for(DateTime wearDate in watch.wearList){
        appointments.add(Appointment(
            isAllDay: true,
            startTime: wearDate,
            endTime: wearDate,
            subject: "${watch.toString()} ${l!.soldSuffix}",
            color: Colors.deepOrangeAccent
        ));
      }
    }

    List<Watches> retiredSchedule = Boxes.getRetiredWatches();
    for(Watches watch in retiredSchedule){

      for(DateTime wearDate in watch.wearList){
        appointments.add(Appointment(
            isAllDay: true,
            startTime: wearDate,
            endTime: wearDate,
            subject: "${watch.toString()} ${l!.retiredSuffix}",
            color: Colors.green
        ));
      }
    }

    List<Watches> onLoanSchedule = Boxes.getOnLoanWatches();
    for(Watches watch in onLoanSchedule){

      for(DateTime wearDate in watch.wearList){
        appointments.add(Appointment(
            isAllDay: true,
            startTime: wearDate,
            endTime: wearDate,
            subject: "${watch.toString()} ${l!.onLoanSuffix}",
            color: Colors.brown
        ));
      }
    }

    List<Watches> serviceSchedule = Boxes.getServiceSchedule();
    for(Watches watch in serviceSchedule){
      appointments.add(Appointment(
          isAllDay: true,
          startTime: watch.nextServiceDue!,
          endTime: watch.nextServiceDue!,
        subject: "${watch.toString()} ${l!.serviceDue}",
        color: Colors.red

      ));
    }

    List<Watches> warrantySchedule = Boxes.getWarrantySchedule();
    for(Watches watch in warrantySchedule){
      appointments.add(Appointment(
          isAllDay: true,
          startTime: watch.warrantyEndDate!,
          endTime: watch.warrantyEndDate!,
          subject: "${watch.toString()} ${l!.warrantyExpires}",
          color: Colors.deepPurpleAccent

      ));
    }

    List<Watches> preOrderSchedule = Boxes.getPreOrderWatches();
    for(Watches watch in preOrderSchedule){
      if(watch.deliveryDate != null) {
        appointments.add(Appointment(
            isAllDay: true,
            startTime: watch.deliveryDate!,
            endTime: watch.deliveryDate!,
            subject: "${watch.toString()} ${l!.deliveryExpected}",
            color: Colors.grey
        ));
      }
    }

    return _WatchDataSource(appointments);
  }
}

class _WatchDataSource extends CalendarDataSource {
  _WatchDataSource(List<Appointment> source){
    appointments = source;
  }
}
