import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/api/purchase_api.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/remove_ads_copy.dart';
import 'package:wristcheck/ui/widgets/paywall_widget.dart';

class RemoveAds extends StatefulWidget {
  RemoveAds({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<RemoveAds> createState() => _RemoveAdsState();
}

class _RemoveAdsState extends State<RemoveAds> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "remove_ads");
    return Obx(
        () => Scaffold(
        appBar: AppBar(
          title: widget.wristCheckController.isAppPro.value? RemoveAdsCopy.getPageTitleSupporter() :RemoveAdsCopy.getPageTitle(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: widget.wristCheckController.isAppPro.value? RemoveAdsCopy.getSupporterMainCopy(context) : RemoveAdsCopy.getRemoveAdsMainCopy(context)),
                  ),
                  const Divider(thickness: 2,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 40, 8, 40),
                    child: OutlinedButton(
                        onPressed:() async {
                          analytics.logEvent(name: "check_offers");
                          fetchOffers();
                        },

                        child: widget.wristCheckController.isAppPro.value? RemoveAdsCopy.getButtonLabelSupporter() : RemoveAdsCopy.getButtonLabel()),
                  )

                ],
              ),
              const Divider(thickness: 2,),
              //If the app is not pro, then show 'restore purchase' button.
              widget.wristCheckController.isAppPro.value? SizedBox(height: 0,) :
              TextButton(onPressed: () async {
                if(await PurchaseApi.restorePurchases()){
                  await analytics.logEvent(name: "restore_purchases",
                  parameters: {
                    "success": "true"
                  });
                  //purchase is restored
                  widget.wristCheckController.updateAppPurchaseStatus();
                  Get.defaultDialog(
                    title: "Purchase Restored",
                    middleText: "You're now ad free!",
                    );
                } else {
                  //purchase restore failed
                  await analytics.logEvent(name: "restore_purchases",
                      parameters: {
                        "success": "false"
                      });
                  Get.defaultDialog(
                    title: "Restore Failed",
                    middleText: "No previous or active purchase found for user",
                  );
                }

              }, child: const Text("Restore Purchase Status"))
            ],
          ),
        )
      ),
    );
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();

    if(offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Options Found, try again later")));
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      showModalBottomSheet(
          context: context,
          builder: (context) => PaywallWidget(
        packages: packages,
        title: "Support WristTrack",
        description: "Pay what you like! Choose any option upgrade to WristTrack Pro",
        onClickedPackage: (package) async{
          //Pop context first - this will allow any exception dialog to show without being blocked by the bottom sheet.
          Navigator.pop(context);
          bool success = await PurchaseApi.purchasePackage(package);
                    if (success) {
            var fryerController = Get.put(WristCheckController());
            fryerController.updateAppPurchaseStatus();
          }


        }
      )
      );


    }


  }

}
