import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/api/purchase_api.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/user/login.dart';
import 'package:wristcheck/ui/user/otp_page.dart';
import 'package:wristcheck/ui/user/profile_page.dart';

enum AuthScreenState { login, otp, profile }

/*
The auth gate checks the users sign-in status. If they are not logged in it
shows the login page, otherwise it shows the profile page.
If they are verifying an OTP, it shows the OTP page.
 */
class AuthGate extends StatefulWidget {
  static final ValueNotifier<String?> pendingOtpEmail = ValueNotifier<String?>(null);

  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late StreamSubscription<AuthState> _authStateSubscription;
  AuthScreenState _currentScreen = AuthScreenState.login;
  bool _wasLoggedIn = false;

  @override
  void initState() {
    super.initState();
    
    // Check initial state
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _wasLoggedIn = true;
      _currentScreen = AuthScreenState.profile;
    } else if (WristCheckPreferences.getPendingOtpEmail() != null) {
      _currentScreen = AuthScreenState.otp;
      AuthGate.pendingOtpEmail.value = WristCheckPreferences.getPendingOtpEmail();
    }

    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _wasLoggedIn = true;
        // Clear pending OTP on successful login
        WristCheckPreferences.setPendingOtpEmail(null);
        AuthGate.pendingOtpEmail.value = null;
        
        // Sync RevenueCat whenever a session is established
        PurchaseApi.logIn(session.user.id);
        
        setState(() {
          _currentScreen = AuthScreenState.profile;
        });
      } else {
        if (_wasLoggedIn) {
          _wasLoggedIn = false;
          PurchaseApi.logOut();
        }
        setState(() {
          _currentScreen = AuthGate.pendingOtpEmail.value != null 
              ? AuthScreenState.otp 
              : AuthScreenState.login;
        });
      }
    });

    AuthGate.pendingOtpEmail.addListener(_onPendingEmailChanged);
  }

  void _onPendingEmailChanged() {
    WristCheckPreferences.setPendingOtpEmail(AuthGate.pendingOtpEmail.value);
    
    if (AuthGate.pendingOtpEmail.value != null && Supabase.instance.client.auth.currentSession == null) {
      setState(() {
        _currentScreen = AuthScreenState.otp;
      });
    } else if (AuthGate.pendingOtpEmail.value == null && Supabase.instance.client.auth.currentSession == null) {
      setState(() {
        _currentScreen = AuthScreenState.login;
      });
    }
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    AuthGate.pendingOtpEmail.removeListener(_onPendingEmailChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case AuthScreenState.profile:
        return const ProfilePage();
      case AuthScreenState.otp:
        return OtpPage(
          email: AuthGate.pendingOtpEmail.value!,
          onCancel: () {
            AuthGate.pendingOtpEmail.value = null; // Go back to login
          },
        );
      case AuthScreenState.login:
        return const Login();
    }
  }
}
