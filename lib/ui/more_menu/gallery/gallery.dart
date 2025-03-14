import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/gallery_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/gallery_selection_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/more_menu/gallery/image_overlay.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class Gallery extends StatefulWidget {
  Gallery({super.key});
  final galleryController = Get.put(GalleryController());
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<Gallery> createState() => _GalleryState();
}



class _GalleryState extends State<Gallery> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  StreamController<Widget> overlayController = StreamController<Widget>.broadcast();
  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  void dispose() {
    overlayController.close();
    super.dispose();
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
            //Check config to confirm if this is a prod or test app build
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.galleryAdUnitID,
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
    analytics.logScreenView(screenName: "gallery");

    return Scaffold(
      appBar: AppBar(
        title: Text("Watch Gallery"),
      ),
      body:  Obx(()=> Column(
        children: [
          Expanded(
            child: FutureBuilder(
                  builder: (ctx, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("${snapshot.error} occurred",
                          style: Theme.of(context).textTheme.headlineSmall,),
                        );
                      } else if (snapshot.hasData){
                        final data = snapshot.data as List<Watches>;
                        widget.galleryController.updateDataAvailable(data.isNotEmpty);
                        return SingleChildScrollView(
                          child: Center(
                            child: Obx(()=> Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _getCollectionPickerRow(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text("Go",
                                      style: TextStyle(fontSize: 20.0),),
                                      onPressed: ()=> data.isNotEmpty? SwipeImageGallery(
                                        context: context,
                                        itemBuilder: (context, index){
                                          return FutureBuilder(
                                              builder: (ctx, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Text(
                                                        "${snapshot.error} occurred",
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .headlineSmall,),
                                                    );
                                                  } else if (snapshot.hasData) {
                                                    final imageData = snapshot.data as File;
                                                    return Image.file(imageData);
                                                  }
                                                }
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );

                                              },
                                                future: ImagesUtil.getImage(data[index], true));
                                          },
                                          itemCount: data.length,
                                        // children: data,
                                        onSwipe: (index) {
                                          overlayController.add(ImageOverlay(
                                            title: '${index + 1}/${data.length}',
                                            subtitle: "${data[index].toString()}",
                                          ));
                                        },
                                        overlayController: overlayController,
                                        initialOverlay: ImageOverlay(
                                          title: '1/${data.length}',
                                          subtitle: "${data[0].manufacturer} ${data[0].model}",
                                      )).show() : null ,
                                    ),
                                  ),
                                  widget.galleryController.dataAvailable.value? SizedBox(height: 0,): _getDataNotAvailableRow()
                                ],
                              ),
                            ),
                          ),
                        );
                      };
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  future: ImagesUtil.getWatchesWithImages(widget.galleryController.gallerySelection.value), ),
          ),
          widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : _buildAdSpace(banner, context),
          const SizedBox(height: 75,)
        ],
      ),
      )
    );
  }
}

Widget _getCollectionPickerRow(){
  final galController = Get.put(GalleryController());

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text("Show me my ", style: Theme.of(Get.context!).textTheme.bodyLarge,),
      ),
      Obx(()=> DropdownButton<GallerySelectionEnum>(
          value: galController.gallerySelection.value,
          items: GallerySelectionEnum.values.map((selection) {
            return DropdownMenuItem<GallerySelectionEnum>(
                value: selection,
                child: Text(WristCheckFormatter.getGallerySelectionName(selection)));
          }).toList(),
          onChanged: (selection) => galController.updateGallerySelection(selection!)

      ),
      ),
    ],
  );
}

Widget _getDataNotAvailableRow(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Icon(FontAwesomeIcons.eyeSlash),
        ),
        Text("No Images were found for this filter",
          style: Theme.of(Get.context!).textTheme.headlineSmall ,
        textAlign: TextAlign.center,)
      ],
    ),
  );
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

