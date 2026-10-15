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

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
    }
  }
}