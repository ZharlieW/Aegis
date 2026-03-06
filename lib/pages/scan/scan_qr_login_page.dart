import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:aegis/common/common_appbar.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/remote_relay_nip46_session.dart';

class ScanQrLoginPage extends StatefulWidget {
  const ScanQrLoginPage({super.key});

  @override
  State<ScanQrLoginPage> createState() => _ScanQrLoginPageState();
}

class _ScanQrLoginPageState extends State<ScanQrLoginPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            title: l10n.loginUsingUrlScheme,
          ),
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: (capture) {
                    if (_isProcessing) return;
                    final barcodes = capture.barcodes;
                    if (barcodes.isEmpty) return;
                    final raw = barcodes.first.rawValue;
                    if (raw == null || raw.isEmpty) return;
                    _isProcessing = true;
                    _handleScan(raw);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Point the camera at the QR code from the web page.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleScan(String raw) async {
    final url = raw.trim();
    AegisLogger.info('🔍 ScanQrLoginPage detected QR content: $url');

    Uri? uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      _onError('Invalid QR code content');
      return;
    }

    if (uri.scheme == 'aegis' || uri.scheme == 'nostrsigner') {
      await _handleSchemeUrl(url);
    } else if (uri.scheme == 'nostrconnect') {
      await _handleNostrConnect(url);
    } else {
      _onError('Unsupported QR code, expected Aegis or Nostr Connect URL.');
    }
  }

  Future<void> _handleSchemeUrl(String url) async {
    try {
      await LaunchSchemeUtils.handleSchemeData(url);
      if (!mounted) return;
      CommonTips.success(
        context,
        'Login request sent, please follow prompts if any.',
      );
      Navigator.of(context).pop();
    } catch (e) {
      AegisLogger.error('Failed to handle scheme QR', e);
      _onError('Failed to handle QR scheme URL.');
    }
  }

  Future<void> _handleNostrConnect(String url) async {
    try {
      // Start one-time remote relay NIP-46 session: connect to relay from QR,
      // subscribe for kind 24133 (p = current user), handle connect/get_public_key.
      final started = await RemoteRelayNip46Session.startFromNostrConnectUri(url);
      if (!mounted) return;
      if (!started) {
        _onError('Could not start remote login session. Check relay URL and login.');
        return;
      }
      CommonTips.success(
        context,
        'Waiting for web app to complete login on remote relay. You can close this page.',
      );
      Navigator.of(context).pop();
    } catch (e) {
      AegisLogger.error('Failed to handle nostrconnect QR', e);
      _onError('Failed to handle Nostr Connect QR.');
    }
  }

  void _onError(String message) {
    if (!mounted) return;
    CommonTips.error(context, message);
    setState(() {
      _isProcessing = false;
    });
  }
}

