import 'package:aegis/nostr/signer/local_nostr_signer.dart';
import 'package:aegis/utils/local_tls_proxy_manager_rust.dart';
import 'package:aegis/utils/platform_utils.dart';

/// Builds NIP-46 bunker and relay display URLs. Pure URL formatting; callers supply relay URL and port.
class Nip46BunkerUrl {
  Nip46BunkerUrl._();

  static const int _defaultPortDesktop = 18081;
  static const int _defaultPortMobile = 8081;

  /// Relay URL for display. If [secure] is true and TLS proxy is running, returns wss URL.
  static String getRelayUrlForDisplay({
    required String? relayUrl,
    bool secure = false,
  }) {
    final defaultPort =
        PlatformUtils.isDesktop ? _defaultPortDesktop : _defaultPortMobile;
    final rawUrl = relayUrl ?? 'ws://127.0.0.1:$defaultPort';
    if (!secure) return rawUrl;
    final uri = Uri.tryParse(rawUrl);
    final portNumber = uri?.port ?? defaultPort;
    final proxyManager = LocalTlsProxyManagerRust.instance;
    if (!proxyManager.isRunning) return rawUrl;
    return proxyManager.relayUrlFor(portNumber.toString());
  }

  /// Bunker URL with given relay URL (for display) and remote signer pubkey.
  static String buildBunkerUrl({
    required String relayUrlForDisplay,
    required String remoteSignerPubkey,
  }) {
    return 'bunker://$remoteSignerPubkey?relay=$relayUrlForDisplay';
  }

  /// Bunker URL using local signer public key (synchronous fallback).
  static String buildBunkerUrlWithLocalSigner({
    required String relayUrlForDisplay,
  }) {
    return buildBunkerUrl(
      relayUrlForDisplay: relayUrlForDisplay,
      remoteSignerPubkey: LocalNostrSigner.instance.publicKey,
    );
  }
}
