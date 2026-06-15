import 'package:flutter/material.dart';

enum LanguageEnum {
  en,
  fr,
  de,
  ru
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
      case LanguageEnum.ru:
        return 'Русский';
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
      case LanguageEnum.ru:
        return const Locale('ru');
        break;
    }
  }
}
