import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/collection_view.dart';


class DynamicCopyHelper{
  static Widget getEmptyBoxCopy(CollectionView view, BuildContext context){
    String returnText = "";
    final l = AppLocalizations.of(context);

    switch(view){
      case CollectionView.all:
        returnText = l!.emptyWatchboxCopy;
        break;
      case CollectionView.sold:
        returnText = l!.emptySoldCopy;
        break;
      case CollectionView.wishlist:
        returnText = l!.emptyWishlistCopy;
        break;
      case CollectionView.favourites:
        returnText = l!.emptyFavouritesCopy;
        break;
      case CollectionView.preorder:
        returnText = l!.emptyPreOrderCopy;
        break;
      default:
        returnText = l!.emptyWatchboxCopy;
        break;
    }

    return Text(returnText, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,);
  }

  static Widget getEmptyServiceText(int index, BuildContext context){
    String returnText = "";
    final l = AppLocalizations.of(context);

    switch(index){
      case 0:
        returnText = l!.emptyServiceText;
        break;
      case 1:
        returnText = l!.emptyWarrantyText;
        break;
      case 2:
        returnText = l!.serviceScheduleHelpText;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(returnText, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,),
    );

  }
}