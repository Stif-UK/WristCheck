import 'package:wristcheck/util/general_helper.dart';
import 'package:wristcheck/util/string_extension.dart';

/*
  The WatchDataValidationFacade provides a simple facade to validate the different fields of a watch record.
  It provides a single method for each data field in once place, each of which then call validations against the given input
  and return the result.
 */
class WatchDataValidationFacade{

  static bool validateStatus(var status){
    if(status is !String){
      status = status.toString();
    }
    //TODO: Ensure status list is held in only one place within the app - implement enum based solution
    var statusList = ["In Collection", "Sold", "Wishlist", "Pre-Order", "Retired", "Archived"];
    return statusList.contains(status);
  }

  static bool validateManufacturer(var manufacturer){
    if(manufacturer is !String){
      print("Manufacturer is not a string");
      return false;
    }
    return manufacturer.isAlphaNumericIncCyrillicAndNotEmpty;
  }

  static bool validateModel(var model){
    if(model is !String){
      model = model.toString();
    }
    return model.isAlphaNumericIncCyrillicAndNotEmpty;
  }

  static bool validateSerialNumber(var serialNumber){
    if(serialNumber is !String){
      serialNumber = serialNumber.toString();
    }
    return serialNumber.isAlphaNumericWithSymbolsOrEmpty;
  }

  static bool validateReferenceNumber(var referenceNumber){
    if(referenceNumber is !String){
      referenceNumber = referenceNumber.toString();
    }
    return referenceNumber.isAlphaNumericWithSymbolsOrEmpty;
  }

  static bool validateWarrantyExpiryDate(var warrantyDate){
    if(warrantyDate is !String){
      warrantyDate = warrantyDate.toString();
    }
    return GeneralHelper.isValidDateOrEmpty(warrantyDate);
  }

  static bool validateLastServicedDate(var lastServiced){
    if(lastServiced is !String){
      lastServiced = lastServiced.toString();
    }
    return GeneralHelper.isValidDateOrEmpty(lastServiced);
  }

  static bool validatePurchasedDate(var purchaseDate){
    if(purchaseDate is !String){
      purchaseDate = purchaseDate.toString();
    }
    return GeneralHelper.isValidDateOrEmpty(purchaseDate);
  }

  static bool validateSoldDate(var soldDate){
    if(soldDate is !String){
      soldDate = soldDate.toString();
    }
    return GeneralHelper.isValidDateOrEmpty(soldDate);
  }

  static bool validatePurchasePrice(var purchasePrice){
    if(purchasePrice is !String){
      purchasePrice = purchasePrice.toString();
    }
    return purchasePrice.isWcCurrency;
  }

  static bool validateSoldPrice(var soldPrice){
    if(soldPrice is !String){
      soldPrice = soldPrice.toString();
    }
    return soldPrice.isWcCurrency;
  }

  static bool validatePurchasedFrom(var purchasedFrom){
    if(purchasedFrom is !String){
      purchasedFrom = purchasedFrom.toString();
    }
    return purchasedFrom.isAlphaNumericWithSymbolsOrEmpty;
  }

  static bool validateSoldTo(var soldTo){
    if(soldTo is !String){
      soldTo = soldTo.toString();
    }
    return soldTo.isAlphaNumericWithSymbolsOrEmpty;
  }

  static bool validateCaseDiameter(var caseDiameter){
    if(caseDiameter is !String){
      caseDiameter = caseDiameter.toString();
    }
    return caseDiameter.isDouble;
  }

  static bool validateCaseThickness(var caseThickness){
    if(caseThickness is !String){
      caseThickness = caseThickness.toString();
    }
    return caseThickness.isDouble;
  }

  static bool validateLug2Lug(var lug2lug){
    if(lug2lug is !String){
      lug2lug = lug2lug.toString();
    }
    return lug2lug.isDouble;
  }

  static bool validateLugWidth(var lugWidth){
    if(lugWidth is !String){
      lugWidth = lugWidth.toString();
    }
    return lugWidth.isServiceNumber;
  }

  static bool validateWaterResistance(var waterResistance){
    if(waterResistance is !String){
      waterResistance = waterResistance.toString();
    }
    return waterResistance.isUnboundPositiveInteger;
  }



}