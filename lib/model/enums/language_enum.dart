import 'package:flutter/material.dart';

enum LanguageEnum {
  en,
  fr,
  de
}

extension LanguageEnumExtension on LanguageEnum {
  String get name {
    switch (this) {
      case LanguageEnum.en:
        return 'English';
      case LanguageEnum.fr:
        return 'Français';
      case LanguageEnum.de:
        return 'Deutsch';
        break;
    }
  }

  Locale get locale {
    switch (this) {
      case LanguageEnum.en:
        return const Locale('en');
      case LanguageEnum.fr:
        return const Locale('fr');
      case LanguageEnum.de:
        return const Locale('de');
        break;
    }
  }
}
