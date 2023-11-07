import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';

class CategoryClass{
  CategoryClass(this.category, this.count);

  late final CategoryEnum category;
  late final int count;
}

class MovementClass{
  MovementClass(this.movement, this.count);

  late final MovementEnum movement;
  late final int count;
}