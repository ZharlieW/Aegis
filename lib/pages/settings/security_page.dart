import 'package:aegis/common/common_tips.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/services/app_pin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Configure device-local app PIN to protect sensitive actions (backup view, switch account).
class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _loading = true;
  bool _pinConfigured = false;

  final _newPin = TextEditingController();
  final _confirmPin = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _newPin.dispose();
    _confirmPin.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final v = await AppPinService.instance.isPinConfigured;
    if (!mounted) return;
    setState(() {
      _pinConfigured = v;
      _loading = false;
      _newPin.clear();
      _confirmPin.clear();
    });
  }

  Future<void> _saveNewPin() async {
    final l10n = AppLocalizations.of(context)!;
    final a = _newPin.text.trim();
    final b = _confirmPin.text.trim();
    if (a != b) {
      CommonTips.error(context, l10n.appPinMismatch);
      return;
    }
    if (!AppPinService.isValidPinFormat(a)) {
      CommonTips.error(context, l10n.appPinInvalid);
      return;
    }
    try {
      await AppPinService.instance.setPin(a);
      if (!mounted) return;
      CommonTips.success(context, l10n.appPinSetSuccess);
      await _refresh();
    } catch (_) {
      if (!mounted) return;
      CommonTips.error(context, l10n.appPinInvalid);
    }
  }

  Future<void> _showChangePinDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final oldC = TextEditingController();
    final newC = TextEditingController();
    final confirmC = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.appPinChange),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldC,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: l10n.appPinCurrent),
              ),
              TextField(
                controller: newC,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: l10n.appPinNew),
              ),
              TextField(
                controller: confirmC,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: l10n.appPinConfirmLabel),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (!await AppPinService.instance.verify(oldC.text.trim())) {
                if (ctx.mounted) CommonTips.error(ctx, l10n.appPinCurrentWrong);
                return;
              }
              final n = newC.text.trim();
              final c = confirmC.text.trim();
              if (n != c) {
                if (ctx.mounted) CommonTips.error(ctx, l10n.appPinMismatch);
                return;
              }
              if (!AppPinService.isValidPinFormat(n)) {
                if (ctx.mounted) CommonTips.error(ctx, l10n.appPinInvalid);
                return;
              }
              await AppPinService.instance.setPin(n);
              if (!context.mounted) return;
              Navigator.pop(ctx);
              if (!context.mounted) return;
              CommonTips.success(context, l10n.appPinChangeSuccess);
              await _refresh();
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    oldC.dispose();
    newC.dispose();
    confirmC.dispose();
  }

  Future<void> _showRemovePinDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final oldC = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.appPinRemove),
        content: TextField(
          controller: oldC,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(labelText: l10n.appPinCurrent),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              if (!await AppPinService.instance.verify(oldC.text.trim())) {
                if (ctx.mounted) CommonTips.error(ctx, l10n.appPinCurrentWrong);
                return;
              }
              await AppPinService.instance.clearPin();
              if (!context.mounted) return;
              Navigator.pop(ctx);
              if (!context.mounted) return;
              CommonTips.success(context, l10n.appPinRemoveSuccess);
              await _refresh();
            },
            child: Text(l10n.appPinRemove),
          ),
        ],
      ),
    );

    oldC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.securityTitle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.securityDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!_pinConfigured) ...[
                    TextField(
                      controller: _newPin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.appPinNew,
                        hintText: l10n.appPinHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmPin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.appPinConfirmLabel,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _saveNewPin,
                      child: Text(l10n.appPinSet),
                    ),
                  ] else ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.appPinEnabledStatus),
                      trailing: const Icon(Icons.lock_outline),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _showChangePinDialog,
                      child: Text(l10n.appPinChange),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _showRemovePinDialog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                      child: Text(l10n.appPinRemove),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
