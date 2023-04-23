import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/errors.dart';
import 'dart:io' show Platform;

class WristCheckErrorHandling{

  static surfacePlatformError(PlatformException e){
    Get.defaultDialog(
        title: "An Error Occurred",
        middleText: "Code: ${e.code}\n\n"
            "Message: ${e.details}",
        textConfirm: "Dismiss"
    );
  }

  static handlePurchaseError(PlatformException e){
    var errorCode = PurchasesErrorHelper.getErrorCode(e);
    if(errorCode != PurchasesErrorCode.purchaseCancelledError){

      String errorTitle = "";
      String errorText = "";

      switch (errorCode) {
        case PurchasesErrorCode.networkError:
          errorTitle = "Network Error";
          errorText = "A network error occurred, please try again";
          break;
        case PurchasesErrorCode.unknownError:
          errorTitle = "Unknown Error";
          errorText = "An unknown error occurred, please try again";
          break;
        case PurchasesErrorCode.storeProblemError:
          errorTitle = "Store Problem Error";
          errorText = "There was an issue communicating with the store. Please confirm the transaction has not completed before trying again";
          break;
        case PurchasesErrorCode.purchaseNotAllowedError:
          errorTitle = "Purchase Note Allowed Error";
          errorText = "This device or user may not be allowed to make purchases";
          break;
        case PurchasesErrorCode.purchaseInvalidError:
          errorTitle = "Purchase Invalid Error";
          errorText = "This error could indicate that the payment method is invalid, or that the developer made a mistake!\n\n"
              "Please check payment method details and contact the developer if this continues.";
          break;
        case PurchasesErrorCode.productNotAvailableForPurchaseError:
          errorTitle = "Product Not Available Error";
          errorText = "This could indicate incorrect store configuration. If this continues please contact the developer";
          break;
        case PurchasesErrorCode.productAlreadyPurchasedError:
          errorTitle = "Product Already Purchased Error";
          errorText = "You really shouldn't get this error! Please let the developer know.";
          break;
        case PurchasesErrorCode.invalidCredentialsError:
          errorTitle = "Invalid Credentials";
          errorText = "This indicates the application may have been configured incorrectly by the developer - please report to the app developer for resolution.";
          break;
        case PurchasesErrorCode.unexpectedBackendResponseError:
          errorTitle = "Unexpected Backend Response";
          errorText = "An unexpected response was received from the server. Please try again later";
          break;
        case PurchasesErrorCode.operationAlreadyInProgressError:
          errorTitle = "Operation Already in Progress";
          errorText = "Please allow the initial request to complete before trying again.";
          break;
        case PurchasesErrorCode.unknownBackendError:
          errorTitle = "Unknown Backend Error";
          errorText = "The server returned an unknown error";
          break;
        case PurchasesErrorCode.ineligibleError:
          errorTitle = "Ineligible Error";
          errorText = "It appears you are not eligible for the selected offer.";
          break;
        case PurchasesErrorCode.insufficientPermissionsError:
          errorTitle = "Insufficient Permissions";
          errorText = "This device does not have sufficient permissions to make in-app purchases.";
          break;
        case PurchasesErrorCode.paymentPendingError:
          errorTitle = "Additional action required";
          errorText = Platform.isAndroid? "Please follow instructions from Google to continue. \nConfirm no payment has been taken before trying again, this can be caused by slow payment processing.":"Please follow instructions from Apple to continue.\nConfirm no payment has been taken before trying again, this can be caused by slow payment processing.";
          break;
        case PurchasesErrorCode.configurationError:
          errorTitle = "Configuration Error";
          errorText = "Please contact the developer. The app may not be correctly configured.";
          break;
        case PurchasesErrorCode.productRequestTimeout:
          errorTitle = "Product Request Timeout";
          errorText = "A timeout occurred when requesting the product. Please try again later";
          break;
        case PurchasesErrorCode.invalidPromotionalOfferError:
          errorTitle = "Invalid Promotion Error";
          errorText = "An invalid promotion was returned, please try again";
          break;
        case PurchasesErrorCode.offlineConnectionError:
          errorTitle = "Offline Connection Error";
          errorText = "Please check your connection and try again";
          break;
        default:
          errorTitle = "Error: ${errorCode.name}";
          errorText = "An unhandled error occurred, please contact the developer if this continues";
          break;

      }
      Get.defaultDialog(
          title: "Something's gone wrong",
          middleText: "$errorTitle\n\n"
              "$errorText\n\n"

      );
    }
  }

}