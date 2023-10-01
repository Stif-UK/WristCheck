import 'package:flutter/material.dart';
import 'package:wristcheck/model/enums/collection_view.dart';


class DynamicCopyHelper{
  static Widget getEmptyBoxCopy(CollectionView view, BuildContext context){
    String returnText = "";

    switch(view){
      case CollectionView.all:
        returnText = "Your watch-box is currently empty.\n\nPress the red button to add watches to your collection\n\nSet app preferences, such as preferred currency format, by pressing the cog icon in the top right";
        break;
      case CollectionView.sold:
        returnText = "You don't have any sold watches in your collection.\n\nYou can mark a watch as sold by editing it's status.\n";
        break;
      case CollectionView.wishlist:
        returnText = "You aren't tracking any watches in your wishlist.\n\nTo add a watch to your wishlist, create a new watch record and set it's status to 'Wishlist'.\n";
        break;
      case CollectionView.favourites:
        returnText = "You don't have any watches marked as 'favourite' yet. \n\nTo mark a watch as a favourite adjust the toggle on the watch detail screen.\n";
        break;
      default:
        returnText = "Your watch-box is currently empty.\n\nPress the red button to add watches to your collection\n";
        break;
    }

    return Text(returnText, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge,);
  }
}