import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/language_controller.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/winder_direction_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/model/upload_models.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';
import 'package:wristcheck/ui/watch/rows/case_diameter_row.dart';
import 'package:wristcheck/ui/watch/rows/case_thickness_row.dart';
import 'package:wristcheck/ui/watch/rows/current_value_row.dart';
import 'package:wristcheck/ui/watch/rows/last_serviced_row.dart';
import 'package:wristcheck/ui/watch/rows/lug_to_lug_row.dart';
import 'package:wristcheck/ui/watch/rows/lug_width_row.dart';
import 'package:wristcheck/ui/watch/rows/manufacturer_row.dart';
import 'package:wristcheck/ui/watch/rows/model_row.dart';
import 'package:wristcheck/ui/watch/rows/power_reserve_row.dart';
import 'package:wristcheck/ui/watch/rows/primary_colour_row.dart';
import 'package:wristcheck/ui/watch/rows/purchase_date_row.dart';
import 'package:wristcheck/ui/watch/rows/purchase_price_row.dart';
import 'package:wristcheck/ui/watch/rows/purchased_from_row.dart';
import 'package:wristcheck/ui/watch/rows/reference_number_row.dart';
import 'package:wristcheck/ui/watch/rows/secondary_colour_row.dart';
import 'package:wristcheck/ui/watch/rows/serial_number_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_date_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_price_row.dart';
import 'package:wristcheck/ui/watch/rows/sold_to_row.dart';
import 'package:wristcheck/ui/watch/rows/warranty_end_row.dart';
import 'package:wristcheck/ui/watch/rows/water_resistance_row.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';
import 'package:wristcheck/util/string_extension.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WatchValidation extends StatefulWidget {
  WatchValidation({super.key, required this.index});

  final uploadsController = Get.put(UploadsController());
  final wristCheckController = Get.put(WristCheckController());
  final int index;

  @override
  State<WatchValidation> createState() => _WatchValidationState();
}

