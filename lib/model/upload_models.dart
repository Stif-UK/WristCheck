import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/watches.dart';

enum CsvFieldKey {
  status,
  manufacturer,
  model,
  category,
  movement,
  primaryColour,
  secondaryColour,
  serialNumber,
  referenceNumber,
  dateComplication,
  year,
  warrantyEndDate,
  lastServicedDate,
  serviceInterval,
  purchaseDate,
  deliveryDate,
  purchasePrice,
  purchasedFrom,
  soldDate,
  soldPrice,
  soldTo,
  value,
  caseDiameter,
  caseThickness,
  caseMaterial,
  lugWidth,
  lug2lug,
  waterResistance,
  powerReserve,
  winderTPD,
  winderDirection,
  notes,
  favourite,
  dateWorn,
}

enum DuplicateResolution {
  mergeFillEmpty,
  mergeOverwrite,
  createNew,
  skip,
}

class CsvColumnSpec {
  final CsvFieldKey key;
  final String canonicalName;
  final List<String> aliases;
  final bool required;
  final String group;
  final List<String> acceptedValues;
  final List<String> valueAliases;
  final String? validationNote;

  const CsvColumnSpec({
    required this.key,
    required this.canonicalName,
    required this.aliases,
    this.required = false,
    required this.group,
    this.acceptedValues = const [],
    this.valueAliases = const [],
    this.validationNote,
  });

  bool get isEnumValidated => acceptedValues.isNotEmpty;
}

