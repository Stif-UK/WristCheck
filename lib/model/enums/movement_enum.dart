import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum MovementEnum {
  blank,
  mechanical,
  automatic,
  analogue_quartz,
  digital_quartz,
  ana_digi_quartz,
  kinetic,
  mechaquartz,
  springdrive,
  smartwatch,
  tourbillon,
  solar,
  tuning_fork,
  other
}

extension MovementEnumLocalization on MovementEnum {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (this) {
      case MovementEnum.blank:
        return localizations.notEntered;
      case MovementEnum.mechanical:
        return localizations.movementMechanicalManual;
      case MovementEnum.automatic:
        return localizations.movementMechanicalAutomatic;
      case MovementEnum.analogue_quartz:
        return localizations.movementAnalogueQuartz;
      case MovementEnum.digital_quartz:
        return localizations.movementDigitalQuartz;
      case MovementEnum.ana_digi_quartz:
        return localizations.movementAnaDigiQuartz;
      case MovementEnum.kinetic:
        return localizations.movementKinetic;
      case MovementEnum.mechaquartz:
        return localizations.movementMechaQuartz;
      case MovementEnum.springdrive:
        return localizations.movementSpringDrive;
      case MovementEnum.smartwatch:
        return localizations.movementSmartWatch;
      case MovementEnum.tourbillon:
        return localizations.movementTourbillon;
      case MovementEnum.solar:
        return localizations.movementSolarQuartz;
      case MovementEnum.tuning_fork:
        return localizations.movementTuningFork;
      case MovementEnum.other:
        return localizations.other;
    }
  }

  /// Returns the English string for database storage
  String toDbString() {
    switch (this) {
      case MovementEnum.blank:
        return "Not Entered";
      case MovementEnum.mechanical:
        return "Mechanical - Manual";
      case MovementEnum.automatic:
        return "Mechanical - Automatic";
      case MovementEnum.analogue_quartz:
        return "Analogue Quartz";
      case MovementEnum.digital_quartz:
        return "Digital Quartz";
      case MovementEnum.ana_digi_quartz:
        return "Ana-Digi Quartz";
      case MovementEnum.kinetic:
        return "Kinetic";
      case MovementEnum.mechaquartz:
        return "Mecha-Quartz";
      case MovementEnum.springdrive:
        return "Spring Drive";
      case MovementEnum.smartwatch:
        return "Smartwatch";
      case MovementEnum.tourbillon:
        return "Tourbillon";
      case MovementEnum.solar:
        return "Solar Quartz";
      case MovementEnum.tuning_fork:
        return "Tuning Fork";
      case MovementEnum.other:
        return "Other";
    }
  }

  /// Creates a MovementEnum from a database string (English)
  static MovementEnum fromDbString(String? movement) {
    switch (movement) {
      case "Mechanical - Manual":
        return MovementEnum.mechanical;
      case "Mechanical - Automatic":
        return MovementEnum.automatic;
      case "Analogue Quartz":
        return MovementEnum.analogue_quartz;
      case "Digital Quartz":
        return MovementEnum.digital_quartz;
      case "Ana-Digi Quartz":
        return MovementEnum.ana_digi_quartz;
      case "Kinetic":
        return MovementEnum.kinetic;
      case "Mecha-Quartz":
        return MovementEnum.mechaquartz;
      case "Spring Drive":
        return MovementEnum.springdrive;
      case "Smartwatch":
        return MovementEnum.smartwatch;
      case "Tourbillon":
        return MovementEnum.tourbillon;
      case "Solar Quartz":
        return MovementEnum.solar;
      case "Tuning Fork":
        return MovementEnum.tuning_fork;
      case "Other":
        return MovementEnum.other;
      case "Not Entered":
      case "":
      case null:
        return MovementEnum.blank;
      default:
        return MovementEnum.blank;
    }
  }
}
