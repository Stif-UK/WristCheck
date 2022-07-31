import 'package:flutter/material.dart';

class AddWatch extends StatefulWidget {
  const AddWatch({Key? key}) : super(key: key);

  @override
  State<AddWatch> createState() => _AddWatchState();
}

class _AddWatchState extends State<AddWatch> {

  //setup input parameters and create form key
  String _manufacturer = "";
  String _model = "";
  String _serialNumber ="";
  bool favourite = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //create widgets for the individual form fields

  Widget _buildManufacturerField(){
    return TextFormField(
      decoration: InputDecoration(labelText: "Manufacturer"),
    //   validator: (String value){
    //     if(value.isEmpty){
    //       return "Manufacturer is required";
    //     }
    // },
    // onSaved: (String value){
    //     _manufacturer = value;
    // },
    );
  }

  // Widget _buildModelField(){
  //   return null;
  // };
  //
  // Widget _buildSerialNumberField(){
  //   return null;
  // };
  //
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
              // _buildModelField(),
              // _buildSerialNumberField(),
              // _buildFavouriteField(),
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
