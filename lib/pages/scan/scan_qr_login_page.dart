import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:aegis/common/common_tips.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/utils/launch_scheme_utils.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/remote_relay_nip46_session.dart';
import 'package:aegis/widgets/scan_frame_overlay.dart';

class ScanQrLoginPage extends StatefulWidget {
  const ScanQrLoginPage({super.key});

  @override
  State<ScanQrLoginPage> createState() => _ScanQrLoginPageState();
}

class _ScanQrLoginPageState extends State<ScanQrLoginPage> {
  bool _isProcessing = false;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Restart camera when widget reassembles (e.g. hot reload or return to page).
  @override
  void reassemble() {
    super.reassemble();
    _controller.stop().then((_) => _controller.start());
  }

  void _restartCamera() {
    _controller.stop().then((_) {
      if (mounted) _controller.start();
    });
  }

  Future<void> _pickImageFromAlbum() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty || !mounted) return;
    final path = result.files.single.path;
    if (path == null || path.isEmpty) return;
    setState(() => _isProcessing = true);
    try {
      final capture = await _controller.analyzeImage(path);
      if (!mounted) return;
      final barcodes = capture?.barcodes ?? [];
      final raw = barcodes.isNotEmpty ? barcodes.first.rawValue : null;
      if (raw != null && raw.isNotEmpty) {
        await _handleScan(raw);
      } else {
        _onError('No QR code found in the image.');
      }
    } catch (e) {
      AegisLogger.error('analyzeImage failed', e);
      if (mounted) _onError('Failed to read QR from image.');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => AegisNavigator.pop(context),
        ),
        title: Text(l10n.scanQrTitle),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              fit: BoxFit.cover,
              onDetect: (capture) {
                if (_isProcessing) return;
                final barcodes = capture.barcodes;
                if (barcodes.isEmpty) return;
                final raw = barcodes.first.rawValue;
                if (raw == null || raw.isEmpty) return;
                _isProcessing = true;
                _handleScan(raw);
              },
              errorBuilder: (context, error, child) {
                return ColoredBox(
                  color: Colors.black87,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            error.errorDetails?.message ?? error.errorCode.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: _restartCamera,
                            icon: const Icon(Icons.refresh, size: 20),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Positioned.fill(
              child: ScanFrameOverlay(scanAreaSize: 260),
            ),
          ],
        ),
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
      // Supports format: nostrconnect://<client_pubkey>?relay=wss://...&secret=...&name=...&url=...&image=...
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
        final reason = RemoteRelayNip46Session.lastFailureReason;
        final message = reason == 'not_logged_in'
            ? AppLocalizations.of(context)!.nostrConnectLoginFirst
            : AppLocalizations.of(context)!.nostrConnectStartFailed;
        if (reason == 'not_logged_in') {
          _showNotLoggedInDialog(message);
        } else {
          _onError(message);
        }
        return;
      }
      CommonTips.success(
        context,
        'Waiting for the app to finish login via remote relay. You can close this page.',
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

  /// Show dialog when scan fails because user is not logged in; offer "Go to login" to return to login page.
  void _showNotLoggedInDialog(String message) {
    if (!mounted) return;
    setState(() => _isProcessing = false);
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.scanQrTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              navigator.pop(); // Return to login page
            },
            child: Text(l10n.goToLogin),
          ),
        ],
      ),
    );
  }
}

