// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Megerősítés';

  @override
  String get cancel => 'Mégse';

  @override
  String get settings => 'Beállítások';

  @override
  String get logout => 'Kijelentkezés';

  @override
  String get login => 'Bejelentkezés';

  @override
  String get usePrivateKey => 'Privát kulcs használata';

  @override
  String get setupAegisWithNsec => 'Állítsa be az Aegist Nostr privát kulcsával — nsec, ncryptsec és hex formátumokat támogat.';

  @override
  String get privateKey => 'Privát kulcs';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex kulcs';

  @override
  String get password => 'Jelszó';

  @override
  String get passwordHint => 'Adja meg a jelszót az ncryptsec visszafejtéséhez';

  @override
  String get contentCannotBeEmpty => 'A tartalom nem lehet üres!';

  @override
  String get passwordRequiredForNcryptsec => 'Az ncryptsec-hez jelszó szükséges!';

  @override
  String get decryptNcryptsecFailed => 'Az ncryptsec visszafejtése sikertelen. Ellenőrizze a jelszavát.';

  @override
  String get invalidPrivateKeyFormat => 'Érvénytelen privát kulcs formátum!';

  @override
  String get loginSuccess => 'Sikeres bejelentkezés!';

  @override
  String loginFailed(String message) {
    return 'Bejelentkezés sikertelen: $message';
  }

  @override
  String get typeConfirmToProceed => 'Gépelje be a \"confirm\" szöveget a folytatáshoz';

  @override
  String get logoutConfirm => 'Biztosan ki szeretne lépni?';

  @override
  String get notLoggedIn => 'Nincs bejelentkezve';

  @override
  String get language => 'Nyelv';

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
  String get addAccount => 'Fiók hozzáadása';

  @override
  String get updateSuccessful => 'Sikeres frissítés!';

  @override
  String get switchAccount => 'Fiók váltása';

  @override
  String get switchAccountConfirm => 'Biztosan váltani szeretne fiókot?';

  @override
  String get switchSuccessfully => 'Sikeres váltás!';

  @override
  String get renameAccount => 'Fiók átnevezése';

  @override
  String get accountName => 'Fiók neve';

  @override
  String get enterNewName => 'Adja meg az új nevet';

  @override
  String get accounts => 'Fiókok';

  @override
  String get localRelay => 'Helyi relay';

  @override
  String get remote => 'Távoli';

  @override
  String get browser => 'Böngésző';

  @override
  String get theme => 'Téma';

  @override
  String get github => 'Github';

  @override
  String get version => 'Verzió';

  @override
  String get appSubtitle => 'Aegis — Nostr aláíró';

  @override
  String get darkMode => 'Sötét mód';

  @override
  String get lightMode => 'Világos mód';

  @override
  String get systemDefault => 'Rendszer alapértelmezett';

  @override
  String switchedTo(String mode) {
    return 'Átváltva erre: $mode';
  }

  @override
  String get home => 'Kezdőlap';

  @override
  String get waitingForRelayStart => 'Relay indításának várása...';

  @override
  String get connected => 'Csatlakozva';

  @override
  String get disconnected => 'Nincs csatlakozva';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Hiba a NIP-07 alkalmazások betöltésekor: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Még nincsenek NIP-07 alkalmazások.\n\nHasználja a Böngészőt a Nostr alkalmazások eléréséhez!';

  @override
  String get unknown => 'Ismeretlen';

  @override
  String get active => 'Aktív';

  @override
  String get congratulationsEmptyState => 'Gratulálunk!\n\nMost már használhatja az Aegist támogató alkalmazásokat!';

  @override
  String localRelayPortInUse(String port) {
    return 'A helyi relay a $port portot használja, de úgy tűnik, más alkalmazás már használja. Zárja be a konfliktust okozó alkalmazást és próbálja újra.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'NIP-46 aláíró elindult!';

  @override
  String get nip46FailedToStart => 'Indítás sikertelen.';

  @override
  String get retry => 'Újra';

  @override
  String get clear => 'Törlés';

  @override
  String get clearDatabase => 'Adatbázis törlése';

  @override
  String get clearDatabaseConfirm => 'Ez törli az összes relay adatot és újraindítja a relayt, ha fut. Ez a művelet nem vonható vissza.';

  @override
  String get importDatabase => 'Adatbázis importálása';

  @override
  String get importDatabaseHint => 'Adja meg az importálandó adatbázis mappa elérési útját. A meglévő adatbázis mentésre kerül az import előtt.';

  @override
  String get databaseDirectoryPath => 'Adatbázis mappa elérési útja';

  @override
  String get import => 'Importálás';

  @override
  String get export => 'Exportálás';

  @override
  String get restart => 'Újraindítás';

  @override
  String get restartRelay => 'Relay újraindítása';

  @override
  String get restartRelayConfirm => 'Biztosan újra szeretné indítani a relayt? A relay átmenetileg leáll, majd újraindul.';

  @override
  String get relayRestartedSuccess => 'Relay sikeresen újraindítva';

  @override
  String relayRestartFailed(String message) {
    return 'Relay újraindítása sikertelen: $message';
  }

  @override
  String get databaseClearedSuccess => 'Adatbázis sikeresen törölve';

  @override
  String get databaseClearFailed => 'Adatbázis törlése sikertelen';

  @override
  String errorWithMessage(String message) {
    return 'Hiba: $message';
  }

  @override
  String get exportDatabase => 'Adatbázis exportálása';

  @override
  String get exportDatabaseHint => 'A relay adatbázis ZIP fájlként lesz exportálva. Az exportálás eltarthat egy ideig.';

  @override
  String databaseExportedTo(String path) {
    return 'Adatbázis exportálva ide: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Adatbázis ZIP-ként exportálva: $path';
  }

  @override
  String get databaseExportFailed => 'Adatbázis exportálása sikertelen';

  @override
  String get importDatabaseReplaceHint => 'Ez lecseréli a jelenlegi adatbázist az importált mentésre. A meglévő adatbázis mentésre kerül az import előtt. Ez a művelet nem vonható vissza.';

  @override
  String get selectDatabaseBackupFile => 'Válassza ki az adatbázis mentési fájlt (ZIP) vagy mappát';

  @override
  String get selectDatabaseBackupDir => 'Válassza ki az adatbázis mentési mappát';

  @override
  String get fileOrDirNotExist => 'A kiválasztott fájl vagy mappa nem létezik';

  @override
  String get databaseImportedSuccess => 'Adatbázis sikeresen importálva';

  @override
  String get databaseImportFailed => 'Adatbázis importálása sikertelen';

  @override
  String get status => 'Állapot';

  @override
  String get address => 'Cím';

  @override
  String get protocol => 'Protokoll';

  @override
  String get connections => 'Kapcsolatok';

  @override
  String get running => 'Fut';

  @override
  String get stopped => 'Leállítva';

  @override
  String get addressCopiedToClipboard => 'Cím vágólapra másolva';

  @override
  String get exportData => 'Adatok exportálása';

  @override
  String get importData => 'Adatok importálása';

  @override
  String get systemLogs => 'Rendszer naplók';

  @override
  String get clearAllRelayData => 'Összes relay adat törlése';

  @override
  String get noLogsAvailable => 'Nincsenek elérhető naplók';

  @override
  String get passwordRequired => 'Jelszó szükséges';

  @override
  String encryptionFailed(String message) {
    return 'Titkosítás sikertelen: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Titkosított privát kulcs vágólapra másolva';

  @override
  String get accountBackup => 'Fiók mentés';

  @override
  String get publicAccountId => 'Nyilvános fiók azonosító';

  @override
  String get accountPrivateKey => 'Fiók privát kulcsa';

  @override
  String get show => 'Megjelenítés';

  @override
  String get generate => 'Generálás';

  @override
  String get enterEncryptionPassword => 'Adja meg a titkosítási jelszót';

  @override
  String get privateKeyEncryption => 'Privát kulcs titkosítás';

  @override
  String get encryptPrivateKeyHint => 'Titkosítsa a privát kulcsát a biztonság növelése érdekében. A kulcs jelszóval lesz titkosítva.';

  @override
  String get ncryptsecHint => 'A titkosított kulcs \"ncryptsec1\" előtaggal kezdődik és jelszó nélkül nem használható.';

  @override
  String get encryptAndCopyPrivateKey => 'Privát kulcs titkosítása és másolása';

  @override
  String get privateKeyEncryptedSuccess => 'Privát kulcs sikeresen titkosítva!';

  @override
  String get encryptedKeyNcryptsec => 'Titkosított kulcs (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Új Nostr fiók létrehozása';

  @override
  String get accountReadyPublicKeyHint => 'A Nostr fiókja kész! Ez az Ön nostr nyilvános kulcsa:';

  @override
  String get nostrPubkey => 'Nostr nyilvános kulcs';

  @override
  String get create => 'Létrehozás';

  @override
  String get createSuccess => 'Sikeresen létrehozva!';

  @override
  String get application => 'Alkalmazás';

  @override
  String get createApplication => 'Alkalmazás létrehozása';

  @override
  String get addNewApplication => 'Új alkalmazás hozzáadása';

  @override
  String get addNsecbunkerManually => 'Nsecbunker manuális hozzáadása';

  @override
  String get loginUsingUrlScheme => 'Bejelentkezés URL séma használatával';

  @override
  String get addApplicationMethodsHint => 'Ezen módszerek bármelyikével csatlakozhat az Aegishez!';

  @override
  String get urlSchemeLoginHint => 'Nyissa meg egy Aegis URL sémát támogató alkalmazással a bejelentkezéshez';

  @override
  String get name => 'Név';

  @override
  String get applicationInfo => 'Alkalmazás információ';

  @override
  String get activities => 'Tevékenységek';

  @override
  String get clientPubkey => 'Kliens nyilvános kulcs';

  @override
  String get remove => 'Eltávolítás';

  @override
  String get removeAppConfirm => 'Biztosan el szeretné távolítani az összes jogosultságot erről az alkalmazásról?';

  @override
  String get removeSuccess => 'Sikeres eltávolítás';

  @override
  String get nameCannotBeEmpty => 'A név nem lehet üres';

  @override
  String get nameTooLong => 'A név túl hosszú.';

  @override
  String get updateSuccess => 'Sikeres frissítés';

  @override
  String get editConfiguration => 'Konfiguráció szerkesztése';

  @override
  String get update => 'Frissítés';

  @override
  String get search => 'Keresés...';

  @override
  String get enterCustomName => 'Adjon meg egyéni nevet';

  @override
  String get selectApplication => 'Válasszon alkalmazást';

  @override
  String get addWebApp => 'Webalkalmazás hozzáadása';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Az én alkalmazásom';

  @override
  String get add => 'Hozzáadás';

  @override
  String get searchNostrApps => 'Nostr alkalmazások keresése...';

  @override
  String get invalidUrlHint => 'Érvénytelen URL. Adjon meg érvényes HTTP vagy HTTPS URL-t.';

  @override
  String get appAlreadyInList => 'Ez az alkalmazás már szerepel a listában.';

  @override
  String appAdded(String name) {
    return '$name hozzáadva';
  }

  @override
  String appAddFailed(String error) {
    return 'Alkalmazás hozzáadása sikertelen: $error';
  }

  @override
  String get deleteApp => 'Alkalmazás törlése';

  @override
  String deleteAppConfirm(String name) {
    return 'Biztosan törölni szeretné a \"$name\" alkalmazást?';
  }

  @override
  String get delete => 'Törlés';

  @override
  String appDeleted(String name) {
    return '$name törölve';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Alkalmazás törlése sikertelen: $error';
  }

  @override
  String get copiedToClipboard => 'Vágólapra másolva';

  @override
  String get eventDetails => 'Esemény részletei';

  @override
  String get eventDetailsCopiedToClipboard => 'Esemény részletei vágólapra másolva';

  @override
  String get rawMetadataCopiedToClipboard => 'Nyers metaadatok vágólapra másolva';

  @override
  String get permissionRequest => 'Jogosultság kérés';

  @override
  String get permissionRequestContent => 'Ez az alkalmazás hozzáférést kér a Nostr fiókjához';

  @override
  String get grantPermissions => 'Jogosultságok megadása';

  @override
  String get reject => 'Elutasítás';

  @override
  String get fullAccessGranted => 'Teljes hozzáférés megadva';

  @override
  String get fullAccessHint => 'Ez az alkalmazás teljes hozzáférést kap a Nostr fiókjához, beleértve:';

  @override
  String get permissionAccessPubkey => 'Nostr nyilvános kulcs elérése';

  @override
  String get permissionSignEvents => 'Nostr események aláírása';

  @override
  String get permissionEncryptDecrypt => 'Események titkosítása és visszafejtése (NIP-04 és NIP-44)';

  @override
  String get tips => 'Tippek';

  @override
  String get schemeLoginFirst => 'A séma nem oldható meg, először jelentkezzen be.';

  @override
  String get newConnectionRequest => 'Új kapcsolatkérés';

  @override
  String get newConnectionNoSlotHint => 'Egy új alkalmazás próbál csatlakozni, de nincs szabad alkalmazás. Először hozzon létre új alkalmazást.';

  @override
  String get copiedSuccessfully => 'Sikeresen másolva';

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
  String get noResultsFound => 'Nincs találat';

  @override
  String get pleaseSelectApplication => 'Válasszon alkalmazást';

  @override
  String get orEnterCustomName => 'Vagy adjon meg egyéni nevet';

  @override
  String get continueButton => 'Tovább';
}
