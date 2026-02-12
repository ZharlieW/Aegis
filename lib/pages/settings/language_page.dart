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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
      ),
      body: ListView(
        children: [
          _languageTile(context, l10n.english, const Locale('en'), current),
          _languageTile(context, l10n.simplifiedChinese, const Locale('zh'), current),
          _languageTile(context, l10n.traditionalChinese, const Locale('zh', 'TW'), current),
          _languageTile(context, l10n.japanese, const Locale('ja'), current),
          _languageTile(context, l10n.korean, const Locale('ko'), current),
          _languageTile(context, l10n.spanish, const Locale('es'), current),
          _languageTile(context, l10n.french, const Locale('fr'), current),
          _languageTile(context, l10n.german, const Locale('de'), current),
          _languageTile(context, l10n.portuguese, const Locale('pt'), current),
          _languageTile(context, l10n.russian, const Locale('ru'), current),
          _languageTile(context, l10n.arabic, const Locale('ar'), current),
          _languageTile(context, l10n.azerbaijani, const Locale('az'), current),
          _languageTile(context, l10n.bulgarian, const Locale('bg'), current),
          _languageTile(context, l10n.catalan, const Locale('ca'), current),
          _languageTile(context, l10n.czech, const Locale('cs'), current),
          _languageTile(context, l10n.danish, const Locale('da'), current),
          _languageTile(context, l10n.greek, const Locale('el'), current),
          _languageTile(context, l10n.estonian, const Locale('et'), current),
          _languageTile(context, l10n.farsi, const Locale('fa'), current),
          _languageTile(context, l10n.hindi, const Locale('hi'), current),
          _languageTile(context, l10n.hungarian, const Locale('hu'), current),
          _languageTile(context, l10n.indonesian, const Locale('id'), current),
          _languageTile(context, l10n.italian, const Locale('it'), current),
          _languageTile(context, l10n.latvian, const Locale('lv'), current),
          _languageTile(context, l10n.dutch, const Locale('nl'), current),
          _languageTile(context, l10n.polish, const Locale('pl'), current),
          _languageTile(context, l10n.swedish, const Locale('sv'), current),
          _languageTile(context, l10n.thai, const Locale('th'), current),
          _languageTile(context, l10n.turkish, const Locale('tr'), current),
          _languageTile(context, l10n.ukrainian, const Locale('uk'), current),
          _languageTile(context, l10n.urdu, const Locale('ur'), current),
          _languageTile(context, l10n.vietnamese, const Locale('vi'), current),
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
