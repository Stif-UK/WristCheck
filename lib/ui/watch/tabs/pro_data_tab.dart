import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/winder_direction_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/watch/rows/case_diameter_row.dart';
import 'package:wristcheck/ui/watch/rows/case_thickness_row.dart';
import 'package:wristcheck/ui/watch/rows/lug_to_lug_row.dart';
import 'package:wristcheck/ui/watch/rows/lug_width_row.dart';
import 'package:wristcheck/ui/watch/rows/power_reserve_row.dart';
import 'package:wristcheck/ui/watch/rows/water_resistance_row.dart';
import 'package:wristcheck/ui/widgets/responsive_two_column_grid.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class ProDataTab extends StatelessWidget {
  ProDataTab({
    super.key,
    required this.caseDiameterController,
    required this.lugWidthController,
    required this.lug2lugController,
    required this.caseThicknessController,
    required this.waterResistanceController,
    required this.caseMaterialController,
    required this.winderTPDController,
    required this.winderDirectionController,
    required this.dateComplicationController,
    required this.powerReserveController,
  });

  final watchViewController = Get.put(WatchViewController());
  final wristCheckController = Get.put(WristCheckController());
  final TextEditingController caseDiameterController;
  final TextEditingController lugWidthController;
  final TextEditingController lug2lugController;
  final TextEditingController caseThicknessController;
  final TextEditingController waterResistanceController;
  final TextEditingController caseMaterialController;
  final TextEditingController winderTPDController;
  final TextEditingController winderDirectionController;
  final TextEditingController dateComplicationController;
  final TextEditingController powerReserveController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCaseDetailsSection(context),
          const Divider(thickness: 2),
          _buildWinderSettingsRow(context),
        ],
      ),
    );
  }

  Widget _buildCaseDetailsSection(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        l10n.watchDetailsSectionTitle,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      children: [
        ResponsiveTwoColumnGrid(
          children: [
            CaseDiameterRow(
              enabled: watchViewController.inEditState.value,
              caseDiameterController: caseDiameterController,
            ),
            LugToLugRow(
              enabled: watchViewController.inEditState.value,
              lug2lugController: lug2lugController,
            ),
            CaseThicknessRow(
              enabled: watchViewController.inEditState.value,
              caseThicknessController: caseThicknessController,
            ),
            LugWidthRow(
              enabled: watchViewController.inEditState.value,
              lugWidthController: lugWidthController,
            ),
            WaterResistanceRow(
              enabled: watchViewController.inEditState.value,
              waterResistanceController: waterResistanceController,
              units: wristCheckController.waterResistanceUnit.value.toLocalizedString(context),
            ),
            _buildCaseMaterialField(context),
            _buildDateComplicationField(context),
            PowerReserveRow(
              enabled: watchViewController.inEditState.value,
              powerReserveController: powerReserveController,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCaseMaterialField(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.caseMaterialRowTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          DropdownButtonFormField<CaseMaterialEnum>(
            isExpanded: true,
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            menuMaxHeight: 300,
            value: WristCheckFormatter.getCaseMaterialEnum(watchViewController.caseMaterial.value),
            iconSize: watchViewController.inEditState.value ? 24.0 : 0.0,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              const Icon(Icons.watch),
              context,
            ),
            items: CaseMaterialEnum.values.map((material) {
              return DropdownMenuItem<CaseMaterialEnum>(
                value: material,
                child: Text(material.toLocalizedString(context)),
              );
            }).toList(),
            onChanged: watchViewController.inEditState.value
                ? (material) {
                    watchViewController.updateCaseMaterial(
                      WristCheckFormatter.getCaseMaterialText(material!),
                    );
                    caseMaterialController.value = TextEditingValue(
                      text: WristCheckFormatter.getCaseMaterialText(material),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildWinderSettingsRow(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        l10n.winderSettingsSectionTitle,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      children: [
        ResponsiveTwoColumnGrid(
          children: [
            WatchFormField(
              keyboardType: TextInputType.number,
              icon: const FaIcon(FontAwesomeIcons.gaugeHigh),
              enabled: watchViewController.inEditState.value,
              fieldTitle: l10n.tpdRowTitle,
              hintText: l10n.tpdRowTitle,
              maxLines: 1,
              controller: winderTPDController,
              textCapitalization: TextCapitalization.none,
              validator: (String? val) {
                if (!val!.isUnboundPositiveInteger) {
                  return l10n.mustBeAValidWholeNumber;
                }
                return null;
              },
            ),
            _buildWinderDirectionField(context),
          ],
        ),
      ],
    );
  }

  Widget _buildWinderDirectionField(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.winderDirectionRowTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Obx(
            () => DropdownButtonFormField<WinderDirectionEnum>(
              isExpanded: true,
              dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
              borderRadius: BorderRadius.circular(24),
              menuMaxHeight: 300,
              value: WristCheckFormatter.getWinderDirectionEnum(
                watchViewController.winderDirection.value,
              ),
              iconSize: watchViewController.inEditState.value ? 24.0 : 0.0,
              decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
                WristCheckFormatter.getWinderDirectionIcon(
                  WristCheckFormatter.getWinderDirectionEnum(
                    watchViewController.winderDirection.value,
                  ),
                ),
                context,
              ),
              items: WinderDirectionEnum.values.map((direction) {
                return DropdownMenuItem<WinderDirectionEnum>(
                  value: direction,
                  child: Text(direction.toLocalizedString(context)),
                );
              }).toList(),
              onChanged: watchViewController.inEditState.value
                  ? (direction) {
                      watchViewController.updateWinderDirection(
                        WristCheckFormatter.getWinderDirectionText(direction!),
                      );
                      winderDirectionController.value = TextEditingValue(
                        text: WristCheckFormatter.getWinderDirectionText(direction),
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateComplicationField(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations.of(Get.context!)!;
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dateComplicationRowTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          DropdownButtonFormField<DateComplicationEnum>(
            isExpanded: true,
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            menuMaxHeight: 300,
            value: WristCheckFormatter.getDateComplicationEnum(
              watchViewController.dateComplication.value,
            ),
            iconSize: watchViewController.inEditState.value ? 24.0 : 0.0,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              const FaIcon(FontAwesomeIcons.calendarDay),
              context,
            ),
            items: DateComplicationEnum.values.map((dateType) {
              return DropdownMenuItem<DateComplicationEnum>(
                value: dateType,
                child: Text(dateType.toLocalizedString(context)),
              );
            }).toList(),
            onChanged: watchViewController.inEditState.value
                ? (dateType) {
                    watchViewController.updateDateComplication(
                      WristCheckFormatter.getDateComplicationName(dateType!),
                    );
                    dateComplicationController.value = TextEditingValue(
                      text: WristCheckFormatter.getDateComplicationName(dateType),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}


