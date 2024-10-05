import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';

class WatchStatusHeader extends StatelessWidget {
  WatchStatusHeader({super.key,
  required this.currentWatch,
  });

  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;

  final List<String> _statusList = ["In Collection", "Sold", "Wishlist", "Pre-Order", "Archived"];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _buildStatusDropdownRow()
        ),
        watchViewController.watchViewState.value == WatchViewEnum.add
            ? const SizedBox(height: 0,)
            : _buildFavouriteRow(
            currentWatch!),
      ],
    );
  }

  Widget _buildStatusDropdownRow(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      child: Obx(()=> Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (watchViewController.inEditState.value == false) && (watchViewController.watchViewState.value == WatchViewEnum.view)? Text(currentWatch!.status.toString()):
            Obx(()=> DropdownButton(
                dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
                value: watchViewController.selectedStatus.value,
                items: _statusList
                    .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status))

                ).toList(),
                onChanged: (status) {
                  watchViewController.updateSelectedStatus(status.toString());
                  if(watchViewController.selectedStatus.value == "Sold" && WristCheckPreferences.getShowSoldDialog()){
                    WristCheckDialogs.getSoldStatusPopup();
                  }
                  if(watchViewController.selectedStatus.value == "Pre-Order" && WristCheckPreferences.getShowPreOrderDialog()){
                    WristCheckDialogs.getPreOrderStatusPopUp();
                  }
                }
            ),
            )


          ]
      ),
      ),
    );
  }

  //Favourite selector toggle - ONLY SHOW FOR VIEW/EDIT! //TODO: Implement for add state
  Widget _buildFavouriteRow(Watches watch){
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("Favourite:"),

          Obx(()=> Switch(
              value: watchViewController.favourite.value,
              onChanged: (value){
                watch.favourite = value;
                watch.save();
                watchViewController.updateFavourite(watch.favourite);
              }),
          ),
        ]

    );
  }

}
