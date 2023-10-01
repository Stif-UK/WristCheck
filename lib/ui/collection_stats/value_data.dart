import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/value_stats_help_copy.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class ValueData extends StatelessWidget {
  ValueData({Key? key}) : super(key: key);

  final wristCheckController = Get.put(WristCheckController());

  @override
  Widget build(BuildContext context) {
    int collectionCost = WatchMethods.calculateCollectionCost(false);
    int totalSpend = WatchMethods.calculateCollectionCost(true);
    int totalSoldValue = WatchMethods.calculateSoldIncome();
    int resaleRatio = WatchMethods.calculateResaleRatio();
    String locale = WristCheckFormatter.getLocaleString(wristCheckController.locale.value);

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(FontAwesomeIcons.dollarSign),
                title: const Text("Current Collection Cost"),
                subtitle: Text(collectionCost == 0 ? "No value captured": NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0).format(collectionCost),
                style: Theme.of(context).textTheme.bodyLarge,),
                trailing: IconButton(
                  icon: const Icon(FontAwesomeIcons.question),
                  onPressed: (){
                    ValueDataHelpDialogs.getCurrentCollectionCostHelp();
                  },
                ),
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(FontAwesomeIcons.sackDollar),
                title: const Text("Total Collection Spend"),
                subtitle: Text(totalSpend == 0 ? "No value captured": NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0).format(totalSpend),
                  style: Theme.of(context).textTheme.bodyLarge,),
                trailing: IconButton(
                  icon: const Icon(FontAwesomeIcons.question),
                  onPressed: (){
                    ValueDataHelpDialogs.getTotalCollectionSpendHelp();
                  },
                ),
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(FontAwesomeIcons.handHoldingDollar),
                title: const Text("Total Sold Value"),
                subtitle: Text(totalSoldValue == 0 ? "No value captured": NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0).format(totalSoldValue),
                  style: Theme.of(context).textTheme.bodyLarge,),
                trailing: IconButton(
                  icon: const Icon(FontAwesomeIcons.question),
                  onPressed: (){
                    ValueDataHelpDialogs.getTotalSoldValueHelp();
                  },
                ),
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(FontAwesomeIcons.moneyBillTransfer),
                title: const Text("Average Resale %"),
                subtitle: Text("Resale Ratio = $resaleRatio%",
                  style: Theme.of(context).textTheme.bodyLarge,),
                trailing: IconButton(
                  icon: const Icon(FontAwesomeIcons.question),
                  onPressed: (){
                    ValueDataHelpDialogs.getAverageResaleHelp();
                  },
                ),
              )
            ],
          ),
        )
        ],
      );
  }
}
