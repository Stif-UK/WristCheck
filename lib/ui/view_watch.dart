import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/watch_methods.dart';
// import 'package:wristcheck/copy/snackbars.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/wear_dates_widget.dart';
import 'package:image_picker/image_picker.dart';


class ViewWatch extends StatefulWidget {
  //const ViewWatch({Key? key}) : super(key: key);

  final Watches currentWatch;

  ViewWatch({
    required this.currentWatch});

  @override
  State<ViewWatch> createState() => _ViewWatchState();
}

class _ViewWatchState extends State<ViewWatch> {



  //ToDo: Refactor out into utility class?
//pickImage() allows the user to pick the image from either the gallery or camera
  Future pickImage({required ImageSource source,
  }) async {
    //required Future<File> Function(File file) cropImage}
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      final imageTemporary = File(image.path);
      var croppedImage = await cropImage(imageTemporary);
      var returnImage;
     // croppedImage == null? var returnImage = File(croppedImage.path) : return null;
      if(croppedImage == null){
        return null;
    } else{
         returnImage = File(croppedImage.path);
         WatchMethods.saveImage(croppedImage.path, widget.currentWatch);
         setState(() => this.image = returnImage);
      }


      // return cropSquareImage(File(imageTemporary.path)) as File;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      //ToDo: Implement error handling
      return null;
    }
  }

  Future<CroppedFile?> cropImage(File imageFile) async{
    return await ImageCropper.platform.cropImage(sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 70,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [androidUIsettingsForCrop(),iOSUIsettingsForCrop()]
    );
  }

