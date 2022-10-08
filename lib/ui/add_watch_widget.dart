import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/watch_methods.dart';


class AddWatch extends StatefulWidget {
  const AddWatch({Key? key}) : super(key: key);

  @override
  State<AddWatch> createState() => _AddWatchState();
}

class _AddWatchState extends State<AddWatch> {


  //setup input parameters and create form key
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

  //Setup options for watch collection status
  final List<String> _statusList = ["In Collection", "Sold", "Wishlist"];
  String? _selectedStatus = "In Collection";
  //Setup options for service interval
  final List<int> _serviceList = [0,1,2,3,4,5,6,7,8,9,10];
  int _selectedInterval = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //create widgets for the individual form fields

  //Manufacturer form field
  Widget _buildManufacturerField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Manufacturer"),
      textCapitalization: TextCapitalization.words,
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

  //Model form field
  Widget _buildModelField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Model"),
      textCapitalization: TextCapitalization.words,
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

  //Serial Number form field
  Widget _buildSerialNumberField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Serial Number"),
      // No validation as null is acceptable
      onSaved: (String? value){
        _serialNumber = value;
      },
    );
  }

  //Serial Number form field
  Widget _referenceNumberFormField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Reference Number"),
      // No validation as null is acceptable
      onSaved: (String? value){
        _referenceNumber = value;
      },
    );
  }

  //Purchase date date picker
  Widget _buildPurchaseDateField(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Expanded(
          flex: 3,
          child: Text("Purchased:"),
        ),
        // SizedBox(width: 1.0,),
        Expanded(
            flex: 6,
            child: _purchaseDate == null ? const Text("No date entered",
            style: TextStyle(fontStyle: FontStyle.italic),) :Text("${DateFormat.yMMMd().format(_purchaseDate!)}"),
    ),


        // SizedBox(width: 1.0,),
        Expanded(
        flex: 3,
        child: OutlinedButton(
          style: const ButtonStyle(alignment: Alignment.topCenter, ),

            onPressed: () async {
            DateTime? pDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                lastDate: DateTime(2100));
                //if cancelled then date == null
                if(pDate == null) return;

                setState(() {
                  _purchaseDate = pDate;
                });
                },
            child: const Text("Select Date")),
        ),

        
      ],
    );
  }

  //Purchase date date picker
  Widget _buildLastServicedDateField(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Expanded(
          flex: 3,
          child: Text("Last Serviced:"),
        ),
        // SizedBox(width: 1.0,),
        Expanded(
          flex: 6,
          child: _lastServicedDate == null ? const Text("No date entered",
            style: TextStyle(fontStyle: FontStyle.italic),) :Text("${DateFormat.yMMMd().format(_lastServicedDate!)}"),
        ),


        // SizedBox(width: 1.0,),
        Expanded(
          flex: 3,
          child: OutlinedButton(
              style: const ButtonStyle(alignment: Alignment.topCenter, ),

              onPressed: () async {
                DateTime? pDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                //if cancelled then date == null
                if(pDate == null) return;

                setState(() {
                  _lastServicedDate = pDate;
                });
              },
              child: const Text("Select Date")),
        ),


      ],
    );
  }


  //Favourite selector toggle
  Widget _buildFavouriteRow(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Favourite:"),

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

  //Watch collection status dropdown menu
  Widget _buildStatusDropdown(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            flex: 6,
              child: Text("Status: ")
          ),

          Expanded(
            flex: 4,
            child:DropdownButton(
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
          ),
          )
        ]
    );
  }

  //Service Interval selector
  Widget _buildServiceIntervalDropdown(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            flex: 8,
              child:Text("Service Interval (years): ")
          ),

          Expanded(
            flex: 2,
              child:DropdownButton(
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
          )
          ),
          Expanded(
          flex: 1,
    child: InkWell(
    child: const Icon(Icons.help_outline),
    onTap: () => WristCheckDialogs.getServiceIntervalTooltipDialog()
    )
    )
        ]
    );
  }

  //Build multi-line notes field
  Widget _buildNotesField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Notes"),
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 10,
      onSaved: (String? value){
        _notes = value;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Add a watch")
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildManufacturerField(),
              _buildModelField(),
              _buildStatusDropdown(),
              _buildFavouriteRow(),
              ExpansionTile(title: const Text("Additional information (optional)"),
              children: [
                _buildSerialNumberField(),
                _referenceNumberFormField(),
                _buildPurchaseDateField(),
                const Divider(),
                _buildLastServicedDateField(),
                const Divider(),
                _buildServiceIntervalDropdown(),
              ],
              ),
              _buildNotesField(),


              //Dropdown selector to capture watch status


              const SizedBox(height: 100,),
              ElevatedButton(
                  child: const Text("Add Watch"),
                  onPressed: () => {
                    //some prints to validate activity

                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save(),
                      WatchMethods.addWatch(_manufacturer, _model, _serialNumber, favourite, _status, _purchaseDate, _lastServicedDate, _serviceInterval, _notes, _referenceNumber),
                      Get.back(),
                      //Display an acknowlegement snackbar - copy changes based on watch status
                      _status == "Wishlist"?
                      Get.snackbar(
                        "Watch Wishlisted",
                        "$_manufacturer $_model has been added to your wishlist",
                        icon: const Icon(Icons.watch),
                        snackPosition: SnackPosition.BOTTOM,
                      ) :
                      Get.snackbar(
                        "Watch Added",
                        "$_manufacturer $_model has been added to your watch box",
                        icon: const Icon(Icons.watch),
                        snackPosition: SnackPosition.BOTTOM,
                      )

                    },




                  }),
              TextButton(
                  onPressed: (){
                    _formKey.currentState!.reset();
                  },
                  child: const Text("Reset Form"))

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

}
