import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../common/common_image.dart';
import '../../utils/server_nip46_signer.dart';
import '../../utils/local_tls_proxy_manager_rust.dart';
import '../../utils/took_kit.dart';

class BunkerSocketInfo extends StatefulWidget {
  const BunkerSocketInfo({super.key});

  @override
  BunkerSocketInfoState createState() => BunkerSocketInfoState();
}

class BunkerSocketInfoState extends State<BunkerSocketInfo> {
  String _bunkerUrl = '';
  bool _showSecureUrl = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  /// Initialize the widget and update the bunker URL
  void _init() async {
    // Create or get bunker application when page loads
    await _ensureBunkerApplication();
    _updateBunkerUrl();
  }

  /// Ensure a bunker application exists (create one if needed)
  Future<void> _ensureBunkerApplication() async {
    try {
      // Try to find an unused application first
      final unusedApp = await ServerNIP46Signer.instance.findUnusedBunkerApplication();
      if (unusedApp == null) {
        // Create a new application if none exists
        await ServerNIP46Signer.instance.createBunkerApplication();
      }
    } catch (e) {
      // Log error but continue to show URL (will use fallback)
      print('Failed to ensure bunker application: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Update the bunker URL based on the current secure mode selection
  void _updateBunkerUrl() async {
    try {
      final url = await ServerNIP46Signer.instance.getBunkerUrlWithRemoteSigner(secure: _showSecureUrl);
      if (mounted) {
        setState(() {
          _bunkerUrl = url;
        });
      }
    } catch (e) {
      // Fallback to old method if new method fails
      final url = ServerNIP46Signer.instance.getBunkerUrl(secure: _showSecureUrl);
      if (mounted) {
        setState(() {
          _bunkerUrl = url;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bunker Socket Info',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _qrCodeWidget(),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => TookKit.copyKey(context, _bunkerUrl),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                _bunkerUrl,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CommonImage(
                              iconName: 'copy_icon.png',
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBunkerModeSelector(),
                      const SizedBox(height: 16),
                      _buildProtocolExplanation(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  /// Builds the QR code widget displaying the bunker URL
  Widget _qrCodeWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      width: 240,
      height: 240,
      child: PrettyQrView.data(
        data: _bunkerUrl,
        errorCorrectLevel: QrErrorCorrectLevel.M,
      ),
    );
  }

  Widget _buildBunkerModeSelector() {
    final secureAvailable = LocalTlsProxyManagerRust.instance.isRunning;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 12,
          children: [
            ChoiceChip(
              label: const Text('ws://'),
              selected: !_showSecureUrl,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _showSecureUrl = false;
                  });
                  _updateBunkerUrl();
                }
              },
            ),
            ChoiceChip(
              label: const Text('wss://'),
              selected: _showSecureUrl,
              onSelected: secureAvailable
                  ? (selected) {
                      if (selected) {
                        setState(() {
                          _showSecureUrl = true;
                        });
                        _updateBunkerUrl();
                      }
                    }
                  : null,
            ),
          ],
        ),
        if (!secureAvailable)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'TLS proxy not running',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
      ],
    );
  }

  /// Builds a protocol explanation widget that describes the difference
  /// between ws:// and wss:// protocols, and emphasizes that wss://
  /// is required for mobile PWA or browser usage.
  Widget _buildProtocolExplanation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   '• ws://: Unencrypted WebSocket connection, suitable for local network environments',
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
          // const SizedBox(height: 4),
          // Text(
          //   '• wss://: Encrypted WebSocket connection (TLS/SSL), provides secure communication',
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
          // const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Important: If you need to use this in mobile PWA or browser, you must use wss:// link. Browser security policies require WebSocket connections to use encrypted protocols.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