class CsvColumnRegistry {
  static const List<CsvColumnSpec> specs = [
    CsvColumnSpec(
      key: CsvFieldKey.manufacturer,
      canonicalName: 'Manufacturer',
      aliases: ['manufacturer', 'make', 'brand', 'watch brand'],
      required: true,
      group: 'Required',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.model,
      canonicalName: 'Model',
      aliases: ['model', 'model name', 'watch model'],
      required: true,
      group: 'Required',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.status,
      canonicalName: 'Status',
      aliases: ['status', 'watch status', 'collection status'],
      group: 'Identity',
      acceptedValues: [
        'In Collection',
        'Sold',
        'Wishlist',
        'Pre-Order',
        'Retired',
        'Archived',
        'On Loan',
      ],
      valueAliases: ['Collection', 'Owned', 'Active', 'Preorder', 'Pre Order', 'OnLoan', 'Loaned'],
      validationNote:
          'Unrecognised values are flagged for manual review and default to "In Collection" if not corrected.',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.category,
      canonicalName: 'Category',
      aliases: ['category', 'type', 'style', 'watch category'],
      group: 'Identity',
      acceptedValues: [
        'Diver',
        'Sports',
        'Flight',
        'Field',
        'Dress',
        'Tool',
        'Chronograph',
        'Travel',
        'Digital',
        'General',
        'Casual',
        'Smart Watch',
        'Luxury',
      ],
      valueAliases: ['Dive', 'Pilot', 'Aviation', 'GMT', 'Smartwatch'],
      validationNote:
          'Unrecognised values are flagged as a warning for manual review and ignored unless corrected.',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.movement,
      canonicalName: 'Movement',
      aliases: ['movement', 'calibre', 'caliber', 'movement type'],
      group: 'Identity',
      acceptedValues: [
        'Mechanical - Manual',
        'Mechanical - Automatic',
        'Analogue Quartz',
        'Digital Quartz',
        'Ana-Digi Quartz',
        'Kinetic',
        'Mecha-Quartz',
        'Spring Drive',
        'Smartwatch',
        'Tourbillon',
        'Solar Quartz',
        'Tuning Fork',
        'Other',
      ],
      valueAliases: [
        'Automatic',
        'Auto',
        'Manual',
        'Hand-Wound',
        'Mechanical',
        'Quartz',
        'Solar',
        'Mechaquartz',
      ],
      validationNote:
          'Unrecognised values are flagged as a warning for manual review and ignored unless corrected.',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.primaryColour,
      canonicalName: 'Primary Colour',
      aliases: [
        'primary colour',
        'primary color',
        'dial colour',
        'dial color',
        'colour',
        'color',
      ],
      group: 'Identity',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.secondaryColour,
      canonicalName: 'Secondary Colour',
      aliases: ['secondary colour', 'secondary color', 'accent colour', 'accent color'],
      group: 'Identity',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.serialNumber,
      canonicalName: 'Serial Number',
      aliases: ['serial number', 'serial', 'serial no', 'sn'],
      group: 'Identity',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.referenceNumber,
      canonicalName: 'Reference Number',
      aliases: ['reference number', 'reference', 'ref', 'ref number', 'ref no'],
      group: 'Identity',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.dateComplication,
      canonicalName: 'Date Complication',
      aliases: ['date complication', 'complication', 'date type'],
      group: 'Identity',
      acceptedValues: [
        'Date',
        'No Date',
        'Day-Date',
        'Pointer Date',
        'Pointer Day-Date',
        'Sub-Dial Date',
        'Sub-Dial Day-Date',
        'Perpetual Date',
        'Digital Date',
      ],
      valueAliases: ['None', 'No', 'Day Date'],
      validationNote:
          'Unrecognised values are flagged as a warning for manual review and ignored unless corrected.',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.favourite,
      canonicalName: 'Favourite',
      aliases: ['favourite', 'favorite', 'fav'],
      group: 'Identity',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.dateWorn,
      canonicalName: 'Date Worn',
      aliases: [
        'date worn',
        'wear date',
        'wear dates',
        'worn date',
        'worn on',
        'dates worn',
      ],
      group: 'Wear Tracking',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.year,
      canonicalName: 'Model Year',
      aliases: ['model year', 'year', 'manufacture year'],
      group: 'Dates',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.purchaseDate,
      canonicalName: 'Purchase Date',
      aliases: ['purchase date', 'purchased date', 'date purchased', 'acquired date'],
      group: 'Dates',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.deliveryDate,
      canonicalName: 'Delivery Date',
      aliases: ['delivery date', 'pre-order due date', 'preorder due date', 'due date'],
      group: 'Dates',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.warrantyEndDate,
      canonicalName: 'Warranty Expiry Date',
      aliases: [
        'warranty expiry date',
        'warranty end date',
        'warranty expiry',
        'warranty end',
        'warranty date',
      ],
      group: 'Dates',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.lastServicedDate,
      canonicalName: 'Last Serviced Date',
      aliases: ['last serviced date', 'last serviced', 'service date', 'last service date'],
      group: 'Dates',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.serviceInterval,
      canonicalName: 'Service Interval',
      aliases: ['service interval', 'service interval years', 'service frequency'],
      group: 'Dates',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.soldDate,
      canonicalName: 'Sold Date',
      aliases: ['sold date', 'date sold', 'sale date'],
      group: 'Dates',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.purchasePrice,
      canonicalName: 'Purchase Price',
      aliases: ['purchase price', 'price paid', 'cost', 'bought price'],
      group: 'Value',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.purchasedFrom,
      canonicalName: 'Purchased From',
      aliases: ['purchased from', 'seller', 'dealer', 'retailer', 'bought from'],
      group: 'Value',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.soldPrice,
      canonicalName: 'Sold Price',
      aliases: ['sold price', 'sale price'],
      group: 'Value',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.soldTo,
      canonicalName: 'Sold To',
      aliases: ['sold to', 'buyer'],
      group: 'Value',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.value,
      canonicalName: 'Current Value',
      aliases: ['current value', 'value', 'estimated value', 'market value'],
      group: 'Value',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.caseDiameter,
      canonicalName: 'Case Diameter',
      aliases: ['case diameter', 'diameter', 'case size', 'width'],
      group: 'Specifications',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.caseThickness,
      canonicalName: 'Case Thickness',
      aliases: ['case thickness', 'thickness', 'height'],
      group: 'Specifications',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.caseMaterial,
      canonicalName: 'Case Material',
      aliases: ['case material', 'material'],
      group: 'Specifications',
      acceptedValues: [
        'Steel',
        'PVD/DLC Steel',
        'Titanium',
        'Gold',
        'White Gold',
        'Two-Tone',
        'Platinum',
        'Bronze',
        'Ceramic',
        'Carbon',
        'Tungsten',
        'Resin',
        'Plastic',
        'Other',
      ],
      valueAliases: [
        'Stainless Steel',
        'SS',
        'PVD',
        'DLC',
        'PVD Steel',
        'DLC Steel',
        'Two Tone',
        'Bi-Metal',
      ],
      validationNote:
          'Unrecognised values are flagged as a warning for manual review and ignored unless corrected.',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.lugWidth,
      canonicalName: 'Lug Width',
      aliases: ['lug width', 'strap width'],
      group: 'Specifications',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.lug2lug,
      canonicalName: 'Lug to Lug',
      aliases: ['lug to lug', 'lug-to-lug', 'lug2lug', 'l2l'],
      group: 'Specifications',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.waterResistance,
      canonicalName: 'Water Resistance',
      aliases: ['water resistance', 'wr', 'waterproof'],
      group: 'Specifications',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.powerReserve,
      canonicalName: 'Power Reserve',
      aliases: ['power reserve', 'reserve'],
      group: 'Specifications',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.winderTPD,
      canonicalName: 'Winder TPD',
      aliases: ['winder tpd', 'tpd', 'turns per day'],
      group: 'Specifications',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.winderDirection,
      canonicalName: 'Winder Direction',
      aliases: ['winder direction', 'winding direction'],
      group: 'Specifications',
      acceptedValues: [
        'Clockwise',
        'Counter-Clockwise',
        'Both',
      ],
      valueAliases: ['CW', 'CCW', 'Counter Clockwise', 'Bidirectional', 'Bi-Directional'],
      validationNote:
          'Unrecognised values are flagged as a warning for manual review and ignored unless corrected.',
    ),
    CsvColumnSpec(
      key: CsvFieldKey.notes,
      canonicalName: 'Notes',
      aliases: ['notes', 'note', 'comments', 'description'],
      group: 'Identity',
    ),
  ];

