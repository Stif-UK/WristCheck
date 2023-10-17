import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/api/purchase_api.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/onboarding.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class DeveloperStats extends StatefulWidget {
  const DeveloperStats({Key? key}) : super(key: key);

  @override
  State<DeveloperStats> createState() => _DeveloperStatsState();
}

class _DeveloperStatsState extends State<DeveloperStats> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final wristCheckController = Get.put(WristCheckController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer Stats"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

        }, items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.cashRegister),
          label: "Purchase",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.info),
          label: "Info",
        ),
      ],

      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            _currentIndex == 1? ListTile(
              title: const Text("Open Count"),
              subtitle: Text("App Opened: ${WristCheckPreferences.getOpenCount()} times"),
            ): const SizedBox(height: 0,),
            _currentIndex == 1? const Divider(thickness: 2,): const SizedBox(height: 0,),

            _currentIndex == 0? ListTile(
              title: const Text("App Purchased"),
              subtitle: Text("${WristCheckPreferences.getAppPurchasedStatus() ?? false}"),
            ): const SizedBox(height: 0,),
            _currentIndex == 0? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 0? FutureBuilder(
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('${snapshot.error} occurred'),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data as String;
                    return ListTile(
                      title: const Text("Purchase Date"),
                      subtitle: Text(
                        '$data',

                      ),
                    );
                  }
                }
                return const ListTile(
                  title: Text("Purchase Date"),
                  trailing: CircularProgressIndicator(),
                );

              },
              future: getPurchaseDate(),

            ): const SizedBox(height: 0,),
            _currentIndex == 0? const Divider(thickness: 2,): const SizedBox(height: 0,),            _currentIndex == 0? FutureBuilder(
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('${snapshot.error} occurred'),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data as String;
                    return ListTile(
                      title: const Text("Last Donation Date"),
                      subtitle: Text(
                        '$data',

                      ),
                    );
                  }
                }
                return const ListTile(
                  title: Text("Last Donation Date"),
                  trailing: CircularProgressIndicator(),
                );

              },
              future: getLastDonationDate(),

            ): const SizedBox(height: 0,),
            _currentIndex == 0? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 0? FutureBuilder(
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('${snapshot.error} occurred'),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data as String;
                    return ListTile(
                      title: const Text("Last Entitlement Check"),
                      subtitle: Text(
                        '$data',

                      ),
                    );
                  }
                }
                return const ListTile(
                  title: Text("Last Entitlement Check"),
                  trailing: CircularProgressIndicator(),
                );

              },
              future: getLastEntilementCheck(),

            ): const SizedBox(height: 0,),
            _currentIndex == 0? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 0? FutureBuilder(
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('${snapshot.error} occurred'),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    // Extracting data from snapshot object
                    final data = snapshot.data as String;
                    return ListTile(
                      title: const Text("App User ID"),
                      subtitle: Text(
                        '$data',

                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: (){
                          //Copy the appUserID to the clipboard
                          Clipboard.setData(ClipboardData(text:'$data'));
                          Get.snackbar(
                              "Copied",
                              "appUserID saved to clipboard",
                              icon: const Icon(Icons.copy),
                              snackPosition: SnackPosition.BOTTOM
                          );

                        },
                      ),
                    );
                  }
                }
                return const ListTile(
                  title: Text("App User ID"),
                  trailing: CircularProgressIndicator(),
                );

              },
              future: PurchaseApi.getAppUserID(),

            ): const SizedBox(height: 0,),
            _currentIndex == 0? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 1? ListTile(
              title: const Text("Show 'what's new' dialog"),
              subtitle: const Text("Click here to trigger dialog box for testing"),
              onTap: (){
                WristCheckDialogs.getWhatsNewDialog(context);
              },
            ): const SizedBox(height: 0,),
            _currentIndex == 1? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 1? ListTile(
              title: const Text("Show onboarding slides"),
              subtitle: const Text("Click here to trigger the first use demo"),
              onTap: (){
                Get.to(()=>const WristCheckOnboarding());
              },
            ): const SizedBox(height: 0,),
            _currentIndex == 1? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 0? ListTile(
              title: const Text("Revert Purchase Status"),
              subtitle: const Text("Remove pro option and show ads by clicking here. If done in error purchases can be restored on the 'remove ads' page"),
              onTap: (){
                wristCheckController.revertPurchaseStatus();
                Get.snackbar(
                    "Reverted",
                    "User is no longer Pro on this app",
                    icon: const Icon(Icons.no_accounts),
                    snackPosition: SnackPosition.BOTTOM
                );
              },
            ): const SizedBox(height: 0,),
            _currentIndex == 0? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 1? ListTile(
              title: const Text("Reset all dialog preferences"),
              subtitle: const Text("Any dialogs that were chosen to 'not show again' will now be set to show"),
              onTap: (){
                WristCheckPreferences.setShowSoldDialog(true);
                Get.snackbar(
                  "Action",
                  "All Dialogs reset to show",
                  snackPosition: SnackPosition.BOTTOM
                );
              },
            ):const SizedBox(height: 0,),
            _currentIndex == 1? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 1? ListTile(
              title: Text("Generate Crash"),
              subtitle: Text("Caution: Pressing this tile will cause an app crash for crashlytics testing only!"),
              onTap: () => throw Exception("Crashlytics test exception"),
            ): const SizedBox(height: 0,),
            _currentIndex == 1? const Divider(thickness: 2,): const SizedBox(height: 0,),
            _currentIndex == 1? ListTile(
              title: Text("Last Sale Prompt Dismissed"),
              subtitle: WristCheckPreferences.getLastSalePrompt() != null? Text(WristCheckFormatter.getFormattedDate(WristCheckPreferences.getLastSalePrompt()!)) : Text("Not Recorded"),
              onLongPress: () async {
                //When long pressed, push a date > 30 day sin the past
                DateTime newDate = DateTime.now().subtract(Duration(days: 31));
                await WristCheckPreferences.setLastSalePrompt(newDate);
                setState(() {
                  
                });
                Get.snackbar(
                    "Date Amended",
                    "Last Prompted date moved 30+ days into the past",
                    icon: const Icon(Icons.date_range),
                    snackPosition: SnackPosition.BOTTOM
                );
              },
            ): const SizedBox(height: 0,),
            _currentIndex == 1? const Divider(thickness: 2,): const SizedBox(height: 0,),


          ],
        ),
      ),
    );
  }

  Future<String> getPurchaseDate() async {
    return  WristCheckPreferences.getAppPurchasedStatus() ?? false ? WristCheckFormatter.getFormattedDate(DateTime.parse(await PurchaseApi.getAppPurchaseDate(true))): "N/A";
  }

  Future<String> getLastDonationDate() async{
    return WristCheckPreferences.getAppPurchasedStatus() ?? false ? WristCheckFormatter.getFormattedDate(DateTime.parse(await PurchaseApi.getAppPurchaseDate(false))): "N/A";
  }

  Future<String> getLastEntilementCheck() async{
    return WristCheckPreferences.getLastEntitlementCheckDate() != null ? WristCheckFormatter.getFormattedDate(await WristCheckPreferences.getLastEntitlementCheckDate()!): "N/A";
  }


}




// "Last Entitlement Check: ${FryerPreferences.getLastEntitlementCheckDate() != null ? TextHelper.formatDate(await FryerPreferences.getLastEntitlementCheckDate()!): "N/A"}\n\n"
// );
