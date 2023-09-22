import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class LocationOptions extends StatefulWidget {
  LocationOptions({Key? key}) : super(key: key);

  @override
  State<LocationOptions> createState() => _LocationOptionsState();
}

class _LocationOptionsState extends State<LocationOptions> {
  final wristCheckController = Get.put(WristCheckController());

  @override
  Widget build(BuildContext context) {

    EdgeInsetsGeometry pagePadding = const EdgeInsets.all(10.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Localisation Options"),
        //TODO: Implement some help text
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: pagePadding,
              child: Text("WristCheck can track values of watches and collections, and in places will display these in a format of your choosing.", style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
            ),
            Padding(
              padding: pagePadding,
              child: Text("Please select your preferred currency layout:", style: Theme.of(context).textTheme.bodyLarge,),
            ),
            Obx(
                ()=> Padding(
                  padding: pagePadding,
                  child: DropdownButton<LocationEnum>(
                    dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
                    value: wristCheckController.locale.value,
                    items: LocationEnum.values.map((loca) {
                      return DropdownMenuItem<LocationEnum>(
                          value: loca,
                          child: Text(WristCheckFormatter.getLocaleDisplayText(loca)));
                    }).toList(),
                    onChanged: (lcn) {
                      // location = lcn!;
                      wristCheckController.updateLocale(lcn!);
                    }
              ),
                ),
            ),
            Padding(
              padding: pagePadding,
              child: Text("Example output", style: Theme.of(context).textTheme.bodyLarge,),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Text("Date Format:",style: Theme.of(context).textTheme.bodyLarge,),
            // ),
            // Obx(()=> Text(DateFormat.yMd(WristCheckFormatter.getLocaleString(wristCheckController.locale.value)).format(DateTime.now()))),

            Obx(()=> Text(NumberFormat.simpleCurrency(locale: WristCheckFormatter.getLocaleString(wristCheckController.locale.value), decimalDigits: 2).format(12345.99),
                  style: Theme.of(context).textTheme.headlineSmall,))

          ],
        ),
      ),
    );
  }
}
