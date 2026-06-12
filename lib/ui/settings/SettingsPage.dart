import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/language_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/language_enum.dart';
import 'package:wristcheck/ui/archived.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wristcheck/ui/settings/chart_options.dart';
import 'package:wristcheck/ui/developer/developer_stats.dart';
import 'package:wristcheck/ui/settings/locale_options.dart';
import 'package:wristcheck/ui/notifications.dart';
import 'package:wristcheck/ui/onboarding.dart';
import 'package:wristcheck/ui/settings/view_options.dart';




class SettingsPage extends StatefulWidget{




@override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final langController = Get.put(LanguageController());


  String _buildVersion = "";
  int _clickCount = 0;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_){
          _buildVersion = AppLocalizations.of(context)!.unknownAppVersionText;
          _getBuildVersion().then((val) {
            setState(() {
              _buildVersion = val;
            });
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "settings");
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        leading:  IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                WristCheckConfig.enableLanguagePicker? Obx(()=> ListTile(
                  title: Text(AppLocalizations.of(context)!.languageLink),
                  leading: Icon(FontAwesomeIcons.earthAmericas),
                  trailing: DropdownButton(
                      value: langController.language.value.languageCode,
                      items: LanguageEnum.values.map((lang) {
                        return DropdownMenuItem<String>(
                          value: lang.name,
                          child: Text(lang.name), // .name gives the enum case name
                        );
                      }).toList(),
                      onChanged: (newValue){
                        Locale loc = Locale(newValue.toString());
                        print(loc);
                        langController.updateLocalePref(loc);
                      }



                  ),
                ),
                ) : const SizedBox(height: 0,),
                WristCheckConfig.enableLanguagePicker? const Divider(thickness: 2,) : const SizedBox(height: 0,),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.reminderLink),
                    leading: const Icon(Icons.notifications_active_outlined),
                    onTap: ()=> Get.to(()=> Notifications())
                ),
                const Divider(thickness: 2,),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.currencyLink),
                  leading: const Icon(FontAwesomeIcons.dollarSign),
                  onTap: ()=> Get.to(()=> LocationOptions())
                ),
                const Divider(thickness: 2,),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.chartOptionsLink),
                    leading: const Icon(Icons.bar_chart_outlined),
                    onTap: ()=> Get.to(()=> const ChartOptions())
                ),
                const Divider(thickness: 2,),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.appPreferencesLink),
                  leading: const Icon(FontAwesomeIcons.display),
                  onTap: () => Get.to(() => ViewOptions()),
                ),
                const Divider(thickness: 2,),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.showArchiveLink),
                    leading: const Icon(Icons.archive_outlined),
                  onTap: ()=> Get.to(()=> const Archived())
                ),
                const Divider(thickness: 2,),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.showDemoLink),
                  leading: const Icon(FontAwesomeIcons.mobileScreen),
                  onTap: ()=> Get.to(()=> const WristCheckOnboarding())
                ),
                const Divider(thickness: 2,),
              ],
            ),
          ),

          GestureDetector(
            onTap: (){
              _clickCount = _clickCount+1;
              if(_clickCount > 5){
                Get.to(() => const DeveloperStats());
              }
            },
            child: SizedBox(
              height: 50,
              child: Text("${AppLocalizations.of(context)!.appVersion}$_buildVersion"),
            ),
          )
        ],
      ),


    );
  }

  Future<String> _getBuildVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;

  }



}
