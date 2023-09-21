import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/wear_dates_widget.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:intl/intl.dart';

import '../../util/list_tile_helper.dart';

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
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.banner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  //Identify locale
  String locale = Intl.getCurrentLocale();
  //Instance Variables
  final watchBox = Boxes.getWatches();
  int _currentIndex = 0;
  String _manufacturer = "";
  String _model = "";
  String? _serialNumber = "";
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
  String? _movement;
  String? _category;
  String? _purchasedFrom = "";
  String? _soldTo = "";
  int _purchasePrice = 0;

  //Setup options for watch collection status
  final List<String> _statusList = ["In Collection", "Sold", "Wishlist", "Archived"];
  String? _selectedStatus = "In Collection";
  int _selectedInterval = 0;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WatchViewEnum watchviewState = ViewWatchHelper.getWatchViewState(widget.currentWatch, widget.inEditState);

    void saveAndUpdate(){
      //Validate the form
      if (_formKey.currentState!.validate()) {
        //Ensure watch is not null
        if(widget.currentWatch != null) {

          _manufacturer = manufacturerFieldController.value.text;
          _model = modelFieldController.value.text;
          //convert service interval field to int
          _serviceInterval = getServiceInterval(serviceIntervalFieldController.value.text);
          _purchaseDate = getDateFromFieldString(purchaseDateFieldController.value.text);
          _lastServicedDate = getDateFromFieldString(lastServicedDateFieldController.value.text);
          _movement = movementFieldController.value.text;
          _category = categoryFieldController.value.text;
          _purchasedFrom = purchasedFromFieldController.value.text;
          _soldTo = soldToFieldController.value.text;
          _purchasePrice = getPurchasePrice(purchasePriceFieldController.value.text);


          widget.currentWatch!.manufacturer = _manufacturer;
          widget.currentWatch!.model = _model;
          widget.currentWatch!.status = _selectedStatus;
          widget.currentWatch!.serialNumber = serialNumberFieldController.value.text;
          widget.currentWatch!.referenceNumber = referenceNumberFieldController.value.text;
          widget.currentWatch!.serviceInterval = _serviceInterval;
          widget.currentWatch!.purchaseDate = _purchaseDate;
          widget.currentWatch!.lastServicedDate = _lastServicedDate;
          widget.currentWatch!.nextServiceDue = WatchMethods.calculateNextService(_purchaseDate, _lastServicedDate, _serviceInterval);
          widget.currentWatch!.notes = notesFieldController.value.text;
          widget.currentWatch!.movement = _movement;
          widget.currentWatch!.category = _category;
          widget.currentWatch!.purchasedFrom = _purchasedFrom;
          widget.currentWatch!.soldTo = _soldTo;
          widget.currentWatch!.purchasePrice = _purchasePrice;
          widget.currentWatch!.save();

          Get.snackbar("$_manufacturer $_model",
              "Updates Saved",
            snackPosition: SnackPosition.BOTTOM
          );

        }
        setState(() {
          widget.inEditState = false;
        });
      }
    }

    Widget _saveWatchUpdateButton(){
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: ElevatedButton(
                onPressed: (){
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
      _movement = widget.currentWatch!.movement;
      _category = widget.currentWatch!.category;
      _purchasedFrom = widget.currentWatch!.purchasedFrom;
      _soldTo = widget.currentWatch!.soldTo;
      _purchasePrice = widget.currentWatch!.purchasePrice ?? 0;

      //Load watch content, only if watch is not being edited
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

        movementFieldController.value = TextEditingValue(text: widget.currentWatch!.movement?? WristCheckFormatter.getMovementText(MovementEnum.blank));
        categoryFieldController.value = TextEditingValue(text: widget.currentWatch!.category?? WristCheckFormatter.getCategoryText(CategoryEnum.blank));
        purchasedFromFieldController.value = TextEditingValue(text: widget.currentWatch!.purchasedFrom ?? "");
        soldToFieldController.value = TextEditingValue(text: widget.currentWatch!.soldTo ?? "");
        //check if the purchaseprice associated with the watch is null - if so, return an empty string, otherwise return a string representation of the integer
        var watchPriceValue = widget.currentWatch!.purchasePrice;
        purchasePriceFieldController.value = TextEditingValue(text: watchPriceValue != null? watchPriceValue.toString() : "" );
      }
    }
    //Wrap Scaffold in a FutureBuilder to show images once loaded
    
    return FutureBuilder<File?>(
        future: watchviewState != WatchViewEnum.add? ImagesUtil.getImage(widget.currentWatch!, front): addWatchImage(front),
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
                      watchviewState, _manufacturer, _model),


                  actions: [
                    //Show edit button if a watch object is loaded and state is view
                    ViewWatchHelper.getWatchViewState(
                        widget.currentWatch, widget.inEditState) ==
                        WatchViewEnum.view ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(FontAwesomeIcons.penToSquare),
                        onPressed: () {
                          setState(() {
                            widget.inEditState = true;
                          });
                        },
                      ),
                    ) : const SizedBox(height: 0,),
                    ViewWatchHelper.getWatchViewState(
                        widget.currentWatch, widget.inEditState) ==
                        WatchViewEnum.edit ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(FontAwesomeIcons.floppyDisk),
                        onPressed: () {
                          setState(() {
                            saveAndUpdate();
                          });
                        },
                      ),
                    ) : const SizedBox(height: 0,),
                  ]

              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }
                },
                items: const [
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
                    label: "Deal",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.book),
                    label: "Notes",
                  )
                ],

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
                            child: Column(
                              children: [
                                //Build the UI from components
                                //Watch Images
                                _displayWatchImageViewEdit(watchviewState),
                                watchviewState == WatchViewEnum.view
                                    ? _buildWearRow()
                                    : const SizedBox(height: 0,),
                                const Divider(thickness: 2,),
                                Row(
                                  children: [
                                    Expanded(
                                        child: _buildStatusDropdownRow(
                                            watchviewState)
                                    ),
                                    watchviewState == WatchViewEnum.add
                                        ? const SizedBox(height: 0,)
                                        : _buildFavouriteRow(
                                        widget.currentWatch!),
                                  ],
                                ),
                                const Divider(thickness: 2,),
                                Column(
                                  children: [
                                    //Tab one - Watch info
                                    _currentIndex == 0 ? _manufacturerRow(
                                        watchviewState) : const SizedBox(
                                      height: 0,),
                                    _currentIndex == 0
                                        ? _modelRow(watchviewState)
                                        : const SizedBox(height: 0,),
                                    _currentIndex == 0 ? _buildCategoryField(watchviewState != WatchViewEnum.view): const SizedBox(height: 0,),
                                    _currentIndex == 0 ? _serialNumberRow(
                                        watchviewState) : const SizedBox(
                                      height: 0,),
                                    _currentIndex == 0 ? _referenceNumberRow(
                                        watchviewState) : const SizedBox(
                                      height: 0,),
                                    _currentIndex == 0? _buildMovementField(watchviewState != WatchViewEnum.view) : const SizedBox(height: 0,),
                                    //Tab two - Schedule info
                                    _currentIndex == 1 ? _purchaseDateRow(
                                        watchviewState) : const SizedBox(
                                      height: 0,),
                                    _currentIndex == 1 ? _serviceIntervalRow(
                                        watchviewState) : const SizedBox(
                                      height: 0,),
                                    _currentIndex == 1 ? _lastServicedDateRow(
                                        watchviewState) : const SizedBox(
                                      height: 0,),
                                    _currentIndex == 1 &&
                                        watchviewState == WatchViewEnum.view
                                        ? _nextServiceDueRow(watchviewState)
                                        : const SizedBox(height: 0,),
                                    //Tab three - cost info
                                    _currentIndex == 2 ? _purchasePriceRow(watchviewState): const SizedBox(height: 0,),
                                    _currentIndex == 2 ? _purchaseFromRow(watchviewState): const SizedBox(height: 0,),

                                    //Add sold price row
                                    _currentIndex == 2? _soldToRow(watchviewState): const SizedBox(height: 0,),
                                    //Add cost per wear calculation row and maybe a graph?

                                    //Tab four - Notebook
                                    _currentIndex == 3
                                        ? _notesRow(watchviewState)
                                        : const SizedBox(height: 0,),
                                    const Divider(thickness: 2,),
                                    //Implement Add / Save button and next button to show if in an 'add' state
                                    watchviewState == WatchViewEnum.add &&
                                        _currentIndex < 3
                                        ? _nextTabButton()
                                        : const SizedBox(height: 10,),
                                    watchviewState == WatchViewEnum.add
                                        ? _addWatchButton()
                                        : const SizedBox(height: 0,),

                                    //implement a save button to show when in an edit state
                                    watchviewState == WatchViewEnum.edit
                                        ? _saveWatchUpdateButton()
                                        : const SizedBox(height: 0,)


                                  ],
                                ),
                              ],
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
    );
  }

  //Code to create individual sections of the UI - consider externalising these!

  Widget _displayWatchImageViewEdit(WatchViewEnum watchViewState){
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
                    if (watchViewState != WatchViewEnum.add) {
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
      fieldTitle: watchviewState == WatchViewEnum.add? "Serial Number (Optional)": "Serial Number:",
      hintText: "Serial Number",
      maxLines: 1,
      controller: serialNumberFieldController,
      textCapitalization: TextCapitalization.none,
      // validator: (String? val) {
      //   //TODO: Amend validation - field is optional!
      //   if(!val!.isAlphaNumericAndNotEmpty) {
      //     print(!val!.isAlphaNumericAndNotEmpty);
      //     return 'Serial Number is missing or invalid characters included';
      //   }
      // },
    );
  }

  Widget _referenceNumberRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.hashtag),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: watchviewState == WatchViewEnum.add? "Reference Number (Optional)": "Reference Number:",
      hintText: "Reference Number",
      maxLines: 1,
      controller: referenceNumberFieldController,
      textCapitalization: TextCapitalization.none,
      // validator: (String? val) {
      //   //TODO: Amend validation - field is optional!
      //   if(!val!.isAlphaNumericAndNotEmpty) {
      //     print(!val!.isAlphaNumericAndNotEmpty);
      //     return 'Reference Number is missing or invalid characters included';
      //   }
      // },
    );
  }

  Widget _buildMovementField(bool edit){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Movement:",
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,),
        Padding(
          padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
          child: DropdownButtonFormField<MovementEnum>(
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            menuMaxHeight: 300,
            value: WristCheckFormatter.getMovementEnum(_movement),
            iconSize: edit? 24.0: 0.0,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(const Icon(FontAwesomeIcons.gears,), context),
              items: MovementEnum.values.map((movement) {
                return DropdownMenuItem<MovementEnum>(
                  value: movement,
                    child: Text(WristCheckFormatter.getMovementText(movement)));
              }).toList(),
              onChanged: edit? (movement){
              setState(() {
                _movement = WristCheckFormatter.getMovementText(movement!);
                movementFieldController.value = TextEditingValue(text:WristCheckFormatter.getMovementText(movement!));
              });
              } : null ),
        ),
      ],
    );
  }

  Widget _buildCategoryField(bool edit){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category:",
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,),
        Padding(
          padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
          child: DropdownButtonFormField<CategoryEnum>(
              dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
              borderRadius: BorderRadius.circular(24),
              menuMaxHeight: 300,
              value: WristCheckFormatter.getCategoryEnum(_category),
              iconSize: edit? 24.0: 0.0,
              decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(ListTileHelper.getCategoryIcon(WristCheckFormatter.getCategoryEnum(_category)), context),
              items: CategoryEnum.values.map((category) {
                return DropdownMenuItem<CategoryEnum>(
                    value: category,
                    child: Text(WristCheckFormatter.getCategoryText(category)));
              }).toList(),
              onChanged: edit? (category){
                setState(() {
                  _category = WristCheckFormatter.getCategoryText(category!);
                  categoryFieldController.value = TextEditingValue(text:WristCheckFormatter.getCategoryText(category!));
                });
              } : null ),
        ),
      ],
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
                dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
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
          return 'Must be 0-99 or blank';
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
      // validator: (String? val) {
      //   //TODO: Validation?
      //   if(!val!.isServiceNumber) {
      //     print(!val!.isServiceNumber);
      //     return 'Service interval must be a whole number between 0 - 99';
      //   }
      // },
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

  Widget _purchasePriceRow(WatchViewEnum watchviewState){
    //if state is add or edit, return a formfield to take an integer input otherwise return a field returning a view of the price
    return watchviewState != WatchViewEnum.view ? WatchFormField(
      icon: const Icon(FontAwesomeIcons.moneyBill1),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Purchase Price:",
      hintText: "Purchased Price",
      maxLines: 1,
      controller: purchasePriceFieldController,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.none,
      validator: (String? val) {
        if(!val!.isWcCurrency) {
          return "Enter digits only, no decimals, we'll take care of the rest!";
        }
      },
    ):
    //Alternate return view
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Purchase Price:",
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(FontAwesomeIcons.moneyBill1),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(_purchasePrice == 0 ? "": NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0).format(_purchasePrice),
                style: Theme.of(context).textTheme.bodyLarge,),
            ),
          ],
        )
      ],
    )
    ;
  }

  Widget _purchaseFromRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.cartShopping),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Purchased From:",
      hintText: "Purchased From",
      maxLines: 1,
      controller: purchasedFromFieldController,
      textCapitalization: TextCapitalization.sentences,
      // validator: (String? val) {
      //   //TODO: Amend validation
      //   if(!val!.isAlphaNumericAndNotEmpty) {
      //     print(!val!.isAlphaNumericAndNotEmpty);
      //     return 'Model is missing or invalid characters included';
      //   }
      // },
    );
  }

  Widget _soldToRow(WatchViewEnum watchviewState){
    return WatchFormField(
      icon: const Icon(FontAwesomeIcons.handHoldingHand),
      enabled: watchviewState == WatchViewEnum.view? false: true,
      fieldTitle: "Sold To:",
      hintText: "Sold to",
      maxLines: 1,
      controller: soldToFieldController,
      textCapitalization: TextCapitalization.sentences,
      // validator: (String? val) {
      //   //TODO: Amend validation
      //   if(!val!.isAlphaNumericAndNotEmpty) {
      //     print(!val!.isAlphaNumericAndNotEmpty);
      //     return 'Model is missing or invalid characters included';
      //   }
      // },
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
      // validator: (String? val) {
      //   //TODO: Amend validation - can be empty
      //   if(!val!.isAlphaNumericAndNotEmpty) {
      //     print(!val!.isAlphaNumericAndNotEmpty);
      //     return 'Invalid characters entered';
      //   }
      // },
    );
  }

  Widget _nextTabButton(){
    return Center(
      child: ElevatedButton(
        onPressed: (){
          if(_formKey.currentState!.validate()) {
          setState(() {
            _currentIndex = _currentIndex + 1;
          });
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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            if(_formKey.currentState!.validate()){
              var snackTitle = "${manufacturerFieldController.value.text} ${modelFieldController.value.text}";

              _purchaseDate = getDateFromFieldString(purchaseDateFieldController.value.text);
              _lastServicedDate = getDateFromFieldString(lastServicedDateFieldController.value.text);
              _serviceInterval = getServiceInterval(serviceIntervalFieldController.value.text);
              _purchasePrice = getPurchasePrice(purchasePriceFieldController.value.text);

              watchKey = await WatchMethods.addWatch(
                  manufacturerFieldController.value.text,
                  modelFieldController.value.text,
                  serialNumberFieldController.value.text,
                  favourite,
                  _status,
                  _purchaseDate,
                  _lastServicedDate,
                  _serviceInterval,
                  notesFieldController.value.text,
                  referenceNumberFieldController.value.text,
                  movementFieldController.value.text,
                categoryFieldController.value.text,
                purchasedFromFieldController.value.text,
                soldToFieldController.value.text,
                _purchasePrice
              );
              //if a front image has been set, we add this to the newly created watch before exiting
              if(frontImage != null){
                currentWatch = watchBox.get(watchKey);
            ImagesUtil.saveImage(frontImage!.path, currentWatch!, true);
            }
            //and repeat for the back image
            if(backImage != null){
            currentWatch = watchBox.get(watchKey);
            ImagesUtil.saveImage(backImage!.path, currentWatch!, false);
            }

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

  int getServiceInterval(String serviceIntervalString){
    return serviceIntervalString.length == 0? 0: int.parse(serviceIntervalString);
  }

  int getPurchasePrice(String purchasePrice){
    return purchasePrice.length == 0? 0: int.parse(purchasePrice);
  }

  Future<File?>addWatchImage(bool front) async {
    return front? frontImage: backImage;
  }

  DateTime? getDateFromFieldString(String dateField){
    if(dateField == "Not Recorded" || dateField == "N/A"){
      return null;
    } else {
      final dateFormat = DateFormat('MMM d, yyyy');
      return dateField.length != 0 ? dateFormat.parse(dateField) : null;
    }
  }



    }


