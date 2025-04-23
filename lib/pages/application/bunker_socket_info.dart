import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../common/common_image.dart';
import '../../utils/server_nip46_signer.dart';
import '../../utils/took_kit.dart';

class BunkerSocketInfo extends StatefulWidget {

  const BunkerSocketInfo({super.key});

  @override
  BunkerSocketInfoState createState() => BunkerSocketInfoState();
}

class BunkerSocketInfoState extends State<BunkerSocketInfo> {
  String _bunkerUrl = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  void _init() async{
    _bunkerUrl = ServerNIP46Signer.instance.getBunkerUrl();
    setState(() {});
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    _bunkerUrl,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                GestureDetector(
                  onTap: () => TookKit.copyKey(context, _bunkerUrl),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: CommonImage(
                        iconName: 'copy_icon.png',
                        size: 24,
                      ),
                    ),
                  ),
                ),
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
}
