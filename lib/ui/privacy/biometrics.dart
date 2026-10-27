import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class Biometrics extends StatefulWidget {
  const Biometrics({super.key});

  @override
  State<Biometrics> createState() => _BiometricsState();
}

class _BiometricsState extends State<Biometrics> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isBiometricsEnabled = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isBiometricsEnabled = WristCheckPreferences.getEnableBiometrics();
    analytics.logEvent(name: "biometrics_screen_viewed");
  }

  Future<void> _toggleBiometrics(bool value) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    await analytics.logEvent(
      name: "biometrics_toggle_pressed",
      parameters: {"target_state": value ? "enable" : "disable"},
    );

    try {
      if (value) {
        // User wants to enable biometrics
        final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
        final bool canAuthenticate =
            canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

        if (!canAuthenticate) {
          await analytics.logEvent(name: "biometrics_not_supported");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Biometric authentication is not available or set up on this device."),
              ),
            );
          }
          setState(() {
            _isProcessing = false;
          });
          return;
        }

        final bool authenticated = await _auth.authenticate(
          localizedReason: 'Please authenticate to enable biometric lock',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false,
          ),
        );

        if (authenticated) {
          await WristCheckPreferences.setEnableBiometrics(true);
          await analytics.logEvent(name: "biometrics_enable_success");
          if (mounted) {
            setState(() {
              _isBiometricsEnabled = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Biometric lock enabled")),
            );
          }
        } else {
          await analytics.logEvent(name: "biometrics_enable_cancelled");
        }
      } else {
        // User wants to disable biometrics - authenticate first to verify identity
        final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
        final bool canAuthenticate =
            canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

        bool authenticated = true;
        if (canAuthenticate) {
          authenticated = await _auth.authenticate(
            localizedReason: 'Please authenticate to disable biometric lock',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: false,
            ),
          );
        }

        if (authenticated) {
          await WristCheckPreferences.setEnableBiometrics(false);
          await analytics.logEvent(name: "biometrics_disable_success");
          if (mounted) {
            setState(() {
              _isBiometricsEnabled = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Biometric lock disabled")),
            );
          }
        } else {
          await analytics.logEvent(name: "biometrics_disable_cancelled");
        }
      }
    } on PlatformException catch (e) {
      debugPrint("Biometric settings error: $e");
      await analytics.logEvent(
        name: "biometrics_error",
        parameters: {"error_code": e.code, "error_message": e.message ?? ""},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Biometric authentication error: ${e.message}")),
        );
      }
    } catch (e) {
      debugPrint("Unexpected error: $e");
      await analytics.logEvent(
        name: "biometrics_unexpected_error",
        parameters: {"error": e.toString()},
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometrics"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              FaIcon(
                FontAwesomeIcons.fingerprint,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Want to keep your collection private? Enable biometrics to use your face or fingerprint to unlock the app.\n\n"
                  "You'll then be asked to authenticate every time you open the app.",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                value: _isBiometricsEnabled,
                title: const Text("Enable Biometrics"),
                subtitle: Text(
                  _isBiometricsEnabled ? "App is currently locked with biometrics" : "App lock is currently turned off",
                ),
                onChanged: _isProcessing ? null : (value) => _toggleBiometrics(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
