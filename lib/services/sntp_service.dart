import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// A pure-Dart SNTP (Simple Network Time Protocol) client service.
/// Provides NTP time synchronization without external or native dependencies.
class SntpService {
  static const List<String> defaultNtpServers = [
    'pool.ntp.org',
    'time.google.com',
    'time.apple.com',
    'time.cloudflare.com',
  ];

  static const int ntpPort = 123;
  static const int ntpPacketSize = 48;
  static const int ntpEpochOffsetSeconds = 2208988800; // Seconds between 1900 and 1970

  static bool _isSynced = false;
  static Duration _offset = Duration.zero;
  static DateTime? _lastSyncTime;
  static DateTime? _anchorNtpTime;
  static final Stopwatch _stopwatch = Stopwatch();

  /// Returns true if time has been successfully synchronized with an NTP server.
  static bool get isSynced => _isSynced;

  /// Returns the computed clock offset duration between network time and system time.
  static Duration get offset => _offset;

  /// Returns the timestamp when the last successful sync occurred.
  static DateTime? get lastSyncTime => _lastSyncTime;

  /// Returns the current synchronized NTP DateTime, anchored to monotonic time.
  /// If not yet synced, attempts a quick sync. If sync fails or device is offline,
  /// falls back to local system [DateTime.now()].
  static Future<DateTime?> get getNtpDateTime async {
    if (_isSynced && _anchorNtpTime != null) {
      return _anchorNtpTime!.add(_stopwatch.elapsed);
    }

    final success = await sync();
    if (success && _anchorNtpTime != null) {
      return _anchorNtpTime!.add(_stopwatch.elapsed);
    }

    return DateTime.now();
  }

  /// Synchronous property to get NTP time if synced, or system time if not.
  static DateTime get now {
    if (_isSynced && _anchorNtpTime != null) {
      return _anchorNtpTime!.add(_stopwatch.elapsed);
    }
    return DateTime.now();
  }

  /// Synchronizes time with NTP servers.
  /// Tries servers in [hosts] sequentially until a valid response is received.
  static Future<bool> sync({
    List<String> hosts = defaultNtpServers,
    Duration timeout = const Duration(seconds: 4),
  }) async {
    for (final host in hosts) {
      try {
        final result = await _queryServer(host, timeout: timeout);
        if (result != null) {
          _offset = result.offset;
          _anchorNtpTime = result.ntpTime;
          _lastSyncTime = DateTime.now();
          _stopwatch
            ..reset()
            ..start();
          _isSynced = true;
          if (kDebugMode) {
            print('[SNTP] Synced with $host. Offset: ${_offset.inMilliseconds}ms');
          }
          return true;
        }
      } catch (e) {
        if (kDebugMode) {
          print('[SNTP] Failed sync with $host: $e');
        }
      }
    }
    return _isSynced;
  }

  /// Resets the sync status and stored offset.
  static void reset() {
    _isSynced = false;
    _offset = Duration.zero;
    _lastSyncTime = null;
    _anchorNtpTime = null;
    _stopwatch.stop();
    _stopwatch.reset();
  }

