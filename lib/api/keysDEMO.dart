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
}
