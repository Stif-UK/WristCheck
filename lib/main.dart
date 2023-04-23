import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/wristcheck_home.dart';
import 'package:wristcheck/theme/theme_constants.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/provider/db_provider.dart';
import 'package:wristcheck/api/purchase_api.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  //Initialise RevenueCat
  await PurchaseApi.init();

  await Hive.initFlutter();

  Hive.registerAdapter(WatchesAdapter());
  await Hive.openBox<Watches>("WatchBox");

  //Get SharedPreferences for watches and set opencount
  await WristCheckPreferences.init().then((_) => _updateOpenCount());
  //if this is the first time the app has opened, then set reference date
  if(WristCheckPreferences.getReferenceDate() == null || WristCheckPreferences.getOpenCount() == 1){
    WristCheckPreferences.setReferenceDate(DateTime.now());
  }
  //Ensure app purchase status is instantiated in preferences
  if(WristCheckPreferences.getAppPurchasedStatus() == null){
    WristCheckPreferences.setAppPurchasedStatus(false);
  }


  runApp(

      MultiProvider(
        providers: [ChangeNotifierProvider<DatabaseProvider>(
            create: (_) => DatabaseProvider(),
        ),
          Provider.value(value: adState)


        ],
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
            title: 'WristCheck',

          theme: lightTheme ,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          //ThemeMode.light,
          //ThemeMode.system,

          home:  WristCheckHome(),
        )),
      );


  //Make the app full-screen
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

void _updateOpenCount(){
  int? currentCount = WristCheckPreferences.getOpenCount();
  currentCount == null? WristCheckPreferences.setOpenCount(1) : WristCheckPreferences.setOpenCount(currentCount+1);
}