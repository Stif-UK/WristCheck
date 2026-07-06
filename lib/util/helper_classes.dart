import '../model/watches.dart';

class WornWatchesClass{
  WornWatchesClass(
      this.watch,
      this.count,
      [this.percentage]);
  final Watches watch;
  final int count;
  String? percentage;

  void setPercentage(String value) {
    this.percentage = value;
  }
}

class ManufacturersWornClass {
  ManufacturersWornClass(
      this.manufacturer,
      this.count,
      [this.percentage]);
  final String manufacturer;
  final int count;
  String? percentage;

  void setPercentage(String value) {
    this.percentage = value;
  }
}

class CategoriesWornClass {
  CategoriesWornClass(
      this.category,
      this.count,
      [this.percentage]);
  final String category;
  final int count;
  String? percentage;

  void setPercentage(String value) {
    this.percentage = value;
  }
}

class StatusWornClass {
  StatusWornClass(
      this.status,
      this.count,
      [this.percentage]);
  final String status;
  final int count;
  String? percentage;

  void setPercentage(String value) {
    this.percentage = value;
  }
}

