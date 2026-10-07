/// Initialisation Helper is a class created to manage admob GDPR consent.
/// It's methods can be called at various points in the app where consent
/// may be required.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InitialisationHelper {
  Future<FormError?> initialise() async {
    final completer = Completer<FormError?>();

    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          try {
            if (await ConsentInformation.instance.isConsentFormAvailable()) {
              await _loadConsentForm();
            } else {
              await _initialise();
            }
          } catch (e) {
            debugPrint('Error during consent check/load: $e');
            try {
              await _initialise();
            } catch (_) {}
          }
          if (!completer.isCompleted) completer.complete(null);
        },
        (error) async {
          debugPrint('Consent info update failed (possibly offline): $error');
          try {
            await _initialise();
          } catch (_) {}
          if (!completer.isCompleted) completer.complete(error);
        },
      );
    } catch (e) {
      debugPrint('Exception in initialise: $e');
      try {
        await _initialise();
      } catch (_) {}
      if (!completer.isCompleted) completer.complete(null);
    }
    return completer.future;
  }

  Future<void> _loadConsentForm() async {
    final completer = Completer<void>();

    try {
      ConsentForm.loadConsentForm(
        (consentForm) async {
          try {
            final status = await ConsentInformation.instance.getConsentStatus();
            if (status == ConsentStatus.required) {
              consentForm.show((formError) async {
                try {
                  await _initialise();
                } catch (_) {}
                if (formError != null) {
                  if (!completer.isCompleted) completer.complete();
                } else {
                  _loadConsentForm().then((_) {
                    if (!completer.isCompleted) completer.complete();
                  }).catchError((_) {
                    if (!completer.isCompleted) completer.complete();
                  });
                }
              });
            } else {
              await _initialise();
              if (!completer.isCompleted) completer.complete();
            }
          } catch (e) {
            try {
              await _initialise();
            } catch (_) {}
            if (!completer.isCompleted) completer.complete();
          }
        },
        (formError) async {
          debugPrint('Consent form load failed (possibly offline): $formError');
          try {
            await _initialise();
          } catch (_) {}
          if (!completer.isCompleted) completer.complete();
        },
      );
    } catch (e) {
      debugPrint('Exception in _loadConsentForm: $e');
      try {
        await _initialise();
      } catch (_) {}
      if (!completer.isCompleted) completer.complete();
    }

    return completer.future;
  }

  Future<bool> changePrivacyPreferences() async {
    final completer = Completer<bool>();

    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          try {
            if (await ConsentInformation.instance.isConsentFormAvailable()) {
              ConsentForm.loadConsentForm(
                (consentForm) {
                  consentForm.show((formError) async {
                    try {
                      await _initialise();
                    } catch (_) {}
                    if (!completer.isCompleted) completer.complete(true);
                  });
                },
                (formError) async {
                  try {
                    await _initialise();
                  } catch (_) {}
                  if (!completer.isCompleted) completer.complete(false);
                },
              );
            } else {
              if (!completer.isCompleted) completer.complete(false);
            }
          } catch (_) {
            if (!completer.isCompleted) completer.complete(false);
          }
        },
        (error) async {
          if (!completer.isCompleted) completer.complete(false);
        },
      );
    } catch (_) {
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future;
  }

  Future<void> _initialise() async {
    try {
      await MobileAds.instance.initialize();
    } catch (_) {}
  }

}