//create UI settings for the crop
  AndroidUiSettings androidUIsettingsForCrop() => AndroidUiSettings(
    toolbarTitle: "Crop watch image",
  );

  IOSUiSettings iOSUIsettingsForCrop() => IOSUiSettings(
    title: "Crop Image"
  );



  //create instance variables to hold element values of the given watch element
  String _serialNo = "Not Provided";
  String _notes = "";
  String _manufacturer = "";
  String _model ="";
  String _status = "In Collection";
  int _serviceInterval = 0;
  DateTime? _purchaseDate;
  DateTime? _lastServiceDate;
  //variables for status dropdown
  final List<String> _statusList = ["In Collection", "Sold", "Wishlist"];
  String? _selectedStatus = "In Collection";
  //variables for service schedule dropdown
  final List<int> _serviceList = [0,1,2,3,4,5,6,7,8,9,10];
  int _selectedInterval = 0;

  //create bools to confirm if field is in an editable state
  bool canEditManufacturer = false;
  bool canEditModel = false;
  bool canEditSerialNo = false;
  bool canEditNotes = false;
  bool canEditStatus = false;
  bool canEditServiceInterval = false;
  bool canEditPurchaseDate = false;
  bool canEditLastServiceDate = false;
  bool canRecordWear = false;
  //ToDo: Need to reset ALL to false via a method whenever one is set to true - only ever one field editable. Would need to make this list of variables into a map

  //Temporary file to display watch image
  File? image;

  //form key to allow access to the form state
  final GlobalKey<FormState> _editKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    //check if wear button should be enabled
    widget.currentWatch.status == "In Collection"? canRecordWear = true : canRecordWear = false;
    //If there is a saved image, get it
    // image = WatchMethods.getImage(widget.currentWatch)

    return FutureBuilder<File?>(
        future: WatchMethods.getImage(widget.currentWatch),
        builder: (context, AsyncSnapshot<File?> snapshot) {
          if (snapshot.hasData) {
            try {
              snapshot.data == File("")? image = null :
              image = snapshot.data;
            } on Exception catch(e){
              print("Exception caught in implementing file: $e");
              image = null;
          }
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                      "${widget.currentWatch.manufacturer} ${widget.currentWatch
                          .model}"),
                  actions: const [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.edit),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    //margin: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _editKey,
                      //Build the page layout
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          //Placeholder image picker
                          _displayWatchImage(),

                          //Wear button and stats
                          _buildWearRow(),

                          const SizedBox(height: 20),


                          //build Manufacturer row
                          const Text("Manufacturer:"),
                          _buildManufacturerRow(),

                          //build model row
                          const Text("Model:"),
                          _buildModelRow(),

                          //Build Serial Number row
                          const Text("Serial Number:"),
                          _buildSerialNumberRow(),

                          //build favourite toggle
                          _buildFavouriteRow(widget.currentWatch),

                          //build collection status toggle
                          _buildStatusDropdownRow(),

                          const SizedBox(height: 10),
                          //build purchase date row
                          _buildPurchaseDateRow(),
                          const SizedBox(height: 10),

                          //build service interval selector
                          _buildServiceIntervalDropdown(),
                          const SizedBox(height: 10),

                          //build last serviced date field
                          _buildLastServicedDateRow(),
                          const SizedBox(height: 10,),


                          //Next service due by field is not editable
                          widget.currentWatch.nextServiceDue != null
                              ? Text(
                              "Next service date by: ${DateFormat.yMMMd()
                                  .format(
                                  widget.currentWatch.nextServiceDue!)}")
                              : const Text("Next Service due by: N/A"),
                          const SizedBox(height: 10),

                          //Build Notes Row
                          const Text("Notes:"),
                          _buildNotesRow(),

                        ],
                      ),
                    ),),
                )
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
          );


        //end FutureBuilder here
  }






  //Favourite selector toggle
  Widget _buildFavouriteRow(Watches watch){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
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

  //Widget to build collection status dropdown
  Widget _buildStatusDropdownRow(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
              flex: 4,
              child: Text("Status: ")
          ),

          Expanded(
            flex: 3,
            child: canEditStatus? DropdownButton(
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
            ) :
              Text(widget.currentWatch.status.toString())
          ),
          Expanded(
              flex: 2,
              child:  InkWell(
                  child: ViewWatchHelper.getEditIcon(canEditStatus),
                  onTap: () => setState(() {
                    //if save is hit, we then trigger the update on the database only if it has changed
                    if(canEditStatus && widget.currentWatch.status != _status) {
                      widget.currentWatch.status = _status;
                      widget.currentWatch.save();
                    }
                    canEditStatus = !canEditStatus;
                  })
              )
          )

        ]
    );
  }

  //Widget to create service Interval selector
  Widget _buildServiceIntervalDropdown(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
              flex: 4,
              child:Text("Service Interval: ")
          ),

          //If not editable the display text, otherwise display dropdown
          Expanded(
              flex: 3,
              child:canEditServiceInterval? DropdownButton(
                  value: _selectedInterval,
                  items: _serviceList
                      .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.toString()))

                  ).toList(),
                  onChanged: (status) {
                    _serviceInterval = status as int;
                    setState(() => _selectedInterval = status as int);
                  }
              ) :
                  Text(ViewWatchHelper.getScheduleText(widget.currentWatch.serviceInterval, widget.currentWatch))
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                  child: const Icon(Icons.help_outline),
                  onTap: () => WristCheckDialogs.getServiceIntervalTooltipDialog()
              )
          ),
          Expanded(
              flex: 2,
              child:  InkWell(
                  child: ViewWatchHelper.getEditIcon(canEditServiceInterval),
                  onTap: () => setState(() {
                    //if save is hit, we then trigger the update on the database only if it has changed
                    if(canEditServiceInterval && widget.currentWatch.serviceInterval != _serviceInterval) {
                      widget.currentWatch.serviceInterval = _serviceInterval;
                      //if we update the service interval we also have to re-calculate the next service date
                      widget.currentWatch.nextServiceDue = WatchMethods.calculateNextService(widget.currentWatch.purchaseDate, widget.currentWatch.lastServicedDate, _serviceInterval);
                      widget.currentWatch.save();
                    }
                    canEditServiceInterval = !canEditServiceInterval;
                  })
              )
          )
        ]
    );
  }

  Widget _buildNotesRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: TextFormField(
            initialValue: widget.currentWatch.notes,
            enabled: canEditNotes,
            maxLines: 10,
            onSaved: (String? value){
              value != null? _notes = value : _notes = "";
            } ,
            decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                    )
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red
                    )
                )
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child:  InkWell(
                child: ViewWatchHelper.getEditIcon(canEditNotes),
                onTap: () => setState(() {
                  //if the field isn't empty, trigger it's save() method which sets the instance variable serialNo
                  _editKey.currentState != null? _editKey.currentState!.save(): print("state is null");
                  //if save is hit, we then trigger the update on the database only if it has changed
                  if(canEditNotes && widget.currentWatch.notes != _notes) {
                    print("updating notes");
                    widget.currentWatch.notes = _notes;
                    widget.currentWatch.save();
                  }
                  canEditNotes = !canEditNotes;
                })
            )
        )
      ],
    );
  }

  Widget _buildSerialNumberRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: TextFormField(
            initialValue: widget.currentWatch.serialNumber,
            enabled: canEditSerialNo,
            onSaved: (String? value){
              value != null? _serialNo = value : _serialNo = "Not Provided";
            } ,
            decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                    )
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red
                    )
                )
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child:  InkWell(
                child: ViewWatchHelper.getEditIcon(canEditSerialNo),
                onTap: () => setState(() {
                  //if the field isn't empty, trigger it's save() method which sets the instance variable serialNo
                  _editKey.currentState != null? _editKey.currentState!.save(): print("state is null");
                  //if save is hit, we then trigger the update on the database only if it has changed
                  if(canEditSerialNo && widget.currentWatch.serialNumber != _serialNo) {
                    widget.currentWatch.serialNumber = _serialNo;
                    widget.currentWatch.save();
                  }
                  canEditSerialNo = !canEditSerialNo;
                })
            )
        )
      ],
    );
  }

  Widget _buildModelRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: TextFormField(
            initialValue: widget.currentWatch.model,
            enabled: canEditModel,
            onSaved: (String? value){
              value != null? _model = value : _model = widget.currentWatch.model;
            } ,
            decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                    )
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red
                    )
                )
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child:  InkWell(
                child: ViewWatchHelper.getEditIcon(canEditModel),
                onTap: () => setState(() {
                  //if the field isn't empty, trigger it's save() method which sets the instance variable serialNo
                  _editKey.currentState != null? _editKey.currentState!.save(): print("state is null");
                  //if save is hit, we then trigger the update on the database only if it has changed
                  if(canEditModel && widget.currentWatch.model != _model) {
                    widget.currentWatch.model = _model;
                    widget.currentWatch.save();
                  }
                  canEditModel = !canEditModel;
                })
            )
        )
      ],
    );
  }

  Widget _buildManufacturerRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: TextFormField(
            initialValue: widget.currentWatch.manufacturer,
            enabled: canEditManufacturer,
            onSaved: (String? value){
              value != null? _manufacturer = value : _manufacturer = widget.currentWatch.manufacturer;
            } ,
            decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                    )
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red
                    )
                )
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child:  InkWell(
                child: ViewWatchHelper.getEditIcon(canEditManufacturer),
                onTap: () => setState(() {
                  //if the field isn't empty, trigger it's save() method which sets the instance variable serialNo
                  _editKey.currentState != null? _editKey.currentState!.save(): print("state is null");
                  //if save is hit, we then trigger the update on the database only if it has changed
                  if(canEditManufacturer && widget.currentWatch.manufacturer != _manufacturer) {
                    widget.currentWatch.manufacturer = _manufacturer;
                    widget.currentWatch.save();
                  }
                  canEditManufacturer = !canEditManufacturer;
                })
            )
        )
      ],
    );
  }

  Widget _buildPurchaseDateRow(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
              flex: 4,
              child: Text("Purchased: ")
          ),

          Expanded(
              flex: 3,
              child: Text(ViewWatchHelper.getPurchaseDateToDisplay(widget.currentWatch, _purchaseDate, canEditPurchaseDate))
          ),
          Expanded(
              flex: 2,
              child:  InkWell(
                  child: ViewWatchHelper.getEditIcon(canEditPurchaseDate),
                  onTap: ()  async {
                    if(!canEditPurchaseDate) {
                  DateTime? pDate = await showDatePicker(
                      context: context,
                      initialDate: widget.currentWatch.purchaseDate != null
                          ? widget.currentWatch.purchaseDate!
                          : DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  //if cancelled then date == null
                  if (pDate == null) return;

                  setState(() {
                    _purchaseDate = pDate;
                    canEditPurchaseDate = !canEditPurchaseDate;
                  });
                } else {
                      //code to save to database
                      setState(() {
                        if (canEditPurchaseDate &&
                            widget.currentWatch.purchaseDate != _purchaseDate) {
                          widget.currentWatch.purchaseDate = _purchaseDate;
                          //With the purchase date updated, should also now re-calculate the next service date
                          widget.currentWatch.nextServiceDue = WatchMethods.calculateNextService(widget.currentWatch.purchaseDate, widget.currentWatch.lastServicedDate, widget.currentWatch.serviceInterval);
                          widget.currentWatch.save();
                          canEditPurchaseDate = !canEditPurchaseDate;
                        }
                      }
                        );

                    }
              }

                  )
              )


        ]
    );
  }

  Widget _buildLastServicedDateRow(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
              flex: 4,
              child: Text("Last Serviced: ")
          ),

          Expanded(
              flex: 3,
              //need to udpate to lastServicedDate - need method to determind which version to return
              child: Text(ViewWatchHelper.getServiceDateToDisplay(widget.currentWatch, _lastServiceDate, canEditLastServiceDate))
              // _lastServiceDate != null ?  Text(DateFormat
              //     .yMMMd().format(_lastServiceDate!)) : const Text("Not Recorded"),
              //
            // Text(ViewWatchHelper.getPurchaseDateToDisplay(widget.currentWatch, _purchaseDate, canEditPurchaseDate))
          ),
          Expanded(
              flex: 2,
              child:  InkWell(
                  child: ViewWatchHelper.getEditIcon(canEditLastServiceDate),
                  onTap: ()  async {
                    if(!canEditLastServiceDate) {
                      DateTime? pDate = await showDatePicker(
                          context: context,
                          initialDate: widget.currentWatch.lastServicedDate != null
                              ? widget.currentWatch.lastServicedDate!
                              : DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      //if cancelled then date == null
                      if (pDate == null) return;

                      setState(() {
                        _lastServiceDate = pDate;
                        canEditLastServiceDate = !canEditLastServiceDate;
                      });
                    } else {
                      //code to save to database
                      setState(() {
                        if (canEditLastServiceDate &&
                            widget.currentWatch.lastServicedDate != _lastServiceDate) {
                          widget.currentWatch.lastServicedDate = _lastServiceDate;
                          //With the purchase date updated, should also now re-calculate the next service date
                          widget.currentWatch.nextServiceDue = WatchMethods.calculateNextService(widget.currentWatch.purchaseDate, widget.currentWatch.lastServicedDate, widget.currentWatch.serviceInterval);
                          widget.currentWatch.save();
                          canEditLastServiceDate = !canEditLastServiceDate;
                        }
                      }
                      );

                    }
                  }
              )
          )


        ]
    );
  }


  Widget _displayWatchImage(){
    //TODO: Implement image picker and data model
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        const Expanded(
          flex: 2,
            child: SizedBox(height: 10)),
        Expanded(
          flex: 6,
          child: Container(
              margin: const EdgeInsets.all(20),
              //Padding and borderradius not required once image is selected
              padding: image == null? const EdgeInsets.all(40): null,
              decoration: image == null? BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  //ToDo: Ensure border colour works on both light and dark theme
                  border: Border.all(width: 2, color: Colors.white)) : null,
              //If we have an image display it (ClipRRect used to round corners to soften the image)
              child: image == null? const Icon(Icons.camera_alt, size: 100): ClipRRect(
                  child: Image.file(image!),
                borderRadius: BorderRadius.circular(16),
              )
          ),
              // child: image == null? const Icon(Icons.camera_alt,size: 100)):,

          ),
        Expanded(
          flex: 2,
          child: InkWell(
              child: const Icon(Icons.add_a_photo_outlined),
          onTap: () async {

                var imageSource = await _imageSourcePopUp();
                pickImage(source: imageSource!);
          }
          ),
        ),


      ],
    );
  }

  Widget _addWearButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //ToDo: Disable this button unless status is 'In Collection'
        ElevatedButton(
            child: const Text("Wear this watch today"),
          onPressed: () {
              if(canRecordWear) {
                var wearDate = DateTime.now();
                WatchMethods.attemptToRecordWear(
                    widget.currentWatch, wearDate, false).then((_) =>
                {
                  //ToDo: Defect where if a watch is worn more than once in a day the UI doesn't refresh on submission
                  setState(() {})
                });
              } else { null; }




          },

        ),
      ],
    );
  }

  Widget _displayLastWearDate(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Last worn: ${ViewWatchHelper.getLastWearDate(widget.currentWatch)}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),),
      ],
    );
  }

  Widget _displayWearCount(){
    var wearCount = widget.currentWatch.wearList.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        wearCount == 1? const Text("Worn 1 time"): Text("Worn: $wearCount times",
          ),
      ],
    );
  }

  Widget _buildWearRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(),
        ),
        Expanded(
          flex:6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _addWearButton(),
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
                      Get.to(() => WearDatesWidget(currentWatch: widget.currentWatch))!.then((_) => setState(
                          (){}
                      ));
                  },
                )
              ],
            ))
      ],
    );
  }

  //Triggers a bottom sheet giving the user the option to select the picture from the camera or gallery
  Future<ImageSource?> _imageSourcePopUp() async {
    return showModalBottomSheet(context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text("Take with Camera"),
              onTap: ()=> Navigator.of(context).pop(ImageSource.camera)
            ),
            ListTile(
                leading: const Icon(Icons.camera_roll_outlined),
                title: const Text("Select from Gallery"),
                onTap: ()=> Navigator.of(context).pop(ImageSource.gallery)
            )
          ],

        ));
  }

}
