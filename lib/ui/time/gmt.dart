import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

class GMT extends StatelessWidget {
  const GMT({super.key});

  @override
  Widget build(BuildContext context) {
    final timeController = Get.find<TimeController>();
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.gmtTimeOffsetLabel),
              const SizedBox(width: 10),
              Obx(() => DropdownButton<int>(
                    value: timeController.timeOffset.value,
                    items: List.generate(27, (index) => index - 12).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value >= 0 ? "+$value" : "$value"),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        timeController.updateTimeOffset(newValue);
                      }
                    },
                  )),
            ],
          ),
          Obx(
            () => Text(
              timeController.currentGMTtime.value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ],
      ),
    );
  }
}
