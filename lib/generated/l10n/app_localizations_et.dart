// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Kinnita';

  @override
  String get cancel => 'Tühista';

  @override
  String get settings => 'Seaded';

  @override
  String get logout => 'Logi välja';

  @override
  String get login => 'Logi sisse';

  @override
  String get usePrivateKey => 'Kasuta oma privaatvõtit';

  @override
  String get setupAegisWithNsec => 'Seadista Aegis oma Nostr privaatvõtmega — toetab nsec-, ncryptsec- ja hex-vorme.';

  @override
  String get privateKey => 'Privaatvõti';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex võti';

  @override
  String get password => 'Parool';

  @override
  String get passwordHint => 'Sisesta parool ncryptsec lahtikrüptimiseks';

  @override
  String get contentCannotBeEmpty => 'Sisu ei tohi olla tühi!';

  @override
  String get passwordRequiredForNcryptsec => 'Ncryptsec jaoks on vaja parooli!';

  @override
  String get decryptNcryptsecFailed => 'Ncryptsec lahtikrüptimine ebaõnnestus. Kontrolli parooli.';

  @override
  String get invalidPrivateKeyFormat => 'Vigane privaatvõtme vorming!';

  @override
  String get loginSuccess => 'Sisselogimine õnnestus!';

  @override
  String loginFailed(String message) {
    return 'Sisselogimine ebaõnnestus: $message';
  }

  @override
  String get typeConfirmToProceed => 'Sisesta \"confirm\" jätkamiseks';

  @override
  String get logoutConfirm => 'Kas oled kindel, et soovid välja logida?';

  @override
  String get notLoggedIn => 'Pole sisse logitud';

  @override
  String get language => 'Keel';

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
  String get addAccount => 'Lisa konto';

  @override
  String get updateSuccessful => 'Uuendamine õnnestus!';

  @override
  String get switchAccount => 'Vaheta kontot';

  @override
  String get switchAccountConfirm => 'Kas oled kindel, et soovid kontot vahetada?';

  @override
  String get switchSuccessfully => 'Vahetus õnnestus!';

  @override
  String get renameAccount => 'Nimeta konto ümber';

  @override
  String get accountName => 'Konto nimi';

  @override
  String get enterNewName => 'Sisesta uus nimi';

  @override
  String get accounts => 'Kontod';

  @override
  String get localRelay => 'Kohalik relay';

  @override
  String get remote => 'Kaug';

  @override
  String get browser => 'Brauser';

  @override
  String get theme => 'Teema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versioon';

  @override
  String get appSubtitle => 'Aegis — Nostr allkirjastaja';

  @override
  String get darkMode => 'Tume režiim';

  @override
  String get lightMode => 'Hele režiim';

  @override
  String get systemDefault => 'Süsteemi vaikimisi';

  @override
  String switchedTo(String mode) {
    return 'Vahetatud väärtusele $mode';
  }

  @override
  String get home => 'Avaleht';

  @override
  String get waitingForRelayStart => 'Ootan relay käivitumist...';

  @override
  String get connected => 'Ühendatud';

  @override
  String get disconnected => 'Ühendus katkes';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Viga NIP-07 rakenduste laadimisel: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'NIP-07 rakendusi pole veel.\n\nKasuta brauserit Nostr rakenduste avamiseks!';

  @override
  String get unknown => 'Tundmatu';

  @override
  String get active => 'Aktiivne';

  @override
  String get congratulationsEmptyState => 'Palju õnne!\n\nNüüd saad kasutada Aegist toetavaid rakendusi!';

  @override
  String localRelayPortInUse(String port) {
    return 'Kohalik relay kasutab porti $port, kuid tundub, et teine rakendus seda juba kasutab. Sulge konfliktiv rakendus ja proovi uuesti.';
  }

  @override
  String get nip46Started => 'NIP-46 allkirjastaja käivitus!';

  @override
  String get nip46FailedToStart => 'Käivitamine ebaõnnestus.';

  @override
  String get retry => 'Proovi uuesti';

  @override
  String get clear => 'Tühjenda';

  @override
  String get clearDatabase => 'Tühjenda andmebaas';

  @override
  String get clearDatabaseConfirm => 'See kustutab kõik relay andmed ja taaskäivitab relay, kui see töötab. Seda tehet ei saa tagasi võtta.';

  @override
  String get importDatabase => 'Impordi andmebaas';

  @override
  String get importDatabaseHint => 'Sisesta importida sooviva andmebaasi kausta tee. Olemasolev andmebaas tehakse enne importi varukoopiana.';

  @override
  String get databaseDirectoryPath => 'Andmebaasi kausta tee';

  @override
  String get import => 'Import';

  @override
  String get export => 'Eksport';

  @override
  String get restart => 'Taaskäivita';

  @override
  String get restartRelay => 'Taaskäivita relay';

  @override
  String get restartRelayConfirm => 'Kas oled kindel, et soovid relay taaskäivitada? Relay peatatakse ajutiselt ja seejärel taaskäivitatakse.';

  @override
  String get relayRestartedSuccess => 'Relay taaskäivitatud';

  @override
  String relayRestartFailed(String message) {
    return 'Relay taaskäivitamine ebaõnnestus: $message';
  }

  @override
  String get databaseClearedSuccess => 'Andmebaas tühjendatud';

  @override
  String get databaseClearFailed => 'Andmebaasi tühjendamine ebaõnnestus';

  @override
  String errorWithMessage(String message) {
    return 'Viga: $message';
  }

  @override
  String get exportDatabase => 'Ekspordi andmebaas';

  @override
  String get exportDatabaseHint => 'Relay andmebaas eksporditakse ZIP-failina. Eksport võib võtta hetke.';

  @override
  String databaseExportedTo(String path) {
    return 'Andmebaas eksporditud: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Andmebaas eksporditud ZIPina: $path';
  }

  @override
  String get databaseExportFailed => 'Andmebaasi eksport ebaõnnestus';

  @override
  String get importDatabaseReplaceHint => 'See asendab praeguse andmebaasi imporditud varukoopiaga. Olemasolev andmebaas tehakse enne importi varukoopiana. Seda tehet ei saa tagasi võtta.';

  @override
  String get selectDatabaseBackupFile => 'Vali andmebaasi varukoopia fail (ZIP) või kaust';

  @override
  String get selectDatabaseBackupDir => 'Vali andmebaasi varukoopia kaust';

  @override
  String get fileOrDirNotExist => 'Valitud fail või kaust ei eksisteeri';

  @override
  String get databaseImportedSuccess => 'Andmebaas imporditud';

  @override
  String get databaseImportFailed => 'Andmebaasi import ebaõnnestus';

  @override
  String get status => 'Olek';

  @override
  String get address => 'Aadress';

  @override
  String get protocol => 'Protokoll';

  @override
  String get connections => 'Ühendused';

  @override
  String get running => 'Töötab';

  @override
  String get stopped => 'Peatatud';

  @override
  String get addressCopiedToClipboard => 'Aadress kopeeritud lõikelauale';

  @override
  String get exportData => 'Ekspordi andmed';

  @override
  String get importData => 'Impordi andmed';

  @override
  String get systemLogs => 'Süsteemi logid';

  @override
  String get clearAllRelayData => 'Tühjenda kõik relay andmed';

  @override
  String get noLogsAvailable => 'Logisid pole';

  @override
  String get passwordRequired => 'Parool on nõutud';

  @override
  String encryptionFailed(String message) {
    return 'Krüptimine ebaõnnestus: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Krüptitud privaatvõti kopeeritud lõikelauale';

  @override
  String get accountBackup => 'Konto varukoopia';

  @override
  String get publicAccountId => 'Avalik konto ID';

  @override
  String get accountPrivateKey => 'Konto privaatvõti';

  @override
  String get show => 'Näita';

  @override
  String get generate => 'Genereeri';

  @override
  String get enterEncryptionPassword => 'Sisesta krüptimise parool';

  @override
  String get privateKeyEncryption => 'Privaatvõtme krüptimine';

  @override
  String get encryptPrivateKeyHint => 'Krüpti oma privaatvõti turvalisuse parandamiseks. Võti krüptitakse parooliga.';

  @override
  String get ncryptsecHint => 'Krüptitud võti algab \"ncryptsec1\" ja seda ei saa paroolita kasutada.';

  @override
  String get encryptAndCopyPrivateKey => 'Krüpti ja kopeeri privaatvõti';

  @override
  String get privateKeyEncryptedSuccess => 'Privaatvõti krüptitud!';

  @override
  String get encryptedKeyNcryptsec => 'Krüptitud võti (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Loo uus Nostr konto';

  @override
  String get accountReadyPublicKeyHint => 'Sinu Nostr konto on valmis! See on sinu nostr avalik võti:';

  @override
  String get nostrPubkey => 'Nostr avalik võti';

  @override
  String get create => 'Loo';

  @override
  String get createSuccess => 'Loodud!';

  @override
  String get application => 'Rakendus';

  @override
  String get createApplication => 'Loo rakendus';

  @override
  String get addNewApplication => 'Lisa uus rakendus';

  @override
  String get addNsecbunkerManually => 'Lisa nsecbunker käsitsi';

  @override
  String get loginUsingUrlScheme => 'Logi sisse URL skeemiga';

  @override
  String get addApplicationMethodsHint => 'Võid valida ühe neist meetoditest Aegisega ühendamiseks!';

  @override
  String get urlSchemeLoginHint => 'Ava rakendusega, mis toetab Aegis URL skeemi sisselogimiseks';

  @override
  String get name => 'Nimi';

  @override
  String get applicationInfo => 'Rakenduse info';

  @override
  String get activities => 'Tegevused';

  @override
  String get clientPubkey => 'Kliendi avalik võti';

  @override
  String get remove => 'Eemalda';

  @override
  String get removeAppConfirm => 'Kas oled kindel, et soovid sellelt rakenduselt kõik õigused eemaldada?';

  @override
  String get removeSuccess => 'Eemaldatud';

  @override
  String get nameCannotBeEmpty => 'Nimi ei tohi olla tühi';

  @override
  String get nameTooLong => 'Nimi on liiga pikk.';

  @override
  String get updateSuccess => 'Uuendamine õnnestus';

  @override
  String get editConfiguration => 'Muuda konfiguratsiooni';

  @override
  String get update => 'Uuenda';

  @override
  String get search => 'Otsi...';

  @override
  String get enterCustomName => 'Sisesta kohandatud nimi';

  @override
  String get selectApplication => 'Vali rakendus';

  @override
  String get addWebApp => 'Lisa veebirakendus';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Minu rakendus';

  @override
  String get add => 'Lisa';

  @override
  String get searchNostrApps => 'Otsi Nostr rakendusi...';

  @override
  String get invalidUrlHint => 'Vigane URL. Sisesta kehtiv HTTP või HTTPS URL.';

  @override
  String get appAlreadyInList => 'See rakendus on juba nimekirjas.';

  @override
  String appAdded(String name) {
    return '$name lisatud';
  }

  @override
  String appAddFailed(String error) {
    return 'Rakenduse lisamine ebaõnnestus: $error';
  }

  @override
  String get deleteApp => 'Kustuta rakendus';

  @override
  String deleteAppConfirm(String name) {
    return 'Kas oled kindel, et soovid kustutada \"$name\"?';
  }

  @override
  String get delete => 'Kustuta';

  @override
  String appDeleted(String name) {
    return '$name kustutatud';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Rakenduse kustutamine ebaõnnestus: $error';
  }

  @override
  String get copiedToClipboard => 'Kopeeritud lõikelauale';

  @override
  String get eventDetails => 'Sündmuse üksikasjad';

  @override
  String get eventDetailsCopiedToClipboard => 'Sündmuse üksikasjad kopeeritud lõikelauale';

  @override
  String get rawMetadataCopiedToClipboard => 'Toormetaandmed kopeeritud lõikelauale';

  @override
  String get permissionRequest => 'Õiguse taotlus';

  @override
  String get permissionRequestContent => 'See rakendus küsib ligipääsu sinu Nostr kontole';

  @override
  String get grantPermissions => 'Anna õigused';

  @override
  String get reject => 'Keeldu';

  @override
  String get fullAccessGranted => 'Täielik ligipääs antud';

  @override
  String get fullAccessHint => 'See rakendus saab täieliku ligipääsu sinu Nostr kontole, sealhulgas:';

  @override
  String get permissionAccessPubkey => 'Ligipääs sinu Nostr avalikule võtmele';

  @override
  String get permissionSignEvents => 'Nostr sündmuste allkirjastamine';

  @override
  String get permissionEncryptDecrypt => 'Sündmuste krüptimine ja lahtikrüptimine (NIP-04 ja NIP-44)';

  @override
  String get tips => 'Nõuanded';

  @override
  String get schemeLoginFirst => 'Skeemi ei saa lahendada, logi esmalt sisse.';

  @override
  String get newConnectionRequest => 'Uus ühendustaotlus';

  @override
  String get newConnectionNoSlotHint => 'Uus rakendus üritab ühenduda, kuid vaba rakendust pole. Loo esmalt uus rakendus.';

  @override
  String get copiedSuccessfully => 'Kopeeritud';

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
  String get noResultsFound => 'Tulemusi ei leitud';

  @override
  String get pleaseSelectApplication => 'Valige rakendus';

  @override
  String get orEnterCustomName => 'Või sisestage kohandatud nimi';

  @override
  String get continueButton => 'Jätka';
}