  static String normalizeHeader(String raw) {
    return raw
        .replaceAll('\uFEFF', '')
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[_]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static CsvColumnSpec? specForKey(CsvFieldKey key) {
    for (final spec in specs) {
      if (spec.key == key) return spec;
    }
    return null;
  }

  static CsvColumnSpec? matchHeader(String rawHeader) {
    final normalized = normalizeHeader(rawHeader);
    if (normalized.isEmpty) return null;

    for (final spec in specs) {
      if (normalizeHeader(spec.canonicalName) == normalized) {
        return spec;
      }
      for (final alias in spec.aliases) {
        if (normalizeHeader(alias) == normalized) {
          return spec;
        }
      }
    }
    return null;
  }
}

class HeaderAnalysisResult {
  final List<String> rawHeaders;
  final Map<CsvFieldKey, int> matchedColumns;
  final Map<CsvFieldKey, String> matchedHeaderNames;
  final List<String> unrecognizedHeaders;
  final List<CsvFieldKey> missingRequiredFields;

  const HeaderAnalysisResult({
    required this.rawHeaders,
    required this.matchedColumns,
    required this.matchedHeaderNames,
    required this.unrecognizedHeaders,
    required this.missingRequiredFields,
  });

  bool get isValid => missingRequiredFields.isEmpty;

  int get matchedCount => matchedColumns.length;

  int get totalKnownCount => CsvColumnRegistry.specs.length;
}

class ImportFieldIssue {
  final CsvFieldKey fieldKey;
  final String fieldName;
  final String rawValue;
  final String message;
  final bool isError;

  const ImportFieldIssue({
    required this.fieldKey,
    required this.fieldName,
    required this.rawValue,
    required this.message,
    this.isError = false,
  });
}

class ImportWatchCandidate {
  final String id;
  final List<int> sourceRowNumbers;

