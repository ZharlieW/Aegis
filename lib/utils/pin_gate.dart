import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/services/app_pin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// If the user has configured an app PIN, shows a verification dialog.
/// Returns `true` when the action may proceed (no PIN or correct PIN).
Future<bool> requireAppPinIfSet(BuildContext context) async {
  if (!await AppPinService.instance.isPinConfigured) {
    return true;
  }
  if (!context.mounted) return false;
  final ok = await showAppPinVerificationDialog(context);
  return ok == true;
}

Future<bool?> showAppPinVerificationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _PinVerifyDialog(),
  );
}

class _PinVerifyDialog extends StatefulWidget {
  const _PinVerifyDialog();

  @override
  State<_PinVerifyDialog> createState() => _PinVerifyDialogState();
}

class _PinVerifyDialogState extends State<_PinVerifyDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _controller.text.trim();
    if (!AppPinService.isValidPinFormat(pin)) {
      setState(() {
        _error = AppLocalizations.of(context)!.appPinInvalid;
      });
      return;
    }
    final ok = await AppPinService.instance.verify(pin);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _error = AppLocalizations.of(context)!.appPinWrong;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.appPinEnterTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.appPinLabel,
                errorText: _error,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.confirm),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
