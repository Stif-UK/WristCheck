import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/api/keys.dart';
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

  // Sign in with Apple
  Future<AuthResponse?> signInWithApple() async {
    try {
      
      if (Platform.isAndroid) {
        // For Android we use Supabase's web OAuth flow which handles the dance automatically
        await _supabase.auth.signInWithOAuth(
          OAuthProvider.apple,
          redirectTo: 'io.supabase.wristcheck://login-callback',
        );
        return null; // returning null here ensures the UI doesn't crash while we wait for the deep link callback
      }
      
      // Native iOS Sign in with Apple
      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw 'Could not find ID Token from generated credential.';
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      // On first sign in with Apple, we can get their name from the credential.
      // Apple only returns the full name exactly ONCE (on the very first sign in).
      final String? givenName = credential.givenName;
      final String? familyName = credential.familyName;
      
      if (givenName != null || familyName != null) {
        // Update user metadata in Supabase
        await _supabase.auth.updateUser(
          UserAttributes(
            data: {
              if (givenName != null) 'first_name': givenName,
              if (familyName != null) 'last_name': familyName,
              'full_name': '${givenName ?? ''} ${familyName ?? ''}'.trim(),
            },
          ),
        );
      }

      return response;

    } catch (e) {
      if (e is AuthException) {
        WristCheckErrorHandling.showError(e.message);
      } else if (e is SignInWithAppleAuthorizationException) {
         // Handle cancellation silently so we don't spam the user with an error
        print("Apple sign-in exception: ${e.message}");
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
  Future<void> resendOTP(String email, {OtpType type = OtpType.signup}) async {
    try {
      await _supabase.auth.resend(
        type: type,
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

  // Get user name
  String? getUsersName() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    
    if (user == null) return null;

    // Check user_metadata first (where Apple explicitly stores names if saved properly)
    final metadataName = user.userMetadata?['full_name'] ?? user.userMetadata?['name'];
    if (metadataName != null && metadataName.toString().trim().isNotEmpty) {
      return metadataName.toString().trim();
    }

    // Fallback: Check identities array for OAuth providers like Google that might supply 'name' or 'full_name'
    if (user.identities != null) {
      for (final identity in user.identities!) {
        final identityData = identity.identityData;
        if (identityData != null) {
          final identityName = identityData['full_name'] ?? identityData['name'];
          if (identityName != null && identityName.toString().trim().isNotEmpty) {
            return identityName.toString().trim();
          }
        }
      }
    }

    return null; // No name found anywhere
  }

  // Has Password
  bool hasPassword() {
    final user = _supabase.auth.currentSession?.user;
    if (user == null) return false;
    return user.identities?.any((identity) => identity.provider == 'email') ?? false;
  }

  // Update Password
  Future<UserResponse?> updatePassword({String? oldPassword, required String newPassword}) async {
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

  // Update User Name
  Future<bool> updateUserName(String newName) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': newName.trim(),
          },
        ),
      );
      return response.user != null;
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
      return false;
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
      return false;
    }
  }

  // Update Email address
  Future<bool> updateEmail(String newEmail) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          email: newEmail.trim(),
        ),
      );
      return response.user != null;
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
      return false;
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
      return false;
    }
  }

  // Verify Email Change OTP
  Future<bool> verifyEmailChangeOtp(String newEmail, String token) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        email: newEmail.trim(),
        token: token,
        type: OtpType.emailChange,
      );
      return response.user != null;
    } on AuthException catch (e) {
      WristCheckErrorHandling.showError(e.message);
      return false;
    } catch (e) {
      WristCheckErrorHandling.showError(e.toString());
      return false;
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