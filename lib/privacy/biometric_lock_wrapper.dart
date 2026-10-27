import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';

class BiometricLockWrapper extends StatefulWidget {
  final Widget child;

  const BiometricLockWrapper({super.key, required this.child});

  static bool _isLockPaused = false;

  static void pauseLock() {
    _isLockPaused = true;
  }

  static void resumeLock() {
    _isLockPaused = false;
  }

  static Future<T> suppressLockDuring<T>(Future<T> Function() action) async {
    pauseLock();
    try {
      return await action();
    } finally {
      // Delay resuming lock briefly so the resuming lifecycle event passes without locking
      Future.delayed(const Duration(milliseconds: 600), () {
        resumeLock();
      });
    }
  }

  @override
  State<BiometricLockWrapper> createState() => _BiometricLockWrapperState();
}

class _BiometricLockWrapperState extends State<BiometricLockWrapper>
    with WidgetsBindingObserver {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isLocked = false;
  bool _isAuthenticating = false;
  DateTime? _pausedAt;
  static const Duration _gracePeriod = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialLockState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkInitialLockState() async {
    final bool isBiometricsEnabled = WristCheckPreferences.getEnableBiometrics();
    if (isBiometricsEnabled) {
      setState(() {
        _isLocked = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _authenticate();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isAuthenticating) return;
    if (BackupRestoreMethods.isPickingFile || BiometricLockWrapper._isLockPaused) {
      if (state == AppLifecycleState.resumed && _isLocked) {
        setState(() {
          _isLocked = false;
        });
      }
      return;
    }

    final bool isBiometricsEnabled = WristCheckPreferences.getEnableBiometrics();
    if (!isBiometricsEnabled) {
      if (_isLocked) {
        setState(() {
          _isLocked = false;
        });
      }
      return;
    }

    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _pausedAt = DateTime.now();
      setState(() {
        _isLocked = true;
      });
    } else if (state == AppLifecycleState.resumed && _isLocked) {
      if (_pausedAt != null && DateTime.now().difference(_pausedAt!) < _gracePeriod) {
        setState(() {
          _isLocked = false;
        });
        return;
      }
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        if (mounted) {
          setState(() {
            _isLocked = false;
            _isAuthenticating = false;
          });
        }
        return;
      }

      final reason = Get.context != null && AppLocalizations.of(Get.context!) != null
          ? AppLocalizations.of(Get.context!)!.biometricsAuthReasonAccess
          : 'Please authenticate to access WristTrack';

      final bool authenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        await _analytics.logEvent(name: "biometrics_unlock_success");
      } else {
        await _analytics.logEvent(name: "biometrics_unlock_failed");
      }

      if (mounted) {
        setState(() {
          _isLocked = !authenticated;
          _isAuthenticating = false;
        });
      }
    } on PlatformException catch (e) {
      debugPrint("Biometric auth error: $e");
      await _analytics.logEvent(
        name: "biometrics_unlock_error",
        parameters: {"error_code": e.code, "error_message": e.message ?? ""},
      );
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      debugPrint("Unexpected biometric auth error: $e");
      await _analytics.logEvent(
        name: "biometrics_unlock_unexpected_error",
        parameters: {"error": e.toString()},
      );
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isLocked)
          Positioned.fill(
            child: BiometricLockScreen(
              onUnlockPressed: _authenticate,
              isAuthenticating: _isAuthenticating,
            ),
          ),
      ],
    );
  }
}

class BiometricLockScreen extends StatelessWidget {
  final VoidCallback onUnlockPressed;
  final bool isAuthenticating;

  const BiometricLockScreen({
    super.key,
    required this.onUnlockPressed,
    required this.isAuthenticating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final title = l10n?.appLockedTitle ?? "WristTrack Locked";
    final subtitle = l10n?.appLockedSubtitle ?? "Authentication required to access your watch collection.";
    final buttonText = l10n?.unlockAppButton ?? "Unlock App";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.fingerprint,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                if (isAuthenticating)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onUnlockPressed,
                      icon: const FaIcon(FontAwesomeIcons.fingerprint, size: 20),
                      label: Text(
                        buttonText,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
