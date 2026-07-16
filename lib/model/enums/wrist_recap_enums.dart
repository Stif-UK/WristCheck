import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum WristRecapEnums {monthly, annually, allData, last30days, last90days, last365days, sinceLastPurchase, betweenDates}

extension WristRecapEnumsExtension on WristRecapEnums {
  String toLocalizedString(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    switch (this) {
      case WristRecapEnums.monthly:
        return l.recapMonthly;
      case WristRecapEnums.annually:
        return l.recapAnnually;
      case WristRecapEnums.allData:
        return l.allData;
      case WristRecapEnums.last30days:
        return l.last30days;
      case WristRecapEnums.last90days:
        return l.last90days;
      case WristRecapEnums.last365days:
        return l.last365days;
      case WristRecapEnums.sinceLastPurchase:
        return l.sinceLastPurchase;
      case WristRecapEnums.betweenDates:
        return l.betweenSelectedDates;
    }
  }
}