  static Future<_SntpQueryResult?> _queryServer(
    String host, {
    required Duration timeout,
  }) async {
    RawDatagramSocket? socket;
    try {
      final addresses = await InternetAddress.lookup(host).timeout(timeout);
      if (addresses.isEmpty) return null;

      final address = addresses.first;
      socket = await RawDatagramSocket.bind(
        address.type == InternetAddressType.IPv6
            ? InternetAddress.anyIPv6
            : InternetAddress.anyIPv4,
        0,
      ).timeout(timeout);

      final buffer = Uint8List(ntpPacketSize);
      // Mode 3 (Client), Version 3, Leap Indicator 0 -> 0x1B
      buffer[0] = 0x1B;

      final t1 = DateTime.now().toUtc();
      _writeNtpTimestamp(buffer, 40, t1); // Transmit timestamp in client packet

      socket.send(buffer, address, ntpPort);

      final completer = Completer<_SntpQueryResult?>();

      socket.listen(
        (RawSocketEvent event) {
          if (event == RawSocketEvent.read) {
            final datagram = socket?.receive();
            final t4 = DateTime.now().toUtc();
            if (datagram != null && datagram.data.length >= ntpPacketSize) {
              final res = _parseNtpResponse(datagram.data, t1, t4);
              if (!completer.isCompleted) {
                completer.complete(res);
              }
            }
          }
        },
        onError: (e) {
          if (!completer.isCompleted) completer.complete(null);
        },
        onDone: () {
          if (!completer.isCompleted) completer.complete(null);
        },
      );

      return await completer.future.timeout(
        timeout,
        onTimeout: () => null,
      );
    } catch (_) {
      return null;
    } finally {
      socket?.close();
    }
  }

  static void _writeNtpTimestamp(Uint8List buffer, int offset, DateTime dateTime) {
    final seconds = (dateTime.millisecondsSinceEpoch ~/ 1000) + ntpEpochOffsetSeconds;
    final fraction = ((dateTime.millisecondsSinceEpoch % 1000) * 4294967296) ~/ 1000;

    final bd = ByteData.view(buffer.buffer, offset, 8);
    bd.setUint32(0, seconds, Endian.big);
    bd.setUint32(4, fraction, Endian.big);
  }

  static _SntpQueryResult? _parseNtpResponse(
    Uint8List data,
    DateTime t1,
    DateTime t4,
  ) {
    final bd = ByteData.view(data.buffer, data.offsetInBytes, data.lengthInBytes);

    // Mode check (bits 0-2 of byte 0: 4 = Server, 5 = Broadcast)
    final mode = data[0] & 0x07;
    if (mode != 4 && mode != 5) return null;

    final t2 = _readNtpTimestamp(bd, 32); // Receive timestamp on server
    final t3 = _readNtpTimestamp(bd, 40); // Transmit timestamp on server

    if (t2 == null || t3 == null) return null;

    final t1Ms = t1.millisecondsSinceEpoch;
    final t2Ms = t2.millisecondsSinceEpoch;
    final t3Ms = t3.millisecondsSinceEpoch;
    final t4Ms = t4.millisecondsSinceEpoch;

    // Offset = ((t2 - t1) + (t3 - t4)) / 2
    final offsetMs = ((t2Ms - t1Ms) + (t3Ms - t4Ms)) ~/ 2;
    // Delay = (t4 - t1) - (t3 - t2)
    final delayMs = (t4Ms - t1Ms) - (t3Ms - t2Ms);

    // Discard suspiciously high delays (> 3000ms)
    if (delayMs > 3000) return null;

    final ntpTime = DateTime.fromMillisecondsSinceEpoch(t4Ms + offsetMs, isUtc: true).toLocal();

    return _SntpQueryResult(
      offset: Duration(milliseconds: offsetMs),
      delay: Duration(milliseconds: delayMs),
      ntpTime: ntpTime,
    );
  }

  static DateTime? _readNtpTimestamp(ByteData bd, int offset) {
    final seconds = bd.getUint32(offset, Endian.big);
    final fraction = bd.getUint32(offset + 4, Endian.big);

    if (seconds == 0) return null;

    final unixSeconds = seconds - ntpEpochOffsetSeconds;
    final millisFromFraction = (fraction * 1000) ~/ 4294967296;
    final totalMillis = (unixSeconds * 1000) + millisFromFraction;

    return DateTime.fromMillisecondsSinceEpoch(totalMillis, isUtc: true);
  }
}

class _SntpQueryResult {
  final Duration offset;
  final Duration delay;
  final DateTime ntpTime;

  _SntpQueryResult({
    required this.offset,
    required this.delay,
    required this.ntpTime,
  });
}
