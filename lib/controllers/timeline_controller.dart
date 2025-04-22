import 'package:get/get.dart';

class TimelineController extends GetxController{

  final timelineOrderAscending = true.obs;
  final showPurchases = true.obs;
  final showSales = true.obs;
  final showLastServiced = true.obs;
  final showWarrantyEnd = true.obs;

  updateTimelineOrderAscending(bool ascending){
    timelineOrderAscending(ascending);
  }

  updateShowPurchases(bool purchases){
    showPurchases(purchases);
  }

  updateShowSales(bool sales){
    showSales(sales);
  }

  updateShowLastServiced(bool serviced){
    showLastServiced(serviced);
  }

  updateShowWarrantyEnd(bool warranty){
    showWarrantyEnd(warranty);
  }

}