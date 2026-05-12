import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aegis/common/common_tips.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/nostr_login_uri_handler.dart';

/// Paste Nostr Connect / Aegis / NostrSigner URIs; same handling as [ScanQrLoginPage].
class UrlSchemeLoginPage extends StatefulWidget {
  const UrlSchemeLoginPage({super.key});

  @override
  State<UrlSchemeLoginPage> createState() => _UrlSchemeLoginPageState();
}

class _UrlSchemeLoginPageState extends State<UrlSchemeLoginPage> {
  final TextEditingController _controller = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (!mounted) return;
    if (text == null || text.isEmpty) {
      CommonTips.error(context, AppLocalizations.of(context)!.urlSchemeLoginClipboardEmpty);
      return;
    }
    setState(() {
      _controller.text = text;
      _controller.selection = TextSelection.collapsed(offset: text.length);
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final raw = _controller.text.trim();
    if (raw.isEmpty) {
      CommonTips.error(context, l10n.urlSchemeLoginEmpty);
      return;
    }

    setState(() => _busy = true);
    try {
      final outcome = await NostrLoginUriHandler.handle(raw);
      if (!mounted) return;

      switch (outcome.kind) {
        case NostrLoginUriOutcomeKind.success:
          final msg = _successMessageForUri(raw, l10n);
          CommonTips.success(context, msg);
          AegisNavigator.pop(context);
          return;
        case NostrLoginUriOutcomeKind.invalid:
          CommonTips.error(context, l10n.urlSchemeLoginInvalidUri);
          return;
        case NostrLoginUriOutcomeKind.unsupported:
          CommonTips.error(context, l10n.urlSchemeLoginUnsupported);
          return;
        case NostrLoginUriOutcomeKind.bunkerNotApplicable:
          CommonTips.error(context, l10n.urlSchemeLoginBunkerIsForClients);
          return;
        case NostrLoginUriOutcomeKind.notLoggedIn:
          _showNotLoggedInDialog(l10n.nostrConnectLoginFirst);
          return;
        case NostrLoginUriOutcomeKind.error:
          CommonTips.error(context, l10n.nostrConnectStartFailed);
          return;
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _successMessageForUri(String raw, AppLocalizations l10n) {
    try {
      final scheme = Uri.parse(raw.trim()).scheme.toLowerCase();
      if (scheme == 'nostrconnect') {
        return l10n.urlSchemeLoginSuccessNostrConnect;
      }
    } catch (_) {}
    return l10n.urlSchemeLoginSuccessScheme;
  }

  void _showNotLoggedInDialog(String message) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.loginUsingUrlScheme),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              navigator.pop();
            },
            child: Text(l10n.goToLogin),
          ),
        ],
      ),
    );
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
        title: Text(l10n.urlSchemeLoginPageTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.urlSchemeLoginPageSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 5,
              minLines: 3,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.urlSchemeLoginFieldLabel,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                if (!_busy) _submit();
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _busy ? null : _pasteFromClipboard,
              icon: const Icon(Icons.content_paste),
              label: Text(l10n.urlSchemeLoginPasteFromClipboard),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.urlSchemeLoginConnect),
            ),
          ],
        ),
      ),
    );
  }
}
