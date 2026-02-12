import 'package:flutter/material.dart';

import '../../generated/l10n/app_localizations.dart';
import '../../utils/locale_manager.dart';

/// Full-page language selection. Replaces the language dialog.
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = LocaleManager.currentLocale;

    final items = [
      (l10n.english, const Locale('en')),
      (l10n.simplifiedChinese, const Locale('zh')),
      (l10n.traditionalChinese, const Locale('zh', 'TW')),
      (l10n.japanese, const Locale('ja')),
      (l10n.korean, const Locale('ko')),
      (l10n.spanish, const Locale('es')),
      (l10n.french, const Locale('fr')),
      (l10n.german, const Locale('de')),
      (l10n.portuguese, const Locale('pt')),
      (l10n.russian, const Locale('ru')),
      (l10n.arabic, const Locale('ar')),
      (l10n.azerbaijani, const Locale('az')),
      (l10n.bulgarian, const Locale('bg')),
      (l10n.catalan, const Locale('ca')),
      (l10n.czech, const Locale('cs')),
      (l10n.danish, const Locale('da')),
      (l10n.greek, const Locale('el')),
      (l10n.estonian, const Locale('et')),
      (l10n.farsi, const Locale('fa')),
      (l10n.hindi, const Locale('hi')),
      (l10n.hungarian, const Locale('hu')),
      (l10n.indonesian, const Locale('id')),
      (l10n.italian, const Locale('it')),
      (l10n.latvian, const Locale('lv')),
      (l10n.dutch, const Locale('nl')),
      (l10n.polish, const Locale('pl')),
      (l10n.swedish, const Locale('sv')),
      (l10n.thai, const Locale('th')),
      (l10n.turkish, const Locale('tr')),
      (l10n.ukrainian, const Locale('uk')),
      (l10n.urdu, const Locale('ur')),
      (l10n.vietnamese, const Locale('vi')),
    ]..sort((a, b) => a.$1.compareTo(b.$1));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
      ),
      body: ListView(
        children: [
          for (final item in items)
            _languageTile(context, item.$1, item.$2, current),
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
