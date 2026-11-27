import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/winder_direction_enum.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/upload_models.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/sync/sync_service.dart';
import 'package:wristcheck/util/watch_data_validation_facade.dart';

class UploadMethods {
  /// Opens a file picker on the device and parses the selected CSV file into rows.
  /// Returns null if the user cancels the picker.
  static Future<List<List<dynamic>>?> getCSVImport() async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final picked = result.files.single;
    String content;
    if (picked.bytes != null) {
      try {
        content = utf8.decode(picked.bytes!);
      } on FormatException {
        content = latin1.decode(picked.bytes!);
      }
    } else if (picked.path != null) {
      final bytes = await File(picked.path!).readAsBytes();
      try {
        content = utf8.decode(bytes);
      } on FormatException {
        content = latin1.decode(bytes);
      }
    } else {
      return [];
    }

    return parseCsvString(content);
  }

  /// Parses raw CSV string content into rows, stripping UTF-8 BOM and normalizing line endings.
  static List<List<dynamic>> parseCsvString(String rawContent) {
    final stripped = rawContent.replaceFirst('\uFEFF', '');
    if (stripped.trim().isEmpty) return [];

    final normalized = stripped.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(normalized);

    return rows.where((row) {
      return row.any((cell) => cell.toString().trim().isNotEmpty);
    }).toList();
  }

  /// Inspects the header row against [CsvColumnRegistry] in any column order.
  static HeaderAnalysisResult analyzeHeader(List<dynamic> headerRow) {
    final rawHeaders = headerRow.map((cell) => cell.toString().replaceAll('\uFEFF', '').trim()).toList();
    final matchedColumns = <CsvFieldKey, int>{};
    final matchedHeaderNames = <CsvFieldKey, String>{};
    final unrecognizedHeaders = <String>[];

    for (int i = 0; i < rawHeaders.length; i++) {
      final raw = rawHeaders[i];
      if (raw.isEmpty) continue;
      final spec = CsvColumnRegistry.matchHeader(raw);
      if (spec != null && !matchedColumns.containsKey(spec.key)) {
        matchedColumns[spec.key] = i;
        matchedHeaderNames[spec.key] = raw;
      } else {
        unrecognizedHeaders.add(raw);
      }
    }

    final missingRequired = <CsvFieldKey>[];
    for (final spec in CsvColumnRegistry.specs) {
      if (spec.required && !matchedColumns.containsKey(spec.key)) {
        missingRequired.add(spec.key);
      }
    }

    return HeaderAnalysisResult(
      rawHeaders: rawHeaders,
      matchedColumns: matchedColumns,
      matchedHeaderNames: matchedHeaderNames,
      unrecognizedHeaders: unrecognizedHeaders,
      missingRequiredFields: missingRequired,
    );
  }

  /// Parses CSV data rows (skipping row 0 header) and groups them by normalized Manufacturer + Model.
  static List<ImportWatchCandidate> parseAndGroupRows(
    List<List<dynamic>> rows,
    HeaderAnalysisResult headerAnalysis, {
    DateTime? nowOverride,
  }) {
    if (rows.length <= 1) return [];

    final Map<String, ImportWatchCandidate> grouped = {};
    final List<ImportWatchCandidate> orderedCandidates = [];
    final DateTime referenceNow = nowOverride ?? DateTime.now();

    for (int rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];
      final csvRowNumber = rowIndex + 1;

      String cellFor(CsvFieldKey key) {
        final colIndex = headerAnalysis.matchedColumns[key];
        if (colIndex == null || colIndex >= row.length) return '';
        final raw = row[colIndex].toString().trim();
        if (raw.toLowerCase() == 'null') return '';
        return raw;
      }

      final rawManufacturer = cellFor(CsvFieldKey.manufacturer);
      final rawModel = cellFor(CsvFieldKey.model);

      final bool hasIdentity = rawManufacturer.isNotEmpty && rawModel.isNotEmpty;
      final String groupKey = hasIdentity
          ? '${rawManufacturer.toLowerCase()}||${rawModel.toLowerCase()}'
          : '__invalid_row_$csvRowNumber';

      final candidate = grouped.putIfAbsent(groupKey, () {
        final created = ImportWatchCandidate(
          id: groupKey,
          sourceRowNumbers: [csvRowNumber],
          manufacturer: rawManufacturer,
          model: rawModel,
        );
        orderedCandidates.add(created);
        return created;
      });

      if (!candidate.sourceRowNumbers.contains(csvRowNumber)) {
        candidate.sourceRowNumbers.add(csvRowNumber);
      }

      _populateCandidateFromRow(
        candidate: candidate,
        cellFor: cellFor,
        referenceNow: referenceNow,
      );
    }

    for (final candidate in orderedCandidates) {
      refreshCandidateValidation(candidate);
    }

    return orderedCandidates;
  }

  static void _populateCandidateFromRow({
    required ImportWatchCandidate candidate,
    required String Function(CsvFieldKey key) cellFor,
    required DateTime referenceNow,
  }) {
    void applyStringField(
      CsvFieldKey key,
      String? current,
      void Function(String) assign, {
      bool Function(String)? validator,
      String? invalidMessage,
    }) {
      final raw = cellFor(key);
      if (raw.isEmpty || current != null) return;
      if (validator != null && !validator(raw)) {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: key,
            fieldName: CsvColumnRegistry.specForKey(key)?.canonicalName ?? key.name,
            rawValue: raw,
            message: invalidMessage ?? 'Invalid value "$raw" (will be ignored)',
          ),
        );
        return;
      }
      assign(raw);
    }

    final rawStatus = cellFor(CsvFieldKey.status);
    if (rawStatus.isNotEmpty && candidate.status == null) {
      final parsedStatus = parseStatus(rawStatus);
      if (parsedStatus != null) {
        candidate.status = parsedStatus;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.status,
            fieldName: 'Status',
            rawValue: rawStatus,
            message: 'Unrecognised status "$rawStatus" (will default to In Collection)',
          ),
        );
      }
    }

    final rawCategory = cellFor(CsvFieldKey.category);
    if (rawCategory.isNotEmpty && candidate.category == null) {
      final parsed = parseCategory(rawCategory);
      if (parsed != null) {
        candidate.category = parsed;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.category,
            fieldName: 'Category',
            rawValue: rawCategory,
            message: 'Unrecognised category "$rawCategory"',
          ),
        );
      }
    }

    final rawMovement = cellFor(CsvFieldKey.movement);
    if (rawMovement.isNotEmpty && candidate.movement == null) {
      final parsed = parseMovement(rawMovement);
      if (parsed != null) {
        candidate.movement = parsed;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.movement,
            fieldName: 'Movement',
            rawValue: rawMovement,
            message: 'Unrecognised movement "$rawMovement"',
          ),
        );
      }
    }

    applyStringField(
      CsvFieldKey.primaryColour,
      candidate.primaryColour,
      (v) => candidate.primaryColour = v,
      validator: WatchDataValidationFacade.validatePrimaryColour,
      invalidMessage: 'Primary colour contains unsupported characters',
    );
    applyStringField(
      CsvFieldKey.secondaryColour,
      candidate.secondaryColour,
      (v) => candidate.secondaryColour = v,
      validator: WatchDataValidationFacade.validateSecondaryColour,
      invalidMessage: 'Secondary colour contains unsupported characters',
    );
    applyStringField(
      CsvFieldKey.serialNumber,
      candidate.serialNumber,
      (v) => candidate.serialNumber = v,
      validator: WatchDataValidationFacade.validateSerialNumber,
      invalidMessage: 'Serial number contains unsupported characters',
    );
    applyStringField(
      CsvFieldKey.referenceNumber,
      candidate.referenceNumber,
      (v) => candidate.referenceNumber = v,
      validator: WatchDataValidationFacade.validateReferenceNumber,
      invalidMessage: 'Reference number contains unsupported characters',
    );

    final rawDateComp = cellFor(CsvFieldKey.dateComplication);
    if (rawDateComp.isNotEmpty && candidate.dateComplication == null) {
      final parsed = parseDateComplication(rawDateComp);
      if (parsed != null) {
        candidate.dateComplication = parsed;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.dateComplication,
            fieldName: 'Date Complication',
            rawValue: rawDateComp,
            message: 'Unrecognised date complication "$rawDateComp"',
          ),
        );
      }
    }

    final rawYear = cellFor(CsvFieldKey.year);
    if (rawYear.isNotEmpty && candidate.year == null) {
      final parsed = parsePositiveInt(rawYear);
      if (parsed != null && parsed >= 1800 && parsed <= 2100) {
        candidate.year = parsed;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.year,
            fieldName: 'Model Year',
            rawValue: rawYear,
            message: 'Model year must be a 4-digit year',
          ),
        );
      }
    }

    DateTime? parseAndTrackDate(CsvFieldKey key, DateTime? current, String label) {
      final raw = cellFor(key);
      if (raw.isEmpty || current != null) return current;
      final parsed = parseFlexibleDate(raw);
      if (parsed == null) {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: key,
            fieldName: label,
            rawValue: raw,
            message: 'Could not parse $label "$raw"',
          ),
        );
        return null;
      }
      return parsed;
    }

    candidate.warrantyEndDate =
        parseAndTrackDate(CsvFieldKey.warrantyEndDate, candidate.warrantyEndDate, 'Warranty Expiry Date');
    candidate.lastServicedDate =
        parseAndTrackDate(CsvFieldKey.lastServicedDate, candidate.lastServicedDate, 'Last Serviced Date');
    candidate.purchaseDate =
        parseAndTrackDate(CsvFieldKey.purchaseDate, candidate.purchaseDate, 'Purchase Date');
    candidate.deliveryDate =
        parseAndTrackDate(CsvFieldKey.deliveryDate, candidate.deliveryDate, 'Delivery Date');
    candidate.soldDate =
        parseAndTrackDate(CsvFieldKey.soldDate, candidate.soldDate, 'Sold Date');

    final rawServiceInterval = cellFor(CsvFieldKey.serviceInterval);
    if (rawServiceInterval.isNotEmpty && candidate.serviceInterval == null) {
      final parsed = parsePositiveInt(rawServiceInterval);
      if (parsed != null && parsed >= 0 && parsed <= 99) {
        candidate.serviceInterval = parsed;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.serviceInterval,
            fieldName: 'Service Interval',
            rawValue: rawServiceInterval,
            message: 'Service interval must be between 0 and 99',
          ),
        );
      }
    }

    int? parseAndTrackCurrency(CsvFieldKey key, int? current, String label) {
      final raw = cellFor(key);
      if (raw.isEmpty || current != null) return current;
      final parsed = parseCurrencyInt(raw);
      if (parsed == null) {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: key,
            fieldName: label,
            rawValue: raw,
            message: 'Invalid $label "$raw"',
          ),
        );
        return null;
      }
      return parsed;
    }

    candidate.purchasePrice =
        parseAndTrackCurrency(CsvFieldKey.purchasePrice, candidate.purchasePrice, 'Purchase Price');
    candidate.soldPrice =
        parseAndTrackCurrency(CsvFieldKey.soldPrice, candidate.soldPrice, 'Sold Price');
    candidate.value =
        parseAndTrackCurrency(CsvFieldKey.value, candidate.value, 'Current Value');

    applyStringField(
      CsvFieldKey.purchasedFrom,
      candidate.purchasedFrom,
      (v) => candidate.purchasedFrom = v,
      validator: WatchDataValidationFacade.validatePurchasedFrom,
      invalidMessage: 'Purchased From contains unsupported characters',
    );
    applyStringField(
      CsvFieldKey.soldTo,
      candidate.soldTo,
      (v) => candidate.soldTo = v,
      validator: WatchDataValidationFacade.validateSoldTo,
      invalidMessage: 'Sold To contains unsupported characters',
    );

    double? parseAndTrackDouble(CsvFieldKey key, double? current, String label) {
      final raw = cellFor(key);
      if (raw.isEmpty || current != null) return current;
      final parsed = parseDimensionDouble(raw);
      if (parsed == null || parsed < 0 || parsed > 99.99) {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: key,
            fieldName: label,
            rawValue: raw,
            message: 'Invalid $label "$raw"',
          ),
        );
        return null;
      }
      return parsed;
    }

    candidate.caseDiameter =
        parseAndTrackDouble(CsvFieldKey.caseDiameter, candidate.caseDiameter, 'Case Diameter');
    candidate.caseThickness =
        parseAndTrackDouble(CsvFieldKey.caseThickness, candidate.caseThickness, 'Case Thickness');
    candidate.lug2lug =
        parseAndTrackDouble(CsvFieldKey.lug2lug, candidate.lug2lug, 'Lug to Lug');

    final rawCaseMaterial = cellFor(CsvFieldKey.caseMaterial);
    if (rawCaseMaterial.isNotEmpty && candidate.caseMaterial == null) {
      final parsed = parseCaseMaterial(rawCaseMaterial);
      if (parsed != null) {
        candidate.caseMaterial = parsed;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.caseMaterial,
            fieldName: 'Case Material',
            rawValue: rawCaseMaterial,
            message: 'Unrecognised case material "$rawCaseMaterial"',
          ),
        );
      }
    }

    int? parseAndTrackInt(CsvFieldKey key, int? current, String label, {int max = 999999}) {
      final raw = cellFor(key);
      if (raw.isEmpty || current != null) return current;
      final parsed = parsePositiveInt(raw);
      if (parsed == null || parsed < 0 || parsed > max) {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: key,
            fieldName: label,
            rawValue: raw,
            message: 'Invalid $label "$raw"',
          ),
        );
        return null;
      }
      return parsed;
    }

    candidate.lugWidth =
        parseAndTrackInt(CsvFieldKey.lugWidth, candidate.lugWidth, 'Lug Width', max: 99);
    candidate.waterResistance =
        parseAndTrackInt(CsvFieldKey.waterResistance, candidate.waterResistance, 'Water Resistance');
    candidate.powerReserve =
        parseAndTrackInt(CsvFieldKey.powerReserve, candidate.powerReserve, 'Power Reserve');
    candidate.winderTPD =
        parseAndTrackInt(CsvFieldKey.winderTPD, candidate.winderTPD, 'Winder TPD');

    final rawWinderDir = cellFor(CsvFieldKey.winderDirection);
    if (rawWinderDir.isNotEmpty && candidate.winderDirection == null) {
      final parsed = parseWinderDirection(rawWinderDir);
      if (parsed != null) {
        candidate.winderDirection = parsed;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.winderDirection,
            fieldName: 'Winder Direction',
            rawValue: rawWinderDir,
            message: 'Unrecognised winder direction "$rawWinderDir"',
          ),
        );
      }
    }

    final rawNotes = cellFor(CsvFieldKey.notes);
    if (rawNotes.isNotEmpty && candidate.notes == null) {
      candidate.notes = rawNotes;
    }

    final rawFavourite = cellFor(CsvFieldKey.favourite);
    if (rawFavourite.isNotEmpty && candidate.favourite == null) {
      final parsed = parseBool(rawFavourite);
      if (parsed != null) {
        candidate.favourite = parsed;
      } else {
        _addIssueOnce(
          candidate,
          ImportFieldIssue(
            fieldKey: CsvFieldKey.favourite,
            fieldName: 'Favourite',
            rawValue: rawFavourite,
            message: 'Invalid favourite flag "$rawFavourite"',
          ),
        );
      }
    }

    final rawWear = cellFor(CsvFieldKey.dateWorn);
    if (rawWear.isNotEmpty) {
      final tokens = rawWear.split(RegExp(r'[;|]'));
      for (final token in tokens) {
        final trimmed = token.trim();
        if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') continue;
        final parsed = parseFlexibleDate(trimmed);
        if (parsed == null) {
          if (!candidate.invalidWearDateValues.contains(trimmed)) {
            candidate.invalidWearDateValues.add(trimmed);
          }
          continue;
        }
        final normalizedDate = DateTime(parsed.year, parsed.month, parsed.day);
        final todayEnd = DateTime(referenceNow.year, referenceNow.month, referenceNow.day, 23, 59, 59);
        if (normalizedDate.isAfter(todayEnd)) {
          final label = '$trimmed (future date)';
          if (!candidate.invalidWearDateValues.contains(label)) {
            candidate.invalidWearDateValues.add(label);
          }
          continue;
        }
        final alreadyQueued = candidate.wearDates.any((d) =>
            d.year == normalizedDate.year &&
            d.month == normalizedDate.month &&
            d.day == normalizedDate.day);
        if (!alreadyQueued) {
          candidate.wearDates.add(normalizedDate);
        }
      }
    }
  }

  static void _addIssueOnce(ImportWatchCandidate candidate, ImportFieldIssue issue) {
    final exists = candidate.issues.any(
      (i) => i.fieldKey == issue.fieldKey && i.rawValue == issue.rawValue && i.isError == issue.isError,
    );
    if (!exists) {
      candidate.issues.add(issue);
    }
  }

  /// Re-evaluates identity errors and existing-collection duplicates for [candidate].
  static void refreshCandidateValidation(ImportWatchCandidate candidate) {
    candidate.issues.removeWhere(
      (issue) =>
          issue.isError &&
          (issue.fieldKey == CsvFieldKey.manufacturer || issue.fieldKey == CsvFieldKey.model),
    );

    final manufacturer = candidate.manufacturer.trim();
    final model = candidate.model.trim();

    if (manufacturer.isEmpty || !WatchDataValidationFacade.validateManufacturer(manufacturer)) {
      candidate.issues.insert(
        0,
        ImportFieldIssue(
          fieldKey: CsvFieldKey.manufacturer,
          fieldName: 'Manufacturer',
          rawValue: candidate.manufacturer,
          message: manufacturer.isEmpty
              ? 'Manufacturer is required'
              : 'Manufacturer contains invalid characters',
          isError: true,
        ),
      );
    }

    if (model.isEmpty || !WatchDataValidationFacade.validateModel(model)) {
      candidate.issues.insert(
        0,
        ImportFieldIssue(
          fieldKey: CsvFieldKey.model,
          fieldName: 'Model',
          rawValue: candidate.model,
          message: model.isEmpty
              ? 'Model is required'
              : 'Model contains invalid characters',
          isError: true,
        ),
      );
    }

    if (!candidate.hasBlockingError) {
      final matches = WatchMethods.findDuplicateWatches(manufacturer, model);
      candidate.matchedExistingWatches = matches;
      if (matches.isEmpty) {
        candidate.selectedExistingWatch = null;
      } else if (candidate.selectedExistingWatch == null ||
          !matches.contains(candidate.selectedExistingWatch)) {
        candidate.selectedExistingWatch = matches.first;
      }
    } else {
      candidate.matchedExistingWatches = [];
      candidate.selectedExistingWatch = null;
    }
  }

  /// Commits all included, valid candidates into Hive and optionally triggers a single cloud sync.
  static Future<ImportCommitResult> commitImport(
    List<ImportWatchCandidate> candidates, {
    bool triggerSync = true,
  }) async {
    int createdCount = 0;
    int mergedCount = 0;
    int skippedCount = 0;
    int wearDatesAdded = 0;
    int wearDatesSkippedDuplicate = 0;

    final now = DateTime.now();

    for (final candidate in candidates) {
      final status = candidate.computedStatus;
      if (!candidate.included ||
          status == UploadStatusEnum.fail ||
          status == UploadStatusEnum.skipped) {
        skippedCount++;
        continue;
      }

      final validWearDates = candidate.wearDates
          .where((d) => !d.isAfter(now))
          .toList()
        ..sort();

      final targetExisting = candidate.selectedExistingWatch ??
          (candidate.matchedExistingWatches.isNotEmpty
              ? candidate.matchedExistingWatches.first
              : null);

      if (candidate.isDuplicate &&
          targetExisting != null &&
          (candidate.duplicateResolution == DuplicateResolution.mergeFillEmpty ||
              candidate.duplicateResolution == DuplicateResolution.mergeOverwrite)) {
        final added = await WatchMethods.mergeWatchFromImport(
          targetExisting,
          candidate,
          overwriteExisting:
              candidate.duplicateResolution == DuplicateResolution.mergeOverwrite,
          triggerSync: false,
        );
        mergedCount++;
        wearDatesAdded += added;
        wearDatesSkippedDuplicate += (validWearDates.length - added).clamp(0, validWearDates.length);
      } else {
        await WatchMethods.addWatch(
          candidate.manufacturer.trim(),
          candidate.model.trim(),
          status: candidate.status ?? WatchStatusEnum.inCollection.toDbString(),
          category: candidate.category,
          movement: candidate.movement,
          primaryColour: candidate.primaryColour,
          secondaryColour: candidate.secondaryColour,
          serialNumber: candidate.serialNumber,
          referenceNumber: candidate.referenceNumber,
          dateComplication: candidate.dateComplication,
          year: candidate.year,
          warrantyEndDate: candidate.warrantyEndDate,
          lastServicedDate: candidate.lastServicedDate,
          serviceInterval: candidate.serviceInterval ?? 0,
          purchaseDate: candidate.purchaseDate,
          deliveryDate: candidate.deliveryDate,
          purchasePrice: candidate.purchasePrice,
          purchasedFrom: candidate.purchasedFrom,
          soldDate: candidate.soldDate,
          soldPrice: candidate.soldPrice,
          soldTo: candidate.soldTo,
          value: candidate.value,
          caseDiameter: candidate.caseDiameter,
          caseThickness: candidate.caseThickness,
          caseMaterial: candidate.caseMaterial,
          lugWidth: candidate.lugWidth,
          lug2lug: candidate.lug2lug,
          waterResistance: candidate.waterResistance,
          powerReserve: candidate.powerReserve,
          winderTPD: candidate.winderTPD,
          winderDirection: candidate.winderDirection,
          notes: candidate.notes,
          favourite: candidate.favourite ?? false,
          wearList: validWearDates,
          triggerSync: false,
        );
        createdCount++;
        wearDatesAdded += validWearDates.length;
      }
    }

    if (triggerSync && (createdCount > 0 || mergedCount > 0)) {
      unawaited(SyncService.syncData());
    }

    return ImportCommitResult(
      createdCount: createdCount,
      mergedCount: mergedCount,
      skippedCount: skippedCount,
      wearDatesAdded: wearDatesAdded,
      wearDatesSkippedDuplicate: wearDatesSkippedDuplicate,
    );
  }

  /// Generates a sample CSV template showing optional headers and multiple wear-date rows.
  static String generateTemplateCsv() {
    final rows = <List<String>>[
      [
        'Manufacturer',
        'Model',
        'Status',
        'Category',
        'Movement',
        'Reference Number',
        'Purchase Date',
        'Purchase Price',
        'Case Diameter',
        'Water Resistance',
        'Date Worn',
      ],
      [
        'Omega',
        'Speedmaster Professional',
        'In Collection',
        'Chronograph',
        'Mechanical - Manual',
        '310.30.42.50.01.001',
        '2024-03-15',
        '6500',
        '42',
        '50',
        '2025-01-10',
      ],
      [
        'Omega',
        'Speedmaster Professional',
        'In Collection',
        'Chronograph',
        'Mechanical - Manual',
        '310.30.42.50.01.001',
        '2024-03-15',
        '6500',
        '42',
        '50',
        '2025-01-18',
      ],
      [
        'Seiko',
        'Prospex SPB143',
        'In Collection',
        'Diver',
        'Mechanical - Automatic',
        'SPB143J1',
        '2023-07-01',
        '1200',
        '40.5',
        '200',
        '2025-01-12',
      ],
    ];
    return const ListToCsvConverter().convert(rows);
  }

  static Future<ShareResult> shareSampleTemplate() async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/wristtrack_import_template.csv');
    await file.writeAsString(generateTemplateCsv());
    return SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  /// Generates a ready-to-use prompt users can copy into an AI assistant to convert
  /// an existing spreadsheet into a WristTrack-compatible CSV file.
  static String generateAiAssistantPrompt() {
    final requiredCols = CsvColumnRegistry.specs
        .where((s) => s.required)
        .map((s) => s.canonicalName)
        .join(', ');
    final optionalCols = CsvColumnRegistry.specs
        .where((s) => !s.required)
        .map((s) => s.canonicalName)
        .join(', ');
    final enumLines = CsvColumnRegistry.specs
        .where((s) => s.isEnumValidated)
        .map((s) => '- ${s.canonicalName}: ${s.acceptedValues.join(', ')}')
        .join('\n');

    return '''
Please convert my watch collection spreadsheet/data below into a valid UTF-8 CSV file ready for import into WristTrack.

Rules:
1. Required columns: $requiredCols.
2. Recognised optional columns (only include columns that have data): $optionalCols.
3. Leave unknown or empty cells blank (do not write "N/A" or "null").
4. Format all dates as YYYY-MM-DD (e.g. 2025-01-15).
5. Wear dates: if a watch has wear dates, put ONE wear date per row in the "Date Worn" column and repeat the watch's Manufacturer and Model (and details) on each row for that watch.
6. Numbers:
   - Prices & Current Value: whole numbers without currency symbols (e.g. 6500).
   - Case Diameter, Case Thickness, Lug to Lug: numbers in mm without units (e.g. 40.5).
   - Lug Width (mm), Water Resistance (m), Power Reserve (hours), Winder TPD, Model Year (4 digits), Service Interval (years): whole numbers without units.
   - Favourite: true or false.
7. Fixed-option fields MUST use one of these exact values:
$enumLines

Output:
- Provide ONLY the CSV inside a single code block so I can save it as a .csv file.
- Below the code block, briefly list any columns or values you could not map cleanly.

Here is my data:
[PASTE OR ATTACH YOUR SPREADSHEET / WATCH DATA HERE]''';
  }

  // --- Parsing Helpers ---

  static DateTime? parseFlexibleDate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;

    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return iso;

    final formats = <DateFormat>[
      DateFormat('dd/MM/yyyy'),
      DateFormat('d/M/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('d-M-yyyy'),
      DateFormat('yyyy/MM/dd'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('M/d/yyyy'),
      DateFormat('yMMMd'),
      DateFormat('d MMM yyyy'),
      DateFormat('dd MMM yyyy'),
      DateFormat('MMM d, yyyy'),
    ];

    for (final format in formats) {
      try {
        return format.parseStrict(trimmed);
      } catch (_) {
        // try next format
      }
    }
    return null;
  }

  static int? parsePositiveInt(String raw) {
    final cleaned = raw
        .trim()
        .replaceAll(RegExp(r'(mm|m|hrs|hr|h|years|year|yrs|yr)$', caseSensitive: false), '')
        .replaceAll(',', '')
        .trim();
    if (cleaned.isEmpty) return null;
    final direct = int.tryParse(cleaned);
    if (direct != null) return direct;
    final asDouble = double.tryParse(cleaned);
    if (asDouble != null && asDouble % 1 == 0) {
      return asDouble.toInt();
    }
    return null;
  }

  static int? parseCurrencyInt(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    // Strip currency symbols and spaces
    var cleaned = trimmed.replaceAll(RegExp(r'[^\d.,-]'), '');
    if (cleaned.isEmpty) return null;

    // Handle 1,250.00 vs 1250,00 vs 1,250
    if (cleaned.contains('.') && cleaned.contains(',')) {
      cleaned = cleaned.replaceAll(',', '');
    } else if (cleaned.contains(',')) {
      final parts = cleaned.split(',');
      if (parts.length == 2 && parts.last.length <= 2) {
        cleaned = '${parts[0]}.${parts[1]}';
      } else {
        cleaned = cleaned.replaceAll(',', '');
      }
    }

    final parsed = double.tryParse(cleaned);
    if (parsed == null || parsed < 0) return null;
    return parsed.round();
  }

  static double? parseDimensionDouble(String raw) {
    final cleaned = raw
        .trim()
        .replaceAll(RegExp(r'(mm|cm)$', caseSensitive: false), '')
        .replaceAll(',', '.')
        .trim();
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  static bool? parseBool(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'true':
      case 'yes':
      case 'y':
      case '1':
        return true;
      case 'false':
      case 'no':
      case 'n':
      case '0':
        return false;
      default:
        return null;
    }
  }

  static String? parseStatus(String raw) {
    final norm = raw.trim().toLowerCase();
    for (final value in WatchStatusEnum.values) {
      if (value.toDbString().toLowerCase() == norm) {
        return value.toDbString();
      }
    }
    switch (norm) {
      case 'collection':
      case 'owned':
      case 'active':
        return WatchStatusEnum.inCollection.toDbString();
      case 'preorder':
      case 'pre order':
        return WatchStatusEnum.preOrder.toDbString();
      case 'onloan':
      case 'loaned':
        return WatchStatusEnum.onLoan.toDbString();
      default:
        return null;
    }
  }

  static String? parseCategory(String raw) {
    final norm = raw.trim().toLowerCase();
    for (final value in CategoryEnum.values) {
      if (value.toDbString().toLowerCase() == norm) {
        return value.toDbString();
      }
    }
    switch (norm) {
      case 'dive':
        return CategoryEnum.dive.toDbString();
      case 'pilot':
      case 'aviation':
        return CategoryEnum.flight.toDbString();
      case 'gmt':
        return CategoryEnum.travel.toDbString();
      case 'smartwatch':
        return CategoryEnum.smartWatch.toDbString();
      default:
        return null;
    }
  }

  static String? parseMovement(String raw) {
    final norm = raw.trim().toLowerCase();
    for (final value in MovementEnum.values) {
      if (value.toDbString().toLowerCase() == norm) {
        return value.toDbString();
      }
    }
    switch (norm) {
      case 'automatic':
      case 'auto':
        return MovementEnum.automatic.toDbString();
      case 'manual':
      case 'hand-wound':
      case 'hand wound':
      case 'mechanical':
        return MovementEnum.mechanical.toDbString();
      case 'quartz':
        return MovementEnum.analogue_quartz.toDbString();
      case 'solar':
        return MovementEnum.solar.toDbString();
      case 'mechaquartz':
        return MovementEnum.mechaquartz.toDbString();
      default:
        return null;
    }
  }

  static String? parseCaseMaterial(String raw) {
    final norm = raw.trim().toLowerCase();
    for (final value in CaseMaterialEnum.values) {
      if (value.toDbString().toLowerCase() == norm) {
        return value.toDbString();
      }
    }
    switch (norm) {
      case 'stainless steel':
      case 'ss':
        return CaseMaterialEnum.steel.toDbString();
      case 'pvd':
      case 'dlc':
      case 'pvd steel':
      case 'dlc steel':
        return CaseMaterialEnum.pvdsteel.toDbString();
      case 'two tone':
      case 'bi-metal':
        return CaseMaterialEnum.twotone.toDbString();
      default:
        return null;
    }
  }

  static String? parseDateComplication(String raw) {
    final norm = raw.trim().toLowerCase();
    for (final value in DateComplicationEnum.values) {
      if (value.toDbString().toLowerCase() == norm) {
        return value.toDbString();
      }
    }
    switch (norm) {
      case 'none':
      case 'no':
        return DateComplicationEnum.nodate.toDbString();
      case 'day date':
        return DateComplicationEnum.daydate.toDbString();
      default:
        return null;
    }
  }

  static String? parseWinderDirection(String raw) {
    final norm = raw.trim().toLowerCase();
    for (final value in WinderDirectionEnum.values) {
      if (value.toDbString().toLowerCase() == norm && value != WinderDirectionEnum.blank) {
        return value.toDbString();
      }
    }
    switch (norm) {
      case 'cw':
        return WinderDirectionEnum.clockwise.toDbString();
      case 'ccw':
      case 'counter clockwise':
        return WinderDirectionEnum.counterclockwise.toDbString();
      case 'bidirectional':
      case 'bi-directional':
        return WinderDirectionEnum.both.toDbString();
      default:
        return null;
    }
  }

  /// Gets a readable watch name from a candidate or raw row.
  static String getWatchName(List<dynamic> inputRow) {
    if (inputRow.isNotEmpty && inputRow.length > 2) {
      return '${inputRow[1]} ${inputRow[2]}'.trim();
    }
    return 'Unknown';
  }

  static Widget getStatusIcon(UploadStatusEnum? status) {
    switch (status) {
      case UploadStatusEnum.pass:
        return const FaIcon(
          FontAwesomeIcons.circleCheck,
          color: Colors.green,
          size: 26,
        );
      case UploadStatusEnum.fail:
        return const FaIcon(
          FontAwesomeIcons.circleXmark,
          color: Colors.red,
          size: 26,
        );
      case UploadStatusEnum.partialpass:
        return const FaIcon(
          FontAwesomeIcons.triangleExclamation,
          color: Colors.amber,
          size: 26,
        );
      case UploadStatusEnum.duplicate:
        return const FaIcon(
          FontAwesomeIcons.clone,
          color: Colors.orange,
          size: 24,
        );
      case UploadStatusEnum.skipped:
        return const FaIcon(
          FontAwesomeIcons.ban,
          color: Colors.grey,
          size: 24,
        );
      default:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
    }
  }
}
