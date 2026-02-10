import 'package:flutter/material.dart';
import 'package:aegis/utils/local_storage.dart';

/// Manages app locale and persists the user's language choice.
class LocaleManager {
  static const String _localeKey = 'locale_language_code';
  static Locale? _locale;
  static final ValueNotifier<Locale?> _localeNotifier = ValueNotifier<Locale?>(_locale);

  static Locale? get currentLocale => _locale;
  static ValueNotifier<Locale?> get localeNotifier => _localeNotifier;

  /// Initialize locale from local storage. Call after [LocalStorage.init].
  static Future<void> init() async {
    try {
      final saved = LocalStorage.get(_localeKey);
      if (saved != null && saved.toString().trim().isNotEmpty) {
        _locale = Locale(saved.toString().trim());
      } else {
        _locale = null;
      }
      _localeNotifier.value = _locale;
    } catch (e) {
      _locale = null;
      _localeNotifier.value = _locale;
    }
  }

  /// Set the app locale and persist it. Pass [null] for system default.
  static Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    _localeNotifier.value = locale;
    await LocalStorage.set(_localeKey, locale?.languageCode ?? '');
  }
}
