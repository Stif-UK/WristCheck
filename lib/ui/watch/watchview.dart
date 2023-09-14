import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/wear_dates_widget.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/model/watch_methods.dart';

class WatchView extends StatefulWidget {
  WatchView({
    Key? key,
  this.currentWatch
  }) : super(key: key);

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
  int _currentIndex = 0;
  String _manufacturer = "";
  String _model = "";
  String? _serialNumber;
  bool favourite = false;
  String _status = "In Collection";
  DateTime? _purchaseDate;
  DateTime? _lastServicedDate;
  int _serviceInterval = 0;
  String? _notes ="";
  String? _referenceNumber = "";
  File? image;
  bool front = true;
  File? frontImage;
  File? backImage;
  int? watchKey; //Used to save images to newly added watches
  Watches? currentWatch;
  bool canRecordWear = false;

  //Setup options for watch collection status
  final List<String> _statusList = ["In Collection", "Sold", "Wishlist", "Archived"];
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
  final serviceIntervalFieldController = TextEditingController();
  final notesFieldController = TextEditingController();
  final purchaseDateFieldController = TextEditingController();
  final lastServicedDateFieldController = TextEditingController();
  final nextServiceDueFieldController = TextEditingController();

  @override
  void dispose(){
    //clean up the controller when the widget is disposed TODO: Update to ensure each controller is disposed
    manufacturerFieldController.dispose();
    modelFieldController.dispose();
    serialNumberFieldController.dispose();
    referenceNumberFieldController.dispose();
    serialNumberFieldController.dispose();
    purchaseDateFieldController.dispose();
    notesFieldController.dispose();
    lastServicedDateFieldController.dispose();
    nextServiceDueFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WatchViewEnum watchviewState = ViewWatchHelper.getWatchViewState(widget.currentWatch, widget.inEditState);

    if(watchviewState!= WatchViewEnum.add){
      //check if wear button should be enabled
      if (watchviewState == WatchViewEnum.view) {
        widget.currentWatch!.status == "In Collection"? canRecordWear = true : canRecordWear = false;
      }

      _manufacturer = widget.currentWatch!.manufacturer;
      _model = widget.currentWatch!.model;
      _serialNumber = widget.currentWatch!.serialNumber;
      _referenceNumber = widget.currentWatch!.referenceNumber;
      _serviceInterval = widget.currentWatch!.serviceInterval;
      //Load note content, only if note is not being edited
      if(!widget.inEditState) {
        manufacturerFieldController.value =
            TextEditingValue(text: widget.currentWatch!.manufacturer);
        modelFieldController.value =
            TextEditingValue(text: widget.currentWatch!.model);
        serialNumberFieldController.value =
            TextEditingValue(text: widget.currentWatch!.serialNumber ??"");
        referenceNumberFieldController.value = TextEditingValue(text: widget.currentWatch!.referenceNumber ?? "");
        serviceIntervalFieldController.value = TextEditingValue(text: widget.currentWatch!.serviceInterval.toString());
        purchaseDateFieldController.value = TextEditingValue(text: widget.currentWatch!.purchaseDate != null? WristCheckFormatter.getFormattedDate(widget.currentWatch!.purchaseDate!): "Not Recorded");
        lastServicedDateFieldController.value = TextEditingValue(text: widget.currentWatch!.lastServicedDate != null? WristCheckFormatter.getFormattedDate(widget.currentWatch!.lastServicedDate!): "N/A");
        DateTime? nextServiceDue = WatchMethods.calculateNextService(widget.currentWatch!.purchaseDate, widget.currentWatch!.lastServicedDate, widget.currentWatch!.serviceInterval);
        nextServiceDueFieldController.value = TextEditingValue(text: nextServiceDue != null? WristCheckFormatter.getFormattedDate(nextServiceDue): "N/A");
        notesFieldController.value =
            TextEditingValue(text: widget.currentWatch!.notes ?? "");
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: ViewWatchHelper.getTitle(watchviewState, _manufacturer, _model),


          actions:[
            //Show edit button if a watch object is loaded and state is view
            ViewWatchHelper.getWatchViewState(widget.currentWatch, widget.inEditState) == WatchViewEnum.view? Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.penToSquare),
              onPressed: (){
                setState(() {
                  widget.inEditState = true;
                });
              },
            ),
          ) : const SizedBox(height: 0,),
            //Show save button if in edit state //TODO: Update to also include add state
            ViewWatchHelper.getWatchViewState(widget.currentWatch, widget.inEditState) == WatchViewEnum.edit? Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.floppyDisk),
                onPressed: (){
                  setState(() {
                    //TODO: Implement save call and change state
                    widget.inEditState = false;
                  });
                },
              ),
            ) : const SizedBox(height: 0,),
          ]

      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon:  Icon(Icons.watch),
            label: "Info",
          ),
          BottomNavigationBarItem(
            icon:  Icon(FontAwesomeIcons.calendar),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon:  Icon(FontAwesomeIcons.dollarSign),
            label: "Costs",
          ),
          BottomNavigationBarItem(
            icon:  Icon(FontAwesomeIcons.book),
            label: "Notes",
          )
        ],

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Build the UI from components
                    //Watch Images
                    //TODO: Image option for Add state
                    //TODO: Image isn't loading - require Futurebuilder in place
                    watchviewState == WatchViewEnum.view || watchviewState == WatchViewEnum.edit? _displayWatchImageViewEdit(): const SizedBox(height: 0,),
                    watchviewState == WatchViewEnum.view? _buildWearRow() : const SizedBox(height: 0,),
                    const Divider(thickness: 2,),
                    Row(
                      children: [
                        Expanded(
                            child: _buildStatusDropdownRow(watchviewState)
                        ),
                        watchviewState == WatchViewEnum.add? const SizedBox(height: 0,):_buildFavouriteRow(widget.currentWatch!),
                      ],
                    ),
                    const Divider(thickness: 2,),
                    Column(
                      children: [
                        //Tab one - Watch info
                        _currentIndex == 0? _manufacturerRow(watchviewState): const SizedBox(height: 0,),
                        _currentIndex == 0? _modelRow(watchviewState): const SizedBox(height: 0,),
                        _currentIndex == 0? _serialNumberRow(watchviewState): const SizedBox(height: 0,),
                        _currentIndex == 0? _referenceNumberRow(watchviewState): const SizedBox(height: 0,),
                        //Tab two - Schedule info
                        _currentIndex == 1? _purchaseDateRow(watchviewState): const SizedBox(height: 0,),
                        _currentIndex == 1? _serviceIntervalRow(watchviewState): const SizedBox(height: 0,),
                        _currentIndex == 1? _lastServicedDateRow(watchviewState): const SizedBox(height: 0,),
                        _currentIndex == 1 && watchviewState == WatchViewEnum.view? _nextServiceDueRow(watchviewState) : const SizedBox(height: 0,),
                        //Tab three - cost info
                        //Add purchase price row
                        //Add sold price row
                        //Add cost per wear calculation row and maybe a graph?

                        //Tab four - Notebook
                        _currentIndex == 3? _notesRow(watchviewState): const SizedBox(height: 0,),
                        const Divider(thickness: 2,)
                        //Implement Add / Save button
                      ],
                    ),



                  ],
                )
              ))
        ],
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
                    await ImagesUtil.pickAndSaveImage(source: imageSource!, currentWatch: widget.currentWatch!, front: front);
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

  Widget _buildWearRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          flex: 2,
          child: Column(),
        ),
        Expanded(
          flex:6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.currentWatch!.status == "In Collection"? _addWearButton() : const SizedBox(height: 10),
              const SizedBox(height: 10),
              //Show last worn date
              _displayLastWearDate(),
              _displayWearCount(),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: const Icon(Icons.calendar_month),
                  // onTap: () => Get.to(() => WearDatesWidget(currentWatch: widget.currentWatch,)),
                  onTap: (){
                    Get.to(() => WearDatesWidget(currentWatch: widget.currentWatch!))!.then((_) => setState(
                            (){}
                    ));
                  },
                )
              ],
            ))
      ],
    );
  }

  Widget _displayLastWearDate(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Last worn: ${ViewWatchHelper.getLastWearDate(widget.currentWatch!)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),),
      ],
    );
  }

  Widget _displayWearCount(){
    var wearCount = widget.currentWatch!.wearList.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        wearCount == 1? const Text("Worn 1 time"): Text("Worn: $wearCount times",
        ),
      ],
    );
  }

  Widget _addWearButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text("Wear this watch today"),
          onPressed: () {
            if(canRecordWear) {
              var wearDate = DateTime.now();
              WatchMethods.attemptToRecordWear(
                  widget.currentWatch!, wearDate, false).then((_) =>
              {
                setState(() {})
              });
            } else { null; }
          },
        ),
      ],
    );
  }

  Widget _manufacturerRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.building),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Manufacturer:",
      hintText: "Manufacturer",
      maxLines: 1,
      controller: manufacturerFieldController,
      textCapitalization: TextCapitalization.words,
      validator: (String? val) {
        //TODO: Amend validation
        if(!val!.isAlphaNumericAndNotEmpty) {
          print(!val!.isAlphaNumericAndNotEmpty);
          return 'Manufacturer missing or invalid characters included';
        }
      },
    );
  }

  Widget _modelRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(Icons.watch),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Model:",
      hintText: "Model",
      maxLines: 1,
      controller: modelFieldController,
      textCapitalization: TextCapitalization.words,
      validator: (String? val) {
        //TODO: Amend validation
        if(!val!.isAlphaNumericAndNotEmpty) {
          print(!val!.isAlphaNumericAndNotEmpty);
          return 'Model is missing or invalid characters included';
        }
      },
    );
  }

  Widget _serialNumberRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.barcode),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Serial Number:",
      hintText: "Serial Number",
      maxLines: 1,
      controller: serialNumberFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        //TODO: Amend validation - field is optional!
        if(!val!.isAlphaNumericAndNotEmpty) {
          print(!val!.isAlphaNumericAndNotEmpty);
          return 'Serial Number is missing or invalid characters included';
        }
      },
    );
  }

  Widget _referenceNumberRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.hashtag),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Reference Number:",
      hintText: "Reference Number",
      maxLines: 1,
      controller: referenceNumberFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        //TODO: Amend validation - field is optional!
        if(!val!.isAlphaNumericAndNotEmpty) {
          print(!val!.isAlphaNumericAndNotEmpty);
          return 'Reference Number is missing or invalid characters included';
        }
      },
    );
  }

  //Favourite selector toggle - ONLY SHOW FOR VIEW/EDIT!
  Widget _buildFavouriteRow(Watches watch){
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("Favourite:"),

          Switch(
              value: watch.favourite,
              onChanged: (value){
                setState(
                        (){
                      watch.favourite = value;
                      watch.save();
                    }
                );
              }),
        ]

    );
  }

  Widget _buildStatusDropdownRow(WatchViewEnum watchviewState){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //const Text("Status: "),

            watchviewState == WatchViewEnum.view? Text(widget.currentWatch!.status.toString()):
            DropdownButton(
                value: _selectedStatus,
                items: _statusList
                    .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status))

                ).toList(),
                onChanged: (status) {
                  _status = status.toString();
                  setState(() => _selectedStatus = status.toString());
                }
            )


          ]
      ),
    );
  }

  Widget _serviceIntervalRow(WatchViewEnum watchviewState){
    return WatchFormField(
      keyboardType: TextInputType.number,
      icon: const Icon(FontAwesomeIcons.arrowsSpin),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Service Interval:",
      hintText: "Service Interval (years)",
      maxLines: 1,
      controller: serviceIntervalFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        //TODO: This should accept null
        if(!val!.isServiceNumber) {
          print(!val!.isServiceNumber);
          return 'Service interval must be a whole number between 0 - 99';
        }
      },
    );
  }

  Widget _purchaseDateRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendar),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Purchase Date:",
      hintText: "Purchase Date",
      maxLines: 1,
      datePicker: true,
      controller: purchaseDateFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        //TODO: Validation?
        if(!val!.isServiceNumber) {
          print(!val!.isServiceNumber);
          return 'Service interval must be a whole number between 0 - 99';
        }
      },
    );
  }

  Widget _lastServicedDateRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendarCheck),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Last Serviced Date:",
      hintText: "Last Serviced Date",
      maxLines: 1,
      datePicker: true,
      controller: lastServicedDateFieldController,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        //TODO: Validation?
        if(!val!.isServiceNumber) {
          print(!val!.isServiceNumber);
          return 'Service interval must be a whole number between 0 - 99';
        }
      },
    );
  }

  Widget _nextServiceDueRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.calendarDays),
      //Always read only
      enabled: false,
      fieldTitle: "Next Service Due:",
      hintText: "Next Service Due",
      maxLines: 1,
      controller: nextServiceDueFieldController,
      textCapitalization: TextCapitalization.none,
    );
  }

  Widget _notesRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.noteSticky),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Notes:",
      hintText: "Notes",
      minLines: 4,
      maxLines: 150,
      controller: notesFieldController,
      textCapitalization: TextCapitalization.sentences,
      validator: (String? val) {
        //TODO: Amend validation - can be empty
        if(!val!.isAlphaNumericAndNotEmpty) {
          print(!val!.isAlphaNumericAndNotEmpty);
          return 'Invalid characters entered';
        }
      },
    );
  }
}

