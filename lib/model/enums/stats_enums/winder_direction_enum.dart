import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum WinderDirectionEnum {clockwise, counterclockwise, both, blank}


extension WinderDirectionEnumLocalization on WinderDirectionEnum {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (this) {
      case WinderDirectionEnum.clockwise:
        return localizations.clockwise;
      case WinderDirectionEnum.counterclockwise:
        return localizations.counterClockwise;
      case WinderDirectionEnum.both:
        return localizations.both;
      case WinderDirectionEnum.blank:
        return '';
    }
  }

  /// Returns the English string for database storage
  String toDbString() {
    switch (this) {
      case WinderDirectionEnum.clockwise:
        return "Clockwise";
      case WinderDirectionEnum.counterclockwise:
        return "Counter-Clockwise";
      case WinderDirectionEnum.both:
        return "Both";
      case WinderDirectionEnum.blank:
        return "";
    }
  }

  /// Creates a WinderDirectionEnum from a database string (English)
  static WinderDirectionEnum fromDbString(String? direction) {
    switch (direction) {
      case "Clockwise":
        return WinderDirectionEnum.clockwise;
      case "Counter-Clockwise":
        return WinderDirectionEnum.counterclockwise;
      case "Both":
        return WinderDirectionEnum.both;
      case "":
      case null:
        return WinderDirectionEnum.blank;
      default:
        return WinderDirectionEnum.blank;
    }
  }
}
