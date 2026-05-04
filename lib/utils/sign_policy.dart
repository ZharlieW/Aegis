import 'package:aegis/utils/local_storage.dart';

/// Global policy for NIP-46 / batch permission prompts.
///
/// - [SignPolicy.basic]: Default behavior — short debounce before showing the
///   batch dialog, optional "always allow" + remember duration, and remembered
///   choices from storage can auto-approve without a new prompt.
/// - [SignPolicy.manual]: Stricter — approval UI opens immediately (no debounce),
///   no shortcuts to persist "always allow" / TTL in the batch sheet, and
///   remembered TTL choices are ignored so each operation requires an explicit
///   dialog (full trust / per-app allowed methods still apply).
enum SignPolicy {
  basic,
  manual,
}

const String kSignPolicyKey = 'sign_policy';
const String kSignPolicyBasic = 'basic';
const String kSignPolicyManual = 'manual';

/// Debounce before coalescing pending requests into one batch dialog.
Duration signPolicyBatchDebounce() {
  return getSignPolicy() == SignPolicy.manual
      ? Duration.zero
      : const Duration(milliseconds: 200);
}

/// Short delay before reopening a batch dialog when new items arrived during dismiss.
Duration signPolicyBetweenDialogs() {
  return getSignPolicy() == SignPolicy.manual
      ? Duration.zero
      : const Duration(milliseconds: 50);
}

/// When false, the batch permission UI hides "always allow" and remember TTL.
bool signPolicyShowsRememberShortcuts() {
  return getSignPolicy() == SignPolicy.basic;
}

/// Reads persisted sign policy. Defaults to [SignPolicy.basic].
/// Call after [LocalStorage.init] (e.g. app bootstrap).
SignPolicy getSignPolicy() {
  final value = LocalStorage.get(kSignPolicyKey);
  if (value == null) return SignPolicy.basic;
  final s = value.toString().trim().toLowerCase();
  if (s == kSignPolicyManual) return SignPolicy.manual;
  return SignPolicy.basic;
}

Future<bool> setSignPolicy(SignPolicy policy) async {
  final raw =
      policy == SignPolicy.manual ? kSignPolicyManual : kSignPolicyBasic;
  return LocalStorage.set(kSignPolicyKey, raw);
}
