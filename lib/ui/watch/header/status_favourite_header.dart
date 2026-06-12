import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/decoration/formfield_decoration.dart';

import 'package:wristcheck/model/enums/watch_status_enum.dart';

class WatchStatusHeader extends StatelessWidget {
  WatchStatusHeader({super.key,
  required this.currentWatch,
  });

  final watchViewController = Get.put(WatchViewController());
  final Watches? currentWatch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _buildStatusDropdownRow(context)
        ),
        watchViewController.watchViewState.value == WatchViewEnum.add
            ? const SizedBox(height: 0,)
            : _buildFavouriteRow(
            currentWatch!),
      ],
    );
  }

  Widget _buildStatusDropdownRow(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      child: Obx(()=> Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (watchViewController.inEditState.value == false) && (watchViewController.watchViewState.value == WatchViewEnum.view)? Text(WatchStatusEnumExtension.fromDbString(currentWatch!.status).toLocalizedString(context), style: Theme.of(context).textTheme.bodyLarge,):
            Obx(()=> DropdownButton(
                dropdownColor: WristCheckFormFieldDecoration.getDropDownBackground(),
                value: watchViewController.selectedStatus.value,
                items: WatchStatusEnum.values
                    .map((status) => DropdownMenuItem(
                    value: status.toDbString(),
                    child: Text(status.toLocalizedString(context), style: Theme.of(context).textTheme.bodyLarge,))

                ).toList(),
                onChanged: (status) {
                  watchViewController.updateSelectedStatus(status.toString());
                  if(watchViewController.selectedStatus.value == WatchStatusEnum.sold.toDbString() && WristCheckPreferences.getShowSoldDialog()){
                    WristCheckDialogs.getSoldStatusPopup();
                  }
                  if(watchViewController.selectedStatus.value == WatchStatusEnum.preOrder.toDbString() && WristCheckPreferences.getShowPreOrderDialog()){
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

  //Favourite selector toggle - ONLY SHOW FOR VIEW/EDIT!
  // TODO: Implement for add state?
  // TODO: Only allow 'In Collection' watches as favourites?
  Widget _buildFavouriteRow(Watches watch){
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(AppLocalizations.of(Get.context!)!.favouriteLabel),

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
