import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/remove_ads.dart';

class WristcheckProPrompt extends StatelessWidget {


  WristcheckProPrompt({
    Key? key,
    required this.textWidget
  }) : super(key: key);

  final Widget textWidget;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text(l!.wristTrackProFeature, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),
        ),
        Image.asset('assets/customicons/pro_icon.png',scale:1.0,height:75.0,width:75.0, color: Theme.of(context).hintColor),
        textWidget,
        ElevatedButton(
          child: Text(l.tellMeMore),
          onPressed: () => Get.to(() => RemoveAds()),
        )
      ],
    );
  }
}
