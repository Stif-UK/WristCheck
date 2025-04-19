import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/winder_direction_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/watch/header/wear_row.dart';
import 'package:wristcheck/ui/watch/tabs/info_tab.dart';
import 'package:wristcheck/ui/watch/tabs/notes_tab.dart';
import 'package:wristcheck/ui/watch/tabs/pro_data_tab.dart';
import 'package:wristcheck/ui/watch/tabs/service_tab.dart';
import 'package:wristcheck/ui/watch/header/status_favourite_header.dart';
import 'package:wristcheck/ui/watch/tabs/value_tab.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WatchView extends StatefulWidget {
  WatchView({
    Key? key,
  this.currentWatch
  }) : super(key: key);

  final wristCheckController = Get.put(WristCheckController());
  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;

  @override
  State<WatchView> createState() => _WatchViewState();
}

class _WatchViewState extends State<WatchView> {

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

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
  final watchBox = Boxes.getWatches();
  String _manufacturer = "";
  String _model = "";
  bool favourite = false;
  DateTime? _purchaseDate;
  DateTime? _lastServicedDate;
  int _serviceInterval = 0;
  File? image;
  bool front = true;
  File? frontImage;
  File? backImage;
  int? watchKey; //Used to save images to newly added watches
  //bool canRecordWear = false;
  String? _purchasedFrom = "";
  String? _soldTo = "";
  DateTime? _soldDate;
  DateTime? _deliveryDate;
  DateTime? _warrantyEndDate;
  double? _caseDiameter;
  int? _lugWidth;
  double? _lug2lug;
  double? _caseThickness;
  int? _waterResistance;
  int? _winderTPD;
  String? _dateComplication;

  //Form Key
  final _formKey = GlobalKey<FormState>();
  final manufacturerFieldController = TextEditingController();
  final modelFieldController = TextEditingController();
  final serialNumberFieldController = TextEditingController();
  final referenceNumberFieldController = TextEditingController();
  final serviceIntervalFieldController = TextEditingController();
  final notesFieldController = TextEditingController();
  final purchaseDateFieldController = TextEditingController();
  final lastServicedDateFieldController = TextEditingController();
  final nextServiceDueFieldController = TextEditingController();
  final movementFieldController = TextEditingController();
  final categoryFieldController = TextEditingController();
  final purchasedFromFieldController = TextEditingController();
  final soldToFieldController = TextEditingController();
  final purchasePriceFieldController = TextEditingController();
  final soldPriceFieldController = TextEditingController();
  final timeInCollectionFieldController = TextEditingController();
  final soldDateFieldController = TextEditingController();
  final deliveryDateFieldController = TextEditingController();
  final warrantyEndDateFieldController = TextEditingController();
  final caseDiameterFieldController = TextEditingController();
  final lugWidthFieldController = TextEditingController();
  final lug2lugFieldController = TextEditingController();
  final caseThicknessFieldController = TextEditingController();
  final waterResistanceFieldController = TextEditingController();
  final caseMaterialFieldController = TextEditingController();
  final winderTPDFieldController = TextEditingController();
  final winderDirectionFieldController = TextEditingController();
  final dateComplicationFieldController = TextEditingController();

