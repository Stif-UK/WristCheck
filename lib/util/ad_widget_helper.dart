import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdWidgetHelper{

  static Widget buildSmallAdSpace(BannerAd? banner, BuildContext context){
    return banner == null
        ? const SizedBox(height: 50,)
        : StatefulBuilder(
            builder: (context, setState) => SizedBox(
              height: 50,
              child: AdWidget(ad: banner),
    ));
  }

  static Widget buildLargeAdSpace(BannerAd? banner, BuildContext context){
    return banner == null
        ? const SizedBox(height: 100,)
        : StatefulBuilder(builder: (context, setState) => SizedBox(
      height: 100,
      child: AdWidget(ad: banner),
    ));
  }

  static Widget buildRectangleSpace(BannerAd? banner, BuildContext context){
    double size = MediaQuery.of(context).size.height > 500.0? 250 : 100;
    return banner == null
        ? SizedBox(height: size,)
        : StatefulBuilder( builder: (context, setState) => SizedBox(
      height: size,
      child: AdWidget(ad: banner),
    ));
  }

}