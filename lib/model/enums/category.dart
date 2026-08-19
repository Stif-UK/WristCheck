import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum CategoryEnum {
  blank,
  dive,
  sports,
  flight,
  field,
  dress,
  tool,
  chronograph,
  travel,
  digital,
  general,
  casual,
  smartWatch
}

extension CategoryEnumLocalization on CategoryEnum {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (this) {
      case CategoryEnum.blank:
        return localizations.notSelected;
      case CategoryEnum.dive:
        return localizations.categoryDiver;
      case CategoryEnum.sports:
        return localizations.categorySports;
      case CategoryEnum.flight:
        return localizations.categoryFlight;
      case CategoryEnum.field:
        return localizations.categoryField;
      case CategoryEnum.dress:
        return localizations.categoryDress;
      case CategoryEnum.tool:
        return localizations.categoryTool;
      case CategoryEnum.chronograph:
        return localizations.categoryChronograph;
      case CategoryEnum.travel:
        return localizations.categoryTravel;
      case CategoryEnum.digital:
        return localizations.categoryDigital;
      case CategoryEnum.general:
        return localizations.categoryGeneral;
      case CategoryEnum.casual:
        return localizations.categoryCasual;
      case CategoryEnum.smartWatch:
        return localizations.categorySmartWatch;
    }
  }

  /// Returns the English string for database storage
  String toDbString() {
    switch (this) {
      case CategoryEnum.blank:
        return "Not Selected";
      case CategoryEnum.dive:
        return "Diver";
      case CategoryEnum.sports:
        return "Sports";
      case CategoryEnum.flight:
        return "Flight";
      case CategoryEnum.field:
        return "Field";
      case CategoryEnum.dress:
        return "Dress";
      case CategoryEnum.tool:
        return "Tool";
      case CategoryEnum.chronograph:
        return "Chronograph";
      case CategoryEnum.travel:
        return "Travel";
      case CategoryEnum.digital:
        return "Digital";
      case CategoryEnum.general:
        return "General";
      case CategoryEnum.casual:
        return "Casual";
      case CategoryEnum.smartWatch:
        return "Smart Watch";
    }
  }

  /// Creates a CategoryEnum from a database string (English)
  static CategoryEnum fromDbString(String? category) {
    switch (category) {
      case "Diver":
        return CategoryEnum.dive;
      case "Sports":
        return CategoryEnum.sports;
      case "Flight":
        return CategoryEnum.flight;
      case "Field":
        return CategoryEnum.field;
      case "Dress":
        return CategoryEnum.dress;
      case "Tool":
        return CategoryEnum.tool;
      case "Chronograph":
        return CategoryEnum.chronograph;
      case "Travel":
        return CategoryEnum.travel;
      case "Digital":
        return CategoryEnum.digital;
      case "General":
        return CategoryEnum.general;
      case "Casual":
        return CategoryEnum.casual;
      case "Smart Watch":
        return CategoryEnum.smartWatch;
      case "Not Selected":
      case "":
      case null:
        return CategoryEnum.blank;
      default:
        return CategoryEnum.blank;
    }
  }
}