  @override
  void dispose(){
    //clean up the controller when the widget is disposed
    manufacturerFieldController.dispose();
    modelFieldController.dispose();
    serialNumberFieldController.dispose();
    referenceNumberFieldController.dispose();
    serviceIntervalFieldController.dispose();
    purchaseDateFieldController.dispose();
    notesFieldController.dispose();
    lastServicedDateFieldController.dispose();
    nextServiceDueFieldController.dispose();
    movementFieldController.dispose();
    categoryFieldController.dispose();
    purchasedFromFieldController.dispose();
    soldToFieldController.dispose();
    purchasePriceFieldController.dispose();
    soldPriceFieldController.dispose();
    timeInCollectionFieldController.dispose();
    soldDateFieldController.dispose();
    deliveryDateFieldController.dispose();
    warrantyEndDateFieldController.dispose();
    caseDiameterFieldController.dispose();
    lugWidthFieldController.dispose();
    lug2lugFieldController.dispose();
    caseThicknessFieldController.dispose();
    waterResistanceFieldController.dispose();
    caseMaterialFieldController.dispose();
    winderTPDFieldController.dispose();
    winderDirectionFieldController.dispose();
    dateComplicationFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Variable for the final tab index, to ensure next tab button shows on the correct screens when app is pro
    int finalTabIndex = widget.wristCheckController.isAppPro.value ? 4 : 3;

    //On build initialise watchViewController values
    //On first build default edit state - only default to true if this is a new watch record
    widget.watchViewController.updateInEditState(widget.currentWatch == null);
    //If the watch is not null ensure the selected status is updated to reflect the current watches value
    if(widget.currentWatch != null) {
      widget.watchViewController
          .updateSelectedStatus(widget.currentWatch!.status!);
    };
    //Determine the view state and pass to the controller
    widget.watchViewController.updateViewState(ViewWatchHelper.getWatchViewState(widget.currentWatch, widget.watchViewController.inEditState.value));
    String locale = WristCheckFormatter.getLocaleString(widget.wristCheckController.locale.value);
    //Reset controller values to default to prevent info carrying between watches - these should re-load later if a watch is loaded
    widget.watchViewController.updatePurchasePrice(widget.currentWatch?.purchasePrice ?? 0);
    widget.watchViewController.updateSoldPrice(widget.currentWatch?.soldPrice ?? 0);
    widget.watchViewController.updateMovement("");
    widget.watchViewController.updateCategory("");
    widget.watchViewController.updateShowdays(false);
    widget.watchViewController.updateFavourite(widget.currentWatch?.favourite ?? false);
    widget.watchViewController.updateSkipBackCheck(false);
    widget.watchViewController.updateCaseMaterial("");
    widget.watchViewController.updateWinderDirection("");
    widget.watchViewController.updateDateComplication("");

    void saveAndUpdate(){
      //Validate the form
      if (_formKey.currentState!.validate()) {
        //Ensure watch is not null
        if(widget.currentWatch != null) {
          //check if data has changed
          if(hasDataChanged()) {
            _manufacturer = manufacturerFieldController.value.text;
            _model = modelFieldController.value.text;
            //convert service interval field to int
            _serviceInterval =
                ViewWatchHelper.getIntInputValue(serviceIntervalFieldController.value.text);
            _purchaseDate =
                ViewWatchHelper.getDateFromFieldString(purchaseDateFieldController.value.text);
            _lastServicedDate = ViewWatchHelper.getDateFromFieldString(
                lastServicedDateFieldController.value.text);
            _soldDate = ViewWatchHelper.getDateFromFieldString(soldDateFieldController.value.text);
            _deliveryDate = ViewWatchHelper.getDateFromFieldString(deliveryDateFieldController.value.text);
            widget.watchViewController.updateMovement(movementFieldController.value.text);
            widget.watchViewController.updateCategory(categoryFieldController.value.text);
            _purchasedFrom = purchasedFromFieldController.value.text;
            _soldTo = soldToFieldController.value.text;
            widget.watchViewController.updatePurchasePrice(ViewWatchHelper.getPrice(purchasePriceFieldController.value.text));
            widget.watchViewController.updateSoldPrice(ViewWatchHelper.getPrice(soldPriceFieldController.value.text));
            _warrantyEndDate = ViewWatchHelper.getDateFromFieldString(warrantyEndDateFieldController.value.text);
            _caseDiameter = ViewWatchHelper.getDoubleFromStringInput(caseDiameterFieldController.value.text);
            _lugWidth = ViewWatchHelper.getIntInputValue(lugWidthFieldController.value.text);
            _lug2lug = ViewWatchHelper.getDoubleFromStringInput(lug2lugFieldController.value.text);
            _caseThickness = ViewWatchHelper.getDoubleFromStringInput(caseThicknessFieldController.value.text);
            _waterResistance = ViewWatchHelper.getIntInputValue(waterResistanceFieldController.value.text);
            widget.watchViewController.updateCaseMaterial(caseMaterialFieldController.value.text);
            _winderTPD = ViewWatchHelper.getIntInputValue(winderTPDFieldController.value.text);
            widget.watchViewController.updateWinderDirection(winderDirectionFieldController.value.text);
            widget.watchViewController.updateDateComplication(dateComplicationFieldController.value.text);

            widget.currentWatch!.manufacturer = _manufacturer;
            widget.currentWatch!.model = _model;
            widget.currentWatch!.status = widget.watchViewController.selectedStatus.value;
            widget.currentWatch!.serialNumber =
                serialNumberFieldController.value.text;
            widget.currentWatch!.referenceNumber =
                referenceNumberFieldController.value.text;
            widget.currentWatch!.serviceInterval = _serviceInterval;
            widget.currentWatch!.purchaseDate = _purchaseDate;
            widget.currentWatch!.lastServicedDate = _lastServicedDate;
            widget.currentWatch!.nextServiceDue =
                WatchMethods.calculateNextService(
                    _purchaseDate, _lastServicedDate, _serviceInterval);
            widget.currentWatch!.notes = notesFieldController.value.text;
            widget.currentWatch!.movement = widget.watchViewController.movement.value;
            widget.currentWatch!.category = widget.watchViewController.category.value;
            widget.currentWatch!.purchasedFrom = _purchasedFrom;
            widget.currentWatch!.soldTo = _soldTo;
            widget.currentWatch!.purchasePrice = widget.watchViewController.purchasePrice.value;
            widget.currentWatch!.soldPrice = widget.watchViewController.soldPrice.value;
            widget.currentWatch!.soldDate = _soldDate;
            widget.currentWatch!.deliveryDate = _deliveryDate;
            widget.currentWatch!.warrantyEndDate = _warrantyEndDate;
            widget.currentWatch!.caseDiameter = _caseDiameter;
            widget.currentWatch!.lugWidth = _lugWidth;
            widget.currentWatch!.lug2lug = _lug2lug;
            widget.currentWatch!.caseThickness = _caseThickness;
            widget.currentWatch!.waterResistance = _waterResistance;
            widget.currentWatch!.caseMaterial = widget.watchViewController.caseMaterial.value;
            widget.currentWatch!.winderTPD = _winderTPD;
            widget.currentWatch!.winderDirection = widget.watchViewController.winderDirection.value;
            widget.currentWatch!.dateComplication = widget.watchViewController.dateComplication.value;
            widget.currentWatch!.save();
            //Update next service due in controller to refresh view
            widget.watchViewController.updateNextServiceDue(WatchMethods.calculateNextService(widget.currentWatch!.purchaseDate, widget.currentWatch!.lastServicedDate, widget.currentWatch!.serviceInterval));
          }
          Get.snackbar("$_manufacturer $_model",
              "Updates Saved",
            snackPosition: SnackPosition.BOTTOM
          );

        }
        widget.watchViewController.updateInEditState(false);
        widget.watchViewController.updateViewState(WatchViewEnum.view);

      }
    }

    Widget _saveWatchUpdateButton(){
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: ElevatedButton(
                onPressed: () async {
                  await analytics.logEvent(name: "main_save_btn_press");
                  saveAndUpdate();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.save),
                    ),
                    Text("Save Updates"),
                  ],
                )
            )
        ),
      );
    }

    if(widget.watchViewController.watchViewState.value != WatchViewEnum.add){

      widget.watchViewController.updateSelectedStatus(widget.currentWatch!.status!);
      _manufacturer = widget.currentWatch!.manufacturer;
      _model = widget.currentWatch!.model;
      _serviceInterval = widget.currentWatch!.serviceInterval;
      widget.watchViewController.updateMovement(widget.currentWatch!.movement);
      widget.watchViewController.updateCategory(widget.currentWatch!.category);
      _purchasedFrom = widget.currentWatch!.purchasedFrom;
      _soldTo = widget.currentWatch!.soldTo;
      widget.watchViewController.updatePurchasePrice(widget.currentWatch!.purchasePrice ?? 0);
      widget.watchViewController.updateSoldPrice(widget.currentWatch!.soldPrice ?? 0);
      widget.watchViewController.updateCaseMaterial(widget.currentWatch!.caseMaterial);
      widget.watchViewController.updateWinderDirection(widget.currentWatch!.winderDirection);
      widget.watchViewController.updateDateComplication(widget.currentWatch!.dateComplication);

      //Load watch content, only if watch is not being edited
      if(!widget.watchViewController.inEditState.value) {
        manufacturerFieldController.value =
            TextEditingValue(text: widget.currentWatch!.manufacturer);
        modelFieldController.value =
            TextEditingValue(text: widget.currentWatch!.model);
        serialNumberFieldController.value =
            TextEditingValue(text: widget.currentWatch!.serialNumber ??"");
        referenceNumberFieldController.value = TextEditingValue(text: widget.currentWatch!.referenceNumber ?? "");
        serviceIntervalFieldController.value = TextEditingValue(text: widget.currentWatch!.serviceInterval.toString());
        purchaseDateFieldController.value = TextEditingValue(text: widget.currentWatch!.purchaseDate != null? WristCheckFormatter.getFormattedDate(widget.currentWatch!.purchaseDate!): "Not Recorded");
        soldDateFieldController.value = TextEditingValue(text: widget.currentWatch!.soldDate != null? WristCheckFormatter.getFormattedDate(widget.currentWatch!.soldDate!): "Not Recorded");
        deliveryDateFieldController.value = TextEditingValue(text: widget.currentWatch!.deliveryDate != null? WristCheckFormatter.getFormattedDate(widget.currentWatch!.deliveryDate!): "Not Recorded");
        lastServicedDateFieldController.value = TextEditingValue(text: widget.currentWatch!.lastServicedDate != null? WristCheckFormatter.getFormattedDate(widget.currentWatch!.lastServicedDate!): "N/A");
        warrantyEndDateFieldController.value = TextEditingValue(text: widget.currentWatch!.warrantyEndDate != null? WristCheckFormatter.getFormattedDate(widget.currentWatch!.warrantyEndDate!): "Not Recorded");
        widget.watchViewController.updateNextServiceDue(WatchMethods.calculateNextService(widget.currentWatch!.purchaseDate, widget.currentWatch!.lastServicedDate, widget.currentWatch!.serviceInterval));
        nextServiceDueFieldController.value = TextEditingValue(text: widget.watchViewController.nextServiceDue.value);
        notesFieldController.value =
            TextEditingValue(text: widget.currentWatch!.notes ?? "");

        movementFieldController.value = TextEditingValue(text: widget.currentWatch!.movement?? WristCheckFormatter.getMovementText(MovementEnum.blank));
        categoryFieldController.value = TextEditingValue(text: widget.currentWatch!.category?? WristCheckFormatter.getCategoryText(CategoryEnum.blank));
        purchasedFromFieldController.value = TextEditingValue(text: widget.currentWatch!.purchasedFrom ?? "");
        soldToFieldController.value = TextEditingValue(text: widget.currentWatch!.soldTo ?? "");
        //check if the purchaseprice associated with the watch is null - if so, return an empty string, otherwise return a string representation of the integer
        var purchasePriceValue = widget.currentWatch!.purchasePrice;
        purchasePriceFieldController.value = TextEditingValue(text: purchasePriceValue != null? purchasePriceValue.toString() : "" );
        var soldPriceValue = widget.currentWatch!.soldPrice;
        soldPriceFieldController.value = TextEditingValue(text: soldPriceValue != null? soldPriceValue.toString() : "");
        caseDiameterFieldController.value = TextEditingValue(text: widget.currentWatch!.caseDiameter != null?"${widget.currentWatch!.caseDiameter}" : "" );
        lugWidthFieldController.value = TextEditingValue(text: widget.currentWatch!.lugWidth != null? widget.currentWatch!.lugWidth.toString() : "");
        lug2lugFieldController.value = TextEditingValue(text: widget.currentWatch!.lug2lug != null?"${widget.currentWatch!.lug2lug}" : "");
        caseThicknessFieldController.value = TextEditingValue(text: widget.currentWatch!.caseThickness != null?"${widget.currentWatch!.caseThickness}" : "");
        waterResistanceFieldController.value = TextEditingValue(text: widget.currentWatch!.waterResistance != null?"${widget.currentWatch!.waterResistance}" : "");
        caseMaterialFieldController.value = TextEditingValue(text: widget.currentWatch!.caseMaterial?? WristCheckFormatter.getCaseMaterialText(CaseMaterialEnum.blank));
        winderTPDFieldController.value = TextEditingValue(text: widget.currentWatch!.winderTPD != null? "${widget.currentWatch!.winderTPD}" : "");
        winderDirectionFieldController.value = TextEditingValue(text: widget.currentWatch!.winderDirection ?? WristCheckFormatter.getWinderDirectionText(WinderDirectionEnum.blank));
        dateComplicationFieldController.value = TextEditingValue(text: widget.currentWatch!.dateComplication ?? WristCheckFormatter.getDateComplicationName(DateComplicationEnum.blank));
      }
    }

    //Wrap page in PopScope to give control of back navigation, in the event changes have been made but not saved
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
          // Check if changes have been made to the data on the page
          final backNavigationAllowed = await isBackNavigationAllowed();

          if (backNavigationAllowed) {
            Get.back();
          } else {
            Get.defaultDialog(
                title: "You have unsaved changes",
                content: const Text("Are you sure you want to exit?\nUnsaved changes will be lost."),
                textConfirm: "Exit without saving",
                textCancel: "Continue editing",
                onConfirm: ()=> Get.back(closeOverlays: true),
                onCancel: (){}
            );
          }
      },
      //Wrap Scaffold in a FutureBuilder to show images once loaded
      child:FutureBuilder<File?>(
          future: widget.watchViewController.watchViewState.value != WatchViewEnum.add? ImagesUtil.getImage(widget.currentWatch!, front): addWatchImage(front),
          builder: (context, AsyncSnapshot<File?> snapshot) {
            if (snapshot.hasData || snapshot.data == null) {
              try {
                snapshot.data == File("") ? image = null :
                image = snapshot.data;
              } on Exception catch (e) {
                print("Exception caught in implementing file: $e");
                image = null;
              }
              return Scaffold(
                appBar: AppBar(
                    title: ViewWatchHelper.getTitle(
                        widget.watchViewController.watchViewState.value, _manufacturer, _model),


                    actions: [
                      // ViewWatchHelper.getWatchViewState(widget.currentWatch, widget.watchViewController.inEditState.value) == WatchViewEnum.add
                          widget.watchViewController.watchViewState.value == WatchViewEnum.add?
                          const SizedBox(height: 0,) :
                          Obx(()=> Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                  icon: widget.watchViewController.inEditState.value?
                                      const Icon(FontAwesomeIcons.floppyDisk) : const Icon(FontAwesomeIcons.penToSquare),
                                onPressed: () async {
                                    if(widget.watchViewController.inEditState.value){
                                      await analytics.logEvent(name: "save_edit_top_pressed");
                                      saveAndUpdate();
                                      //saveAndUpdate also performs change to view and edit state as called elsewhere
                                    } else
                                    {
                                      await analytics.logEvent(name: "edit_watch_pressed");
                                      widget.watchViewController.updateInEditState(true);
                                      widget.watchViewController.updateViewState(WatchViewEnum.edit);
                                    }
                                },
                              ),
                          ),
                          )
                    ]

                ),
                bottomNavigationBar: Obx(()=> BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: widget.watchViewController.tabIndex.value,
                    onTap: (index) {
                      if (_formKey.currentState!.validate()) {
                        widget.watchViewController.updateTabIndex(index);
                      }
                    },
                    items: widget.wristCheckController.isAppPro.value?
                        //If the app is pro then the list is longer and contains the extra tab
                    //TODO: This is poor code! Dynamically populate the list
                    const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.watch),
                        label: "Info",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.calendar),
                        label: "Schedule",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.dollarSign),
                        label: "Value",
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.glasses),
                        label: "Pro Data"
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.book),
                        label: "Notes",
                      )
                    ]
                        : const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.watch),
                        label: "Info",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.calendar),
                        label: "Schedule",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.dollarSign),
                        label: "Value",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.book),
                        label: "Notes",
                      )
                    ],

                  ),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    purchaseStatus ? const SizedBox(height: 0,) : AdWidgetHelper
                        .buildSmallAdSpace(banner, context),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Obx(()=> Column(
                                  children: [
                                    //Build the UI from components
                                    //Watch Images
                                    _displayWatchImageViewEdit(),
                                    widget.watchViewController.watchViewState.value == WatchViewEnum.view
                                        ? WearRow(currentWatch: widget.currentWatch,)
                                        : const SizedBox(height: 0,),
                                    const Divider(thickness: 2,),
                                    WatchStatusHeader(currentWatch: widget.currentWatch),
                                    const Divider(thickness: 2,),
                                    Column(
                                      children: [
                                        //Tab one - Watch info
                                        widget.watchViewController.tabIndex.value == 0 ? InfoTab(
                                            manufacturerFieldController: manufacturerFieldController,
                                            modelFieldController: modelFieldController,
                                            serialNumberFieldController: serialNumberFieldController,
                                            referenceNumberFieldController: referenceNumberFieldController,
                                            movementFieldController: movementFieldController,
                                            categoryFieldController: categoryFieldController,
                                            bodyLarge: Theme.of(context).textTheme.bodyLarge,
                                            context: context) : const SizedBox(height: 0,),

                                        //Tab two - Schedule info
                                        widget.watchViewController.tabIndex.value == 1 ? ServiceTab(
                                            deliveryDateFieldController: deliveryDateFieldController,
                                            purchaseDateFieldController: purchaseDateFieldController,
                                            soldDateFieldController: soldDateFieldController,
                                            timeInCollectionFieldController: timeInCollectionFieldController,
                                            serviceIntervalFieldController: serviceIntervalFieldController,
                                            warrantyEndDateFieldController: warrantyEndDateFieldController,
                                            lastServicedDateFieldController: lastServicedDateFieldController,
                                            nextServiceDueFieldController: nextServiceDueFieldController,
                                            currentWatch: widget.currentWatch): const SizedBox(height: 0,),

                                        //Tab three - cost info
                                        widget.watchViewController.tabIndex.value == 2 ? ValueTab(
                                            purchasePriceFieldController: purchasePriceFieldController,
                                            purchasedFromFieldController: purchasedFromFieldController,
                                            soldPriceFieldController: soldPriceFieldController,
                                            soldToFieldController: soldToFieldController,
                                            currentWatch: widget.currentWatch,
                                            bodyLarge: Theme.of(context).textTheme.bodyLarge,
                                            headlineSmall: Theme.of(context).textTheme.headlineSmall,
                                            locale: locale) : const SizedBox(height: 0,),

                                        //Tab four when app is pro - Pro Data
                                        //Only show if app is pro
                                        widget.watchViewController.tabIndex.value == 3 && widget.wristCheckController.isAppPro.value
                                            ? ProDataTab(
                                                caseDiameterController: caseDiameterFieldController,
                                                lugWidthController: lugWidthFieldController,
                                                lug2lugController: lug2lugFieldController,
                                                caseThicknessController: caseThicknessFieldController,
                                                waterResistanceController: waterResistanceFieldController,
                                                caseMaterialController: caseMaterialFieldController,
                                                winderTPDController: winderTPDFieldController,
                                                winderDirectionController: winderDirectionFieldController,
                                                dateComplicationController: dateComplicationFieldController,
                                        )
                                            : const SizedBox(height: 0,),

                                        //Tab four when app is not pro- Notebook
                                        widget.watchViewController.tabIndex.value == 3 && !widget.wristCheckController.isAppPro.value
                                            ? NotesTab(notesFieldController: notesFieldController)
                                            : const SizedBox(height: 0,),

                                        //Tab five - Notebook (index 4 only exists when the app is pro)
                                        widget.watchViewController.tabIndex.value == 4
                                            ? NotesTab(notesFieldController: notesFieldController)
                                            : const SizedBox(height: 0,),

                                        const Divider(thickness: 2,),
                                        //Implement Add / Save button and next button to show if in an 'add' state
                                        widget.watchViewController.watchViewState.value == WatchViewEnum.add &&
                                            widget.watchViewController.tabIndex.value < finalTabIndex
                                            ? _nextTabButton()
                                            : const SizedBox(height: 10,),
                                        widget.watchViewController.watchViewState.value == WatchViewEnum.add
                                            ? _addWatchButton()
                                            : const SizedBox(height: 0,),

                                        //implement a save button to show when in an edit state
                                        widget.watchViewController.watchViewState.value == WatchViewEnum.edit
                                            ?  _saveWatchUpdateButton()
                                            : const SizedBox(height: 0,)


                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ))
                  ],
                ),
              );
            }
            else {
              return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator()
              );
            }
          }
      ),
    );
  }

  //Code to create individual sections of the UI - consider externalising these!

  Widget _displayWatchImageViewEdit(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        const Expanded(
            flex: 2,
            child: SizedBox(height: 10)),
        Expanded(
          flex: 6,
          child: Container(
              height: 180,
              margin: const EdgeInsets.all(20),
              //Padding and borderradius not required once image is selected
              padding: image == null? const EdgeInsets.all(40): null,
              decoration: image == null? BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 2, color: Get.isDarkMode? Colors.white: Colors.black)) : null,
              //If we have an image display it (ClipRRect used to round corners to soften the image)
              child: image == null? Column(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  const Icon(Icons.camera_alt, size: 75),
                  front? const Text("Front"): const Text("Back"),
                ],
              ): ClipRRect(
                child: Image.file(image!),
                borderRadius: BorderRadius.circular(16),
              )
          ),

        ),
        Expanded(
          flex: 2,
          //Column to display the pick image and switch image icons
          child: Column(
            children: [
              InkWell(
                  child: const Icon(Icons.add_a_photo_outlined),
                  onTap: () async {


                    var imageSource = await ImagesUtil.imageSourcePopUp(context);
                    //Split this method depending on status
                    if (widget.watchViewController.watchViewState.value != WatchViewEnum.add) {
                      await  ImagesUtil.pickAndSaveImage(source: imageSource!, currentWatch: widget.currentWatch!, front: front);
                    } else{
                      if(front) {
                        imageSource != null
                            ? frontImage =
                                await ImagesUtil.pickImage(source: imageSource!)
                            : null;
                      } else {
                        imageSource != null
                            ? backImage =
                        await ImagesUtil.pickImage(source: imageSource!)
                            : null;
                      }
                    }

                    //pickAndSaveImage will have set the image for the given watch
                    //Now call setstate to ensure the display is updated
                    setState(() {

                    });
                  }
              ),
              const SizedBox(height: 25,),
              IconButton(
                  icon: const Icon(Icons.flip_camera_android_rounded),
                  onPressed: (){
                    setState(() {
                      front = !front;
                    });
                  })
            ],
          ),
        ),


      ],
    );
  }

  Widget _nextTabButton(){
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await analytics.logEvent(name: "next_tab_btn",
              parameters: {
                "current_tab": widget.watchViewController.tabIndex.value
              });
          if(_formKey.currentState!.validate()) {
            await analytics.logEvent(name: "next_tab_btn_success",
            parameters: {
              "current_tab": widget.watchViewController.tabIndex.value
            });
            widget.watchViewController.incrementTabIndex();
        }
      },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add optional details?"),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.navigate_next),
            ),

          ],
        ),

      )
    );
  }

  Widget _addWatchButton(){
    Watches? tempWatch;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            await analytics.logEvent(name: "add_watch_pressed");
            if(_formKey.currentState!.validate()){
              var snackTitle = "${manufacturerFieldController.value.text} ${modelFieldController.value.text}";

              _purchaseDate = ViewWatchHelper.getDateFromFieldString(purchaseDateFieldController.value.text);
              _soldDate = ViewWatchHelper.getDateFromFieldString(soldDateFieldController.value.text);
              _deliveryDate = ViewWatchHelper.getDateFromFieldString(deliveryDateFieldController.value.text);
              _lastServicedDate = ViewWatchHelper.getDateFromFieldString(lastServicedDateFieldController.value.text);
              _warrantyEndDate = ViewWatchHelper.getDateFromFieldString(warrantyEndDateFieldController.value.text);
              _serviceInterval = ViewWatchHelper.getIntInputValue(serviceIntervalFieldController.value.text);
              _caseDiameter = ViewWatchHelper.getDoubleFromStringInput(caseDiameterFieldController.value.text);
              _lugWidth = ViewWatchHelper.getIntInputValue(lugWidthFieldController.value.text);
              _lug2lug = ViewWatchHelper.getDoubleFromStringInput(lug2lugFieldController.value.text);
              _caseThickness = ViewWatchHelper.getDoubleFromStringInput(caseThicknessFieldController.value.text);
              _waterResistance = ViewWatchHelper.getIntInputValue(waterResistanceFieldController.value.text);
              _winderTPD = ViewWatchHelper.getIntInputValue(winderTPDFieldController.value.text);
              widget.watchViewController.updatePurchasePrice(ViewWatchHelper.getPrice(purchasePriceFieldController.value.text));
              widget.watchViewController.updateSoldPrice(ViewWatchHelper.getPrice(soldPriceFieldController.value.text));


              watchKey = await WatchMethods.addWatch(
                  manufacturerFieldController.value.text,
                  modelFieldController.value.text,
                  serialNumberFieldController.value.text,
                  favourite,
                  widget.watchViewController.selectedStatus.value,
                  _purchaseDate,
                  _lastServicedDate,
                  _serviceInterval,
                  notesFieldController.value.text,
                  referenceNumberFieldController.value.text,
                  movementFieldController.value.text,
                categoryFieldController.value.text,
                purchasedFromFieldController.value.text,
                soldToFieldController.value.text,
                widget.watchViewController.purchasePrice.value,
                widget.watchViewController.soldPrice.value,
                _soldDate,
                _deliveryDate,
                _warrantyEndDate,
                _caseDiameter, 
                  _lugWidth,
                  _lug2lug,
                  _caseThickness,
                _waterResistance,
                caseMaterialFieldController.value.text,
                _winderTPD,
                winderDirectionFieldController.value.text,
                dateComplicationFieldController.value.text
              );

              //if a front image has been set, we add this to the newly created watch before exiting
              if(frontImage != null){
                tempWatch = watchBox.get(watchKey);
            ImagesUtil.saveImage(frontImage!.path, tempWatch!, true);
            }
            //and repeat for the back image
            if(backImage != null){
            tempWatch = watchBox.get(watchKey);
            ImagesUtil.saveImage(backImage!.path, tempWatch!, false);
            }
              //Before Navigating back, clear the form, to prevent the back navigation being stopped
              _formKey.currentState!.reset();
              widget.watchViewController.updateSkipBackCheck(true);
              Get.back();

              Get.snackbar(
                  snackTitle,
                  "added to watchbox",
                  snackPosition: SnackPosition.BOTTOM,
                  icon: const Icon(Icons.watch));
            }
          },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.save),
                ),
                Text("Add Watch"),
              ],
            )
        ),
      ),
    );
  }

  Future<File?>addWatchImage(bool front) async {
    return front? frontImage: backImage;
  }

  Future<bool> isBackNavigationAllowed() async {
    bool allowed = true;
    bool editChanges = (widget.watchViewController.watchViewState.value == WatchViewEnum.edit && hasDataChanged());
    bool addChanges = (widget.watchViewController.watchViewState.value == WatchViewEnum.add && newDataInput());

    if (!widget.watchViewController.skipBackCheck.value) {
      if(editChanges || addChanges){
        await analytics.logEvent(name: "edit_pop_dialog",
            parameters: {
              "adding_watch": addChanges.toString(),
              "editing_watch": editChanges.toString()
            });
        allowed = false;
      }
    }

    return allowed;
  }

  bool hasDataChanged(){
    bool returnValue = false;

    if(widget.currentWatch!.status != widget.watchViewController.selectedStatus.value ||
      widget.currentWatch!.manufacturer != manufacturerFieldController.value.text ||
      widget.currentWatch!.model != modelFieldController.value.text ||
      widget.currentWatch!.soldPrice != ViewWatchHelper.getPrice(soldPriceFieldController.value.text) ||
      widget.currentWatch!.purchasePrice != ViewWatchHelper.getPrice(purchasePriceFieldController.value.text) ||
      widget.currentWatch!.category != categoryFieldController.value.text ||
      widget.currentWatch!.soldTo != soldToFieldController.value.text ||
      widget.currentWatch!.purchasedFrom != purchasedFromFieldController.value.text ||
      widget.currentWatch!.movement != movementFieldController.value.text ||
      widget.currentWatch!.lastServicedDate != ViewWatchHelper.getDateFromFieldString(lastServicedDateFieldController.value.text) ||
      widget.currentWatch!.purchaseDate != ViewWatchHelper.getDateFromFieldString(purchaseDateFieldController.value.text) ||
      widget.currentWatch!.serviceInterval != ViewWatchHelper.getIntInputValue(serviceIntervalFieldController.value.text) ||
      widget.currentWatch!.notes != notesFieldController.value.text ||
      widget.currentWatch!.referenceNumber != referenceNumberFieldController.value.text ||
      widget.currentWatch!.serialNumber != serialNumberFieldController.value.text ||
      widget.currentWatch!.soldDate != ViewWatchHelper.getDateFromFieldString(soldDateFieldController.value.text) ||
      widget.currentWatch!.deliveryDate != ViewWatchHelper.getDateFromFieldString(deliveryDateFieldController.value.text) ||
      widget.currentWatch!.warrantyEndDate != ViewWatchHelper.getDateFromFieldString(warrantyEndDateFieldController.value.text) ||
      widget.currentWatch!.caseDiameter != ViewWatchHelper.getDoubleFromStringInput(caseDiameterFieldController.value.text) ||
      widget.currentWatch!.lugWidth != ViewWatchHelper.getIntInputValue(lugWidthFieldController.value.text) ||
      widget.currentWatch!.lug2lug != ViewWatchHelper.getDoubleFromStringInput(lug2lugFieldController.value.text) ||
      widget.currentWatch!.caseThickness != ViewWatchHelper.getDoubleFromStringInput(caseThicknessFieldController.value.text) ||
      widget.currentWatch!.waterResistance != ViewWatchHelper.getIntInputValue(waterResistanceFieldController.value.text) ||
      widget.currentWatch!.caseMaterial != caseMaterialFieldController.value.text ||
      widget.currentWatch!.winderTPD != ViewWatchHelper.getIntInputValue(winderTPDFieldController.value.text) ||
      widget.currentWatch!.winderDirection != winderDirectionFieldController.value.text ||
      widget.currentWatch!.dateComplication != dateComplicationFieldController.value.text
    ){
      returnValue = true;
    }
    return returnValue;
  }

  bool newDataInput(){
    /*
    For new watch entries we currently only need to check for changes on the first info tab as
    the user is prevented from changing tabs without entering data on this one
     */
    bool returnValue = false;
    if(frontImage != null ||
        backImage != null ||
        manufacturerFieldController.value.text.isNotEmpty ||
        modelFieldController.value.text.isNotEmpty ||
        categoryFieldController.value.text.isNotEmpty ||
        serialNumberFieldController.value.text.isNotEmpty ||
        referenceNumberFieldController.value.text.isNotEmpty ||
        movementFieldController.value.text.isNotEmpty ||
        dateComplicationFieldController.value.text.isNotEmpty
    ){
      returnValue = true;
    }

    return returnValue;
  }


    }


