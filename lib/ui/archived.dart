import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/archive_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/watch/watchview.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/images_util.dart';

import 'package:wristcheck/model/enums/watch_status_enum.dart';

class Archived extends StatefulWidget {
  const Archived({Key? key}) : super(key: key);

  @override
  State<Archived> createState() => _ArchivedState();
}

class _ArchivedState extends State<Archived> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final archiveController = Get.put(ArchiveController());
  var watchBox = Boxes.getWatches();
  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!purchaseStatus)
    {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.archivePageBannerAdUnitId,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.largeBanner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "archive");
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(Get.context!)!.archiveScreenTitle),
        actions: [
          IconButton(
              icon: const Icon(Icons.help_outline),
            onPressed: (){
                WristCheckDialogs.getArchivedHelpDialog();
            } )
        ],

      ),
        body: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<Box<Watches>>(
                  valueListenable: watchBox.listenable(),
                  builder: (context, box, _){
                    List<Watches> archiveList = Boxes.getArchivedWatches();



                    return archiveList.isEmpty?Container(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(Get.context!)!.archiveEmptyMessage,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,),
                    ):

                    ListView.separated(
                      itemCount: archiveList.length,
                      itemBuilder: (BuildContext context, int index){
                        final item = archiveList[index].toString();
                        var watch = archiveList.elementAt(index);
                        String? _title = watch.toString();
                        String? _status = WatchStatusEnumExtension.fromDbString(watch.status).toLocalizedString(context);


                        return Dismissible(
                          key: Key(item),
                          direction: DismissDirection.horizontal,

                          child: ListTile(
                            leading: const Icon(Icons.watch),
                            title: Text(_title),
                            subtitle: Text(_status),
                            onTap: () => Get.to(() => WatchView(currentWatch: watch,)),
                          ),

                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              final bool result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(Get.context!)!.archiveDeleteDialogConfirmTitle),
                                      content: Text(
                                          AppLocalizations.of(Get.context!)!.archiveDeleteDialogConfirmText(watch.toString())),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            AppLocalizations.of(Get.context!)!.cancel,                                           ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text(
                                              AppLocalizations.of(Get.context!)!.delete),
                                          onPressed: () async {
                                            await analytics.logEvent(name: "watch_deleted");
                                            setState(() {
                                              archiveList.removeAt(index);
                                              WatchMethods.deleteWatch(watch);
                                              // Then show a snackbar.
                                              WristCheckSnackBars.deleteWatch(
                                                  watch.toString());
                                            });
                                            Navigator.of(context).pop();
                                          },
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)))
                                      ],
                                    );
                                  });
                              return result;
                            } else if (direction == DismissDirection.startToEnd) {
                              final bool result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(Get.context!)!.archiveRestoreDialogTitle),
                                      content: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              AppLocalizations.of(Get.context!)!.archiveRestoreDialogText(watch)),
                                          const SizedBox(height: 10,),
                                          Text(AppLocalizations.of(Get.context!)!.archiveRestoreDialogStatusPicker),
                                          //TODO: Need to ensure space to prevent overflow error
                                          Obx(()=> DropdownButton(
                                                dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
                                                value: archiveController.status.value,
                                                items: WatchStatusEnum.values
                                                    .where((s) => s != WatchStatusEnum.archived)
                                                    .map((status) => DropdownMenuItem(
                                                    value: status.toDbString(),
                                                    child: Text(status.toLocalizedString(context)))

                                                ).toList(),
                                                onChanged: (status) {
                                                  archiveController.updateStatus(status);
                                                }
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            AppLocalizations.of(Get.context!)!.cancel,),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text(
                                            AppLocalizations.of(Get.context!)!.archiveRestoreButtonLabel,
                                          ),
                                          onPressed: () async {
                                            await analytics.logEvent(name: "watch_restored");
                                            setState(() {
                                              //remove from list to remove from page
                                              archiveList.removeAt(index);
                                              //Set watch status
                                              WatchMethods.updateStatus(watch, archiveController.status.value);
                                              // Then show a snackbar.
                                              WristCheckSnackBars.restoreWatch(
                                                  watch.toString(), archiveController.status.value);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              return result;
                            }
                          },

                          background: Container(
                          alignment: Alignment.centerRight,color: Colors.green,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(FontAwesomeIcons.arrowUp, color: Colors.white,),
                              ),
                              Text(AppLocalizations.of(Get.context!)!.archiveBackgroundRestoreLabel, textAlign: TextAlign.start,),
                            ],
                          ),),

                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(AppLocalizations.of(Get.context!)!.archiveBackgroundDeleteLabel, textAlign: TextAlign.end,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(FontAwesomeIcons.trash, color: Colors.white,),
                                )
                              ],
                            ),),
                        );
                      },
                      separatorBuilder: (context, index){
                        return const Divider();
                      },
                    );
                  }


              ),
            ),
            purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildLargeAdSpace(banner, context),
            const SizedBox(height: 100,)
          ],
        )
    );
  }
}
