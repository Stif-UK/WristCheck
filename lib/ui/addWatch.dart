import 'package:flutter/material.dart';

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




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Add a watch")
      ),
      body: Padding(
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

              Row(
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

              ),

              SizedBox(height: 100,),
              RaisedButton(
                  child: Text("Add Watch"),
                  onPressed: () => {
                    //some prints to validate activity

                    if(_formKey.currentState!.validate()){
                      print("Validation output: ${_formKey.currentState!.validate()}"),
                      _formKey.currentState!.save(),
                      print("form saved")
                    },
                    print("button pressed.\n"
                        "manufacturer: $_manufacturer\n"
                        "model: $_model\n"
                        "serial number: $_serialNumber\n"
                        "favourite: $favourite"),


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
      )
    );
  }
}
