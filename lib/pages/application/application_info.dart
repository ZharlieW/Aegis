import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:aegis/common/common_image.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/server_nip46_signer.dart';
import 'package:aegis/utils/local_tls_proxy_manager_rust.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/utils/tool_kit.dart';
import 'package:aegis/utils/app_icon_loader.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/pages/activities/activities.dart';
import 'package:aegis/pages/activities/event_detail_page.dart';
import 'package:aegis/pages/application/application_permissions_page.dart';
import 'package:aegis/pages/application/edit_bunker_socket_info.dart';

class ApplicationInfo extends StatefulWidget {
  final ClientAuthDBISAR clientAuthDBISAR;
  const ApplicationInfo({super.key, required this.clientAuthDBISAR});

  @override
  ApplicationInfoState createState() => ApplicationInfoState();
}

class ApplicationInfoState extends State<ApplicationInfo> {
  static const int _recentOperationLimit = 5;

  String _bunkerUrl = '';
  bool _showSecureBunkerUrl = false;
  ValueNotifier<ClientAuthDBISAR>? _appNotifier;
  List<SignedEventDBISAR> _recentEvents = const <SignedEventDBISAR>[];
  bool _recentEventsLoading = true;
  bool _recentEventsLoadFailed = false;

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
    await _loadRecentOperations(client);
  }

  ClientAuthDBISAR get _currentClient {
    return _appNotifier?.value ?? widget.clientAuthDBISAR;
  }

  Future<void> _updateBunkerUrl() async {
    final client = widget.clientAuthDBISAR;
    String url;

    // Use remote signer pubkey if available, otherwise fallback to user pubkey
    if (client.remoteSignerPubkey != null &&
        client.remoteSignerPubkey!.isNotEmpty) {
      final relayUrl = ServerNIP46Signer.instance
          .getRelayUrlForDisplay(secure: _showSecureBunkerUrl);
      url = "bunker://${client.remoteSignerPubkey}?relay=$relayUrl";
    } else {
      // Fallback to old method for backward compatibility
      url =
          ServerNIP46Signer.instance.getBunkerUrl(secure: _showSecureBunkerUrl);
    }

    if (mounted) {
      setState(() {
        _bunkerUrl = url;
      });
    }
  }

  Future<void> _loadRecentOperations([ClientAuthDBISAR? client]) async {
    final targetClient = client ?? _currentClient;
    if (mounted) {
      setState(() {
        _recentEventsLoading = true;
        _recentEventsLoadFailed = false;
      });
    }

    try {
      final events =
          await SignedEventManager.sharedInstance.getRecentEventsForApplication(
        targetClient,
        limit: _recentOperationLimit,
      );
      if (!mounted) return;
      setState(() {
        _recentEvents = events;
        _recentEventsLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _recentEvents = const <SignedEventDBISAR>[];
        _recentEventsLoading = false;
        _recentEventsLoadFailed = true;
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
          AppLocalizations.of(context)!.applicationInfo,
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
            tooltip: AppLocalizations.of(context)!.activities,
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
                      onTap: () => ToolKit.copyKey(context, _bunkerUrl),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              _bunkerUrl,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
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
                title: AppLocalizations.of(context)!.name,
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
                title: AppLocalizations.of(context)!.viewPermissions,
                content: '',
                iconName: 'edit_icon.png',
                onTap: () {
                  AegisNavigator.pushPage(
                    context,
                    (context) => ApplicationPermissionsPage(
                      clientAuthDBISAR: client,
                    ),
                  );
                },
              ),
              _itemWidget('Client app logo',
                  rightWidget: AppIconLoader.buildIcon(
                    imageUrl: client.image,
                    appName: client.name ?? '?',
                    size: 40,
                    fallback: CommonImage(
                      iconName: 'default_app_icon.png',
                      size: 40,
                    ),
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(20),
                  )),
              _itemWidget(
                'URL Scheme',
                isShowWidget: isNostrconnect,
                subTitle: client.scheme ?? '--',
              ),
              _copyableItemWidget(
                title: AppLocalizations.of(context)!.clientPubkey,
                content: client.clientPubkey,
                onTap: () => ToolKit.copyKey(context, client.clientPubkey),
              ),
              _recentOperationsWidget(client),
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
                    final l10n = AppLocalizations.of(context)!;
                    return AlertDialog(
                      title: Text(l10n.remove),
                      content: Text(l10n.removeAppConfirm),
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
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                            if (clientPubkey.isEmpty &&
                                client.remoteSignerPubkey != null &&
                                client.remoteSignerPubkey!.isNotEmpty) {
                              AccountManager.sharedInstance
                                  .removeApplicationMap(
                                      client.remoteSignerPubkey!);
                            } else {
                              AccountManager.sharedInstance
                                  .removeApplicationMap(clientPubkey);
                            }

                            // Delete from database
                            if (clientPubkey.isEmpty) {
                              // If clientPubkey is empty, try to delete by remoteSignerPubkey or by ID
                              if (client.remoteSignerPubkey != null &&
                                  client.remoteSignerPubkey!.isNotEmpty) {
                                await ClientAuthDBISAR
                                    .deleteFromDBByRemoteSignerPubkey(
                                        currentPubkey,
                                        client.remoteSignerPubkey!);
                              } else {
                                // Fallback to delete by ID
                                await ClientAuthDBISAR.deleteFromDBById(
                                    currentPubkey, client.id);
                              }
                            } else {
                              await ClientAuthDBISAR.deleteFromDB(
                                  currentPubkey, clientPubkey);
                            }

                            // Delete all signed events for this application
                            // Use clientPubkey if available, otherwise use remoteSignerPubkey
                            final applicationPubkey = clientPubkey.isNotEmpty
                                ? clientPubkey
                                : (client.remoteSignerPubkey ?? '');
                            if (applicationPubkey.isNotEmpty) {
                              await SignedEventDBISAR
                                  .deleteAllEventsForApplication(
                                      currentPubkey, applicationPubkey);
                            }

                            // Update subscription to remove deleted application's remoteSignerPubkey
                            await ServerNIP46Signer.instance
                                .updateSubscription();

                            if (!context.mounted) return;
                            CommonTips.success(context,
                                AppLocalizations.of(context)!.removeSuccess);
                            AegisNavigator.popToRoot(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                          ),
                          icon: CommonImage(
                            iconName: 'del_icon.png',
                            size: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.remove,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: Text(
                AppLocalizations.of(context)!.remove,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
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
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
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
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          rightWidget ??
              Text(
                subTitle,
                style: Theme.of(context).textTheme.bodyMedium,
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Row(
              children: [
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                ),
              ),
              GestureDetector(
                onTap: () => onTap?.call(),
                child: CommonImage(
                  iconName: 'copy_icon.png',
                  size: 24,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recentOperationsWidget(ClientAuthDBISAR client) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '最近 $_recentOperationLimit 条',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  AegisNavigator.pushPage(
                    context,
                    (context) => Activities(clientAuthDBISAR: client),
                  );
                },
                icon: const Icon(Icons.history, size: 18),
                label: Text(AppLocalizations.of(context)!.activities),
              ),
              IconButton(
                onPressed: () => _loadRecentOperations(client),
                icon: const Icon(Icons.refresh, size: 20),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_recentEventsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_recentEventsLoadFailed)
            Text(
              AppLocalizations.of(context)!.activitiesLoadFailed,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            )
          else if (_recentEvents.isEmpty)
            Text(
              '暂无最近操作',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            Column(
              children: _recentEvents
                  .map((event) => _recentOperationItem(event))
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }

  Widget _recentOperationItem(SignedEventDBISAR event) {
    final theme = Theme.of(context);
    final content = event.eventContent.isNotEmpty
        ? event.eventContent
        : SignedEventManager.sharedInstance
            .getEventKindDescription(event.eventKind);
    final methodKey = event.methodKey;
    return InkWell(
      onTap: () {
        AegisNavigator.pushPage(
          context,
          (context) => EventDetailPage(event: event),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (methodKey != null && methodKey.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      methodKey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              ToolKit.formatTimestamp(event.signedTimestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
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