class _WatchValidationState extends State<WatchValidation> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController manufacturerFieldController;
  late final TextEditingController modelFieldController;
  late final TextEditingController serialNumberFieldController;
  late final TextEditingController referenceNumberFieldController;
  late final TextEditingController primaryColourFieldController;
  late final TextEditingController secondaryColourFieldController;
  late final TextEditingController modelYearFieldController;
  late final TextEditingController warrantyEndDateFieldController;
  late final TextEditingController lastServicedDateFieldController;
  late final TextEditingController serviceIntervalFieldController;
  late final TextEditingController purchaseDateFieldController;
  late final TextEditingController deliveryDateFieldController;
  late final TextEditingController purchasePriceFieldController;
  late final TextEditingController purchasedFromFieldController;
  late final TextEditingController soldDateFieldController;
  late final TextEditingController soldPriceFieldController;
  late final TextEditingController soldToFieldController;
  late final TextEditingController currentValueFieldController;
  late final TextEditingController caseDiameterController;
  late final TextEditingController caseThicknessController;
  late final TextEditingController lugWidthController;
  late final TextEditingController lug2lugController;
  late final TextEditingController waterResistanceController;
  late final TextEditingController powerReserveController;
  late final TextEditingController winderTPDController;
  late final TextEditingController notesFieldController;

  late String _selectedStatus;
  late CategoryEnum _selectedCategory;
  late MovementEnum _selectedMovement;
  late CaseMaterialEnum _selectedCaseMaterial;
  late DateComplicationEnum _selectedDateComplication;
  late WinderDirectionEnum _selectedWinderDirection;
  late bool _favourite;

  late List<DateTime> _wearDates;
  late DuplicateResolution _duplicateResolution;
  Watches? _selectedExistingWatch;

  ImportWatchCandidate get _candidate => widget.uploadsController.candidates[widget.index];

  @override
  void initState() {
    super.initState();
    final c = _candidate;

    manufacturerFieldController = TextEditingController(text: c.manufacturer);
    modelFieldController = TextEditingController(text: c.model);
    serialNumberFieldController = TextEditingController(text: c.serialNumber ?? '');
    referenceNumberFieldController = TextEditingController(text: c.referenceNumber ?? '');
    primaryColourFieldController = TextEditingController(text: c.primaryColour ?? '');
    secondaryColourFieldController = TextEditingController(text: c.secondaryColour ?? '');
    modelYearFieldController = TextEditingController(text: c.year?.toString() ?? '');
    warrantyEndDateFieldController = TextEditingController(text: _formatDate(c.warrantyEndDate));
    lastServicedDateFieldController = TextEditingController(text: _formatDate(c.lastServicedDate));
    serviceIntervalFieldController =
        TextEditingController(text: c.serviceInterval?.toString() ?? '');
    purchaseDateFieldController = TextEditingController(text: _formatDate(c.purchaseDate));
    deliveryDateFieldController = TextEditingController(text: _formatDate(c.deliveryDate));
    purchasePriceFieldController = TextEditingController(text: c.purchasePrice?.toString() ?? '');
    purchasedFromFieldController = TextEditingController(text: c.purchasedFrom ?? '');
    soldDateFieldController = TextEditingController(text: _formatDate(c.soldDate));
    soldPriceFieldController = TextEditingController(text: c.soldPrice?.toString() ?? '');
    soldToFieldController = TextEditingController(text: c.soldTo ?? '');
    currentValueFieldController = TextEditingController(text: c.value?.toString() ?? '');
    caseDiameterController = TextEditingController(
      text: c.caseDiameter != null ? WristCheckFormatter.getLocalizedDecimal(c.caseDiameter) : '',
    );
    caseThicknessController = TextEditingController(
      text: c.caseThickness != null ? WristCheckFormatter.getLocalizedDecimal(c.caseThickness) : '',
    );
    lugWidthController = TextEditingController(text: c.lugWidth?.toString() ?? '');
    lug2lugController = TextEditingController(
      text: c.lug2lug != null ? WristCheckFormatter.getLocalizedDecimal(c.lug2lug) : '',
    );
    waterResistanceController = TextEditingController(text: c.waterResistance?.toString() ?? '');
    powerReserveController = TextEditingController(text: c.powerReserve?.toString() ?? '');
    winderTPDController = TextEditingController(text: c.winderTPD?.toString() ?? '');
    notesFieldController = TextEditingController(text: c.notes ?? '');

    _selectedStatus = c.status ?? WatchStatusEnum.inCollection.toDbString();
    _selectedCategory = WristCheckFormatter.getCategoryEnum(c.category);
    _selectedMovement = WristCheckFormatter.getMovementEnum(c.movement);
    _selectedCaseMaterial = WristCheckFormatter.getCaseMaterialEnum(c.caseMaterial);
    _selectedDateComplication = WristCheckFormatter.getDateComplicationEnum(c.dateComplication);
    _selectedWinderDirection = WristCheckFormatter.getWinderDirectionEnum(c.winderDirection);
    _favourite = c.favourite ?? false;

    _wearDates = List<DateTime>.from(c.wearDates)..sort();
    _duplicateResolution = c.duplicateResolution;
    _selectedExistingWatch = c.selectedExistingWatch;
  }

  @override
  void dispose() {
    manufacturerFieldController.dispose();
    modelFieldController.dispose();
    serialNumberFieldController.dispose();
    referenceNumberFieldController.dispose();
    primaryColourFieldController.dispose();
    secondaryColourFieldController.dispose();
    modelYearFieldController.dispose();
    warrantyEndDateFieldController.dispose();
    lastServicedDateFieldController.dispose();
    serviceIntervalFieldController.dispose();
    purchaseDateFieldController.dispose();
    deliveryDateFieldController.dispose();
    purchasePriceFieldController.dispose();
    purchasedFromFieldController.dispose();
    soldDateFieldController.dispose();
    soldPriceFieldController.dispose();
    soldToFieldController.dispose();
    currentValueFieldController.dispose();
    caseDiameterController.dispose();
    caseThicknessController.dispose();
    lugWidthController.dispose();
    lug2lugController.dispose();
    waterResistanceController.dispose();
    powerReserveController.dispose();
    winderTPDController.dispose();
    notesFieldController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return WristCheckFormatter.getFormattedDate(date);
  }

  DateTime? _parseEditedDate(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    if (Get.isRegistered<LanguageController>()) {
      final lang = Get.find<LanguageController>().language.value.toString();
      try {
        return DateFormat('yMMMd', lang).parseStrict(trimmed);
      } catch (_) {}
    }
    return UploadMethods.parseFlexibleDate(trimmed);
  }

  String? _nullIfBlank(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _saveChanges() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final c = _candidate;
    c.manufacturer = manufacturerFieldController.text.trim();
    c.model = modelFieldController.text.trim();
    c.status = _selectedStatus;
    c.category = _selectedCategory == CategoryEnum.blank ? null : _selectedCategory.toDbString();
    c.movement = _selectedMovement == MovementEnum.blank ? null : _selectedMovement.toDbString();
    c.primaryColour = _nullIfBlank(primaryColourFieldController.text);
    c.secondaryColour = _nullIfBlank(secondaryColourFieldController.text);
    c.serialNumber = _nullIfBlank(serialNumberFieldController.text);
    c.referenceNumber = _nullIfBlank(referenceNumberFieldController.text);
    c.dateComplication = _selectedDateComplication == DateComplicationEnum.blank
        ? null
        : _selectedDateComplication.toDbString();
    c.year = UploadMethods.parsePositiveInt(modelYearFieldController.text);
    c.warrantyEndDate = _parseEditedDate(warrantyEndDateFieldController.text);
    c.lastServicedDate = _parseEditedDate(lastServicedDateFieldController.text);
    c.serviceInterval = UploadMethods.parsePositiveInt(serviceIntervalFieldController.text);
    c.purchaseDate = _parseEditedDate(purchaseDateFieldController.text);
    c.deliveryDate = _parseEditedDate(deliveryDateFieldController.text);
    c.purchasePrice = UploadMethods.parseCurrencyInt(purchasePriceFieldController.text);
    c.purchasedFrom = _nullIfBlank(purchasedFromFieldController.text);
    c.soldDate = _parseEditedDate(soldDateFieldController.text);
    c.soldPrice = UploadMethods.parseCurrencyInt(soldPriceFieldController.text);
    c.soldTo = _nullIfBlank(soldToFieldController.text);
    c.value = UploadMethods.parseCurrencyInt(currentValueFieldController.text);
    c.caseDiameter = UploadMethods.parseDimensionDouble(caseDiameterController.text);
    c.caseThickness = UploadMethods.parseDimensionDouble(caseThicknessController.text);
    c.caseMaterial =
        _selectedCaseMaterial == CaseMaterialEnum.blank ? null : _selectedCaseMaterial.toDbString();
    c.lugWidth = UploadMethods.parsePositiveInt(lugWidthController.text);
    c.lug2lug = UploadMethods.parseDimensionDouble(lug2lugController.text);
    c.waterResistance = UploadMethods.parsePositiveInt(waterResistanceController.text);
    c.powerReserve = UploadMethods.parsePositiveInt(powerReserveController.text);
    c.winderTPD = UploadMethods.parsePositiveInt(winderTPDController.text);
    c.winderDirection = _selectedWinderDirection == WinderDirectionEnum.blank
        ? null
        : _selectedWinderDirection.toDbString();
    c.notes = _nullIfBlank(notesFieldController.text);
    c.favourite = _favourite;
    c.wearDates = List<DateTime>.from(_wearDates);
    c.issues.clear();
    c.invalidWearDateValues.clear();
    c.duplicateResolution = _duplicateResolution;
    c.selectedExistingWatch = _selectedExistingWatch;
    if (_duplicateResolution == DuplicateResolution.skip) {
      c.included = false;
    } else {
      c.included = true;
    }

    widget.uploadsController.refreshCandidate(widget.index);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String locale =
        WristCheckFormatter.getLocaleString(widget.wristCheckController.locale.value);
    const WatchViewEnum viewState = WatchViewEnum.edit;
    final status = _candidate.computedStatus;

    return Scaffold(
      appBar: AppBar(
        title: Text(_candidate.displayName),
        actions: [
          TextButton.icon(
            onPressed: _saveChanges,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _buildStatusCard(context, status),
                if (_candidate.isDuplicate) _buildDuplicateCard(context),
                _buildWearDatesCard(context),
                ExpansionTile(
                  initiallyExpanded: true,
                  leading: const Icon(Icons.watch),
                  title: const Text('Identity'),
                  children: [
                    ManufacturerRow(
                      enabled: true,
                      manufacturerFieldController: manufacturerFieldController,
                    ),
                    ModelRow(
                      enabled: true,
                      modelFieldController: modelFieldController,
                    ),
                    _buildStatusDropdown(context, l10n),
                    _buildCategoryDropdown(context, l10n),
                    _buildMovementDropdown(context, l10n),
                    PrimaryColourRow(
                      enabled: true,
                      primaryColourFieldController: primaryColourFieldController,
                    ),
                    SecondaryColourRow(
                      enabled: true,
                      secondaryColourFieldController: secondaryColourFieldController,
                    ),
                    ReferenceNumberRow(
                      enabled: true,
                      referenceNumberFieldController: referenceNumberFieldController,
                      viewState: viewState,
                    ),
                    SerialNumberRow(
                      serialNumberFieldController: serialNumberFieldController,
                      enabled: true,
                      viewState: viewState,
                    ),
                    SwitchListTile(
                      title: const Text('Favourite'),
                      secondary: const Icon(Icons.star),
                      value: _favourite,
                      onChanged: (val) => setState(() => _favourite = val),
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Dates & Service'),
                  children: [
                    WatchFormField(
                      keyboardType: TextInputType.number,
                      icon: const FaIcon(FontAwesomeIcons.calendar),
                      enabled: true,
                      fieldTitle: l10n.modelYearRowTitle,
                      hintText: l10n.modelYearRowHintText,
                      maxLines: 1,
                      controller: modelYearFieldController,
                      textCapitalization: TextCapitalization.none,
                      validator: (val) {
                        if (val != null && !val.isFourDigitYear) {
                          return l10n.mustBe4DigitYearOrBlank;
                        }
                        return null;
                      },
                    ),
                    PurchaseDateRow(
                      enabled: true,
                      purchaseDateFieldController: purchaseDateFieldController,
                    ),
                    WatchFormField(
                      icon: const FaIcon(FontAwesomeIcons.calendar),
                      enabled: true,
                      fieldTitle: l10n.preOrderDueDateRowTitle,
                      hintText: l10n.preOrderDueDateRowHintText,
                      maxLines: 1,
                      datePicker: true,
                      controller: deliveryDateFieldController,
                      textCapitalization: TextCapitalization.none,
                    ),
                    SoldDateRow(
                      enabled: true,
                      soldDateFieldController: soldDateFieldController,
                    ),
                    WarrantyEndRow(
                      enabled: true,
                      warrantyEndDateFieldController: warrantyEndDateFieldController,
                    ),
                    LastServicedRow(
                      enabled: true,
                      lastServicedDateFieldController: lastServicedDateFieldController,
                    ),
                    WatchFormField(
                      keyboardType: TextInputType.number,
                      icon: const FaIcon(FontAwesomeIcons.arrowsSpin),
                      enabled: true,
                      fieldTitle: l10n.serviceIntervalRowTitle,
                      hintText: l10n.serviceIntervalRowHintText,
                      maxLines: 1,
                      controller: serviceIntervalFieldController,
                      textCapitalization: TextCapitalization.none,
                      validator: (val) {
                        if (val != null && !val.isServiceNumber) {
                          return l10n.mustBe099orBlank;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  leading: const FaIcon(FontAwesomeIcons.sackDollar, size: 20),
                  title: const Text('Value'),
                  children: [
                    PurchasePriceRow(
                      enabled: true,
                      purchasePriceFieldController: purchasePriceFieldController,
                      viewState: viewState,
                      locale: locale,
                      price: 0,
                    ),
                    PurchasedFromRow(
                      enabled: true,
                      purchasedFromFieldController: purchasedFromFieldController,
                    ),
                    SoldPriceRow(
                      enabled: true,
                      soldPriceFieldController: soldPriceFieldController,
                      viewState: viewState,
                      locale: locale,
                      price: 0,
                    ),
                    SoldToRow(
                      enabled: true,
                      soldToFieldController: soldToFieldController,
                    ),
                    CurrentValueRow(
                      enabled: true,
                      currentValueFieldController: currentValueFieldController,
                      viewState: viewState,
                      locale: locale,
                      price: 0,
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  leading: const FaIcon(FontAwesomeIcons.ruler, size: 20),
                  title: const Text('Specifications'),
                  children: [
                    CaseDiameterRow(
                      enabled: true,
                      caseDiameterController: caseDiameterController,
                    ),
                    LugToLugRow(
                      enabled: true,
                      lug2lugController: lug2lugController,
                    ),
                    CaseThicknessRow(
                      enabled: true,
                      caseThicknessController: caseThicknessController,
                    ),
                    LugWidthRow(
                      enabled: true,
                      lugWidthController: lugWidthController,
                    ),
                    WaterResistanceRow(
                      enabled: true,
                      waterResistanceController: waterResistanceController,
                      units: widget.wristCheckController.waterResistanceUnit.value
                          .toLocalizedString(context),
                    ),
                    _buildCaseMaterialDropdown(context, l10n),
                    _buildDateComplicationDropdown(context, l10n),
                    PowerReserveRow(
                      enabled: true,
                      powerReserveController: powerReserveController,
                    ),
                    WatchFormField(
                      keyboardType: TextInputType.number,
                      icon: const FaIcon(FontAwesomeIcons.gaugeHigh),
                      enabled: true,
                      fieldTitle: l10n.tpdRowTitle,
                      hintText: l10n.tpdRowTitle,
                      maxLines: 1,
                      controller: winderTPDController,
                      textCapitalization: TextCapitalization.none,
                      validator: (val) {
                        if (val != null && !val.isUnboundPositiveInteger) {
                          return l10n.mustBeAValidWholeNumber;
                        }
                        return null;
                      },
                    ),
                    _buildWinderDirectionDropdown(context, l10n),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: _candidate.notes != null,
                  leading: const FaIcon(FontAwesomeIcons.noteSticky, size: 20),
                  title: Text(l10n.notesRowTitle),
                  children: [
                    WatchFormField(
                      icon: const FaIcon(FontAwesomeIcons.noteSticky),
                      enabled: true,
                      fieldTitle: l10n.notesRowTitle,
                      hintText: l10n.notesRowHintText,
                      minLines: 3,
                      maxLines: 10,
                      controller: notesFieldController,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _saveChanges,
                    icon: const Icon(Icons.save),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('Save Changes'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, UploadStatusEnum status) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: UploadMethods.getStatusIcon(status),
              title: Text(
                'Status: ${WristCheckFormatter.getUploadStatusText(status)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(WristCheckFormatter.getUploadStatusSubtitle(status)),
            ),
            if (_candidate.issues.isNotEmpty) ...[
              const Divider(),
              for (final issue in _candidate.issues)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        issue.isError ? Icons.error : Icons.warning_amber_rounded,
                        size: 16,
                        color: issue.isError ? Colors.red : Colors.amber,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${issue.fieldName}: ${issue.message}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDuplicateCard(BuildContext context) {
    final matches = _candidate.matchedExistingWatches;
    final existing = _selectedExistingWatch ?? matches.first;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                FaIcon(FontAwesomeIcons.clone, color: Colors.orange, size: 18),
                SizedBox(width: 8),
                Text(
                  'Existing Watch Match Found',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (matches.length > 1)
              DropdownButtonFormField<Watches>(
                isExpanded: true,
                initialValue: existing,
                decoration: const InputDecoration(labelText: 'Target existing watch'),
                items: matches.map((w) {
                  final ref = (w.referenceNumber != null && w.referenceNumber!.isNotEmpty)
                      ? ' • Ref ${w.referenceNumber}'
                      : '';
                  return DropdownMenuItem<Watches>(
                    value: w,
                    child: Text('${w.manufacturer} ${w.model}$ref (${w.wearList.length} wears)'),
                  );
                }).toList(),
                onChanged: (w) {
                  if (w != null) setState(() => _selectedExistingWatch = w);
                },
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Existing: ${existing.manufacturer} ${existing.model}\n'
                'Status: ${existing.status ?? "Unknown"} • Tracked wears: ${existing.wearList.length}'
                '${existing.referenceNumber != null && existing.referenceNumber!.isNotEmpty ? " • Ref: ${existing.referenceNumber}" : ""}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8),
            RadioGroup<DuplicateResolution>(
              groupValue: _duplicateResolution,
              onChanged: (v) {
                if (v != null) setState(() => _duplicateResolution = v);
              },
              child: const Column(
                children: [
                  RadioListTile<DuplicateResolution>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text('Merge: Fill blank fields & append new wear dates'),
                    value: DuplicateResolution.mergeFillEmpty,
                  ),
                  RadioListTile<DuplicateResolution>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text('Merge: Overwrite existing fields & append wear dates'),
                    value: DuplicateResolution.mergeOverwrite,
                  ),
                  RadioListTile<DuplicateResolution>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text('Create new separate watch record'),
                    value: DuplicateResolution.createNew,
                  ),
                  RadioListTile<DuplicateResolution>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text('Skip this watch'),
                    value: DuplicateResolution.skip,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWearDatesCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        initiallyExpanded: _wearDates.isNotEmpty || _candidate.invalidWearDateValues.isNotEmpty,
        leading: const Icon(Icons.calendar_month),
        title: Text('Wear Dates (${_wearDates.length})'),
        subtitle: _candidate.invalidWearDateValues.isNotEmpty
            ? Text(
                '${_candidate.invalidWearDateValues.length} invalid/future date(s) skipped',
                style: const TextStyle(color: Colors.amber),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_wearDates.isEmpty)
                  const Text('No wear dates parsed for this watch.')
                else
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _wearDates.map((date) {
                      return Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(WristCheckFormatter.getFormattedDate(date)),
                        onDeleted: () {
                          setState(() {
                            _wearDates.remove(date);
                          });
                        },
                      );
                    }).toList(),
                  ),
                if (_candidate.invalidWearDateValues.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Ignored wear date values:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _candidate.invalidWearDateValues.map((raw) {
                      return Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.amber.withValues(alpha: 0.2),
                        label: Text(raw, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status', style: Theme.of(context).textTheme.bodyLarge),
          DropdownButtonFormField<WatchStatusEnum>(
            isExpanded: true,
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            initialValue: WatchStatusEnumExtension.fromDbString(_selectedStatus),
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              const Icon(Icons.flag),
              context,
            ),
            items: WatchStatusEnum.values.map((s) {
              return DropdownMenuItem<WatchStatusEnum>(
                value: s,
                child: Text(s.toLocalizedString(context)),
              );
            }).toList(),
            onChanged: (s) {
              if (s != null) setState(() => _selectedStatus = s.toDbString());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.categoryRowTitle, style: Theme.of(context).textTheme.bodyLarge),
          DropdownButtonFormField<CategoryEnum>(
            isExpanded: true,
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            initialValue: _selectedCategory,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              const Icon(Icons.category),
              context,
            ),
            items: CategoryEnum.values.map((c) {
              return DropdownMenuItem<CategoryEnum>(
                value: c,
                child: Text(c.toLocalizedString(context)),
              );
            }).toList(),
            onChanged: (c) {
              if (c != null) setState(() => _selectedCategory = c);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMovementDropdown(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.movementRowTitle, style: Theme.of(context).textTheme.bodyLarge),
          DropdownButtonFormField<MovementEnum>(
            isExpanded: true,
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            initialValue: _selectedMovement,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              const FaIcon(FontAwesomeIcons.gears),
              context,
            ),
            items: MovementEnum.values.map((m) {
              return DropdownMenuItem<MovementEnum>(
                value: m,
                child: Text(m.toLocalizedString(context)),
              );
            }).toList(),
            onChanged: (m) {
              if (m != null) setState(() => _selectedMovement = m);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCaseMaterialDropdown(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.caseMaterialRowTitle, style: Theme.of(context).textTheme.bodyLarge),
          DropdownButtonFormField<CaseMaterialEnum>(
            isExpanded: true,
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            initialValue: _selectedCaseMaterial,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              const Icon(Icons.watch),
              context,
            ),
            items: CaseMaterialEnum.values.map((m) {
              return DropdownMenuItem<CaseMaterialEnum>(
                value: m,
                child: Text(m.toLocalizedString(context)),
              );
            }).toList(),
            onChanged: (m) {
              if (m != null) setState(() => _selectedCaseMaterial = m);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateComplicationDropdown(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.dateComplicationRowTitle, style: Theme.of(context).textTheme.bodyLarge),
          DropdownButtonFormField<DateComplicationEnum>(
            isExpanded: true,
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            initialValue: _selectedDateComplication,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              const FaIcon(FontAwesomeIcons.calendarDay),
              context,
            ),
            items: DateComplicationEnum.values.map((d) {
              return DropdownMenuItem<DateComplicationEnum>(
                value: d,
                child: Text(d.toLocalizedString(context)),
              );
            }).toList(),
            onChanged: (d) {
              if (d != null) setState(() => _selectedDateComplication = d);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWinderDirectionDropdown(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: WristCheckFormFieldDecoration.getFormFieldPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.winderDirectionRowTitle, style: Theme.of(context).textTheme.bodyLarge),
          DropdownButtonFormField<WinderDirectionEnum>(
            isExpanded: true,
            dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
            borderRadius: BorderRadius.circular(24),
            initialValue: _selectedWinderDirection,
            decoration: WristCheckFormFieldDecoration.getFormFieldDecoration(
              WristCheckFormatter.getWinderDirectionIcon(_selectedWinderDirection),
              context,
            ),
            items: WinderDirectionEnum.values.map((d) {
              return DropdownMenuItem<WinderDirectionEnum>(
                value: d,
                child: Text(d.toLocalizedString(context)),
              );
            }).toList(),
            onChanged: (d) {
              if (d != null) setState(() => _selectedWinderDirection = d);
            },
          ),
        ],
      ),
    );
  }
}
