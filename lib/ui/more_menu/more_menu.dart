import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/more_menu/gallery/gallery.dart';

class MoreMenu extends StatefulWidget {
  MoreMenu({super.key});
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<MoreMenu> createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
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
            //Check config to confirm if this is a prod or test app build
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.moreMenuAdUnitID,
              //If the device screen is large enough display a larger ad on this screen
              size: MediaQuery.of(context).size.height > 500.0
                  ? AdSize.mediumRectangle
                  : AdSize.largeBanner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagePadding = EdgeInsets.all(10.0);

    return Obx(()=> Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: pagePadding,
                  child: ListTile(
                    title: Text("Gallery",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,),
                    trailing: Icon(FontAwesomeIcons.images),
                    onTap: ()=> Get.to(Gallery()),
                  ),
                ),
                const Divider(thickness: 2,),
              ],
            ),
          ),
          widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : _buildAdSpace(banner, context),
        ],
      ),
    );

  }
}

Widget _buildAdSpace(BannerAd? banner, BuildContext context){
  return banner == null
      ? SizedBox(height: MediaQuery.of(context).size.height > 500.0? 250: 100,)
      : StatefulBuilder(
      builder: (context, setState) => Container(
    height: MediaQuery.of(context).size.height > 500.0? 250: 100,
    child: AdWidget(ad: banner!),
  ));
}
