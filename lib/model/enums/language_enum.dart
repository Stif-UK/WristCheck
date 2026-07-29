import 'package:flutter/material.dart';

enum LanguageEnum {
  en,
  fr,
  de,
  ru,
  cs,
  es,
  it,
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
      case LanguageEnum.cs:
        return 'Čeština';
      case LanguageEnum.es:
        return 'Español';
      case LanguageEnum.it:
        return 'Italiano';
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
      case LanguageEnum.ru:
        return const Locale('ru');
      case LanguageEnum.cs:
        return const Locale('cs');
      case LanguageEnum.es:
        return const Locale('es');
      case LanguageEnum.it:
        return const Locale('it');
    }
  }
}
