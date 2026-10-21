import 'dart:async';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:wristcheck/sync/sync_service.dart';

part 'watches.g.dart';

@HiveType(typeId: 0)
class Watches extends HiveObject {

  Watches();

  @HiveField(0)
  late String manufacturer;
  
  @HiveField(1)
  late String model;
  
  @HiveField(2)
  late String? serialNumber;
  
  @HiveField(3)
  late bool favourite;

  @HiveField(4)
  late String? status;

  @HiveField(5)
  late DateTime? purchaseDate;

  @HiveField(6)
  late DateTime? lastServicedDate;

  @HiveField(7)
  late int serviceInterval;

  @HiveField(8)
  late DateTime? nextServiceDue;

  @HiveField(9)
  late String? notes;

  @HiveField(10)
  late List<DateTime> wearList;

  @HiveField(12)
  late String? frontImagePath;

  @HiveField(13)
  late String? referenceNumber;

  @HiveField(14)
  late String? backImagePath;

  @HiveField(15)
  late String? movement;

  @HiveField(16)
  late String? category;

  @HiveField(17)
  late String? purchasedFrom;

  @HiveField(18)
  late String? soldTo;

  @HiveField(19)
  late int? purchasePrice;

  @HiveField(20)
  late int? soldPrice;

  @HiveField(21)
  late DateTime? soldDate;

  @HiveField(22)
  late DateTime? deliveryDate;

  @HiveField(23)
  late DateTime? warrantyEndDate;

  @HiveField(24)
  late double? caseDiameter;

  @HiveField(25)
  late int? lugWidth;

  @HiveField(26)
  late double? lug2lug;
  
  @HiveField(27)
  late double? caseThickness;

  @HiveField(28)
  late int? waterResistance;

  @HiveField(29)
  late String? caseMaterial;

  @HiveField(30)
  late int? winderTPD;

  @HiveField(31)
  late String? winderDirection;

  @HiveField(32)
  late String? dateComplication;

  @HiveField(33)
  late String? lumeImagePath;

  @HiveField(34)
  late int? year;

  @HiveField(35)
  late int? weight;

  @HiveField(36)
  late int? winderTPDmax;

  @HiveField(37)
  late int? value;

  @HiveField(38)
  late String? primaryColour;

  @HiveField(39)
  late String? secondaryColour;

  @HiveField(40)
  late int? powerReserve;

  @HiveField(41)
  late String? crystal;

  @HiveField(42)
  late String? crown;

  @HiveField(44)
  late int? primaryImageIndex;

  // --- Cloud Sync Fields (Nullable to prevent LateInitializationError) ---
  @HiveField(43)
  String? id;

  @HiveField(46)
  DateTime? updatedAt;

  @HiveField(47)
  bool? isDeleted;

  @HiveField(48)
  bool? frontImageSynced;

  @HiveField(49)
  bool? backImageSynced;

  @HiveField(50)
  bool? lumeImageSynced;

  @HiveField(51)
  bool? isDirty;

  /// Ensure ID and sync metadata are initialized
  void ensureInitialized() {
    id ??= const Uuid().v4();
    updatedAt ??= DateTime.now();
    isDeleted ??= false;
    isDirty ??= true; // New or migrated watches start dirty
    frontImageSynced ??= frontImagePath == null || frontImagePath!.isEmpty;
    backImageSynced ??= backImagePath == null || backImagePath!.isEmpty;
    lumeImageSynced ??= lumeImagePath == null || lumeImagePath!.isEmpty;
  }

  /// Helper to save changes and mark watch as dirty for incremental cloud sync
  Future<void> saveModified() async {
    ensureInitialized();
    isDirty = true;
    updatedAt = DateTime.now();
    await save();
    unawaited(SyncService.syncData());
  }

