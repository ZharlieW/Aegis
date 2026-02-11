// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Bekræft';

  @override
  String get cancel => 'Annuller';

  @override
  String get settings => 'Indstillinger';

  @override
  String get logout => 'Log ud';

  @override
  String get login => 'Log ind';

  @override
  String get usePrivateKey => 'Brug din private nøgle';

  @override
  String get setupAegisWithNsec => 'Konfigurer Aegis med din Nostr private nøgle — understøtter nsec-, ncryptsec- og hex-formater.';

  @override
  String get privateKey => 'Privat nøgle';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex nøgle';

  @override
  String get password => 'Adgangskode';

  @override
  String get passwordHint => 'Indtast adgangskode for at dekryptere ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Indholdet kan ikke være tomt!';

  @override
  String get passwordRequiredForNcryptsec => 'Adgangskode kræves til ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Kunne ikke dekryptere ncryptsec. Tjek din adgangskode.';

  @override
  String get invalidPrivateKeyFormat => 'Ugyldigt format for privat nøgle!';

  @override
  String get loginSuccess => 'Login lykkedes!';

  @override
  String loginFailed(String message) {
    return 'Login mislykkedes: $message';
  }

  @override
  String get typeConfirmToProceed => 'Skriv \"confirm\" for at fortsætte';

  @override
  String get logoutConfirm => 'Er du sikker på, at du vil logge ud?';

  @override
  String get notLoggedIn => 'Ikke logget ind';

  @override
  String get language => 'Sprog';

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
  String get addAccount => 'Tilføj konto';

  @override
  String get updateSuccessful => 'Opdatering lykkedes!';

  @override
  String get switchAccount => 'Skift konto';

  @override
  String get switchAccountConfirm => 'Er du sikker på, at du vil skifte konto?';

  @override
  String get switchSuccessfully => 'Skift lykkedes!';

  @override
  String get renameAccount => 'Omdøb konto';

  @override
  String get accountName => 'Kontonavn';

  @override
  String get enterNewName => 'Indtast nyt navn';

  @override
  String get accounts => 'Konti';

  @override
  String get localRelay => 'Lokal relay';

  @override
  String get remote => 'Fjern';

  @override
  String get browser => 'Browser';

  @override
  String get theme => 'Tema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Version';

  @override
  String get appSubtitle => 'Aegis — Nostr-signatur';

  @override
  String get darkMode => 'Mørk tilstand';

  @override
  String get lightMode => 'Lys tilstand';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String switchedTo(String mode) {
    return 'Skiftet til $mode';
  }

  @override
  String get home => 'Hjem';

  @override
  String get waitingForRelayStart => 'Venter på, at relay starter...';

  @override
  String get connected => 'Forbundet';

  @override
  String get disconnected => 'Frakoblet';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Fejl ved indlæsning af NIP-07-apps: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Ingen NIP-07-apps endnu.\n\nBrug browser til at åbne Nostr-apps!';

  @override
  String get unknown => 'Ukendt';

  @override
  String get active => 'Aktiv';

  @override
  String get congratulationsEmptyState => 'Tillykke!\n\nNu kan du bruge apps, der understøtter Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Den lokale relay er sat til port $port, men en anden app bruger den tilsyneladende allerede. Luk den konflikterende app og prøv igen.';
  }

  @override
  String get nip46Started => 'NIP-46-signatur startet!';

  @override
  String get nip46FailedToStart => 'Start mislykkedes.';

  @override
  String get retry => 'Prøv igen';

  @override
  String get clear => 'Ryd';

  @override
  String get clearDatabase => 'Ryd database';

  @override
  String get clearDatabaseConfirm => 'Dette sletter alle relay-data og genstarter relayen, hvis den kører. Denne handling kan ikke fortrydes.';

  @override
  String get importDatabase => 'Importer database';

  @override
  String get importDatabaseHint => 'Indtast stien til databasemappen, der skal importeres. Eksisterende database sikkerhedskopieres før import.';

  @override
  String get databaseDirectoryPath => 'Sti til databasemappe';

  @override
  String get import => 'Importer';

  @override
  String get export => 'Eksporter';

  @override
  String get restart => 'Genstart';

  @override
  String get restartRelay => 'Genstart relay';

  @override
  String get restartRelayConfirm => 'Er du sikker på, at du vil genstarte relayen? Relayen stoppes midlertidigt og genstartes derefter.';

  @override
  String get relayRestartedSuccess => 'Relay genstartet';

  @override
  String relayRestartFailed(String message) {
    return 'Kunne ikke genstarte relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Database ryddet';

  @override
  String get databaseClearFailed => 'Kunne ikke rydde database';

  @override
  String errorWithMessage(String message) {
    return 'Fejl: $message';
  }

  @override
  String get exportDatabase => 'Eksporter database';

  @override
  String get exportDatabaseHint => 'Relay-databasen eksporteres som ZIP-fil. Eksporten kan tage et øjeblik.';

  @override
  String databaseExportedTo(String path) {
    return 'Database eksporteret til: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Database eksporteret som ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Kunne ikke eksportere database';

  @override
  String get importDatabaseReplaceHint => 'Dette erstatter den nuværende database med den importerede sikkerhedskopi. Eksisterende database sikkerhedskopieres før import. Denne handling kan ikke fortrydes.';

  @override
  String get selectDatabaseBackupFile => 'Vælg database-sikkerhedskopifil (ZIP) eller mappe';

  @override
  String get selectDatabaseBackupDir => 'Vælg database-sikkerhedskopimappe';

  @override
  String get fileOrDirNotExist => 'Valgt fil eller mappe findes ikke';

  @override
  String get databaseImportedSuccess => 'Database importeret';

  @override
  String get databaseImportFailed => 'Kunne ikke importere database';

  @override
  String get status => 'Status';

  @override
  String get address => 'Adresse';

  @override
  String get protocol => 'Protokol';

  @override
  String get connections => 'Forbindelser';

  @override
  String get running => 'Kører';

  @override
  String get stopped => 'Stoppet';

  @override
  String get addressCopiedToClipboard => 'Adresse kopieret til udklipsholder';

  @override
  String get exportData => 'Eksporter data';

  @override
  String get importData => 'Importer data';

  @override
  String get systemLogs => 'Systemlogfiler';

  @override
  String get clearAllRelayData => 'Ryd alle relay-data';

  @override
  String get noLogsAvailable => 'Ingen logfiler tilgængelige';

  @override
  String get passwordRequired => 'Adgangskode kræves';

  @override
  String encryptionFailed(String message) {
    return 'Kryptering mislykkedes: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Krypteret privat nøgle kopieret til udklipsholder';

  @override
  String get accountBackup => 'Kontosikkerhedskopi';

  @override
  String get publicAccountId => 'Offentligt konto-ID';

  @override
  String get accountPrivateKey => 'Kontos private nøgle';

  @override
  String get show => 'Vis';

  @override
  String get generate => 'Generer';

  @override
  String get enterEncryptionPassword => 'Indtast krypteringsadgangskode';

  @override
  String get privateKeyEncryption => 'Kryptering af privat nøgle';

  @override
  String get encryptPrivateKeyHint => 'Krypter din private nøgle for øget sikkerhed. Nøglen krypteres med en adgangskode.';

  @override
  String get ncryptsecHint => 'Den krypterede nøgle starter med \"ncryptsec1\" og kan ikke bruges uden adgangskode.';

  @override
  String get encryptAndCopyPrivateKey => 'Krypter og kopiér privat nøgle';

  @override
  String get privateKeyEncryptedSuccess => 'Privat nøgle krypteret!';

  @override
  String get encryptedKeyNcryptsec => 'Krypteret nøgle (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Opret ny Nostr-konto';

  @override
  String get accountReadyPublicKeyHint => 'Din Nostr-konto er klar! Dette er din nostr offentlige nøgle:';

  @override
  String get nostrPubkey => 'Nostr offentlig nøgle';

  @override
  String get create => 'Opret';

  @override
  String get createSuccess => 'Oprettet!';

  @override
  String get application => 'Applikation';

  @override
  String get createApplication => 'Opret applikation';

  @override
  String get addNewApplication => 'Tilføj ny applikation';

  @override
  String get addNsecbunkerManually => 'Tilføj nsecbunker manuelt';

  @override
  String get loginUsingUrlScheme => 'Log ind med URL-skema';

  @override
  String get addApplicationMethodsHint => 'Du kan vælge en af disse metoder til at forbinde med Aegis!';

  @override
  String get urlSchemeLoginHint => 'Åbn med en app, der understøtter Aegis URL-skema for at logge ind';

  @override
  String get name => 'Navn';

  @override
  String get applicationInfo => 'Applikationsinfo';

  @override
  String get activities => 'Aktiviteter';

  @override
  String get clientPubkey => 'Klientens offentlige nøgle';

  @override
  String get remove => 'Fjern';

  @override
  String get removeAppConfirm => 'Er du sikker på, at du vil fjerne alle tilladelser fra denne applikation?';

  @override
  String get removeSuccess => 'Fjernet';

  @override
  String get nameCannotBeEmpty => 'Navnet kan ikke være tomt';

  @override
  String get nameTooLong => 'Navnet er for langt.';

  @override
  String get updateSuccess => 'Opdatering lykkedes';

  @override
  String get editConfiguration => 'Rediger konfiguration';

  @override
  String get update => 'Opdater';

  @override
  String get search => 'Søg...';

  @override
  String get enterCustomName => 'Indtast brugerdefineret navn';

  @override
  String get selectApplication => 'Vælg en applikation';

  @override
  String get addWebApp => 'Tilføj webapp';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Min app';

  @override
  String get add => 'Tilføj';

  @override
  String get searchNostrApps => 'Søg Nostr-apps...';

  @override
  String get invalidUrlHint => 'Ugyldig URL. Indtast en gyldig HTTP- eller HTTPS-URL.';

  @override
  String get appAlreadyInList => 'Denne app er allerede på listen.';

  @override
  String appAdded(String name) {
    return '$name tilføjet';
  }

  @override
  String appAddFailed(String error) {
    return 'Kunne ikke tilføje app: $error';
  }

  @override
  String get deleteApp => 'Slet app';

  @override
  String deleteAppConfirm(String name) {
    return 'Er du sikker på, at du vil slette \"$name\"?';
  }

  @override
  String get delete => 'Slet';

  @override
  String appDeleted(String name) {
    return '$name slettet';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Kunne ikke slette app: $error';
  }

  @override
  String get copiedToClipboard => 'Kopieret til udklipsholder';

  @override
  String get eventDetails => 'Begivenhedsdetaljer';

  @override
  String get eventDetailsCopiedToClipboard => 'Begivenhedsdetaljer kopieret til udklipsholder';

  @override
  String get rawMetadataCopiedToClipboard => 'Rå metadata kopieret til udklipsholder';

  @override
  String get permissionRequest => 'Tilladelsesanmodning';

  @override
  String get permissionRequestContent => 'Denne applikation anmoder om tilladelse til at få adgang til din Nostr-konto';

  @override
  String get grantPermissions => 'Giv tilladelser';

  @override
  String get reject => 'Afvis';

  @override
  String get fullAccessGranted => 'Fuld adgang givet';

  @override
  String get fullAccessHint => 'Denne applikation vil have fuld adgang til din Nostr-konto, herunder:';

  @override
  String get permissionAccessPubkey => 'Adgang til din Nostr offentlige nøgle';

  @override
  String get permissionSignEvents => 'Signer Nostr-begivenheder';

  @override
  String get permissionEncryptDecrypt => 'Krypter og dekrypter begivenheder (NIP-04 og NIP-44)';

  @override
  String get tips => 'Tips';

  @override
  String get schemeLoginFirst => 'Kan ikke løse skema, log ind først.';

  @override
  String get newConnectionRequest => 'Ny forbindelsesanmodning';

  @override
  String get newConnectionNoSlotHint => 'En ny applikation forsøger at forbinde, men der er ingen ledig applikation. Opret først en ny applikation.';

  @override
  String get copiedSuccessfully => 'Kopieret';

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
  String get noResultsFound => 'Ingen resultater fundet';

  @override
  String get pleaseSelectApplication => 'Vælg en applikation';

  @override
  String get orEnterCustomName => 'Eller indtast et brugerdefineret navn';

  @override
  String get continueButton => 'Fortsæt';
}
