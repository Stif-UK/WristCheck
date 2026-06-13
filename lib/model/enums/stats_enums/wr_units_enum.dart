import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum WRUnitsEnum {metres, feet}

extension WrUnitsEnumLocalization on WRUnitsEnum {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (this) {
      case WRUnitsEnum.metres:
        return localizations.meters;
      case WRUnitsEnum.feet:
        return localizations.feet;
    }
  }
}