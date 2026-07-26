import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/privacy/initialisation_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyLanding extends StatefulWidget {
  const PrivacyLanding();

  @override
  State<PrivacyLanding> createState() => _PrivacyLandingState();
}

class _PrivacyLandingState extends State<PrivacyLanding> {
  final _initialisationHelper = InitialisationHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacy),
      ),
      body: Column(
        children: [
          ListTile(title: Text(AppLocalizations.of(context)!.privacyPolicy),
          subtitle: Text(AppLocalizations.of(context)!.opensInBrowser),
          leading: const Icon(Icons.privacy_tip_outlined),
          onTap: () async {
            final Uri url = Uri.parse('https://www.wristtrack.app/privacypolicy/');
            if (!await launchUrl(url)) {
              throw Exception('Could not launch $url');
            }
          }),
          const Divider(thickness: 2,),
          ListTile(title: Text(AppLocalizations.of(context)!.privacySettings),
          leading: const Icon(Icons.settings),
          onTap: () async{
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final didChangePreferences =
                await _initialisationHelper.changePrivacyPreferences();
            scaffoldMessenger.showSnackBar(SnackBar(content: Text(
              didChangePreferences? AppLocalizations.of(context)!.privacySettingsUpdated : AppLocalizations.of(context)!.privacyError
            ),));
          },),
          const Divider(thickness: 2,),
        ],
      ),
    );
  }
}
