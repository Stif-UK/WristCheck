import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_home.dart';

class WristRecapNotification extends StatelessWidget {
  WristRecapNotification({super.key});
  final wristCheckController = Get.put(WristCheckController());

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          //SizedBox to give card height
           SizedBox(height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 0.0),
                  child: IconButton(icon: Icon(FontAwesomeIcons.xmark),
                  onPressed: () => wristCheckController.dismissRecapNotification(DateTime.now()),),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image:  AssetImage('assets/icon/drawerheader.png'),
                    fit: BoxFit.contain
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.recapNotificationTitle, style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 5,),
                  Text(DateTime.now().month == 1 
                      ? AppLocalizations.of(context)!.recapNotificationSubtitleAnnual 
                      : AppLocalizations.of(context)!.recapNotificationSubtitle, 
                    style: Theme.of(context).textTheme.bodyMedium,)
                ],
              ),
            ),
          ),
          IconButton(
              icon: Icon(FontAwesomeIcons.chevronRight),
              onPressed: () {
                var now = DateTime.now();
                var lastMonth = DateTime(now.year, now.month - 1);
                wristCheckController.dismissRecapNotification(now);
                Get.to(() => WristRecapHome(
                  month: lastMonth.month, 
                  year: lastMonth.year, 
                  monthView: now.month != 1,
                ));
              }),
        ],
      ),

    );
  }
}
