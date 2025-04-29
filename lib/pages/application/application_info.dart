import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../common/common_image.dart';
import '../../common/common_tips.dart';
import '../../navigator/navigator.dart';
import '../../utils/account.dart';
import '../../utils/server_nip46_signer.dart';
import '../../utils/took_kit.dart';
import 'edit_bunker_socket_info.dart';

class ApplicationInfo extends StatefulWidget {
  final ClientAuthDBISAR clientAuthDBISAR;
  const ApplicationInfo({super.key, required this.clientAuthDBISAR});

  @override
  ApplicationInfoState createState() => ApplicationInfoState();
}

class ApplicationInfoState extends State<ApplicationInfo> {
  String _bunkerUrl = '';

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  void _init() {
    _bunkerUrl = ServerNIP46Signer.instance.getBunkerUrl();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ClientAuthDBISAR client = widget.clientAuthDBISAR;
    bool isBunnker = client.connectionType == EConnectionType.bunker.toInt;
    bool isNostrconnect = client.connectionType == 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Application Info',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _qrCodeWidget(),
              const SizedBox(height: 20),
              _itemWidget(
                'Connect type',
                subTitle:
                    ConnectionTypeEx.fromToEnum(client.connectionType).toStr,
              ),
              _itemWidget('Client app logo',
                  rightWidget: client.image != null
                      ? Image.network(
                          client.image ?? '',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )
                      : CommonImage(
                          iconName: 'default_app_icon.png',
                          size: 40,
                        )),
              _itemWidget(
                'URL Scheme',
                isShowWidget: isNostrconnect,
                subTitle: client.scheme ?? '--',
              ),
              _itemWidget(
                'Create time',
                subTitle: TookKit.formatTimestamp(client.createTimestamp ??
                    DateTime.now().millisecondsSinceEpoch),
              ),
              _optionItemWidget(
                title: 'Application name',
                content: client.name ?? '--',
                iconName: 'edit_icon.png',
                onTap: () {
                  AegisNavigator.pushPage(
                    context,
                    (context) => EditApplicationInfo(
                      clientAuthDBISAR: client,
                    ),
                  );
                },
              ),
              _optionItemWidget(
                title: 'Client pubkey',
                content: client.clientPubkey,
                iconName: 'copy_icon.png',
                onTap: () => TookKit.copyKey(context, client.clientPubkey),
              ),
              _optionItemWidget(
                isShowWidget: isBunnker,
                title: 'Bunker info',
                content: isBunnker ? _bunkerUrl : client.scheme ?? '--',
                iconName: 'copy_icon.png',
                onTap: () => TookKit.copyKey(context, _bunkerUrl),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Theme.of(context).colorScheme.secondaryContainer.withAlpha((0.3 * 255).round()),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Remove"),
                      content: const Text(
                        "Are you sure you want to remove all permissions from this application?",
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // 圆角
                      ),
                      actions: [
                        ElevatedButton.icon(
                          onPressed: () => AegisNavigator.pop(context),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                          ),
                          icon: CommonImage(
                            iconName: 'title_close_icon.png',
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Cancel",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            Account instance = Account.sharedInstance;
                            String clientPubkey =
                                widget.clientAuthDBISAR.clientPubkey;
                            instance.removeApplicationMap(clientPubkey);
                            await ClientAuthDBISAR.deleteFromDB(
                                instance.currentPubkey, clientPubkey);
                            CommonTips.success(context, 'Remove success');
                            AegisNavigator.popToRoot(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                          ),
                          icon: CommonImage(
                            iconName: 'del_icon.png',
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Remove",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              icon: CommonImage(
                iconName: 'del_icon.png',
                size: 18,
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
    if (widget.clientAuthDBISAR.connectionType != 0) return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      width: 240,
      height: 240,
      child: PrettyQrView.data(
        data: _bunkerUrl,
        errorCorrectLevel: QrErrorCorrectLevel.M,
      ),
    );
  }

  Widget _itemWidget(
    String title, {
    bool isShowWidget = true,
    String subTitle = '',
    Widget? rightWidget,
  }) {
    if (!isShowWidget) return const SizedBox();
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                ),
          ),
          rightWidget ??
              Text(
                subTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
        ],
      ),
    );
  }

  Widget _optionItemWidget({
    bool isShowWidget = true,
    required String title,
    required String content,
    required String iconName,
    GestureTapCallback? onTap,
  }) {
    if (!isShowWidget) return const SizedBox();
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                ),
          ).setPaddingOnly(bottom: 8.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                      ),
                ),
              ),
              GestureDetector(
                onTap: () => onTap?.call(),
                child: SizedBox(
                  width: 48,
                  child: Center(
                    child: CommonImage(
                      iconName: iconName,
                      size: 24,
                      color: Colors.black,
                    ),
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
