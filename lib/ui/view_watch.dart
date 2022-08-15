import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/watch_methods.dart';

class ViewWatch extends StatefulWidget {
  //const ViewWatch({Key? key}) : super(key: key);

  final Watches currentWatch;

  ViewWatch({
    required this.currentWatch});

  @override
  State<ViewWatch> createState() => _ViewWatchState();
}

class _ViewWatchState extends State<ViewWatch> {

  //create instance variables to hold element values of the given watch element
  String _serialNo = "Not Provided";
  String _notes = "";
  String _manufacturer = "";
  String _model ="";
  String _status = "In Collection";
  int _serviceInterval = 0;
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

  //form key to allow access to the form state
  final GlobalKey<FormState> _editKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch.manufacturer} ${widget.currentWatch.model}"),
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
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              widget.currentWatch.purchaseDate != null? Text("Purchased: ${DateFormat.yMMMd().format(widget.currentWatch.purchaseDate!)}"): const Text("Purchase Date: Not Recorded"),
              const SizedBox(height: 10),
              widget.currentWatch.lastServicedDate != null? Text("Last Serviced: ${DateFormat.yMMMd().format(widget.currentWatch.lastServicedDate!)}"): const Text("Last serviced: N/A"),
              const SizedBox(height: 10),

              //build service interval selector
              _buildServiceIntervalDropdown(),
              const SizedBox(height: 10),

              //next service due updates automatically - make it editable/overwritable?
              widget.currentWatch.nextServiceDue != null? Text("Next service date: ${DateFormat.yMMMd().format(widget.currentWatch.nextServiceDue!)}"): const Text("Next Service date: N/A"),
              const SizedBox(height: 10),

              //Build Notes Row
              const Text("Notes:"),
              _buildNotesRow(),

            ],
        ),
          ),),
      )
    );
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
}
