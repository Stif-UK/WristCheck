import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum NavBarAlignment { left, center, right }

extension NavBarAlignmentExtension on NavBarAlignment {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case NavBarAlignment.left:
        return localizations.navBarAlignLeft;
      case NavBarAlignment.center:
        return localizations.navBarAlignCenter;
      case NavBarAlignment.right:
        return localizations.navBarAlignRight;
    }
  }

  Alignment toAlignment() {
    switch (this) {
      case NavBarAlignment.left:
        return Alignment.centerLeft;
      case NavBarAlignment.center:
        return Alignment.center;
      case NavBarAlignment.right:
        return Alignment.centerRight;
    }
  }
}
