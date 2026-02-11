// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Potvrdit';

  @override
  String get cancel => 'Zrušit';

  @override
  String get settings => 'Nastavení';

  @override
  String get logout => 'Odhlásit se';

  @override
  String get login => 'Přihlásit se';

  @override
  String get usePrivateKey => 'Použít soukromý klíč';

  @override
  String get setupAegisWithNsec => 'Nastavte Aegis pomocí klíče Nostr — podporuje formáty nsec, ncryptsec a hex.';

  @override
  String get privateKey => 'Soukromý klíč';

  @override
  String get privateKeyHint => 'Klíč nsec / ncryptsec / hex';

  @override
  String get password => 'Heslo';

  @override
  String get passwordHint => 'Zadejte heslo pro dešifrování ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Obsah nemůže být prázdný!';

  @override
  String get passwordRequiredForNcryptsec => 'Pro ncryptsec je vyžadováno heslo!';

  @override
  String get decryptNcryptsecFailed => 'Dešifrování ncryptsec se nezdařilo. Zkontrolujte heslo.';

  @override
  String get invalidPrivateKeyFormat => 'Neplatný formát soukromého klíče!';

  @override
  String get loginSuccess => 'Přihlášení úspěšné!';

  @override
  String loginFailed(String message) {
    return 'Přihlášení se nezdařilo: $message';
  }

  @override
  String get typeConfirmToProceed => 'Pro pokračování napište \"confirm\"';

  @override
  String get logoutConfirm => 'Opravdu se chcete odhlásit?';

  @override
  String get notLoggedIn => 'Nejste přihlášeni';

  @override
  String get language => 'Jazyk';

  @override
  String get english => 'English';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Français';

  @override
  String get german => 'Deutsch';

  @override
  String get portuguese => 'Português';

  @override
  String get russian => 'Русский';

  @override
  String get arabic => 'العربية';

  @override
  String get azerbaijani => 'Azərbaycan';

  @override
  String get bulgarian => 'Български';

  @override
  String get catalan => 'Català';

  @override
  String get czech => 'Čeština';

  @override
  String get danish => 'Dansk';

  @override
  String get greek => 'Ελληνικά';

  @override
  String get estonian => 'Eesti';

  @override
  String get farsi => 'فارسی';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get hungarian => 'Magyar';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get italian => 'Italiano';

  @override
  String get latvian => 'Latviešu';

  @override
  String get dutch => 'Nederlands';

  @override
  String get polish => 'Polski';

  @override
  String get swedish => 'Svenska';

  @override
  String get thai => 'ไทย';

  @override
  String get turkish => 'Türkçe';

  @override
  String get ukrainian => 'Українська';

  @override
  String get urdu => 'اردو';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get addAccount => 'Přidat účet';

  @override
  String get updateSuccessful => 'Aktualizace úspěšná!';

  @override
  String get switchAccount => 'Přepnout účet';

  @override
  String get switchAccountConfirm => 'Opravdu chcete přepnout účet?';

  @override
  String get switchSuccessfully => 'Přepnutí úspěšné!';

  @override
  String get renameAccount => 'Přejmenovat účet';

  @override
  String get accountName => 'Název účtu';

  @override
  String get enterNewName => 'Zadejte nový název';

  @override
  String get accounts => 'Účty';

  @override
  String get localRelay => 'Místní relay';

  @override
  String get remote => 'Vzdálený';

  @override
  String get browser => 'Prohlížeč';

  @override
  String get theme => 'Motiv';

  @override
  String get github => 'Github';

  @override
  String get version => 'Verze';

  @override
  String get appSubtitle => 'Aegis — Podepisovač Nostr';

  @override
  String get darkMode => 'Tmavý režim';

  @override
  String get lightMode => 'Světlý režim';

  @override
  String get systemDefault => 'Systémové výchozí';

  @override
  String switchedTo(String mode) {
    return 'Přepnuto na $mode';
  }

  @override
  String get home => 'Domů';

  @override
  String get waitingForRelayStart => 'Čekání na spuštění relaye...';

  @override
  String get connected => 'Připojeno';

  @override
  String get disconnected => 'Odpojeno';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Chyba načítání aplikací NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Zatím žádné aplikace NIP-07.\n\nPoužijte prohlížeč pro přístup k aplikacím Nostr!';

  @override
  String get unknown => 'Neznámé';

  @override
  String get active => 'Aktivní';

  @override
  String get congratulationsEmptyState => 'Gratulujeme!\n\nNyní můžete používat aplikace s podporou Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Místní relay je nastaven na port $port, ale zdá se, že jej již používá jiná aplikace. Zavřete konfliktní aplikaci a zkuste znovu.';
  }

  @override
  String get nip46Started => 'Podepisovač NIP-46 spuštěn!';

  @override
  String get nip46FailedToStart => 'Spuštění se nezdařilo.';

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get clear => 'Vymazat';

  @override
  String get clearDatabase => 'Vymazat databázi';

  @override
  String get clearDatabaseConfirm => 'Tím se smažou všechna data relaye a relay se restartuje, pokud běží. Tuto akci nelze vrátit zpět.';

  @override
  String get importDatabase => 'Importovat databázi';

  @override
  String get importDatabaseHint => 'Zadejte cestu k adresáři databáze k importu. Existující databáze bude před importem zálohována.';

  @override
  String get databaseDirectoryPath => 'Cesta k adresáři databáze';

  @override
  String get import => 'Importovat';

  @override
  String get export => 'Exportovat';

  @override
  String get restart => 'Restartovat';

  @override
  String get restartRelay => 'Restartovat relay';

  @override
  String get restartRelayConfirm => 'Opravdu chcete restartovat relay? Relay bude dočasně zastaven a poté znovu spuštěn.';

  @override
  String get relayRestartedSuccess => 'Relay úspěšně restartován';

  @override
  String relayRestartFailed(String message) {
    return 'Restart relaye se nezdařil: $message';
  }

  @override
  String get databaseClearedSuccess => 'Databáze úspěšně vymazána';

  @override
  String get databaseClearFailed => 'Vymazání databáze se nezdařilo';

  @override
  String errorWithMessage(String message) {
    return 'Chyba: $message';
  }

  @override
  String get exportDatabase => 'Exportovat databázi';

  @override
  String get exportDatabaseHint => 'Databáze relaye bude exportována jako soubor ZIP. Export může chvíli trvat.';

  @override
  String databaseExportedTo(String path) {
    return 'Databáze exportována do: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Databáze exportována jako ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Export databáze se nezdařil';

  @override
  String get importDatabaseReplaceHint => 'Tím se nahradí aktuální databáze importovanou zálohou. Existující databáze bude před importem zálohována. Tuto akci nelze vrátit zpět.';

  @override
  String get selectDatabaseBackupFile => 'Vyberte záložní soubor databáze (ZIP) nebo adresář';

  @override
  String get selectDatabaseBackupDir => 'Vyberte záložní adresář databáze';

  @override
  String get fileOrDirNotExist => 'Vybraný soubor nebo adresář neexistuje';

  @override
  String get databaseImportedSuccess => 'Databáze úspěšně importována';

  @override
  String get databaseImportFailed => 'Import databáze se nezdařil';

  @override
  String get status => 'Stav';

  @override
  String get address => 'Adresa';

  @override
  String get protocol => 'Protokol';

  @override
  String get connections => 'Připojení';

  @override
  String get running => 'Běží';

  @override
  String get stopped => 'Zastaveno';

  @override
  String get addressCopiedToClipboard => 'Adresa zkopírována do schránky';

  @override
  String get exportData => 'Exportovat data';

  @override
  String get importData => 'Importovat data';

  @override
  String get systemLogs => 'Systémové protokoly';

  @override
  String get clearAllRelayData => 'Vymazat všechna data relaye';

  @override
  String get noLogsAvailable => 'Žádné protokoly k dispozici';

  @override
  String get passwordRequired => 'Heslo je vyžadováno';

  @override
  String encryptionFailed(String message) {
    return 'Šifrování se nezdařilo: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Šifrovaný soukromý klíč zkopírován do schránky';

  @override
  String get accountBackup => 'Záloha účtu';

  @override
  String get publicAccountId => 'Veřejné ID účtu';

  @override
  String get accountPrivateKey => 'Soukromý klíč účtu';

  @override
  String get show => 'Zobrazit';

  @override
  String get generate => 'Generovat';

  @override
  String get enterEncryptionPassword => 'Zadejte šifrovací heslo';

  @override
  String get privateKeyEncryption => 'Šifrování soukromého klíče';

  @override
  String get encryptPrivateKeyHint => 'Zašifrujte soukromý klíč pro zvýšení bezpečnosti. Klíč bude zašifrován heslem.';

  @override
  String get ncryptsecHint => 'Zašifrovaný klíč bude začínat na \"ncryptsec1\" a nelze jej použít bez hesla.';

  @override
  String get encryptAndCopyPrivateKey => 'Zašifrovat a zkopírovat soukromý klíč';

  @override
  String get privateKeyEncryptedSuccess => 'Soukromý klíč úspěšně zašifrován!';

  @override
  String get encryptedKeyNcryptsec => 'Zašifrovaný klíč (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Vytvořit nový účet Nostr';

  @override
  String get accountReadyPublicKeyHint => 'Váš účet Nostr je připraven! Toto je váš veřejný klíč nostr:';

  @override
  String get nostrPubkey => 'Veřejný klíč Nostr';

  @override
  String get create => 'Vytvořit';

  @override
  String get createSuccess => 'Úspěšně vytvořeno!';

  @override
  String get application => 'Aplikace';

  @override
  String get createApplication => 'Vytvořit aplikaci';

  @override
  String get addNewApplication => 'Přidat novou aplikaci';

  @override
  String get addNsecbunkerManually => 'Přidat nsecbunker ručně';

  @override
  String get loginUsingUrlScheme => 'Přihlásit se pomocí URL schématu';

  @override
  String get addApplicationMethodsHint => 'Můžete zvolit kteroukoli z těchto metod pro připojení k Aegis!';

  @override
  String get urlSchemeLoginHint => 'Otevřete v aplikaci s podporou URL schématu Aegis pro přihlášení';

  @override
  String get name => 'Název';

  @override
  String get applicationInfo => 'Informace o aplikaci';

  @override
  String get activities => 'Aktivity';

  @override
  String get clientPubkey => 'Veřejný klíč klienta';

  @override
  String get remove => 'Odebrat';

  @override
  String get removeAppConfirm => 'Opravdu chcete odebrat všechna oprávnění této aplikace?';

  @override
  String get removeSuccess => 'Úspěšně odebráno';

  @override
  String get nameCannotBeEmpty => 'Název nemůže být prázdný';

  @override
  String get nameTooLong => 'Název je příliš dlouhý.';

  @override
  String get updateSuccess => 'Aktualizace úspěšná';

  @override
  String get editConfiguration => 'Upravit konfiguraci';

  @override
  String get update => 'Aktualizovat';

  @override
  String get search => 'Hledat...';

  @override
  String get enterCustomName => 'Zadejte vlastní název';

  @override
  String get selectApplication => 'Vyberte aplikaci';

  @override
  String get addWebApp => 'Přidat webovou aplikaci';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Moje aplikace';

  @override
  String get add => 'Přidat';

  @override
  String get searchNostrApps => 'Hledat aplikace Nostr...';

  @override
  String get invalidUrlHint => 'Neplatná URL. Zadejte platnou HTTP nebo HTTPS URL.';

  @override
  String get appAlreadyInList => 'Tato aplikace je již v seznamu.';

  @override
  String appAdded(String name) {
    return '$name přidáno';
  }

  @override
  String appAddFailed(String error) {
    return 'Přidání aplikace se nezdařilo: $error';
  }

  @override
  String get deleteApp => 'Smazat aplikaci';

  @override
  String deleteAppConfirm(String name) {
    return 'Opravdu chcete smazat \"$name\"?';
  }

  @override
  String get delete => 'Smazat';

  @override
  String appDeleted(String name) {
    return '$name smazáno';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Smazání aplikace se nezdařilo: $error';
  }

  @override
  String get copiedToClipboard => 'Zkopírováno do schránky';

  @override
  String get eventDetails => 'Podrobnosti události';

  @override
  String get eventDetailsCopiedToClipboard => 'Podrobnosti události zkopírovány do schránky';

  @override
  String get rawMetadataCopiedToClipboard => 'Surová metadata zkopírována do schránky';

  @override
  String get permissionRequest => 'Žádost o oprávnění';

  @override
  String get permissionRequestContent => 'Tato aplikace žádá o oprávnění k přístupu k vašemu účtu Nostr';

  @override
  String get grantPermissions => 'Udělit oprávnění';

  @override
  String get reject => 'Odmítnout';

  @override
  String get fullAccessGranted => 'Plný přístup udělen';

  @override
  String get fullAccessHint => 'Tato aplikace bude mít plný přístup k vašemu účtu Nostr, včetně:';

  @override
  String get permissionAccessPubkey => 'Přístup k veřejnému klíči Nostr';

  @override
  String get permissionSignEvents => 'Podepisování událostí Nostr';

  @override
  String get permissionEncryptDecrypt => 'Šifrování a dešifrování událostí (NIP-04 a NIP-44)';

  @override
  String get tips => 'Tipy';

  @override
  String get schemeLoginFirst => 'Nelze vyřešit schéma, nejprve se přihlaste.';

  @override
  String get newConnectionRequest => 'Nová žádost o připojení';

  @override
  String get newConnectionNoSlotHint => 'Nová aplikace se snaží připojit, ale není k dispozici žádná volná aplikace. Nejprve vytvořte novou aplikaci.';

  @override
  String get copiedSuccessfully => 'Úspěšně zkopírováno';

  @override
  String get importDatabasePathHint => '/path/to/nostr_relay_backup_...';

  @override
  String get relayStatsSize => 'SIZE';

  @override
  String get relayStatsEvents => 'EVENTS';

  @override
  String get relayStatsUptime => 'UPTIME';

  @override
  String get shareRelayBackupSubject => 'Nostr Relay Database Backup';

  @override
  String get shareRelayBackupIosText => 'Nostr Relay Database Backup\n\nTap \"Save to Files\" to save to Files app.';

  @override
  String get shareRelayBackupIosSnackbar => 'Database exported as ZIP file. Use \"Save to Files\" in the share sheet to save.';

  @override
  String databaseExportedToIosHint(String path) {
    return 'Database exported to: $path\n\nYou can access it via Files app > On My iPhone > Aegis';
  }

  @override
  String get shareRelayBackupAndroidText => 'Nostr Relay Database Backup\n\nChoose where to save the ZIP file.';

  @override
  String get shareRelayBackupAndroidSnackbar => 'Database exported as ZIP file. Choose where to save in the share sheet.';

  @override
  String get protocolWs => 'WS';

  @override
  String get protocolWss => 'WSS';

  @override
  String get confirmLiteral => 'confirm';

  @override
  String get errorCannotDetermineHomeDir => 'Cannot determine home directory';

  @override
  String get errorZipFileNotFound => 'ZIP file not found';

  @override
  String get unitBytes => 'B';

  @override
  String get unitKB => 'KB';

  @override
  String get unitMB => 'MB';

  @override
  String get unitGB => 'GB';

  @override
  String get durationZero => '0s';

  @override
  String get durationDayShort => 'd';

  @override
  String get durationHourShort => 'h';

  @override
  String get durationMinuteShort => 'm';

  @override
  String get durationSecondShort => 's';

  @override
  String get noResultsFound => 'Nenalezeny žádné výsledky';

  @override
  String get pleaseSelectApplication => 'Vyberte aplikaci';

  @override
  String get orEnterCustomName => 'Nebo zadejte vlastní název';

  @override
  String get continueButton => 'Pokračovat';
}
