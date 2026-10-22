import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/sync/sync_service.dart';

class SyncManager {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static StreamSubscription<AuthState>? _authSubscription;
  static RealtimeChannel? _realtimeChannel;
  static Timer? _debounceTimer;
  static String? _currentSyncedUserId;

  /// Initialize the sync manager to listen to auth state changes and realtime events
  static void init() {
    // Supabase onAuthStateChange automatically emits the initial session upon listening,
    // so we handle both startup session and subsequent sign-in/sign-out events here.
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final userId = session?.user.id;

      if (userId != null) {
        if (_currentSyncedUserId != userId) {
          _currentSyncedUserId = userId;
          debugPrint('SyncManager: User session active ($userId). Starting conflict check & realtime.');
          _startSyncAndRealtime(userId);
        } else {
          debugPrint('SyncManager: Session already active for user $userId. Skipping duplicate sync trigger.');
        }
      } else {
        if (_currentSyncedUserId != null) {
          _currentSyncedUserId = null;
          debugPrint('SyncManager: User logged out. Stopping sync & realtime.');
          _stopSyncAndRealtime();
        }
      }
    });
  }

  /// Start initial conflict check and subscribe to Supabase Realtime
  static void _startSyncAndRealtime(String userId) async {
    // 1. Check for potential duplicate conflicts on sign-in before regular sync
    unawaited(SyncService.checkForConflictsAndSync());

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
        // Ignore self-triggered echoes from our own sync pushes/writes
        if (SyncService.lastLocalWriteTime != null &&
            DateTime.now().difference(SyncService.lastLocalWriteTime!) < const Duration(seconds: 5)) {
          debugPrint('SyncManager: Ignoring self-triggered Realtime event.');
          return;
        }

        debugPrint('SyncManager: Realtime change detected from another device. Debouncing sync...');
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
