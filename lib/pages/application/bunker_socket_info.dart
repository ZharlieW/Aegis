import 'package:aegis/navigator/navigator.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../common/common_image.dart';
import '../../utils/account.dart';
import '../../utils/took_kit.dart';
import 'edit_bunker_socket_info.dart';

class BunkerSocketInfo extends StatefulWidget {
  const BunkerSocketInfo({super.key});

  @override
  _BunkerSocketInfoState createState() => _BunkerSocketInfoState();
}

class _BunkerSocketInfoState extends State<BunkerSocketInfo> {
  String _bunkerUrl = '';

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bunkerUrl = Account.sharedInstance.bunkerSocketList.value[0].nsecBunker;
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
        margin: EdgeInsets.symmetric(horizontal: 16),
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
                  child: Container(
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
      bottomNavigationBar: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                AegisNavigator.pushPage(context, (context) => EditBunkerSocketInfo());
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              icon: CommonImage(
                iconName: 'edit_icon.png',
                size: 18,
              ),
              label: Text(
                "Edit",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(width: 10), //
            ElevatedButton.icon(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              icon: CommonImage(
                iconName: 'del_icon.png',
                size: 32,
                color: Colors.white,
              ),
              label: Text(
                "Remove",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qrCodeWidget() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      width: 240,
      height: 240,
      child: PrettyQrView.data(
        data: _bunkerUrl,
        errorCorrectLevel: QrErrorCorrectLevel.M,
      ),
    );
  }
}
