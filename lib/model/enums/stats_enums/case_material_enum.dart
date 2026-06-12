import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum CaseMaterialEnum {
  blank,
  steel,
  pvdsteel,
  titanium,
  gold,
  twotone,
  platinum,
  bronze,
  ceramic,
  carbon,
  tungsten,
  resin,
  plastic,
  other
}

extension CaseMaterialEnumLocalization on CaseMaterialEnum {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (this) {
      case CaseMaterialEnum.blank:
        return localizations.caseMaterialNotEntered;
      case CaseMaterialEnum.steel:
        return localizations.caseMaterialSteel;
      case CaseMaterialEnum.pvdsteel:
        return localizations.caseMaterialPVDDLC;
      case CaseMaterialEnum.titanium:
        return localizations.caseMaterialTitanium;
      case CaseMaterialEnum.gold:
        return localizations.caseMaterialGold;
      case CaseMaterialEnum.twotone:
        return localizations.caseMaterialTwoTone;
      case CaseMaterialEnum.platinum:
        return localizations.caseMaterialPlatinum;
      case CaseMaterialEnum.bronze:
        return localizations.caseMaterialBronze;
      case CaseMaterialEnum.ceramic:
        return localizations.caseMaterialCeramic;
      case CaseMaterialEnum.carbon:
        return localizations.caseMaterialCarbon;
      case CaseMaterialEnum.tungsten:
        return localizations.caseMaterialTungsten;
      case CaseMaterialEnum.resin:
        return localizations.caseMaterialResin;
      case CaseMaterialEnum.plastic:
        return localizations.caseMaterialPlastic;
      case CaseMaterialEnum.other:
        return localizations.caseMaterialOther;
    }
  }

  /// Returns the English string for database storage
  String toDbString() {
    switch (this) {
      case CaseMaterialEnum.blank:
        return "Not Entered";
      case CaseMaterialEnum.steel:
        return "Steel";
      case CaseMaterialEnum.titanium:
        return "Titanium";
      case CaseMaterialEnum.gold:
        return "Gold";
      case CaseMaterialEnum.twotone:
        return "Two-Tone";
      case CaseMaterialEnum.platinum:
        return "Platinum";
      case CaseMaterialEnum.bronze:
        return "Bronze";
      case CaseMaterialEnum.ceramic:
        return "Ceramic";
      case CaseMaterialEnum.carbon:
        return "Carbon";
      case CaseMaterialEnum.resin:
        return "Resin";
      case CaseMaterialEnum.plastic:
        return "Plastic";
      case CaseMaterialEnum.other:
        return "Other";
      case CaseMaterialEnum.pvdsteel:
        return "PVD/DLC Steel";
      case CaseMaterialEnum.tungsten:
        return "Tungsten";
    }
  }

  /// Creates a CaseMaterialEnum from a database string (English)
  static CaseMaterialEnum fromDbString(String? material) {
    switch (material) {
      case "Steel":
        return CaseMaterialEnum.steel;
      case "Titanium":
        return CaseMaterialEnum.titanium;
      case "Gold":
        return CaseMaterialEnum.gold;
      case "Two-Tone":
        return CaseMaterialEnum.twotone;
      case "Platinum":
        return CaseMaterialEnum.platinum;
      case "Bronze":
        return CaseMaterialEnum.bronze;
      case "Ceramic":
        return CaseMaterialEnum.ceramic;
      case "Carbon":
        return CaseMaterialEnum.carbon;
      case "Resin":
        return CaseMaterialEnum.resin;
      case "Plastic":
        return CaseMaterialEnum.plastic;
      case "Other":
        return CaseMaterialEnum.other;
      case "PVD/DLC Steel":
        return CaseMaterialEnum.pvdsteel;
      case "Tungsten":
        return CaseMaterialEnum.tungsten;
      case "Not Entered":
      case "":
      case null:
        return CaseMaterialEnum.blank;
      default:
        return CaseMaterialEnum.blank;
    }
  }
}
