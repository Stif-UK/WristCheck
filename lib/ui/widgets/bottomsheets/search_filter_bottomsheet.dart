import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  SearchFilterBottomSheet({Key? key}) : super(key: key);
  final filterController = Get.find<FilterController>();
  final wristCheckController = Get.find<WristCheckController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.searchOptionsTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Divider(thickness: 2),
          const SizedBox(height: 10),
          Obx(() => SwitchListTile(
                title: Text(AppLocalizations.of(context)!.searchByName),
                value: filterController.searchByWatchName.value,
                onChanged: (val) => filterController.updateSearchByWatchName(val),
              )),
          Obx(() => SwitchListTile(
                title: Text(AppLocalizations.of(context)!.searchByNotesLabel),
                value: filterController.searchByNotes.value,
                onChanged: (val) => filterController.updateSearchByNotes(val),
              )),
          Obx(() => wristCheckController.isAppPro.value
              ? SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.searchByLugWidthLabel),
                  value: filterController.searchByLugWidth.value,
                  onChanged: (val) => filterController.updateSearchByLugWidth(val),
                )
              : const SizedBox(height: 0)),
          const Divider(thickness: 2,),
          Obx(() => SwitchListTile(
            title: Text(AppLocalizations.of(context)!.includeArchivedWatches),
            value: filterController.searchIncludeArchived.value,
            onChanged: (val) => filterController.updateSearchIncludeArchived(val),
          )),
          Obx(() => SwitchListTile(
            title: Text(AppLocalizations.of(context)!.includeSoldWatches),
            value: filterController.searchIncludeSold.value,
            onChanged: (val) => filterController.updateSearchIncludeSold(val),
          )),
          Obx(() => SwitchListTile(
            title: Text(AppLocalizations.of(context)!.includeRetiredWatches),
            value: filterController.searchIncludeRetired.value,
            onChanged: (val) => filterController.updateSearchIncludeRetired(val),
          )),
          Obx(() => SwitchListTile(
            title: Text(AppLocalizations.of(context)!.includeOnLoanWatches),
            value: filterController.searchIncludeOnLoan.value,
            onChanged: (val) => filterController.updateSearchIncludeOnLoan(val),
          )),
          Obx(() => SwitchListTile(
            title: Text(AppLocalizations.of(context)!.includeWishlistedWatches),
            value: filterController.searchIncludeWishlist.value,
            onChanged: (val) => filterController.updateSearchIncludeWishlist(val),
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
