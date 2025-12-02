import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../common/common_image.dart';
import '../../common/common_tips.dart';
import '../../navigator/navigator.dart';
import '../../utils/account.dart';
import '../../utils/server_nip46_signer.dart';
import '../../utils/local_tls_proxy_manager_rust.dart';
import '../../utils/took_kit.dart';
import '../activities/activities.dart';
import 'edit_bunker_socket_info.dart';

class ApplicationInfo extends StatefulWidget {
  final ClientAuthDBISAR clientAuthDBISAR;
  const ApplicationInfo({super.key, required this.clientAuthDBISAR});

  @override
  ApplicationInfoState createState() => ApplicationInfoState();
}

class ApplicationInfoState extends State<ApplicationInfo> {
  String _bunkerUrl = '';
  bool _showSecureBunkerUrl = false;
  ValueNotifier<ClientAuthDBISAR>? _appNotifier;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() async {
    // Get the notifier from AccountManager to listen for updates
    final client = widget.clientAuthDBISAR;
    final key = client.clientPubkey.isNotEmpty 
        ? client.clientPubkey 
        : (client.remoteSignerPubkey ?? '');
    _appNotifier = AccountManager.sharedInstance.applicationMap[key];
    await _updateBunkerUrl();
  }

  ClientAuthDBISAR get _currentClient {
    return _appNotifier?.value ?? widget.clientAuthDBISAR;
  }

  Future<void> _updateBunkerUrl() async {
    final client = widget.clientAuthDBISAR;
    String url;
    
    // Use remote signer pubkey if available, otherwise fallback to user pubkey
    if (client.remoteSignerPubkey != null && client.remoteSignerPubkey!.isNotEmpty) {
      final relayUrl = ServerNIP46Signer.instance.getRelayUrlForDisplay(secure: _showSecureBunkerUrl);
      url = "bunker://${client.remoteSignerPubkey}?relay=$relayUrl";
    } else {
      // Fallback to old method for backward compatibility
      url = ServerNIP46Signer.instance.getBunkerUrl(secure: _showSecureBunkerUrl);
    }
    
    if (mounted) {
      setState(() {
        _bunkerUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder to listen for updates
    final notifier = _appNotifier;
    if (notifier != null) {
      return ValueListenableBuilder<ClientAuthDBISAR>(
        valueListenable: notifier,
        builder: (context, client, child) {
          return _buildContent(context, client);
        },
      );
    } else {
      return _buildContent(context, widget.clientAuthDBISAR);
    }
  }

  Widget _buildContent(BuildContext context, ClientAuthDBISAR client) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Don't update timestamp when just viewing activities
              // Only update timestamp when there's actual activity (signing, etc.)
              AegisNavigator.pushPage(
                context,
                (context) => Activities(
                  clientAuthDBISAR: widget.clientAuthDBISAR,
                ),
              );
            },
            tooltip: 'Activities',
          ),
        ],
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
              if (isBunnker) ...[
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
                const SizedBox(height: 20),
              ],
              _optionItemWidget(
                title: 'Name',
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
              _itemWidget('Client app logo',
                  rightWidget: client.image != null && client.image!.isNotEmpty
                      ? Image.network(
                          client.image!,
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
              _copyableItemWidget(
                title: 'Client pubkey',
                content: client.clientPubkey,
                onTap: () => TookKit.copyKey(context, client.clientPubkey),
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
        color: Theme.of(context)
            .colorScheme
            .secondaryContainer
            .withAlpha((0.3 * 255).round()),
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
                            String currentPubkey =
                                Account.sharedInstance.currentPubkey;
                            final client = _currentClient;
                            String clientPubkey = client.clientPubkey;
                            
                            // Remove from memory
                            // Handle case where clientPubkey might be empty (use remoteSignerPubkey as key)
                            if (clientPubkey.isEmpty && client.remoteSignerPubkey != null && client.remoteSignerPubkey!.isNotEmpty) {
                              AccountManager.sharedInstance.removeApplicationMap(client.remoteSignerPubkey!);
                            } else {
                              AccountManager.sharedInstance.removeApplicationMap(clientPubkey);
                            }
                            
                            // Delete from database
                            if (clientPubkey.isEmpty) {
                              // If clientPubkey is empty, try to delete by remoteSignerPubkey or by ID
                              if (client.remoteSignerPubkey != null && client.remoteSignerPubkey!.isNotEmpty) {
                                await ClientAuthDBISAR.deleteFromDBByRemoteSignerPubkey(
                                    currentPubkey, client.remoteSignerPubkey!);
                              } else {
                                // Fallback to delete by ID
                                await ClientAuthDBISAR.deleteFromDBById(currentPubkey, client.id);
                              }
                            } else {
                              await ClientAuthDBISAR.deleteFromDB(currentPubkey, clientPubkey);
                            }
                            
                            // Delete all signed events for this application
                            // Use clientPubkey if available, otherwise use remoteSignerPubkey
                            final applicationPubkey = clientPubkey.isNotEmpty 
                                ? clientPubkey 
                                : (client.remoteSignerPubkey ?? '');
                            if (applicationPubkey.isNotEmpty) {
                              await SignedEventDBISAR.deleteAllEventsForApplication(
                                  currentPubkey, applicationPubkey);
                            }
                            
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Container(
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
            Row(
              children: [
                Text(
                  content,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 28,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a copyable item widget with title on top and content below
  Widget _copyableItemWidget({
    required String title,
    required String content,
    GestureTapCallback? onTap,
  }) {
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
          ),
          const SizedBox(height: 8),
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
                child: CommonImage(
                  iconName: 'copy_icon.png',
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBunkerModeSelector() {
    final secureAvailable = LocalTlsProxyManagerRust.instance.isRunning;
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('ws://'),
          selected: !_showSecureBunkerUrl,
          onSelected: (selected) async {
            if (selected) {
              setState(() {
                _showSecureBunkerUrl = false;
              });
              await _updateBunkerUrl();
            }
          },
        ),
        ChoiceChip(
          label: const Text('wss://'),
          selected: _showSecureBunkerUrl,
          onSelected: secureAvailable
              ? (selected) async {
                  if (selected) {
                    setState(() {
                      _showSecureBunkerUrl = true;
                    });
                    await _updateBunkerUrl();
                  }
                }
              : null,
        ),
      ],
    );
  }
}
