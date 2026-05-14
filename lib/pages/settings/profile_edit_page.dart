import 'dart:async';
import 'dart:convert';

import 'package:aegis/common/common_tips.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/nostr/event.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/connect.dart';
import 'package:aegis/utils/default_profile_relays_store.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/nostr_rust_utils.dart';
import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key, this.initialName});

  final String? initialName;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _aboutController;
  late final TextEditingController _pictureController;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _aboutController = TextEditingController();
    _pictureController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _pictureController.dispose();
    super.dispose();
  }

  bool _isValidPictureUrl(String value) {
    if (value.isEmpty) return true;
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.host.isNotEmpty &&
        (uri.scheme == 'https' || uri.scheme == 'http');
  }

  List<String> _connectedSubset(List<String> relays) {
    final connected = Connect.sharedInstance.relays(
      relayKinds: const [RelayKind.general],
    );
    final normalized = relays.map(_normalizeRelay).toSet();
    return connected
        .where((relay) => normalized.contains(_normalizeRelay(relay)))
        .toList();
  }

  String _normalizeRelay(String relay) {
    var value = relay.trim();
    while (value.length > 1 && value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    return value.toLowerCase();
  }

  Future<List<String>> _publishRelays() async {
    final defaultRelays = await DefaultProfileRelaysStore.load();
    if (defaultRelays.isNotEmpty) {
      await Future.wait(
        defaultRelays.map(
          (relay) => Connect.sharedInstance
              .connect(
                relay,
                relayKind: RelayKind.general,
              )
              .timeout(const Duration(seconds: Connect.timeout),
                  onTimeout: () {}),
        ),
      );
      final connectedDefaults = _connectedSubset(defaultRelays);
      if (connectedDefaults.isNotEmpty) return connectedDefaults;
    }
    return Connect.sharedInstance.relays(relayKinds: const [RelayKind.general]);
  }

  Future<void> _publishProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final account = Account.sharedInstance;
    final privateKey = account.currentPrivkey;
    final publicKey = account.currentPubkey;
    final picture = _pictureController.text.trim();

    if (privateKey.isEmpty || publicKey.isEmpty) {
      CommonTips.error(context, l10n.notLoggedIn);
      return;
    }
    if (!_isValidPictureUrl(picture)) {
      CommonTips.error(context, l10n.profilePictureInvalid);
      return;
    }

    setState(() => _isPublishing = true);
    try {
      final metadata = <String, String>{
        'name': _nameController.text.trim(),
        'about': _aboutController.text.trim(),
        'picture': picture,
      }..removeWhere((_, value) => value.isEmpty);

      final unsignedEvent = {
        'pubkey': publicKey,
        'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'kind': 0,
        'tags': <List<String>>[],
        'content': jsonEncode(metadata),
        'sig': '',
      };
      final signedEventJson = await NostrRustUtils.signEvent(
        jsonEncode(unsignedEvent),
        privateKey,
      );
      final signedEventMap =
          jsonDecode(signedEventJson) as Map<String, dynamic>;
      final event = Event.fromJson(signedEventMap, verify: false);
      if (event == null || !event.isValid()) {
        throw Exception(l10n.profilePublishInvalidSignature);
      }

      final relays = await _publishRelays();
      if (relays.isEmpty) {
        throw Exception(l10n.profilePublishNoRelays);
      }
      await _sendAndWaitForOk(event, relays);
      if (!mounted) return;
      CommonTips.success(context, l10n.profilePublishSuccess);
    } catch (e, stackTrace) {
      AegisLogger.error(
        'Failed to publish profile metadata',
        '$e\n$stackTrace',
      );
      if (!mounted) return;
      CommonTips.error(context, l10n.profilePublishFailed(e.toString()));
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  Future<void> _sendAndWaitForOk(Event event, List<String> relays) async {
    final completer = Completer<void>();
    Connect.sharedInstance.sendEvent(
      event,
      toRelays: relays,
      relayKinds: const [RelayKind.general],
      sendCallBack: (ok, relay) {
        if (completer.isCompleted) return;
        if (ok.status) {
          completer.complete();
        } else {
          completer.completeError(
            Exception(ok.message.isEmpty ? 'Relay rejected event' : ok.message),
          );
        }
      },
    );
    await completer.future.timeout(
      const Duration(seconds: Connect.timeout + 2),
      onTimeout: () => throw TimeoutException('Relay publish timed out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileEditTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.profileNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _aboutController,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: l10n.profileAboutLabel,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pictureController,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.profilePictureLabel,
                hintText: 'https://example.com/avatar.png',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.profilePublishRelayHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isPublishing ? null : _publishProfile,
              icon: _isPublishing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.publish_outlined),
              label: Text(
                _isPublishing ? l10n.profilePublishing : l10n.profilePublish,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
