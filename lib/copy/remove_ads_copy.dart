import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:get/get.dart';

class RemoveAdsCopy{

  static getRemoveAdsMainCopy(BuildContext context){
    final l = AppLocalizations.of(context);
    return Container(
      child: Markdown(
          shrinkWrap: true,
          styleSheet: MarkdownStyleSheet(p: Theme.of(context).textTheme.bodyLarge),
          data: l!.removeAdsMainCopy,
      ),
    );
  }

  static getSupporterMainCopy(BuildContext context){
    return Text(
      AppLocalizations.of(context)!.supporterCopy,
      style: Theme.of(context).textTheme.bodyLarge,);
  }



  static getButtonLabel(){
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(AppLocalizations.of(Get.context!)!.showPaymentOptions),
    );
  }

  static getButtonLabelSupporter(){
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(AppLocalizations.of(Get.context!)!.donateAgain),
    );
  }
}