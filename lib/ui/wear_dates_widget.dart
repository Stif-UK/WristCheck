import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/model/watch_methods.dart';

class WearDatesWidget extends StatefulWidget {
  // const WearDatesWidget({Key? key} ) : super(key: key);

  final Watches currentWatch;

  const WearDatesWidget({
    Key? key,
    required this.currentWatch});

  @override
  State<WearDatesWidget> createState() => _WearDatesWidgetState();
}

class _WearDatesWidgetState extends State<WearDatesWidget> {
bool _locked = true;
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
            adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.datelistBannerAdUnitID,
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
  Widget build(BuildContext context) {
    var wearList = widget.currentWatch.wearList;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentWatch.model),
        actions:  [
          //Show lock icon - page cannot be edited if locked (default state)
          InkWell(child: _locked? const Icon(Icons.lock) :  const Icon(Icons.lock_open),
          onTap: (){
            setState(() {
            _locked = !_locked;
            });
            },),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
                child: const Icon(Icons.add,),
            //If page is 'locked' the 'add' button does nothing
            onTap: _locked? null: () async {
                  DateTime? historicDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
                  //if cancelled then date == null
                  if(historicDate == null) return;
                  WatchMethods.attemptToRecordWear(widget.currentWatch, historicDate, false);

                    setState(() {

                    });
                  },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: (){
              WristCheckDialogs.getWearDatesHelpDialog();
            },
          )
        ],
      ),
      body: Column(
        children: [
          purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          Expanded(
            child: Container(
              child:
              wearList.isNotEmpty? ListView.builder(
                itemCount: wearList.length,
                prototypeItem: ListTile(
                  title: Text(wearList.first.toString()),
                ),
                itemBuilder: (context, index) {
                  final item = wearList[index].toString();
                  var date = wearList[index];
                  return Dismissible(

                    key: Key(item),
                    //If page is locked then dates cannot be dismissed, else require a right to left swipe
                    direction: _locked? DismissDirection.none : DismissDirection.endToStart,

                    onDismissed: (direction) {
                      setState(() {
                        wearList.removeAt(index);
                        widget.currentWatch.save();
                        // Then show a snackbar.
                        WristCheckSnackBars.removeWearSnackbar(widget.currentWatch, date);
                      });

                    },
                    // Show a red background as the item is swiped away.
                    background: Container(
                      alignment: Alignment.center,color: Colors.red,
                    child: const Text("Deleting"),),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: Text(WristCheckFormatter.getFormattedDate(wearList[index])),
                    ),
                  );
                },
              ):
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: const Text("No wear dates are tracked yet for this watch\n\nYou can add dates by clicking the 'unlock' icon above and then clicking the + icon\n",
                  textAlign: TextAlign.center,),
              ),
            ),
          ),
        ],
      )
    );


      

  }
}
