import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/api/keys.dart';
import 'package:wristcheck/api/purchase_api.dart';
import 'package:wristcheck/errors/error_handling.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with Google
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      
      // Initialize with client IDs
      await googleSignIn.initialize(
        clientId: WristCheckKeys.googleIosClientId, 
        serverClientId: WristCheckKeys.googleWebClientId,
      );

      final googleAccount = await googleSignIn.authenticate();

      final googleAuth = googleAccount.authentication;
      final idToken = googleAuth.idToken;
      
      final googleAuthorization = await googleAccount.authorizationClient.authorizationForScopes([]);
      final accessToken = googleAuthorization?.accessToken;

      if (idToken == null || accessToken == null) {
        throw 'Missing authentication tokens.';
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        await PurchaseApi.logIn(response.user!.id);
      }
      return response;
      
    } catch (e) {
      if (e is AuthException) {
        WristCheckErrorHandling.showError(e.message);
      } else {
        WristCheckErrorHandling.showError(e.toString());
      }
      return null;
    }
  }

  // Sign in with email and password
  Future<AuthResponse?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await PurchaseApi.logIn(response.user!.id);
      }
      return response;
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
      return null;
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
      return null;
    }
  }

  // Sign up with email and password
  Future<AuthResponse?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
      return null;
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
      return null;
    }
  }

  //Verify OTP
  Future<AuthResponse?> verifyOTP(String email, String token) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );
      if (response.user != null) {
        await PurchaseApi.logIn(response.user!.id);
      }
      return response;
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
      return null;
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
      return null;
    }
  }

  //Resend OTP
  Future<void> resendOTP(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
    }
  }  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
    }
  }

  // Get user email
  String? getUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // Update Password
  Future<UserResponse?> updatePassword(String oldPassword, String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          password: newPassword,
          currentPassword: oldPassword,
        ),
      );
      return response;
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
      return null;
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
      return null;
    }
  }

  // Request Password Reset
  Future<void> requestPasswordReset(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
    }
  }

  // Verify Recovery OTP and Set New Password
  Future<bool> verifyRecoveryOtpAndSetPassword(String email, String token, String newPassword) async {
    try {
      // 1. Verify the recovery OTP, which logs the user in if successful
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );

      if (response.user != null) {
        await PurchaseApi.logIn(response.user!.id);
        
        // 2. Immediately update the password now that they have an active session
        await _supabase.auth.updateUser(
          UserAttributes(
            password: newPassword,
          ),
        );
        return true;
      }
      return false;
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
      return false;
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
      return false;
    }
  }

}