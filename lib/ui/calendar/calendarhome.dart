import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/ui/ServicingWidget.dart';
import 'package:wristcheck/ui/calendar/schedule_view.dart';

class CalendarHome extends StatefulWidget {
  CalendarHome({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<CalendarHome> createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> widget.wristCheckController.calendarOrService.value? ScheduleView() : ServicingWidget()
    );
  }
}
