import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/sync/sync_service.dart';

class SyncManager {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static StreamSubscription<AuthState>? _authSubscription;
  static RealtimeChannel? _realtimeChannel;
  static Timer? _debounceTimer;

  /// Initialize the sync manager to listen to auth state changes and realtime events
  static void init() {
    // Check initial state on app boot
    final session = _supabase.auth.currentSession;
    if (session != null) {
      _startSyncAndRealtime(session.user.id);
    }

    // Listen to auth state changes (login / logout)
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        debugPrint('SyncManager: User logged in (${session.user.id}). Starting sync & realtime.');
        _startSyncAndRealtime(session.user.id);
      } else {
        debugPrint('SyncManager: User logged out. Stopping sync & realtime.');
        _stopSyncAndRealtime();
      }
    });
  }

  /// Start initial sync and subscribe to Supabase Realtime
  static void _startSyncAndRealtime(String userId) async {
    // 1. Run immediate sync in the background (non-blocking)
    unawaited(SyncService.syncData());

    // 2. Setup Supabase Realtime listener for cross-device updates
    await _realtimeChannel?.unsubscribe();
    
    _realtimeChannel = _supabase.channel('public:watches');
    
    _realtimeChannel!.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'watches',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: userId,
      ),
      callback: (payload) {
        debugPrint('SyncManager: Realtime change detected from another device. Debouncing sync...');
        // Debounce rapid successive events to prevent network spam & jank
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 2), () {
          unawaited(SyncService.syncData());
        });
      },
    );

    _realtimeChannel!.subscribe((status, error) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        debugPrint('SyncManager: Successfully subscribed to Supabase Realtime watches changes.');
      } else if (error != null) {
        debugPrint('SyncManager: Realtime subscription error: $error');
      }
    });
  }

  /// Stop sync and remove realtime subscription on logout
  static void _stopSyncAndRealtime() async {
    _debounceTimer?.cancel();
    if (_realtimeChannel != null) {
      await _supabase.removeChannel(_realtimeChannel!);
      _realtimeChannel = null;
      debugPrint('SyncManager: Unsubscribed from Supabase Realtime.');
    }
  }

  /// Dispose listeners when app closes
  static void dispose() {
    _authSubscription?.cancel();
    _stopSyncAndRealtime();
  }
}
