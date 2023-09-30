import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class ValueData extends StatelessWidget {
  ValueData({Key? key}) : super(key: key);

  final wristCheckController = Get.put(WristCheckController());

  @override
  Widget build(BuildContext context) {
    int collectionCost = WatchMethods.calculateCollectionCost();
    String locale = WristCheckFormatter.getLocaleString(wristCheckController.locale.value);

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(FontAwesomeIcons.dollarSign),
                title: const Text("Current Collection Cost"),
                subtitle: Text(collectionCost == 0 ? "No value captured": NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0).format(collectionCost),),
              ),
              const Divider(thickness: 2,),
            ],
          ),
        )
        ],
      );
  }
}
