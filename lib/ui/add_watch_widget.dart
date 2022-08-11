import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/boxes.dart';
import 'package:intl/intl.dart';


class AddWatch extends StatefulWidget {
  const AddWatch({Key? key}) : super(key: key);

  @override
  State<AddWatch> createState() => _AddWatchState();
}

class _AddWatchState extends State<AddWatch> {


  //setup input parameters and create form key
  String? _manufacturer = "";
  String? _model = "";
  String? _serialNumber = "";
  bool favourite = false;
  String _status = "In Collection";
  DateTime? _purchaseDate;

  //Setup options for watch collection status
  List<String> _statusList = ["In Collection", "Sold", "Wishlist"];
  String? _selectedItem = "In Collection";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //create widgets for the individual form fields

  Widget _buildManufacturerField(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Manufacturer"),
      validator: (String? value){
        if(value == null || value.isEmpty){
          return "Manufacturer is required";
        }
    },

    onSaved: (String? value){
        _manufacturer = value;
    },
    );
  }

  Widget _buildModelField(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Model"),
      validator: (String? value){
        if(value == null || value.isEmpty){
          return "Model is required";
        }
      },
      onSaved: (String? value){
        _model = value;
      },
    );
  }

  Widget _buildSerialNumberField(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Serial Number"),
      // No validation as null is acceptable
      onSaved: (String? value){
        _serialNumber = value;
      },
    );
  }
  
  Widget _buildPurchaseDateField(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text("Purchase Date:"),
        ),
        // SizedBox(width: 1.0,),
        Expanded(
            flex: 6,
            child: _purchaseDate == null ? Text("Click button to enter date (optional)",
            style: TextStyle(fontStyle: FontStyle.italic),) :Text("${DateFormat.yMMMd().format(_purchaseDate!)}"),
    ),


        // SizedBox(width: 1.0,),
        Expanded(
        flex: 3,
        child: OutlinedButton(
          style: ButtonStyle(alignment: Alignment.topCenter, ),

            onPressed: () async {
            DateTime? pDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                lastDate: DateTime(2100));
                //if cancelled then date == null
                if(pDate == null) return;
                //if ok then set the value
                // _purchaseDate = purchaseDate;
                setState(() {
                  _purchaseDate = pDate;
                });
                },
            child: Text("Select Date")),
        ),

        
      ],
    );
  }

  Widget _buildFavouriteRow(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Favourite:"),

          Switch(
              value: favourite,
              onChanged: (value){
                setState(
                        (){
                      favourite = value;
                    }
                );
              }),
        ]

    );
  }

  Widget _buildStatusDropdown(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Status: "),

          DropdownButton(
              value: _selectedItem,
              items: _statusList
                  .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status))

              ).toList(),
              onChanged: (status) {
                _status = status.toString();
                setState(() => _selectedItem = status.toString());
                print(_status);
              }
          ),
        ]
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Add a watch")
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(20),
      child: Column(
        children: [

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildManufacturerField(),
              _buildModelField(),
              _buildSerialNumberField(),
              _buildPurchaseDateField(),
              _buildFavouriteRow(),
              _buildStatusDropdown(),

              //Dropdown selector to capture watch status


              SizedBox(height: 100,),
              RaisedButton(
                  child: Text("Add Watch"),
                  onPressed: () => {
                    //some prints to validate activity

                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save(),
                      addWatch(_manufacturer,_model,_serialNumber,favourite, _status, _purchaseDate),
                      Get.back(),
                      //Display an acknowlegement snackbar - copy changes based on watch status
                      _status == "Wishlist"?
                      Get.snackbar(
                        "Watch Wishlisted",
                        "$_manufacturer $_model has been added to your wishlist",
                        icon: Icon(Icons.watch),
                        snackPosition: SnackPosition.BOTTOM,
                      ) :
                      Get.snackbar(
                        "Watch Added",
                        "$_manufacturer $_model has been added to your watch box",
                        icon: Icon(Icons.watch),
                        snackPosition: SnackPosition.BOTTOM,
                      )

                    },




                  }),
              TextButton(
                  onPressed: (){
                    _formKey.currentState!.reset();
                  },
                  child: Text("Reset Form"))

              ],
          ),
    )
        ],
      ),
      ),
    ),
      )

    );
  }

  Future addWatch(String? manufacturer, String? model, String? serialNumber, bool favourite, String status, DateTime? purchaseDate){
    String m = manufacturer!;
    String mo = model!;
    String? sn = serialNumber;
    bool fv = favourite;
    String st = status;
    DateTime? pd = purchaseDate;


    final watch = Watches()
        ..manufacturer = m
        ..model = mo
        ..serialNumber = sn
        ..favourite = fv
        ..status = st
    ..purchaseDate = pd;

    final box = Boxes.getWatches();

    return box.add(watch);

  }
}
