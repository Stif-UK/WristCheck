import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/view_watch_helper.dart';

class WatchView extends StatefulWidget {
  WatchView({
    Key? key}) : super(key: key);

  final wristCheckController = Get.put(WristCheckController());

  Watches? currentWatch;
  //bool to confirm if note has been marked for editing
  bool inEditState = false;

  @override
  State<WatchView> createState() => _WatchViewState();
}

class _WatchViewState extends State<WatchView> {

  //Setup Ads
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
              adUnitId: AdUnits.viewWatchBannerAdUnitId,
              //adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.viewWatchBannerAdUnitId,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.banner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  //Instance Variables
  String? _manufacturer = "";
  String? _model = "";
  String? _serialNumber;
  bool favourite = false;
  String _status = "In Collection";
  DateTime? _purchaseDate;
  DateTime? _lastServicedDate;
  int _serviceInterval = 0;
  String? _notes ="";
  String? _referenceNumber = "";
  File? frontImage;
  File? backImage;
  int? watchKey; //Used to save images to newly added watches
  Watches? currentWatch;

  //Setup options for watch collection status
  final List<String> _statusList = ["In Collection", "Sold", "Wishlist"];
  String? _selectedStatus = "In Collection";
  //Setup options for service interval
  final List<int> _serviceList = [0,1,2,3,4,5,6,7,8,9,10]; //TODO: Replace with a number validated formfield
  int _selectedInterval = 0;

  //Form Key
  final _formKey = GlobalKey<FormState>();
  //Text Controller TODO: Add controllers for each element of the watch view
  final manufacturerFieldController = TextEditingController();
  final modelFieldController = TextEditingController();
  final serialNumberFieldController = TextEditingController();
  final referenceNumberFieldController = TextEditingController();
  final notesFieldController = TextEditingController();

  @override
  void dispose(){
    //clean up the controller when the widget is disposed TODO: Update to ensure each controller is disposed
    manufacturerFieldController.dispose();
    modelFieldController.dispose();
    serialNumberFieldController.dispose();
    referenceNumberFieldController.dispose();
    notesFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WatchViewEnum watchviewState = ViewWatchHelper.getWatchViewState(widget.currentWatch, widget.inEditState);
    if(watchviewState!= WatchViewEnum.add){
      _manufacturer = widget.currentWatch!.manufacturer;
      _model = widget.currentWatch!.model;
      _serialNumber = widget.currentWatch!.serialNumber;
      _referenceNumber = widget.currentWatch!.referenceNumber;
      //Load note content, only if note is not being edited
      if(!widget.inEditState) {
        manufacturerFieldController.value =
            TextEditingValue(text: widget.currentWatch!.manufacturer);
        modelFieldController.value =
            TextEditingValue(text: widget.currentWatch!.model);
        serialNumberFieldController.value =
            TextEditingValue(text: widget.currentWatch!.serialNumber ??"");
        referenceNumberFieldController.value = TextEditingValue(text: widget.currentWatch!.referenceNumber ?? "");
        notesFieldController.value =
            TextEditingValue(text: widget.currentWatch!.notes ?? "");
      }
    }
    return Container();
  }
}

