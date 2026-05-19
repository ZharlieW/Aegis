/// Public Namecoin ElectrumX WSS endpoints, tried in order with
/// failover. Wire-compatible with the cross-language references; the
/// server set is intentionally the same on every platform aegis ships
/// to (Android, iOS, macOS, Linux, Windows, web), so that the same
/// `name_show` flow lands on the same data wherever the signer runs.
///
/// Each entry MUST use the WSS port (typically `base + 4`) so the web
/// build can also dial it. `wss://` works for native targets as well.
///
/// Keep this list aligned with the canonical references:
///   * Go:     `mstrofnone/nostrlib-nip05-namecoin/namecoin/servers.go`
///   * TS:     `mstrofnone/nostr-tools` PR #533 (`nip05namecoin.ts`)
///   * Kotlin: `vitorpamplona/amethyst` `ElectrumXServer.kt`
///   * Dart:   `ethicnology/dart-nostr` `electrumx_server.dart`
library;

class ElectrumxServer {
  final String host;
  final int port;
  final String path;
  final bool useTls;

  const ElectrumxServer({
    required this.host,
    required this.port,
    this.path = '/',
    this.useTls = true,
  });

  String get url {
    final scheme = useTls ? 'wss' : 'ws';
    final p = path.startsWith('/') ? path : '/$path';
    return '$scheme://$host:$port$p';
  }

  @override
  String toString() => url;
}

/// Default WSS endpoints. Aegis is a signer so it runs on both web
/// (browser webview / NIP-07) and native (NIP-46 / NIP-55) — we keep
/// the same set for both paths so behaviour stays consistent.
const List<ElectrumxServer> defaultElectrumxServers = [
  ElectrumxServer(host: 'electrumx.testls.space', port: 50004),
  ElectrumxServer(host: 'nmc2.bitcoins.sk', port: 57004),
  ElectrumxServer(host: 'ex.namecoin.webbtc.com', port: 50004),
  ElectrumxServer(host: 'electrum-nmc.le-space.de', port: 50004),
];

/// Number of blocks after which a Namecoin name expires if not
/// re-registered (≈ 250 days at 10 min/block).
const int namecoinNameExpireDepth = 36000;
