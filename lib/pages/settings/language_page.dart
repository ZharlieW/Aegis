import 'package:flutter/material.dart';

import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/utils/locale_manager.dart';

/// Native display names for each locale (not translated), so users can always
/// find their language after switching to another locale.
final Map<Locale, String> _localeNativeNames = {
  const Locale('en'): 'English',
  const Locale('zh'): '简体中文',
  const Locale('zh', 'TW'): '繁體中文',
  const Locale('ja'): '日本語',
  const Locale('ko'): '한국어',
  const Locale('es'): 'Español',
  const Locale('fr'): 'Français',
  const Locale('de'): 'Deutsch',
  const Locale('pt'): 'Português',
  const Locale('ru'): 'Русский',
  const Locale('ar'): 'العربية',
  const Locale('az'): 'Azərbaycan',
  const Locale('bg'): 'Български',
  const Locale('ca'): 'Català',
  const Locale('cs'): 'Čeština',
  const Locale('da'): 'Dansk',
  const Locale('el'): 'Ελληνικά',
  const Locale('et'): 'Eesti',
  const Locale('fa'): 'فارسی',
  const Locale('hi'): 'हिन्दी',
  const Locale('hu'): 'Magyar',
  const Locale('id'): 'Bahasa Indonesia',
  const Locale('it'): 'Italiano',
  const Locale('lv'): 'Latviešu',
  const Locale('nl'): 'Nederlands',
  const Locale('pl'): 'Polski',
  const Locale('sv'): 'Svenska',
  const Locale('th'): 'ไทย',
  const Locale('tr'): 'Türkçe',
  const Locale('uk'): 'Українська',
  const Locale('ur'): 'اردو',
  const Locale('vi'): 'Tiếng Việt',
};

/// Full-page language selection. Replaces the language dialog.
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = LocaleManager.currentLocale;

    final items = _localeNativeNames.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
      ),
      body: ListView(
        children: [
          for (final entry in items)
            _languageTile(context, entry.value, entry.key, current),
        ],
      ),
    );
  }

  static bool _localeEquals(Locale? a, Locale? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.languageCode == b.languageCode &&
        (a.countryCode ?? '') == (b.countryCode ?? '');
  }

  Widget _languageTile(
    BuildContext context,
    String title,
    Locale locale,
    Locale? current,
  ) {
    final isSelected = _localeEquals(locale, current);
    return ListTile(
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        LocaleManager.setLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }
}
