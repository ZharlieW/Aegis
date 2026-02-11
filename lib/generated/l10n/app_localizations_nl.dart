// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get settings => 'Instellingen';

  @override
  String get logout => 'Uitloggen';

  @override
  String get login => 'Inloggen';

  @override
  String get usePrivateKey => 'Gebruik uw privésleutel';

  @override
  String get setupAegisWithNsec => 'Stel Aegis in met uw Nostr-privésleutel — ondersteunt nsec-, ncryptsec- en hex-formaten.';

  @override
  String get privateKey => 'Privésleutel';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex-sleutel';

  @override
  String get password => 'Wachtwoord';

  @override
  String get passwordHint => 'Voer wachtwoord in om ncryptsec te decoderen';

  @override
  String get contentCannotBeEmpty => 'De inhoud mag niet leeg zijn!';

  @override
  String get passwordRequiredForNcryptsec => 'Wachtwoord is vereist voor ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Decoderen van ncryptsec mislukt. Controleer uw wachtwoord.';

  @override
  String get invalidPrivateKeyFormat => 'Ongeldig privésleutelformaat!';

  @override
  String get loginSuccess => 'Inloggen geslaagd!';

  @override
  String loginFailed(String message) {
    return 'Inloggen mislukt: $message';
  }

  @override
  String get typeConfirmToProceed => 'Typ \"confirm\" om door te gaan';

  @override
  String get logoutConfirm => 'Weet u zeker dat u wilt uitloggen?';

  @override
  String get notLoggedIn => 'Niet ingelogd';

  @override
  String get language => 'Taal';

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
  String get addAccount => 'Account toevoegen';

  @override
  String get updateSuccessful => 'Bijwerken geslaagd!';

  @override
  String get switchAccount => 'Account wisselen';

  @override
  String get switchAccountConfirm => 'Weet u zeker dat u van account wilt wisselen?';

  @override
  String get switchSuccessfully => 'Succesvol gewisseld!';

  @override
  String get renameAccount => 'Account hernoemen';

  @override
  String get accountName => 'Accountnaam';

  @override
  String get enterNewName => 'Voer nieuwe naam in';

  @override
  String get accounts => 'Accounts';

  @override
  String get localRelay => 'Lokale relay';

  @override
  String get remote => 'Op afstand';

  @override
  String get browser => 'Browser';

  @override
  String get theme => 'Thema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versie';

  @override
  String get appSubtitle => 'Aegis - Nostr-ondertekenaar';

  @override
  String get darkMode => 'Donkere modus';

  @override
  String get lightMode => 'Lichte modus';

  @override
  String get systemDefault => 'Systeemstandaard';

  @override
  String switchedTo(String mode) {
    return 'Gewisseld naar $mode';
  }

  @override
  String get home => 'Start';

  @override
  String get waitingForRelayStart => 'Wachten op start van relay...';

  @override
  String get connected => 'Verbonden';

  @override
  String get disconnected => 'Verbinding verbroken';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Fout bij laden van NIP-07-applicaties: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Nog geen NIP-07-applicaties.\n\nGebruik Browser om Nostr-apps te openen!';

  @override
  String get unknown => 'Onbekend';

  @override
  String get active => 'Actief';

  @override
  String get congratulationsEmptyState => 'Gefeliciteerd!\n\nU kunt nu apps gebruiken die Aegis ondersteunen!';

  @override
  String localRelayPortInUse(String port) {
    return 'De lokale relay is ingesteld op poort $port, maar een andere app gebruikt deze poort al. Sluit de conflicterende app en probeer het opnieuw.';
  }

  @override
  String get nip46Started => 'NIP-46-ondertekenaar gestart!';

  @override
  String get nip46FailedToStart => 'Starten mislukt.';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get clear => 'Wissen';

  @override
  String get clearDatabase => 'Database wissen';

  @override
  String get clearDatabaseConfirm => 'Dit verwijdert alle relaygegevens en herstart de relay als deze draait. Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get importDatabase => 'Database importeren';

  @override
  String get importDatabaseHint => 'Voer het pad naar de te importeren databasemap in. De bestaande database wordt vóór import geback-upt.';

  @override
  String get databaseDirectoryPath => 'Pad naar databasemap';

  @override
  String get import => 'Importeren';

  @override
  String get export => 'Exporteren';

  @override
  String get restart => 'Herstarten';

  @override
  String get restartRelay => 'Relay herstarten';

  @override
  String get restartRelayConfirm => 'Weet u zeker dat u de relay wilt herstarten? De relay wordt tijdelijk gestopt en daarna herstart.';

  @override
  String get relayRestartedSuccess => 'Relay succesvol herstart';

  @override
  String relayRestartFailed(String message) {
    return 'Herstarten van relay mislukt: $message';
  }

  @override
  String get databaseClearedSuccess => 'Database succesvol gewist';

  @override
  String get databaseClearFailed => 'Database wissen mislukt';

  @override
  String errorWithMessage(String message) {
    return 'Fout: $message';
  }

  @override
  String get exportDatabase => 'Database exporteren';

  @override
  String get exportDatabaseHint => 'De relaydatabase wordt geëxporteerd als ZIP-bestand. Het exporteren kan even duren.';

  @override
  String databaseExportedTo(String path) {
    return 'Database geëxporteerd naar: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Database geëxporteerd als ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Database exporteren mislukt';

  @override
  String get importDatabaseReplaceHint => 'Dit vervangt de huidige database door de geïmporteerde back-up. De bestaande database wordt vóór import geback-upt. Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get selectDatabaseBackupFile => 'Selecteer databaseback-upbestand (ZIP) of map';

  @override
  String get selectDatabaseBackupDir => 'Selecteer databaseback-upmap';

  @override
  String get fileOrDirNotExist => 'Geselecteerd bestand of map bestaat niet';

  @override
  String get databaseImportedSuccess => 'Database succesvol geïmporteerd';

  @override
  String get databaseImportFailed => 'Database importeren mislukt';

  @override
  String get status => 'Status';

  @override
  String get address => 'Adres';

  @override
  String get protocol => 'Protocol';

  @override
  String get connections => 'Verbindingen';

  @override
  String get running => 'Actief';

  @override
  String get stopped => 'Gestopt';

  @override
  String get addressCopiedToClipboard => 'Adres gekopieerd naar klembord';

  @override
  String get exportData => 'Gegevens exporteren';

  @override
  String get importData => 'Gegevens importeren';

  @override
  String get systemLogs => 'Systeemlogboeken';

  @override
  String get clearAllRelayData => 'Alle relaygegevens wissen';

  @override
  String get noLogsAvailable => 'Geen logboeken beschikbaar';

  @override
  String get passwordRequired => 'Wachtwoord is vereist';

  @override
  String encryptionFailed(String message) {
    return 'Versleuteling mislukt: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Versleutelde privésleutel gekopieerd naar klembord';

  @override
  String get accountBackup => 'Accountback-up';

  @override
  String get publicAccountId => 'Openbaar account-ID';

  @override
  String get accountPrivateKey => 'Privésleutel account';

  @override
  String get show => 'Tonen';

  @override
  String get generate => 'Genereren';

  @override
  String get enterEncryptionPassword => 'Voer versleutelingswachtwoord in';

  @override
  String get privateKeyEncryption => 'Versleuteling privésleutel';

  @override
  String get encryptPrivateKeyHint => 'Versleutel uw privésleutel voor meer beveiliging. De sleutel wordt met een wachtwoord versleuteld.';

  @override
  String get ncryptsecHint => 'De versleutelde sleutel begint met \"ncryptsec1\" en kan niet worden gebruikt zonder wachtwoord.';

  @override
  String get encryptAndCopyPrivateKey => 'Privésleutel versleutelen en kopiëren';

  @override
  String get privateKeyEncryptedSuccess => 'Privésleutel succesvol versleuteld!';

  @override
  String get encryptedKeyNcryptsec => 'Versleutelde sleutel (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Nieuw Nostr-account aanmaken';

  @override
  String get accountReadyPublicKeyHint => 'Uw Nostr-account is klaar! Dit is uw nostr-publieke sleutel:';

  @override
  String get nostrPubkey => 'Nostr-publieke sleutel';

  @override
  String get create => 'Aanmaken';

  @override
  String get createSuccess => 'Succesvol aangemaakt!';

  @override
  String get application => 'Applicatie';

  @override
  String get createApplication => 'Applicatie aanmaken';

  @override
  String get addNewApplication => 'Nieuwe applicatie toevoegen';

  @override
  String get addNsecbunkerManually => 'Nsecbunker handmatig toevoegen';

  @override
  String get loginUsingUrlScheme => 'Inloggen via URL-schema';

  @override
  String get addApplicationMethodsHint => 'U kunt een van deze methoden kiezen om met Aegis te verbinden!';

  @override
  String get urlSchemeLoginHint => 'Open met een app die het Aegis-URL-schema ondersteunt om in te loggen';

  @override
  String get name => 'Naam';

  @override
  String get applicationInfo => 'Applicatie-info';

  @override
  String get activities => 'Activiteiten';

  @override
  String get clientPubkey => 'Publieke sleutel client';

  @override
  String get remove => 'Verwijderen';

  @override
  String get removeAppConfirm => 'Weet u zeker dat u alle rechten van deze applicatie wilt verwijderen?';

  @override
  String get removeSuccess => 'Succesvol verwijderd';

  @override
  String get nameCannotBeEmpty => 'De naam mag niet leeg zijn';

  @override
  String get nameTooLong => 'De naam is te lang.';

  @override
  String get updateSuccess => 'Bijwerken geslaagd';

  @override
  String get editConfiguration => 'Configuratie bewerken';

  @override
  String get update => 'Bijwerken';

  @override
  String get search => 'Zoeken...';

  @override
  String get enterCustomName => 'Voer een aangepaste naam in';

  @override
  String get selectApplication => 'Selecteer een applicatie';

  @override
  String get addWebApp => 'Webapp toevoegen';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Mijn app';

  @override
  String get add => 'Toevoegen';

  @override
  String get searchNostrApps => 'Nostr-apps zoeken...';

  @override
  String get invalidUrlHint => 'Ongeldige URL. Voer een geldige HTTP- of HTTPS-URL in.';

  @override
  String get appAlreadyInList => 'Deze app staat al in de lijst.';

  @override
  String appAdded(String name) {
    return '$name toegevoegd';
  }

  @override
  String appAddFailed(String error) {
    return 'App toevoegen mislukt: $error';
  }

  @override
  String get deleteApp => 'App verwijderen';

  @override
  String deleteAppConfirm(String name) {
    return 'Weet u zeker dat u \"$name\" wilt verwijderen?';
  }

  @override
  String get delete => 'Verwijderen';

  @override
  String appDeleted(String name) {
    return '$name verwijderd';
  }

  @override
  String appDeleteFailed(String error) {
    return 'App verwijderen mislukt: $error';
  }

  @override
  String get copiedToClipboard => 'Gekopieerd naar klembord';

  @override
  String get eventDetails => 'Details gebeurtenis';

  @override
  String get eventDetailsCopiedToClipboard => 'Details gebeurtenis gekopieerd naar klembord';

  @override
  String get rawMetadataCopiedToClipboard => 'Ruwe metadata gekopieerd naar klembord';

  @override
  String get permissionRequest => 'Machtigingsverzoek';

  @override
  String get permissionRequestContent => 'Deze applicatie vraagt toestemming om uw Nostr-account te openen';

  @override
  String get grantPermissions => 'Machtigingen verlenen';

  @override
  String get reject => 'Weigeren';

  @override
  String get fullAccessGranted => 'Volledige toegang verleend';

  @override
  String get fullAccessHint => 'Deze applicatie krijgt volledige toegang tot uw Nostr-account, waaronder:';

  @override
  String get permissionAccessPubkey => 'Toegang tot uw Nostr-publieke sleutel';

  @override
  String get permissionSignEvents => 'Nostr-gebeurtenissen ondertekenen';

  @override
  String get permissionEncryptDecrypt => 'Gebeurtenissen versleutelen en ontsleutelen (NIP-04 & NIP-44)';

  @override
  String get tips => 'Tips';

  @override
  String get schemeLoginFirst => 'Schema kan niet worden opgelost, log eerst in.';

  @override
  String get newConnectionRequest => 'Nieuwe verbindingsaanvraag';

  @override
  String get newConnectionNoSlotHint => 'Een nieuwe applicatie probeert verbinding te maken, maar er is geen ongebruikte applicatie beschikbaar. Maak eerst een nieuwe applicatie aan.';

  @override
  String get copiedSuccessfully => 'Succesvol gekopieerd';

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
  String get noResultsFound => 'Geen resultaten gevonden';

  @override
  String get pleaseSelectApplication => 'Selecteer een toepassing';

  @override
  String get orEnterCustomName => 'Of voer een aangepaste naam in';

  @override
  String get continueButton => 'Doorgaan';
}
