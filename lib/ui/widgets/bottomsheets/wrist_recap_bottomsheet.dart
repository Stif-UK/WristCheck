import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/ui/widgets/wrist_track_bottom_nav_bar.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristRecapBottomsheet extends StatelessWidget {
  WristRecapBottomsheet({super.key});

  final WristRecapController controller = Get.put(WristRecapController());

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = WristTrackBottomNavBar.isLargeScreen(context);
    final l = AppLocalizations.of(context)!;

    return Material(
      color: Get.isDarkMode ? Colors.grey[600] : Colors.white38,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.recapOptionsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(thickness: 2),
            Expanded(
              child: Obx(() => ListView(
                    children: [
                      RadioGroup<WristRecapEnums>(
                        groupValue: controller.selectedRecapOption.value,
                        onChanged: (WristRecapEnums? value) {
                          controller.setRecapOption(value);
                        },
                        child: Column(
                          children: WristRecapEnums.values.map((option) {
                            return RadioListTile<WristRecapEnums>(
                              title: Text(option.toLocalizedString(context)),
                              value: option,
                              selected:
                                  controller.selectedRecapOption.value == option,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      ),
                      if (controller.selectedRecapOption.value ==
                          WristRecapEnums.betweenDates) ...[
                        const Divider(thickness: 2),
                        ListTile(
                          title: Text(l.startDate),
                          subtitle: Text(
                            WristCheckFormatter.getFormattedDate(
                              controller.startDate.value,
                            ),
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: controller.startDate.value,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              controller.updateStartDate(picked);
                            }
                          },
                        ),
                        ListTile(
                          title: Text(l.endDate),
                          subtitle: Text(
                            WristCheckFormatter.getFormattedDate(
                              controller.endDate.value,
                            ),
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: controller.endDate.value,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              controller.updateEndDate(picked);
                            }
                          },
                        ),
                      ],
                      if (isLargeScreen) ...[
                        const Divider(thickness: 2),
                        SwitchListTile(
                          title: Text(l.recapPackChartsTitle),
                          subtitle: Text(l.recapPackChartsSubtitle),
                          value: controller.packCharts.value,
                          onChanged: (bool value) {
                            controller.updatePackCharts(value);
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  )),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
