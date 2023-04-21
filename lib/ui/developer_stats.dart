import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wristcheck/api/purchase_api.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/list_tile_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class DeveloperStats extends StatefulWidget {
  const DeveloperStats({Key? key}) : super(key: key);

  @override
  State<DeveloperStats> createState() => _DeveloperStatsState();
}

class _DeveloperStatsState extends State<DeveloperStats> {
  @override
  Widget build(BuildContext context) {
    final wristCheckController = Get.put(WristCheckController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer Stats"),
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Divider(thickness: 2,),
            ListTile(
              title: const Text("Open Count"),
              subtitle: Text("App Opened: ${WristCheckPreferences.getOpenCount()} times"),
            ),
            const Divider(thickness: 2,),

            ListTile(
              title: const Text("App Purchased"),
              subtitle: Text("${WristCheckPreferences.getAppPurchasedStatus() ?? false}"),
            ),
            const Divider(thickness: 2,),
            FutureBuilder(
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

            ),
            const Divider(thickness: 2,),
            FutureBuilder(
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

            ),
            const Divider(thickness: 2,),
            FutureBuilder(
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

            ),
            const Divider(thickness: 2,),
            FutureBuilder(
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

            ),
            const Divider(thickness: 2,),
            ListTile(
              title: const Text("Show 'what's new' dialog"),
              subtitle: const Text("Click here to trigger dialog box for testing"),
              onTap: (){
                WristCheckDialogs.getWhatsNewDialog(context);
              },
            ),
            const Divider(thickness: 2,),
            ListTile(
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
            )

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
