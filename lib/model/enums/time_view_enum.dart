import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum TimeViewEnum {moonphase, gmt}

extension TimeViewEnumExtension on TimeViewEnum {
  String toLocalizedString(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    switch (this) {
      case TimeViewEnum.moonphase:
        return l.timeViewMoonPhase;
      case TimeViewEnum.gmt:
        return l.timeViewGMT;
    }
  }
}
