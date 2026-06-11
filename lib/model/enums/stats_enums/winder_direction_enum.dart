import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart'; // Adjust path to your generated files

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
}