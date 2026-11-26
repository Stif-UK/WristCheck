import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/more_menu/gallery/gallery.dart';
import 'package:wristcheck/ui/more_menu/timeline/timeline.dart';
import 'package:wristcheck/ui/wrist_recap/animated_recap_preview_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreMenu extends StatefulWidget {
  MoreMenu({super.key});
  final wristCheckController = Get.put(WristCheckController());
  //final remoteConfig = FirebaseRemoteConfig.instance;

  static AdSize adSizeForScreenHeight(double screenHeight) {
    return screenHeight >= 850.0 ? AdSize.largeBanner : AdSize.banner;
  }

  @override
  State<MoreMenu> createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    // widget.showMerch = widget.remoteConfig.getBool("show_merch_link");
    widget.wristCheckController.refreshShowMerchStore();
    widget.wristCheckController.refreshWristRewind2026();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!purchaseStatus && banner == null) {
      final adSize = MoreMenu.adSizeForScreenHeight(MediaQuery.of(context).size.height);
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        if (!mounted) return;
        setState(() {
          banner = BannerAd(
            //Check config to confirm if this is a prod or test app build
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.moreMenuAdUnitID,
              size: adSize,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "more_menu");
    final pagePadding = EdgeInsets.all(10.0);

    return Obx(()=> Column(
        children: [
          Expanded(
            child: Obx(() => SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: pagePadding,
                      child: ListTile(
                        title: Text(AppLocalizations.of(context)!.gallery,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,),
                        trailing: FaIcon(FontAwesomeIcons.images),
                        onTap: ()=> Get.to(() => GalleryV2()),
                      ),
                    ),
                    const Divider(thickness: 2,),
                    Padding(
                      padding: pagePadding,
                      child: ListTile(
                        title: Text(AppLocalizations.of(context)!.timeline,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,),
                        trailing: FaIcon(FontAwesomeIcons.timeline),
                        onTap: ()=> Get.to(() => WristCheckTimeline()),
                      ),
                    ),
                    const Divider(thickness: 2,),
                    if (widget.wristCheckController.showWristRewind2026.value) ...[
                      Padding(
                        padding: pagePadding,
                        child: ListTile(
                          title: Text(
                            '2026 Wrist Rewind',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          trailing: const FaIcon(FontAwesomeIcons.clockRotateLeft),
                          onTap: () async {
                            await analytics.logEvent(name: 'more_menu_wrist_rewind_clicked');
                            Get.to(() => const AnimatedRecapPreviewPage());
                          },
                        ),
                      ),
                      const Divider(thickness: 2,),
                    ],
                    widget.wristCheckController.showMerchStore.value ? Padding(
                      padding: pagePadding,
                      child: ListTile(
                        title: Text(AppLocalizations.of(context)!.merchStore,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,),
                        subtitle: Text(AppLocalizations.of(context)!.opensInBrowser,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,),
                        trailing: FaIcon(FontAwesomeIcons.shirt),
                        onTap: () async {
                          await analytics.logEvent(
                            name: "merch_store_clicked",
                            parameters: {
                              "url": widget.wristCheckController.merchStoreUrl.value
                            },
                          );
                          final Uri url = Uri.parse(widget.wristCheckController.merchStoreUrl.value);
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        }),
                      ) : const SizedBox.shrink(),
                    widget.wristCheckController.showMerchStore.value ? const Divider(thickness: 2,) : const SizedBox.shrink(),
                  ],
                ),
            ),
            ),
          ),
          widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : _buildAdSpace(banner, context),
          const SizedBox(height: 100,)//Ensure ad doesn't hide behind bottom navigation bar
        ],
      ),
    );

  }
}

Widget _buildAdSpace(BannerAd? banner, BuildContext context) {
  final double fallbackHeight =
      MoreMenu.adSizeForScreenHeight(MediaQuery.of(context).size.height).height.toDouble();
  return banner == null
      ? SizedBox(height: fallbackHeight)
      : StatefulBuilder(
          builder: (context, setState) => SizedBox(
            height: banner.size.height.toDouble(),
            child: AdWidget(ad: banner),
          ),
        );
}
