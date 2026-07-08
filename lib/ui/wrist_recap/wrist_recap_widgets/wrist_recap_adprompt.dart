import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/remove_ads.dart';

class WristRecapAdprompt extends StatefulWidget {
  WristRecapAdprompt({super.key});

  @override
  State<WristRecapAdprompt> createState() => _WristRecapAdpromptState();
}

class _WristRecapAdpromptState extends State<WristRecapAdprompt> {
  final recapController = Get.put(WristRecapController());
  RewardedAd? _rewardedAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    final adState = Provider.of<AdState>(context, listen: false);
    RewardedAd.load(
      adUnitId: WristCheckConfig.prodBuild == false
          ? adState.getRewardedTestAds
          : AdUnits.recapRewardedAd,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded ad before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      // Increment counter and save timestamp
      int currentCount = WristCheckPreferences.getRewardedAdCount();
      WristCheckPreferences.setRewardedAdCount(currentCount + 1);
      WristCheckPreferences.setLastRecordedAdTimestamp(DateTime.now());
      recapController.updateShowOptionalAdCard(false);
    });
    _rewardedAd = null;
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              //give the Card fixed height
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/icon/drawerheader.png'),
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Thanks for using WristTrack",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Please consider clicking the play button to watch an optional short ad to support the app",
                        softWrap: true,
                      ),
                    ),
                    Obx(
                      () => recapController.expandAdCard.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "WristTrack relies on donations and ad revenue to thrive. Watching an ad means a lot to me, and is hopefully only a small inconvenience to you.",
                                    softWrap: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Alternatively, why not consider unlocking WristTrack Pro with a donation. Click the icon to learn more",
                                    softWrap: true,
                                  ),
                                ),
                                IconButton(
                                  icon: Image.asset(
                                      'assets/customicons/pro_icon.png',
                                      scale: 1.0,
                                      height: 80.0,
                                      width: 80.0,
                                      color: Theme.of(context).hintColor),
                                  onPressed: () => Get.to(RemoveAds()),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => TextButton(
                        child: Text(recapController.expandAdCard.value
                            ? "Show Less"
                            : "Show more"),
                        onPressed: recapController.toggleAdCard,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.rectangleAd),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: _showRewardedAd,
                    icon: Icon(FontAwesomeIcons.play)),
              ),
            ],
          ),
        ));
  }
}
