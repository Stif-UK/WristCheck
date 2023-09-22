import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class LocationOptions extends StatelessWidget {
  LocationOptions({Key? key}) : super(key: key);

  final wristCheckController = Get.put(WristCheckController());


  @override
  Widget build(BuildContext context) {

    //Instance Variable
    LocationEnum _location = wristCheckController.locale.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Localisation Options"),
        //TODO: Implement some help text
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Placeholder"),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Select Country Settings:", style: Theme.of(context).textTheme.bodyMedium,),
              DropdownButton(
                  dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
                  value: _location,
                  items: LocationEnum.values.map((loca) {
                    return DropdownMenuItem<LocationEnum>(
                        value: loca,
                        child: Text(WristCheckFormatter.getLocaleDisplayText(loca)));
                  }).toList(),
                  onChanged: (location) {
                    //wristCheckController.updateLocale(location);
                  }
              )
            ],
          )
        ],
      ),
    );
  }
}
