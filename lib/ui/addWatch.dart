import 'package:flutter/material.dart';

class AddWatch extends StatefulWidget {
  const AddWatch({Key? key}) : super(key: key);

  @override
  State<AddWatch> createState() => _AddWatchState();
}

class _AddWatchState extends State<AddWatch> {

  //setup input parameters and create form key
  String? _manufacturer;
  String? _model;
  String? _serialNumber;
  bool favourite = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //create widgets for the individual form fields

  Widget _buildManufacturerField(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Manufacturer"),
      validator: (value){
        if(value == null || value.isEmpty){
          return "Manufacturer is required";
        }
    },
    onSaved: (value){
        _manufacturer = value;
    },
    );
  }

  Widget _buildModelField(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Model"),
      validator: (value){
        if(value == null || value.isEmpty){
          return "Model is required";
        }
      },
      onSaved: (value){
        _model = value;
      },
    );
  }

  Widget _buildSerialNumberField(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Serial Number"),
      // No validation as null is acceptable
      onSaved: (value){
        _serialNumber = value;
      },
    );
  }

  // //ToDo:This is a bool field? I think I can remove and replace with a toggle?
  // Widget _buildFavouriteField(){
  //   return null;
  // };


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Add a watch")
      ),
      body: Column(

        children: [

          Form(
            child: Column(
            children: [
              _buildManufacturerField(),
              _buildModelField(),
              _buildSerialNumberField(),
              // _buildFavouriteField(),
              // Switch(value: _favourite, onChanged: (value){
              //   _favourite = true;
              // }),
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
                  onPressed: () => {})

              ],
          ),
    )
        ],
      ),
    );
  }
}
