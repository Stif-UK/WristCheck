import 'package:get/get.dart';

class FilterController extends GetxController{

  //filterName can be set to "In Collection", "Sold", "Wishlist", "Show All"
  //ToDo: create enums
  final filterName = "In Collection".obs;

updateFilterName(String name){
    filterName(name);
    print("Updating filterName to $name");
    print("filterName is now $filterName");
  }

  getFilterName(){
  print("Returning filterName: ${filterName.toString()}");
  return filterName.toString();
  }

}