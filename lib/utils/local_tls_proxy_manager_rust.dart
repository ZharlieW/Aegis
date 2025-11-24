import 'dart:async';
import 'package:flutter/services.dart';
import 'package:nostr_rust/src/rust/api/tls_proxy.dart';
import 'logger.dart';
import 'platform_utils.dart';

/// Manages a local TLS termination proxy using Rust implementation
/// This works on all platforms (iOS, macOS, Android, Linux, Windows)
/// Uses tokio-rustls which properly sends the full certificate chain
class LocalTlsProxyManagerRust {
  LocalTlsProxyManagerRust._();

  static final LocalTlsProxyManagerRust instance = LocalTlsProxyManagerRust._();

  static const int _defaultTlsPort = 28443;
  static const String _fullchainAsset = 'assets/certs/fullchain.pem';
  static const String _privateKeyAsset = 'assets/certs/privatekey.pem';
  static const String _domain = 'localrelay.link';

  Future<void>? _startFuture;
  String? _cachedFullchain;
  String? _cachedPrivateKey;
  bool _isRunning = false;
  int _tlsPort = _defaultTlsPort;

  bool get isRunning => _isRunning;
  int get tlsPort => _tlsPort;

  /// Return the relay URL that should be advertised to clients.
  String relayUrlFor(String wsPort) {
    if (_isRunning) {
      // Use domain name for proper certificate validation
      final url = 'wss://$_domain:$_tlsPort';
      return url;
    }
    final url = 'ws://127.0.0.1:$wsPort';
    return url;
  }

  /// Ensure the TLS proxy is started.
  Future<void> ensureStarted({
    required int wsPort,
    int? tlsPort,
  }) {
    AegisLogger.info(
        '🔧 LocalTlsProxyManagerRust.ensureStarted called: platform=${PlatformUtils.platformName}, wsPort=$wsPort');

    if (wsPort <= 0) {
      AegisLogger.warning(
          'Skipping TLS proxy start due to invalid relay port: $wsPort');
      return Future.value();
    }
    if (_isRunning) {
      AegisLogger.info('ℹ️ TLS proxy already running');
      return Future.value();
    }
    if (_startFuture != null) {
      AegisLogger.info('⏳ TLS proxy start already in progress');
      return _startFuture!;
    }

    AegisLogger.info('🚀 Starting TLS proxy (Rust implementation)...');
    final completer = Completer<void>();
    _startFuture = completer.future;

    () async {
      try {
        _tlsPort = tlsPort ?? _defaultTlsPort;
        AegisLogger.info('📦 Loading certificates from assets...');
        final fullchain = await _loadFullchain();
        final privateKey = await _loadPrivateKey();
        AegisLogger.info(
            '✅ Certificates loaded, starting Rust TLS proxy server...');
        
        // Call Rust API (throws exception on error)
        tlsProxyStart(
          tlsPort: _tlsPort,
          wsPort: wsPort,
          fullchainPem: fullchain,
          privateKeyPem: privateKey,
        );
        
        _isRunning = true;
        completer.complete();
        AegisLogger.info(
            '✅ Local TLS proxy (Rust) listening on wss://$_domain:$_tlsPort (→ ws://127.0.0.1:$wsPort)');
      } catch (error, stackTrace) {
        _isRunning = false;
        AegisLogger.error('❌ Failed to start local TLS proxy', error);
        AegisLogger.error('Stack trace', stackTrace);
        completer.completeError(error);
      } finally {
        _startFuture = null;
      }
    }();

    return completer.future;
  }

  /// Stop the TLS proxy if running.
  Future<void> stop() async {
    if (!_isRunning) {
      return;
    }

    try {
      tlsProxyStop();
    } catch (error) {
      AegisLogger.error('❌ Failed to stop local TLS proxy', error);
      rethrow;
    } finally {
      _isRunning = false;
    }
  }

  Future<String> _loadFullchain() async {
    if (_cachedFullchain != null) {
      AegisLogger.info(
          '📦 Using cached fullchain (${_cachedFullchain!.length} bytes)');
      return _cachedFullchain!;
    }
    try {
      AegisLogger.info('📦 Loading fullchain from asset: $_fullchainAsset');
      final byteData = await rootBundle.load(_fullchainAsset);
      _cachedFullchain = String.fromCharCodes(byteData.buffer.asUint8List());
      AegisLogger.info(
          '✅ Fullchain loaded successfully (${_cachedFullchain!.length} bytes)');
      return _cachedFullchain!;
    } catch (e, stackTrace) {
      AegisLogger.error('❌ Failed to load fullchain from $_fullchainAsset', e);
      AegisLogger.error('Stack trace', stackTrace);
      rethrow;
    }
  }

  Future<String> _loadPrivateKey() async {
    if (_cachedPrivateKey != null) {
      AegisLogger.info(
          '📦 Using cached private key (${_cachedPrivateKey!.length} bytes)');
      return _cachedPrivateKey!;
    }
    try {
      AegisLogger.info('📦 Loading private key from asset: $_privateKeyAsset');
      final byteData = await rootBundle.load(_privateKeyAsset);
      _cachedPrivateKey = String.fromCharCodes(byteData.buffer.asUint8List());
      AegisLogger.info(
          '✅ Private key loaded successfully (${_cachedPrivateKey!.length} bytes)');
      return _cachedPrivateKey!;
    } catch (e, stackTrace) {
      AegisLogger.error(
          '❌ Failed to load private key from $_privateKeyAsset', e);
      AegisLogger.error('Stack trace', stackTrace);
      rethrow;
    }
  }
}

