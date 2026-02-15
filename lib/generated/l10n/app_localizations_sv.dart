// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Bekräfta';

  @override
  String get cancel => 'Avbryt';

  @override
  String get settings => 'Inställningar';

  @override
  String get logout => 'Logga ut';

  @override
  String get login => 'Logga in';

  @override
  String get usePrivateKey => 'Använd din privata nyckel';

  @override
  String get setupAegisWithNsec => 'Konfigurera Aegis med din Nostr-privata nyckel — stöder nsec-, ncryptsec- och hex-format.';

  @override
  String get privateKey => 'Privat nyckel';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex-nyckel';

  @override
  String get password => 'Lösenord';

  @override
  String get passwordHint => 'Ange lösenord för att dekryptera ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Innehållet kan inte vara tomt!';

  @override
  String get passwordRequiredForNcryptsec => 'Lösenord krävs för ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Kunde inte dekryptera ncryptsec. Kontrollera ditt lösenord.';

  @override
  String get invalidPrivateKeyFormat => 'Ogiltigt format för privat nyckel!';

  @override
  String get loginSuccess => 'Inloggning lyckades!';

  @override
  String loginFailed(String message) {
    return 'Inloggning misslyckades: $message';
  }

  @override
  String get typeConfirmToProceed => 'Skriv \"confirm\" för att fortsätta';

  @override
  String get logoutConfirm => 'Är du säker på att du vill logga ut?';

  @override
  String get notLoggedIn => 'Inte inloggad';

  @override
  String get language => 'Språk';

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
  String get addAccount => 'Lägg till konto';

  @override
  String get updateSuccessful => 'Uppdatering lyckades!';

  @override
  String get switchAccount => 'Byt konto';

  @override
  String get switchAccountConfirm => 'Är du säker på att du vill byta konto?';

  @override
  String get switchSuccessfully => 'Byt lyckades!';

  @override
  String get renameAccount => 'Byt namn på konto';

  @override
  String get accountName => 'Kontonamn';

  @override
  String get enterNewName => 'Ange nytt namn';

  @override
  String get accounts => 'Konton';

  @override
  String get localRelay => 'Lokal relay';

  @override
  String get remote => 'Fjärr';

  @override
  String get browser => 'Webbläsare';

  @override
  String get theme => 'Tema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Version';

  @override
  String get appSubtitle => 'Aegis — Nostr-signerare';

  @override
  String get darkMode => 'Mörkt läge';

  @override
  String get lightMode => 'Ljust läge';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String switchedTo(String mode) {
    return 'Bytt till $mode';
  }

  @override
  String get home => 'Hem';

  @override
  String get waitingForRelayStart => 'Väntar på att relay ska starta...';

  @override
  String get connected => 'Ansluten';

  @override
  String get disconnected => 'Frånkopplad';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Fel vid laddning av NIP-07-appar: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Inga NIP-07-appar ännu.\n\nAnvänd webbläsaren för att öppna Nostr-appar!';

  @override
  String get unknown => 'Okänd';

  @override
  String get active => 'Aktiv';

  @override
  String get congratulationsEmptyState => 'Grattis!\n\nNu kan du börja använda appar som stöder Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Den lokala relayn är inställd på port $port, men en annan app verkar redan använda den. Stäng den konflikterande appen och försök igen.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'NIP-46-signerare startad!';

  @override
  String get nip46FailedToStart => 'Start misslyckades.';

  @override
  String get retry => 'Försök igen';

  @override
  String get clear => 'Rensa';

  @override
  String get clearDatabase => 'Rensa databas';

  @override
  String get clearDatabaseConfirm => 'Detta tar bort all relaydata och startar om relayn om den körs. Denna åtgärd kan inte ångras.';

  @override
  String get importDatabase => 'Importera databas';

  @override
  String get importDatabaseHint => 'Ange sökvägen till databasmappen som ska importeras. Befintlig databas säkerhetskopieras före import.';

  @override
  String get databaseDirectoryPath => 'Sökväg till databasmapp';

  @override
  String get import => 'Importera';

  @override
  String get export => 'Exportera';

  @override
  String get restart => 'Starta om';

  @override
  String get restartRelay => 'Starta om relay';

  @override
  String get restartRelayConfirm => 'Är du säker på att du vill starta om relayn? Relayn stoppas tillfälligt och startas sedan om.';

  @override
  String get relayRestartedSuccess => 'Relayn startades om';

  @override
  String relayRestartFailed(String message) {
    return 'Kunde inte starta om relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Databas rensad';

  @override
  String get databaseClearFailed => 'Kunde inte rensa databas';

  @override
  String errorWithMessage(String message) {
    return 'Fel: $message';
  }

  @override
  String get exportDatabase => 'Exportera databas';

  @override
  String get exportDatabaseHint => 'Relaydatabasen exporteras som ZIP-fil. Exporten kan ta en stund.';

  @override
  String databaseExportedTo(String path) {
    return 'Databas exporterad till: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Databas exporterad som ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Kunde inte exportera databas';

  @override
  String get importDatabaseReplaceHint => 'Detta ersätter den nuvarande databasen med den importerade säkerhetskopian. Befintlig databas säkerhetskopieras före import. Denna åtgärd kan inte ångras.';

  @override
  String get selectDatabaseBackupFile => 'Välj databassäkerhetskopiefil (ZIP) eller mapp';

  @override
  String get selectDatabaseBackupDir => 'Välj databassäkerhetskopiemapp';

  @override
  String get fileOrDirNotExist => 'Vald fil eller mapp finns inte';

  @override
  String get databaseImportedSuccess => 'Databas importerad';

  @override
  String get databaseImportFailed => 'Kunde inte importera databas';

  @override
  String get status => 'Status';

  @override
  String get address => 'Adress';

  @override
  String get protocol => 'Protokoll';

  @override
  String get connections => 'Anslutningar';

  @override
  String get running => 'Kör';

  @override
  String get stopped => 'Stoppad';

  @override
  String get addressCopiedToClipboard => 'Adress kopierad till urklipp';

  @override
  String get exportData => 'Exportera data';

  @override
  String get importData => 'Importera data';

  @override
  String get systemLogs => 'Systemloggar';

  @override
  String get clearAllRelayData => 'Rensa all relaydata';

  @override
  String get noLogsAvailable => 'Inga loggar tillgängliga';

  @override
  String get passwordRequired => 'Lösenord krävs';

  @override
  String encryptionFailed(String message) {
    return 'Kryptering misslyckades: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Krypterad privat nyckel kopierad till urklipp';

  @override
  String get accountBackup => 'Kontosäkerhetskopia';

  @override
  String get publicAccountId => 'Offentligt konto-ID';

  @override
  String get accountPrivateKey => 'Kontots privata nyckel';

  @override
  String get show => 'Visa';

  @override
  String get generate => 'Generera';

  @override
  String get enterEncryptionPassword => 'Ange krypteringslösenord';

  @override
  String get privateKeyEncryption => 'Kryptering av privat nyckel';

  @override
  String get encryptPrivateKeyHint => 'Kryptera din privata nyckel för ökad säkerhet. Nyckeln krypteras med ett lösenord.';

  @override
  String get ncryptsecHint => 'Den krypterade nyckeln börjar med \"ncryptsec1\" och kan inte användas utan lösenord.';

  @override
  String get encryptAndCopyPrivateKey => 'Kryptera och kopiera privat nyckel';

  @override
  String get privateKeyEncryptedSuccess => 'Privat nyckel krypterad!';

  @override
  String get encryptedKeyNcryptsec => 'Krypterad nyckel (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Skapa nytt Nostr-konto';

  @override
  String get accountReadyPublicKeyHint => 'Ditt Nostr-konto är klart! Detta är din nostr-offentliga nyckel:';

  @override
  String get nostrPubkey => 'Nostr-offentlig nyckel';

  @override
  String get create => 'Skapa';

  @override
  String get createSuccess => 'Skapad!';

  @override
  String get application => 'Applikation';

  @override
  String get createApplication => 'Skapa applikation';

  @override
  String get addNewApplication => 'Lägg till ny applikation';

  @override
  String get addNsecbunkerManually => 'Lägg till nsecbunker manuellt';

  @override
  String get loginUsingUrlScheme => 'Logga in med URL-schema';

  @override
  String get addApplicationMethodsHint => 'Du kan välja någon av dessa metoder för att ansluta till Aegis!';

  @override
  String get urlSchemeLoginHint => 'Öppna med en app som stöder Aegis URL-schema för att logga in';

  @override
  String get name => 'Namn';

  @override
  String get applicationInfo => 'Applikationsinfo';

  @override
  String get activities => 'Aktiviteter';

  @override
  String get clientPubkey => 'Klientens offentliga nyckel';

  @override
  String get remove => 'Ta bort';

  @override
  String get removeAppConfirm => 'Är du säker på att du vill ta bort alla behörigheter från denna applikation?';

  @override
  String get removeSuccess => 'Borttagen';

  @override
  String get nameCannotBeEmpty => 'Namnet kan inte vara tomt';

  @override
  String get nameTooLong => 'Namnet är för långt.';

  @override
  String get updateSuccess => 'Uppdatering lyckades';

  @override
  String get editConfiguration => 'Redigera konfiguration';

  @override
  String get update => 'Uppdatera';

  @override
  String get search => 'Sök...';

  @override
  String get enterCustomName => 'Ange anpassat namn';

  @override
  String get selectApplication => 'Välj en applikation';

  @override
  String get addWebApp => 'Lägg till webbapp';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Min app';

  @override
  String get add => 'Lägg till';

  @override
  String get searchNostrApps => 'Sök Nostr-appar...';

  @override
  String get invalidUrlHint => 'Ogiltig URL. Ange en giltig HTTP- eller HTTPS-URL.';

  @override
  String get appAlreadyInList => 'Denna app finns redan i listan.';

  @override
  String appAdded(String name) {
    return '$name tillagd';
  }

  @override
  String appAddFailed(String error) {
    return 'Kunde inte lägga till app: $error';
  }

  @override
  String get deleteApp => 'Ta bort app';

  @override
  String deleteAppConfirm(String name) {
    return 'Är du säker på att du vill ta bort \"$name\"?';
  }

  @override
  String get delete => 'Ta bort';

  @override
  String appDeleted(String name) {
    return '$name borttagen';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Kunde inte ta bort app: $error';
  }

  @override
  String get copiedToClipboard => 'Kopierad till urklipp';

  @override
  String get eventDetails => 'Händelsedetaljer';

  @override
  String get eventDetailsCopiedToClipboard => 'Händelsedetaljer kopierade till urklipp';

  @override
  String get rawMetadataCopiedToClipboard => 'Rå metadata kopierad till urklipp';

  @override
  String get permissionRequest => 'Behörighetsbegäran';

  @override
  String get permissionRequestContent => 'Denna applikation begär behörighet att komma åt ditt Nostr-konto';

  @override
  String get grantPermissions => 'Bevilja behörigheter';

  @override
  String get reject => 'Avvisa';

  @override
  String get fullAccessGranted => 'Full åtkomst beviljad';

  @override
  String get fullAccessHint => 'Denna applikation får full åtkomst till ditt Nostr-konto, inklusive:';

  @override
  String get permissionAccessPubkey => 'Åtkomst till din Nostr-offentliga nyckel';

  @override
  String get permissionSignEvents => 'Signera Nostr-händelser';

  @override
  String get permissionEncryptDecrypt => 'Kryptera och dekryptera händelser (NIP-04 och NIP-44)';

  @override
  String get tips => 'Tips';

  @override
  String get schemeLoginFirst => 'Kan inte lösa schema, logga in först.';

  @override
  String get newConnectionRequest => 'Ny anslutningsbegäran';

  @override
  String get newConnectionNoSlotHint => 'En ny applikation försöker ansluta, men ingen ledig applikation finns. Skapa först en ny applikation.';

  @override
  String get copiedSuccessfully => 'Kopierat';

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
  String get noResultsFound => 'Inga resultat hittades';

  @override
  String get pleaseSelectApplication => 'Välj en applikation';

  @override
  String get orEnterCustomName => 'Eller ange ett anpassat namn';

  @override
  String get continueButton => 'Fortsätt';
}
