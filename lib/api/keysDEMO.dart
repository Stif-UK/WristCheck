import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class WristCheckKeys {
  static String getRevenueCatKey() {
    return Platform.isAndroid ? "" : "";
  }

  // Supabase Dev Keys
  static const String _supabaseDevUrl = "https://your-dev-project-id.supabase.co";
  static const String _supabaseDevAnonKey = "your_dev_anon_key";

  // Supabase Prod Keys
  static const String _supabaseProdUrl = "https://your-prod-project-id.supabase.co";
  static const String _supabaseProdAnonKey = "your_prod_anon_key";

  static String getSupabaseUrl() {
    return kReleaseMode ? _supabaseProdUrl : _supabaseDevUrl;
  }

  static String getSupabaseAnonKey() {
    return kReleaseMode ? _supabaseProdAnonKey : _supabaseDevAnonKey;
  }

  // Google Sign-In Client IDs
  static const String googleWebClientId = "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com";
  static const String googleIosClientId = "YOUR_IOS_CLIENT_ID.apps.googleusercontent.com";
}