  String manufacturer;
  String model;
  String? status;
  String? category;
  String? movement;
  String? primaryColour;
  String? secondaryColour;
  String? serialNumber;
  String? referenceNumber;
  String? dateComplication;
  int? year;
  DateTime? warrantyEndDate;
  DateTime? lastServicedDate;
  int? serviceInterval;
  DateTime? purchaseDate;
  DateTime? deliveryDate;
  int? purchasePrice;
  String? purchasedFrom;
  DateTime? soldDate;
  int? soldPrice;
  String? soldTo;
  int? value;
  double? caseDiameter;
  double? caseThickness;
  String? caseMaterial;
  int? lugWidth;
  double? lug2lug;
  int? waterResistance;
  int? powerReserve;
  int? winderTPD;
  String? winderDirection;
  String? notes;
  bool? favourite;

  List<DateTime> wearDates;
  List<String> invalidWearDateValues;
  List<ImportFieldIssue> issues;

  List<Watches> matchedExistingWatches;
  Watches? selectedExistingWatch;
  DuplicateResolution duplicateResolution;
  bool included;

  ImportWatchCandidate({
    required this.id,
    required this.sourceRowNumbers,
    required this.manufacturer,
    required this.model,
    this.status,
    this.category,
    this.movement,
    this.primaryColour,
    this.secondaryColour,
    this.serialNumber,
    this.referenceNumber,
    this.dateComplication,
    this.year,
    this.warrantyEndDate,
    this.lastServicedDate,
    this.serviceInterval,
    this.purchaseDate,
    this.deliveryDate,
    this.purchasePrice,
    this.purchasedFrom,
    this.soldDate,
    this.soldPrice,
    this.soldTo,
    this.value,
    this.caseDiameter,
    this.caseThickness,
    this.caseMaterial,
    this.lugWidth,
    this.lug2lug,
    this.waterResistance,
    this.powerReserve,
    this.winderTPD,
    this.winderDirection,
    this.notes,
    this.favourite,
    List<DateTime>? wearDates,
    List<String>? invalidWearDateValues,
    List<ImportFieldIssue>? issues,
    List<Watches>? matchedExistingWatches,
    this.selectedExistingWatch,
    this.duplicateResolution = DuplicateResolution.mergeFillEmpty,
    this.included = true,
  })  : wearDates = wearDates ?? [],
        invalidWearDateValues = invalidWearDateValues ?? [],
        issues = issues ?? [],
        matchedExistingWatches = matchedExistingWatches ?? [];

  bool get isDuplicate => matchedExistingWatches.isNotEmpty;

  bool get hasBlockingError =>
      issues.any((issue) => issue.isError) ||
      manufacturer.trim().isEmpty ||
      model.trim().isEmpty;

  bool get hasWarnings =>
      issues.any((issue) => !issue.isError) || invalidWearDateValues.isNotEmpty;

  String get displayName {
    final full = '${manufacturer.trim()} ${model.trim()}'.trim();
    return full.isEmpty ? 'Unknown Watch' : full;
  }

  UploadStatusEnum get computedStatus {
    if (!included || (isDuplicate && duplicateResolution == DuplicateResolution.skip)) {
      return UploadStatusEnum.skipped;
    }
    if (hasBlockingError) {
      return UploadStatusEnum.fail;
    }
    if (isDuplicate && duplicateResolution != DuplicateResolution.createNew) {
      return UploadStatusEnum.duplicate;
    }
    if (hasWarnings) {
      return UploadStatusEnum.partialpass;
    }
    return UploadStatusEnum.pass;
  }

  int countNewWearDatesFor(Watches? targetWatch) {
    if (wearDates.isEmpty) return 0;
    if (targetWatch == null) return wearDates.length;
    int count = 0;
    for (final date in wearDates) {
      final exists = targetWatch.wearList.any((existing) =>
          existing.year == date.year &&
          existing.month == date.month &&
          existing.day == date.day);
      if (!exists) count++;
    }
    return count;
  }
}

class ImportCommitResult {
  final int createdCount;
  final int mergedCount;
  final int skippedCount;
  final int wearDatesAdded;
  final int wearDatesSkippedDuplicate;

  const ImportCommitResult({
    required this.createdCount,
    required this.mergedCount,
    required this.skippedCount,
    required this.wearDatesAdded,
    required this.wearDatesSkippedDuplicate,
  });

  int get totalProcessed => createdCount + mergedCount;
}
