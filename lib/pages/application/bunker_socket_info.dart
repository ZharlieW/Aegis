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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  void _init() async {
    _updateBunkerUrl();
  }

  void _updateBunkerUrl() {
    final url = ServerNIP46Signer.instance.getBunkerUrl(secure: _showSecureUrl);
    setState(() {
      _bunkerUrl = url;
    });
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
      body: Container(
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
              ],
            ),
          ],
        ),
      ),
    );
  }

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
}
