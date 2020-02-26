import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

/// Peer5 operates as a service that orchestrates peers and provides analytics
/// and control. The service is activated using our Javascript API in the
/// browser. The client side consists of custom WebRTC p2p logic, an HTTP client
/// and a delivery manager that optimizes speed using the two methods
/// (P2P and HTTP).
///
/// The client connects to multiple peers and to the HTTP server simultaneously
/// and ensures chunks are received in time for playback.
class Peer5 {
  static const MethodChannel _channel = MethodChannel('dev.ianko/peer5');

  /// Check if the `init` method has already been called.
  static bool get initialized => _initialized;
  static bool _initialized = false;

  /// `iOS` Only. Initialize the Peer5 local server.
  static Future<void> init() async {
    if (Platform.isAndroid) {
      _initialized = true;
      return;
    }

    if (initialized) {
      throw 'Peer5 already initialized';
    }

    _initialized = true;

    return _channel.invokeMethod('init');
  }

  /// Get a proxied `url` through Peer5 in exchange for the `originalUrl`.
  /// You will use this `url` to your player.
  static Future<String> getStreamUrl(String originalUrl) async {
    if (Platform.isIOS && !initialized) {
      throw 'Peer5 needs to be initialized first.';
    }

    return _channel.invokeMethod('streamUrl', <String, dynamic>{
      'url': originalUrl,
    });
  }
}
