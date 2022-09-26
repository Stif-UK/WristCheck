import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  //method to return test ad units during testing
  String get getTestAds => Platform.isAndroid
      ? "ca-app-pub-3940256099942544/6300978111"
      : "ca-app-pub-3940256099942544/2934735716";


  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) {
      print('Ad failed to loaded: ${ad.adUnitId}, $error.');
      ad.dispose();
    },

      onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAdClicked: (ad) => print('Ad clicked: ${ad.adUnitId}.'),
    onAdImpression: (ad) => print('Ad Impression: ${ad.adUnitId}.'),
    onAdWillDismissScreen: (ad) => print('Ad dismissed: ${ad.adUnitId}.'),
  );

}