import 'package:get/get.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_diameter_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_thickness_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/colour_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/lug2lug_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/model_year_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/power_reserve_chart_enum.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CollectionStatsController extends GetxController {
  final caseThicknessChartType = CaseThicknessChartEnum.line.obs;
  final lug2lugChartType = Lug2lugChartEnum.line.obs;
  final powerReserveChartType = PowerReserveChartEnum.line.obs;
  final colourChartType = ColourChartEnum.stackedBar.obs;
  final movementChartType = RecapCategoryChartType.bar.obs;
  final categoryChartType = RecapCategoryChartType.bar.obs;
  final dateComplicationChartType = RecapCategoryChartType.bar.obs;
  final caseMaterialChartType = RecapCategoryChartType.bar.obs;
  final lugWidthChartType = RecapCategoryChartType.bar.obs;
  final waterResistanceChartType = RecapCategoryChartType.bar.obs;
  final caseDiameterChartType = CaseDiameterChartEnum.bar.obs;
  final modelYearChartType = ModelYearChartEnum.bar.obs;

  final showPrice = WristCheckPreferences.getCostPerWearValuePref().obs;
  final groupWatchYearByDecade =
      WristCheckPreferences.getGroupWatchYearByDecade().obs;

  updateCaseThicknessChartType(type) {
    caseThicknessChartType(type);
  }

  updateLug2LugChartType(type) {
    lug2lugChartType(type);
  }

  updatePowerReserveChartType(type) {
    powerReserveChartType(type);
  }

  updateColourChartType(ColourChartEnum type) {
    colourChartType(type);
  }

  cycleColourChartType() {
    switch (colourChartType.value) {
      case ColourChartEnum.stackedBar:
        colourChartType(ColourChartEnum.pie);
        break;
      case ColourChartEnum.pie:
        colourChartType(ColourChartEnum.donut);
        break;
      case ColourChartEnum.donut:
        colourChartType(ColourChartEnum.stackedBar);
        break;
    }
  }

  void cycleMovementChartType() {
    movementChartType(
      nextCategoryChartType(movementChartType.value, includeRadialBar: true),
    );
  }

  void cycleCategoryChartType() {
    categoryChartType(
      nextCategoryChartType(categoryChartType.value, includeRadialBar: true),
    );
  }

  void cycleDateComplicationChartType() {
    dateComplicationChartType(
      nextCategoryChartType(
        dateComplicationChartType.value,
        includeRadialBar: true,
      ),
    );
  }

  void cycleCaseMaterialChartType() {
    caseMaterialChartType(
      nextCategoryChartType(
        caseMaterialChartType.value,
        includeRadialBar: true,
      ),
    );
  }

  void cycleLugWidthChartType() {
    lugWidthChartType(nextCategoryChartType(lugWidthChartType.value));
  }

  void cycleWaterResistanceChartType() {
    waterResistanceChartType(
      nextCategoryChartType(waterResistanceChartType.value),
    );
  }

  void toggleCaseDiameterChartType() {
    caseDiameterChartType(
      caseDiameterChartType.value == CaseDiameterChartEnum.bar
          ? CaseDiameterChartEnum.line
          : CaseDiameterChartEnum.bar,
    );
  }

  void cycleModelYearChartType() {
    switch (modelYearChartType.value) {
      case ModelYearChartEnum.bar:
        modelYearChartType(ModelYearChartEnum.column);
        break;
      case ModelYearChartEnum.column:
        modelYearChartType(ModelYearChartEnum.splineArea);
        break;
      case ModelYearChartEnum.splineArea:
        modelYearChartType(ModelYearChartEnum.bar);
        break;
    }
  }

  updateShowPrice(price) {
    showPrice(price);
    WristCheckPreferences.setCostPerWearValuePref(price);
  }

  updateGroupWatchYearByDecade(bool value) {
    groupWatchYearByDecade(value);
    WristCheckPreferences.setGroupWatchYearByDecade(value);
  }

  static bool isFieldPopulated(String? value) {
    if (value == null) return false;
    final trimmed = value.trim();
    return trimmed.isNotEmpty &&
        trimmed != 'Not Entered' &&
        trimmed != 'Not Selected';
  }

  static bool isCostPerWearComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every((w) => w.purchasePrice != null && w.purchasePrice! > 0);
  }

  static bool isMovementComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every(
      (w) =>
          isFieldPopulated(w.movement) &&
          WristCheckFormatter.getMovementEnum(w.movement) != MovementEnum.blank,
    );
  }

  static bool isCategoryComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every(
      (w) =>
          isFieldPopulated(w.category) &&
          WristCheckFormatter.getCategoryEnum(w.category) != CategoryEnum.blank,
    );
  }

  static bool isColourComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every(
      (w) =>
          isFieldPopulated(w.primaryColour) ||
          isFieldPopulated(w.secondaryColour),
    );
  }

  static bool hasModelYearData(List<Watches> watches) {
    return watches.any((w) => w.year != null && w.year! > 0);
  }

  static bool isModelYearComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every((w) => w.year != null && w.year! > 0);
  }

  static bool isDateComplicationComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every(
      (w) =>
          isFieldPopulated(w.dateComplication) &&
          WristCheckFormatter.getDateComplicationEnum(w.dateComplication) !=
              DateComplicationEnum.blank,
    );
  }

  static bool isCaseDiameterComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every((w) => w.caseDiameter != null && w.caseDiameter! > 0.0);
  }

  static bool isLugWidthComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every((w) => w.lugWidth != null && w.lugWidth! > 0);
  }

  static bool isLugToLugComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every((w) => w.lug2lug != null && w.lug2lug! > 0.0);
  }

  static bool isCaseThicknessComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every(
      (w) => w.caseThickness != null && w.caseThickness! > 0.0,
    );
  }

  static bool isPowerReserveComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every((w) => w.powerReserve != null && w.powerReserve! > 0);
  }

  static bool isWaterResistanceComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every(
      (w) => w.waterResistance != null && w.waterResistance! > 0,
    );
  }

  static bool isCaseMaterialComplete(List<Watches> watches) {
    if (watches.isEmpty) return true;
    return watches.every(
      (w) =>
          isFieldPopulated(w.caseMaterial) &&
          WristCheckFormatter.getCaseMaterialEnum(w.caseMaterial) !=
              CaseMaterialEnum.blank,
    );
  }
}