  /// Serialize to JSON for Supabase upsert
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? const Uuid().v4(),
      'manufacturer': manufacturer,
      'model': model,
      'serial_number': serialNumber,
      'favourite': favourite,
      'status': status,
      'purchase_date': purchaseDate?.toIso8601String(),
      'last_serviced_date': lastServicedDate?.toIso8601String(),
      'service_interval': serviceInterval,
      'next_service_due': nextServiceDue?.toIso8601String(),
      'notes': notes,
      'wear_list': wearList.map((d) => d.toIso8601String()).toList(),
      'front_image_path': frontImagePath,
      'reference_number': referenceNumber,
      'back_image_path': backImagePath,
      'movement': movement,
      'category': category,
      'purchased_from': purchasedFrom,
      'sold_to': soldTo,
      'purchase_price': purchasePrice,
      'sold_price': soldPrice,
      'sold_date': soldDate?.toIso8601String(),
      'delivery_date': deliveryDate?.toIso8601String(),
      'warranty_end_date': warrantyEndDate?.toIso8601String(),
      'case_diameter': caseDiameter,
      'lug_width': lugWidth,
      'lug2_lug': lug2lug,
      'case_thickness': caseThickness,
      'water_resistance': waterResistance,
      'case_material': caseMaterial,
      'winder_tpd': winderTPD,
      'winder_direction': winderDirection,
      'date_complication': dateComplication,
      'lume_image_path': lumeImagePath,
      'year': year,
      'weight': weight,
      'winder_tpd_max': winderTPDmax,
      'value': value,
      'primary_colour': primaryColour,
      'secondary_colour': secondaryColour,
      'power_reserve': powerReserve,
      'crystal': crystal,
      'crown': crown,
      'primary_image_index': primaryImageIndex,
      'updated_at': (updatedAt ?? DateTime.now()).toIso8601String(),
      'is_deleted': isDeleted ?? false,
      'front_image_synced': frontImageSynced ?? false,
      'back_image_synced': backImageSynced ?? false,
      'lume_image_synced': lumeImageSynced ?? false,
    };
  }

  /// Deserialize from Supabase JSON response
  factory Watches.fromJson(Map<String, dynamic> json) {
    return Watches()
      ..id = json['id'] as String?
      ..manufacturer = json['manufacturer'] as String? ?? ''
      ..model = json['model'] as String? ?? ''
      ..serialNumber = json['serial_number'] as String?
      ..favourite = json['favourite'] as bool? ?? false
      ..status = json['status'] as String?
      ..purchaseDate = json['purchase_date'] != null ? DateTime.parse(json['purchase_date']) : null
      ..lastServicedDate = json['last_serviced_date'] != null ? DateTime.parse(json['last_serviced_date']) : null
      ..serviceInterval = json['service_interval'] as int? ?? 0
      ..nextServiceDue = json['next_service_due'] != null ? DateTime.parse(json['next_service_due']) : null
      ..notes = json['notes'] as String?
      ..wearList = (json['wear_list'] as List<dynamic>?)
              ?.map((d) => DateTime.parse(d as String))
              .toList() ??
          <DateTime>[]
      ..frontImagePath = json['front_image_path'] as String?
      ..referenceNumber = json['reference_number'] as String?
      ..backImagePath = json['back_image_path'] as String?
      ..movement = json['movement'] as String?
      ..category = json['category'] as String?
      ..purchasedFrom = json['purchased_from'] as String?
      ..soldTo = json['sold_to'] as String?
      ..purchasePrice = json['purchase_price'] as int?
      ..soldPrice = json['sold_price'] as int?
      ..soldDate = json['sold_date'] != null ? DateTime.parse(json['sold_date']) : null
      ..deliveryDate = json['delivery_date'] != null ? DateTime.parse(json['delivery_date']) : null
      ..warrantyEndDate = json['warranty_end_date'] != null ? DateTime.parse(json['warranty_end_date']) : null
      ..caseDiameter = (json['case_diameter'] as num?)?.toDouble()
      ..lugWidth = json['lug_width'] as int?
      ..lug2lug = (json['lug2_lug'] as num?)?.toDouble()
      ..caseThickness = (json['case_thickness'] as num?)?.toDouble()
      ..waterResistance = json['water_resistance'] as int?
      ..caseMaterial = json['case_material'] as String?
      ..winderTPD = json['winder_tpd'] as int?
      ..winderDirection = json['winder_direction'] as String?
      ..dateComplication = json['date_complication'] as String?
      ..lumeImagePath = json['lume_image_path'] as String?
      ..year = json['year'] as int?
      ..weight = json['weight'] as int?
      ..winderTPDmax = json['winder_tpd_max'] as int?
      ..value = json['value'] as int?
      ..primaryColour = json['primary_colour'] as String?
      ..secondaryColour = json['secondary_colour'] as String?
      ..powerReserve = json['power_reserve'] as int?
      ..crystal = json['crystal'] as String?
      ..crown = json['crown'] as String?
      ..primaryImageIndex = json['primary_image_index'] as int? ?? 0
      ..updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null
      ..isDeleted = json['is_deleted'] as bool? ?? false
      ..isDirty = false // Pulled from remote, so initially clean
      ..frontImageSynced = json['front_image_synced'] as bool? ?? false
      ..backImageSynced = json['back_image_synced'] as bool? ?? false
      ..lumeImageSynced = json['lume_image_synced'] as bool? ?? false;
  }

  @override
  String toString() {
    return "$manufacturer $model";
  }
}
