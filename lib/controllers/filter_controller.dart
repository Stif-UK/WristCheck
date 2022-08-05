import 'package:get/get.dart';

class FilterController extends GetxController{

  //filterName can be set to "In Collection", "Sold", "Wishlist", "None"
  //ToDo: create enums
  final filterName = "In Collection".obs;

updateFilterName(String name){
    filterName(name);
    print(name);
  }
}