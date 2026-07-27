import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/**
 * ListTileHelper provides helper methods to generate dynamic elements of List Tiles throughout the app
 */

class ListTileHelper {

  static Widget getServicingIcon(DateTime nextServicingDate){
    var dueSoon = const Icon(Icons.warning_amber_rounded, color: Colors.red,);
    var standard = const Icon(Icons.manage_history_rounded);

    return nextServicingDate.isBefore(Jiffy.now().add(months: 3).dateTime)?  dueSoon :  standard;
  }

  static FaIcon getCategoryIcon(CategoryEnum category){
    FaIcon returnIcon = const FaIcon(FontAwesomeIcons.sitemap);

    switch(category) {
      case CategoryEnum.blank:
        returnIcon = const FaIcon(FontAwesomeIcons.sitemap);
        break;
      case CategoryEnum.dive:
        returnIcon = const FaIcon(FontAwesomeIcons.waterLadder);
        break;
      case CategoryEnum.sports:
        returnIcon = const FaIcon(FontAwesomeIcons.personSnowboarding);
        break;
      case CategoryEnum.flight:
        returnIcon = const FaIcon(FontAwesomeIcons.plane);
        break;
      case CategoryEnum.field:
        returnIcon = const FaIcon(FontAwesomeIcons.personHiking);
        break;
      case CategoryEnum.dress:
        returnIcon = const FaIcon(FontAwesomeIcons.userTie);
        break;
      case CategoryEnum.tool:
        returnIcon = const FaIcon(FontAwesomeIcons.screwdriverWrench);
        break;
      case CategoryEnum.chronograph:
        returnIcon = const FaIcon(FontAwesomeIcons.stopwatch);
        break;
      case CategoryEnum.travel:
        returnIcon = const FaIcon(FontAwesomeIcons.earthAmericas);
        break;
    }

    return returnIcon;
  }

  static String getWatchboxListSubtitle(Watches watch, CollectionView view){
    String returnText = "";

    switch(view) {
      case CollectionView.all:
        returnText = _getStandardReturnText(watch);
        break;
      case CollectionView.favourites:
        returnText = _getStandardReturnText(watch);
        break;
      case CollectionView.wishlist:
        returnText = "";
        break;
      case CollectionView.sold:
        returnText = _getSoldReturnText(watch);
        break;
      case CollectionView.preorder:
        returnText = _getPreOrderReturnText(watch);
        break;
      case CollectionView.random:
        returnText = _getStandardReturnText(watch);
        break;
      case CollectionView.retired:
        returnText = _getStandardReturnText(watch);
        break;
      case CollectionView.onLoan:
        returnText = _getStandardReturnText(watch);
        break;
    }
    return returnText;
  }

  static String _getStandardReturnText(Watches watch){
    final wristCheckController = Get.put(WristCheckController());
    String returnText = "";
    if (watch.wearList.isNotEmpty) {
      int _wearCount = watch.wearList.length;
      watch.wearList.sort();
      String _lastWorn = ViewWatchHelper.isDateToday(watch.wearList.last)
          ? AppLocalizations.of(Get.context!)!.today
          : WristCheckFormatter.getFormattedDate(watch.wearList.last);

      List<String> lines = [];
      if (wristCheckController.showLastWornDate.value) {
        lines.add(AppLocalizations.of(Get.context!)!.lastWornDate(_lastWorn));
      }
      if (wristCheckController.showWearCount.value) {
        lines.add(AppLocalizations.of(Get.context!)!.wearCount(_wearCount));
      }
      if (wristCheckController.showWearFrequency.value) {
        DateTime firstWorn = watch.wearList.first;
        DateTime now = DateTime.now();
        int daysSinceFirstWear = now.difference(firstWorn).inDays + 1;
        var wearFrequency = (watch.wearList.length / daysSinceFirstWear) * 100;
        lines.add(AppLocalizations.of(Get.context!)!.wearFrequency(wearFrequency.toStringAsFixed(0)));
      }
      returnText = lines.join("\n");
    } else {
      returnText = AppLocalizations.of(Get.context!)!.notWornYet;
    }
    return returnText;
  }

  static String _getSoldReturnText(Watches watch){
    final wristCheckController = Get.put(WristCheckController());
    String locale = WristCheckFormatter.getLocaleString(wristCheckController.locale.value);
    String returnText = "";
    DateTime? soldDate = watch.soldDate;
    int soldPrice = watch.soldPrice ?? 0;
    //Where the date or price is not available a placeholder is substituted, i.e Not Recorded
    returnText = AppLocalizations.of(Get.context!)!.soldDetails((soldPrice == 0? AppLocalizations.of(Get.context!)!.notRecorded :
        WristCheckFormatter.getCurrencyValue(locale, soldPrice, 0)),
        (soldDate != null? WristCheckFormatter.getFormattedDate(soldDate):
            AppLocalizations.of(Get.context!)!.notRecorded));
    return returnText;
  }

  static String _getPreOrderReturnText(Watches watch){
    String returnText = AppLocalizations.of(Get.context!)!.countDownNA;
    DateTime? dueDate = watch.deliveryDate;
    if(dueDate != null){
      Duration countdown = DateTime.now().difference(dueDate);
      if(countdown.inDays <= 0){
        returnText = AppLocalizations.of(Get.context!)!.dueInXDays(AppLocalizations.of(Get.context!)!.nDays(countdown.inDays));
        // returnText = "Due: ${countdown.inDays} days";
      }else{
        returnText = AppLocalizations.of(Get.context!)!.overdueXDays(AppLocalizations.of(Get.context!)!.nDays(countdown.inDays));
        // returnText = "Overdue: +${countdown.inDays} days";
      }

    }
    return returnText;
  }


  static FaIcon getWatchOrderIcon(WatchOrder? watchOrder){
    FaIcon returnIcon = const FaIcon(FontAwesomeIcons.sort);

    switch(watchOrder){
      case WatchOrder.watchbox:
        returnIcon = const FaIcon(FontAwesomeIcons.arrowDownWideShort);
        break;
      case WatchOrder.reverse:
        returnIcon = const FaIcon(FontAwesomeIcons.arrowUpWideShort);
        break;
      case WatchOrder.alpha_asc:
        returnIcon = const FaIcon(FontAwesomeIcons.arrowDownAZ);
        break;
      case WatchOrder.alpha_desc:
        returnIcon = const FaIcon(FontAwesomeIcons.arrowUpAZ);
        break;
      case WatchOrder.lastworn:
        returnIcon = const FaIcon(FontAwesomeIcons.arrowDown91);
        break;
      case WatchOrder.mostworn:
        returnIcon = const FaIcon(FontAwesomeIcons.chartLine);
        break;
      default:
        returnIcon = const FaIcon(FontAwesomeIcons.arrowDownWideShort);
        break;
    }

    return returnIcon;
  }

  static TextStyle? getSubtitleTheme(Watches watch){
    TextStyle? returnStyle = null;
    if(watch.status == "Pre-Order" && watch.deliveryDate != null){
      if (watch.deliveryDate!.isBefore(DateTime.now())) {
        returnStyle = TextStyle(
          color: Colors.red
        );
      }
    }
    return returnStyle;
  }


}