import 'package:flutter/material.dart';

enum LanguageEnum {
  en,
  fr
}

extension LanguageEnumExtension on LanguageEnum {
  String get name {
    switch (this) {
      case LanguageEnum.en:
        return 'English';
      case LanguageEnum.fr:
        return 'Français';
    }
  }

  Locale get locale {
    switch (this) {
      case LanguageEnum.en:
        return const Locale('en');
      case LanguageEnum.fr:
        return const Locale('fr');
    }
  }
}
