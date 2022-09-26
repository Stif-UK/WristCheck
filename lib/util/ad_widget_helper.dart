import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdWidgetHelper{

  static Widget buildSmallAdSpace(BannerAd? banner, BuildContext context){
    return banner == null
        ? const SizedBox(height: 50,)
        : SizedBox(
              height: 50,
              child: AdWidget(ad: banner),
    );
  }
}