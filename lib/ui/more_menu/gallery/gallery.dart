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
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/more_menu/gallery/image_overlay.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class GalleryV2 extends StatefulWidget {
  GalleryV2({super.key});
  final galleryController = Get.put(GalleryController());
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<GalleryV2> createState() => _GalleryV2State();
}

class _GalleryV2State extends State<GalleryV2> {
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.galleryAdUnitID,
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
    analytics.logScreenView(screenName: "gallery");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Watch Gallery"),
      ),
      body:  Obx(()=> Column(
        children: [
          _getCollectionPickerRow(),
          Expanded(
            child: FutureBuilder<List<Watches>>(
                  future: ImagesUtil.getWatchesWithImages(widget.galleryController.gallerySelection.value),
                  builder: (ctx, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasError){
                        return Center(
                          child: Text("${snapshot.error} occurred",
                          style: Theme.of(context).textTheme.headlineSmall,),
                        );
                      } else if (snapshot.hasData){
                        final data = snapshot.data!;
                        widget.galleryController.updateDataAvailable(data.isNotEmpty);
                        
                        if(data.isEmpty){
                          return _getDataNotAvailableRow();
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                SwipeImageGallery(
                                  context: context,
                                  itemBuilder: (context, galleryIndex) {
                                    return FutureBuilder<File?>(
                                      future: ImagesUtil.getImage(data[galleryIndex], data[galleryIndex].primaryImageIndex ?? 0),
                                      builder: (ctx, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (snapshot.hasData && snapshot.data != null) {
                                            return Image.file(snapshot.data!);
                                          }
                                        }
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                    );
                                  },
                                  itemCount: data.length,
                                  initialIndex: index,
                                  onSwipe: (swipeIndex) {
                                    overlayController.add(ImageOverlay(
                                      title: '${swipeIndex + 1}/${data.length}',
                                      subtitle: data[swipeIndex].toString(),
                                      subtitle2: WristCheckFormatter.getGallerySubheaderText(data[swipeIndex]),
                                    ));
                                  },
                                  overlayController: overlayController,
                                  initialOverlay: ImageOverlay(
                                    title: '${index + 1}/${data.length}',
                                    subtitle: data[index].toString(),
                                    subtitle2: WristCheckFormatter.getGallerySubheaderText(data[index]),
                                  ),
                                ).show();
                              },
                              child: FutureBuilder<File?>(
                                future: ImagesUtil.getImage(data[index], data[index].primaryImageIndex ?? 0),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.hasData && snapshot.data != null) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Image.file(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                  }
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                            );
                          },
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
            ),
          ),
          widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
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
        dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Icon(FontAwesomeIcons.eyeSlash),
        ),
        Text("No Images were found for this filter",
          style: Theme.of(Get.context!).textTheme.headlineSmall ,
        textAlign: TextAlign.center,)
      ],
    ),
  );
}
