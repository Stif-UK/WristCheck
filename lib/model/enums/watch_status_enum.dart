import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

enum WatchStatusEnum {
  inCollection,
  sold,
  wishlist,
  preOrder,
  retired,
  archived
}

extension WatchStatusEnumExtension on WatchStatusEnum {
  String toLocalizedString(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    switch (this) {
      case WatchStatusEnum.inCollection:
        return localizations.statusInCollection;
      case WatchStatusEnum.sold:
        return localizations.statusSold;
      case WatchStatusEnum.wishlist:
        return localizations.statusWishlist;
      case WatchStatusEnum.preOrder:
        return localizations.statusPreOrder;
      case WatchStatusEnum.retired:
        return localizations.statusRetired;
      case WatchStatusEnum.archived:
        return localizations.statusArchived;
    }
  }

  String toDbString() {
    switch (this) {
      case WatchStatusEnum.inCollection:
        return "In Collection";
      case WatchStatusEnum.sold:
        return "Sold";
      case WatchStatusEnum.wishlist:
        return "Wishlist";
      case WatchStatusEnum.preOrder:
        return "Pre-Order";
      case WatchStatusEnum.retired:
        return "Retired";
      case WatchStatusEnum.archived:
        return "Archived";
    }
  }

  static WatchStatusEnum fromDbString(String? status) {
    switch (status) {
      case "In Collection":
        return WatchStatusEnum.inCollection;
      case "Sold":
        return WatchStatusEnum.sold;
      case "Wishlist":
        return WatchStatusEnum.wishlist;
      case "Pre-Order":
        return WatchStatusEnum.preOrder;
      case "Retired":
        return WatchStatusEnum.retired;
      case "Archived":
        return WatchStatusEnum.archived;
      default:
        return WatchStatusEnum.inCollection;
    }
  }
}
