import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/errors/error_handling.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
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

}