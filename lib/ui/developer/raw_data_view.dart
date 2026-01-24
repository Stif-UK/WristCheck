import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import '../../boxes.dart';

class RawDataView extends StatefulWidget {
  const RawDataView({super.key});

  @override
  State<RawDataView> createState() => _RawDataViewState();
}

class _RawDataViewState extends State<RawDataView> {
  @override
  Widget build(BuildContext context) {
    var data = Boxes.getAllWatches();
    return Scaffold(
      appBar: AppBar(title: const Text("Raw Watch Data"),),
      body: Column(
        children: [
          // ListTile(title: const Text("Clear data"),
          //   trailing: IconButton(
          //     icon: const Icon(FontAwesomeIcons.trash),
          //     onPressed: (){
          //       setState(() {
          //         //MeasurementMethods.clearMeasurementData();
          //       });
          //     },),),
          const Divider(thickness: 2,),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns:[
                      DataColumn(label: Text('Key')),
                      DataColumn(label: Text('Manufacturer')),
                      DataColumn(label: Text('Model')),
                      DataColumn(label: Text('Serial Number')),
                      DataColumn(label: Text('Favourite')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Purchase Date')),
                      DataColumn(label: Text('Last Serviced')),
                      DataColumn(label: Text('Service Interval')),
                      DataColumn(label: Text('Next Service')),
                      DataColumn(label: Text('ImgPath-F')),
                      DataColumn(label: Text('Reference')),
                      DataColumn(label: Text('ImgPath-B')),
                      DataColumn(label: Text('Movement')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Purchased From')),
                      DataColumn(label: Text('Sold To')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Sold Price')),
                      DataColumn(label: Text('Sold Date')),
                      DataColumn(label: Text('Delivery Date')),
                      DataColumn(label: Text('Warranty End')),
                      DataColumn(label: Text('Case Diameter')),
                      DataColumn(label: Text('Lug Width')),
                      DataColumn(label: Text('Lug to Lug')),
                      DataColumn(label: Text('Case Thickness')),
                      DataColumn(label: Text('Water Resistance')),
                      DataColumn(label: Text('Meterial')),
                      DataColumn(label: Text('TPD')),
                      DataColumn(label: Text('Direction')),
                      DataColumn(label: Text('Date Complication')),
                      DataColumn(label: Text('ImgPath-L')),
                      DataColumn(label: Text('ImgIndex-P')),
                      DataColumn(label: Text('Notes')),
                    ],
                    rows: getRows(data)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> getRows(List<Watches> data) {
    List<DataRow> rows = [];
    for(Watches watch in data){
      rows.add(DataRow(
          cells:[
            DataCell(Text(watch.key.toString())),
            DataCell(Text(watch.manufacturer.toString())),
            DataCell(Text(watch.model.toString())),
            DataCell(Text(watch.serialNumber.toString())),
            DataCell(Text(watch.favourite.toString())),
            DataCell(Text(watch.status.toString())),
            DataCell(Text(watch.purchaseDate.toString())),
            DataCell(Text(watch.lastServicedDate.toString())),
            DataCell(Text(watch.serviceInterval.toString())),
            DataCell(Text(watch.nextServiceDue.toString())),
            //Wearlist and filteredWearList are ignored - these are easily reviewed via the calendar views in the app
            DataCell(Text(watch.frontImagePath.toString())),
            DataCell(Text(watch.referenceNumber.toString())),
            DataCell(Text(watch.backImagePath.toString())),
            DataCell(Text(watch.movement.toString())),
            DataCell(Text(watch.category.toString())),
            DataCell(Text(watch.purchasedFrom.toString())),
            DataCell(Text(watch.soldTo.toString())),
            DataCell(Text(watch.purchasePrice.toString())),
            DataCell(Text(watch.soldPrice.toString())),
            DataCell(Text(watch.soldDate.toString())),
            DataCell(Text(watch.deliveryDate.toString())),
            DataCell(Text(watch.warrantyEndDate.toString())),
            DataCell(Text(watch.caseDiameter.toString())),
            DataCell(Text(watch.lugWidth.toString())),
            DataCell(Text(watch.lug2lug.toString())),
            DataCell(Text(watch.caseThickness.toString())),
            DataCell(Text(watch.waterResistance.toString())),
            DataCell(Text(watch.caseMaterial.toString())),
            DataCell(Text(watch.winderTPD.toString())),
            DataCell(Text(watch.winderDirection.toString())),
            DataCell(Text(watch.dateComplication.toString())),
            DataCell(Text(watch.lumeImagePath.toString())),
            DataCell(Text(watch.primaryImageIndex.toString())),
            DataCell(Text(watch.notes.toString())),



          ]));

    }
    return rows;
  }
}
