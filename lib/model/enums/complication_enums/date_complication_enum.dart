import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum DateComplicationEnum {
  date,
  nodate,
  daydate,
  pointerdate,
  subdialdate,
  perpetualdate,
  digitaldate,
  blank
}

extension DateComplicationEnumLocalization on DateComplicationEnum {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (this) {
      case DateComplicationEnum.date:
        return localizations.dateComplicationsDate;
      case DateComplicationEnum.nodate:
        return localizations.dateComplicationsNoDate;
      case DateComplicationEnum.daydate:
        return localizations.dateComplicationsDayDate;
      case DateComplicationEnum.pointerdate:
        return localizations.dateComplicationsPointerDate;
      case DateComplicationEnum.subdialdate:
        return localizations.dateComplicationsSubDialDate;
      case DateComplicationEnum.perpetualdate:
        return localizations.dateComplicationsPerpetualDate;
      case DateComplicationEnum.digitaldate:
        return localizations.dateComplicationsDigitalDate;
      case DateComplicationEnum.blank:
        return localizations.notRecorded;
    }
  }

  /// Returns the English string for database storage
  String toDbString() {
    switch (this) {
      case DateComplicationEnum.date:
        return "Date";
      case DateComplicationEnum.nodate:
        return "No Date";
      case DateComplicationEnum.daydate:
        return "Day-Date";
      case DateComplicationEnum.pointerdate:
        return "Pointer Date";
      case DateComplicationEnum.subdialdate:
        return "Sub-Dial Date";
      case DateComplicationEnum.perpetualdate:
        return "Perpetual Date";
      case DateComplicationEnum.digitaldate:
        return "Digital Date";
      case DateComplicationEnum.blank:
        return "Not Entered";
    }
  }

  /// Creates a DateComplicationEnum from a database string (English)
  static DateComplicationEnum fromDbString(String? date) {
    switch (date) {
      case "Date":
        return DateComplicationEnum.date;
      case "No Date":
        return DateComplicationEnum.nodate;
      case "Day-Date":
        return DateComplicationEnum.daydate;
      case "Pointer Date":
        return DateComplicationEnum.pointerdate;
      case "Sub-Dial Date":
        return DateComplicationEnum.subdialdate;
      case "Perpetual Date":
        return DateComplicationEnum.perpetualdate;
      case "Digital Date":
        return DateComplicationEnum.digitaldate;
      case "Not Entered":
      case "":
      case null:
        return DateComplicationEnum.blank;
      default:
        return DateComplicationEnum.blank;
    }
  }
}
