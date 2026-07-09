/// Initialisation Helper is a class created to manage admob GDPR consent.
/// It's methods can be called at various points in the app where consent
/// may be required.

import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InitialisationHelper {
  Future<FormError?> initialise() async {
    final completer = Completer<FormError?>();

    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await _loadConsentForm();
        } else {
          await _initialise();
        }
        completer.complete();
      },
      (error) {
        completer.complete(error);
      },
    );
    return completer.future;
  }

  Future<void> _loadConsentForm() async {
    final completer = Completer<void>();

    ConsentForm.loadConsentForm(
      (consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((formError) {
            if (formError != null) {
              completer.completeError(formError);
            } else {
              _loadConsentForm().then((_) => completer.complete());
            }
          });
        } else {
          await _initialise();
          completer.complete();
        }
      },
      (formError) {
        completer.completeError(formError);
      },
    );

    return completer.future;
  }

  Future<bool> changePrivacyPreferences() async {
    final completer = Completer<bool>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          ConsentForm.loadConsentForm(
            (consentForm) {
              consentForm.show((formError) async {
                await _initialise();
                completer.complete(true);
              });
            },
            (formError) {
              completer.complete(false);
            },
          );
        } else {
          completer.complete(false);
        }
      },
      (error) {
        completer.complete(false);
      },
    );

    return completer.future;
  }

  Future<void> _initialise() async {
    await MobileAds.instance.initialize();
  }

}