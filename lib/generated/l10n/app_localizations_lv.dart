// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Apstiprināt';

  @override
  String get cancel => 'Atcelt';

  @override
  String get settings => 'Iestatījumi';

  @override
  String get logout => 'Iziet';

  @override
  String get login => 'Pieslēgties';

  @override
  String get usePrivateKey => 'Izmantot privāto atslēgu';

  @override
  String get setupAegisWithNsec => 'Iestatiet Aegis ar Nostr privāto atslēgu — atbalsta nsec, ncryptsec un hex formātus.';

  @override
  String get privateKey => 'Privātā atslēga';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex atslēga';

  @override
  String get password => 'Parole';

  @override
  String get passwordHint => 'Ievadiet paroli ncryptsec atšifrēšanai';

  @override
  String get contentCannotBeEmpty => 'Saturs nevar būt tukšs!';

  @override
  String get passwordRequiredForNcryptsec => 'Ncryptsec nepieciešama parole!';

  @override
  String get decryptNcryptsecFailed => 'Neizdevās atšifrēt ncryptsec. Pārbaudiet paroli.';

  @override
  String get invalidPrivateKeyFormat => 'Nederīgs privātās atslēgas formāts!';

  @override
  String get loginSuccess => 'Pieslēgšanās veiksmīga!';

  @override
  String loginFailed(String message) {
    return 'Pieslēgšanās neizdevās: $message';
  }

  @override
  String get typeConfirmToProceed => 'Ierakstiet \"confirm\", lai turpinātu';

  @override
  String get logoutConfirm => 'Vai tiešām vēlaties iziet?';

  @override
  String get notLoggedIn => 'Nav pieslēdzies';

  @override
  String get language => 'Valoda';

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
  String get addAccount => 'Pievienot kontu';

  @override
  String get updateSuccessful => 'Atjauninājums veiksmīgs!';

  @override
  String get switchAccount => 'Pārslēgt kontu';

  @override
  String get switchAccountConfirm => 'Vai tiešām vēlaties pārslēgt kontu?';

  @override
  String get switchSuccessfully => 'Pārslēgšana veiksmīga!';

  @override
  String get renameAccount => 'Pārdēvēt kontu';

  @override
  String get accountName => 'Konta nosaukums';

  @override
  String get enterNewName => 'Ievadiet jauno nosaukumu';

  @override
  String get accounts => 'Konti';

  @override
  String get localRelay => 'Vietējais relay';

  @override
  String get remote => 'Attālināts';

  @override
  String get browser => 'Pārlūks';

  @override
  String get theme => 'Tēma';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versija';

  @override
  String get appSubtitle => 'Aegis — Nostr parakstītājs';

  @override
  String get darkMode => 'Tumšais režīms';

  @override
  String get lightMode => 'Gaišais režīms';

  @override
  String get systemDefault => 'Sistēmas noklusējums';

  @override
  String switchedTo(String mode) {
    return 'Pārslēgts uz $mode';
  }

  @override
  String get home => 'Sākums';

  @override
  String get waitingForRelayStart => 'Gaida relay palaišanu...';

  @override
  String get connected => 'Savienots';

  @override
  String get disconnected => 'Atvienots';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Kļūda NIP-07 lietotņu ielādē: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Vēl nav NIP-07 lietotņu.\n\nIzmantojiet pārlūku Nostr lietotņu piekļuvei!';

  @override
  String get unknown => 'Nezināms';

  @override
  String get active => 'Aktīvs';

  @override
  String get congratulationsEmptyState => 'Apsveicam!\n\nTagad varat izmantot lietotnes ar Aegis atbalstu!';

  @override
  String localRelayPortInUse(String port) {
    return 'Vietējais relay ir iestatīts uz portu $port, bet šķiet, ka cita lietotne to jau izmanto. Aizveriet konfliktējošo lietotni un mēģiniet vēlreiz.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'NIP-46 parakstītājs palaists!';

  @override
  String get nip46FailedToStart => 'Palaišana neizdevās.';

  @override
  String get retry => 'Mēģināt vēlreiz';

  @override
  String get clear => 'Notīrīt';

  @override
  String get clearDatabase => 'Notīrīt datu bāzi';

  @override
  String get clearDatabaseConfirm => 'Tiks dzēsti visi relay dati un relay tiks pārstartēts, ja darbojas. Šo darbību nevar atsaukt.';

  @override
  String get importDatabase => 'Importēt datu bāzi';

  @override
  String get importDatabaseHint => 'Ievadiet datu bāzes mapes ceļu importēšanai. Esošā datu bāze tiks dublēta pirms importa.';

  @override
  String get databaseDirectoryPath => 'Datu bāzes mapes ceļš';

  @override
  String get import => 'Importēt';

  @override
  String get export => 'Eksportēt';

  @override
  String get restart => 'Pārstartēt';

  @override
  String get restartRelay => 'Pārstartēt relay';

  @override
  String get restartRelayConfirm => 'Vai tiešām vēlaties pārstartēt relay? Relay īslaicīgi apstāsies un pēc tam startēs no jauna.';

  @override
  String get relayRestartedSuccess => 'Relay pārstartēts';

  @override
  String relayRestartFailed(String message) {
    return 'Relay pārstartēšana neizdevās: $message';
  }

  @override
  String get databaseClearedSuccess => 'Datu bāze notīrīta';

  @override
  String get databaseClearFailed => 'Datu bāzes notīrīšana neizdevās';

  @override
  String errorWithMessage(String message) {
    return 'Kļūda: $message';
  }

  @override
  String get exportDatabase => 'Eksportēt datu bāzi';

  @override
  String get exportDatabaseHint => 'Relay datu bāze tiks eksportēta kā ZIP fails. Eksportēšana var aizņemt brīdi.';

  @override
  String databaseExportedTo(String path) {
    return 'Datu bāze eksportēta uz: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Datu bāze eksportēta kā ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Datu bāzes eksportēšana neizdevās';

  @override
  String get importDatabaseReplaceHint => 'Tas aizstās pašreizējo datu bāzi ar importēto dublējumu. Esošā datu bāze tiks dublēta pirms importa. Šo darbību nevar atsaukt.';

  @override
  String get selectDatabaseBackupFile => 'Izvēlieties datu bāzes dublējuma failu (ZIP) vai mapi';

  @override
  String get selectDatabaseBackupDir => 'Izvēlieties datu bāzes dublējuma mapi';

  @override
  String get fileOrDirNotExist => 'Izvēlētais fails vai mape neeksistē';

  @override
  String get databaseImportedSuccess => 'Datu bāze importēta';

  @override
  String get databaseImportFailed => 'Datu bāzes importēšana neizdevās';

  @override
  String get status => 'Statuss';

  @override
  String get address => 'Adrese';

  @override
  String get protocol => 'Protokols';

  @override
  String get connections => 'Savienojumi';

  @override
  String get running => 'Darbojas';

  @override
  String get stopped => 'Apturēts';

  @override
  String get addressCopiedToClipboard => 'Adrese nokopēta starpliktuvē';

  @override
  String get exportData => 'Eksportēt datus';

  @override
  String get importData => 'Importēt datus';

  @override
  String get systemLogs => 'Sistēmas žurnāli';

  @override
  String get clearAllRelayData => 'Notīrīt visus relay datus';

  @override
  String get noLogsAvailable => 'Žurnālu nav';

  @override
  String get passwordRequired => 'Nepieciešama parole';

  @override
  String encryptionFailed(String message) {
    return 'Šifrēšana neizdevās: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Šifrētā privātā atslēga nokopēta starpliktuvē';

  @override
  String get accountBackup => 'Konta dublējums';

  @override
  String get publicAccountId => 'Publiskais konta ID';

  @override
  String get accountPrivateKey => 'Konta privātā atslēga';

  @override
  String get show => 'Rādīt';

  @override
  String get generate => 'Ģenerēt';

  @override
  String get enterEncryptionPassword => 'Ievadiet šifrēšanas paroli';

  @override
  String get privateKeyEncryption => 'Privātās atslēgas šifrēšana';

  @override
  String get encryptPrivateKeyHint => 'Šifrējiet privāto atslēgu drošībai. Atslēga tiks šifrēta ar paroli.';

  @override
  String get ncryptsecHint => 'Šifrētā atslēga sāksies ar \"ncryptsec1\" un nevar izmantot bez paroles.';

  @override
  String get losePasswordKeyRecoveryWarning => '⚠️ Brīdinājums: Ja zaudēsit paroli, nevarēsiet atgūt atslēgu.';

  @override
  String get encryptAndCopyPrivateKey => 'Šifrēt un nokopēt privāto atslēgu';

  @override
  String get privateKeyEncryptedSuccess => 'Privātā atslēga šifrēta!';

  @override
  String get encryptedKeyNcryptsec => 'Šifrētā atslēga (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Izveidot jaunu Nostr kontu';

  @override
  String get accountReadyPublicKeyHint => 'Jūsu Nostr konts ir gatavs! Šī ir jūsu nostr publiskā atslēga:';

  @override
  String get nostrPubkey => 'Nostr publiskā atslēga';

  @override
  String get create => 'Izveidot';

  @override
  String get createSuccess => 'Izveidots!';

  @override
  String get application => 'Lietotne';

  @override
  String get createApplication => 'Izveidot lietotni';

  @override
  String get addNewApplication => 'Pievienot jaunu lietotni';

  @override
  String get addNsecbunkerManually => 'Pievienot nsecbunker manuāli';

  @override
  String get loginUsingUrlScheme => 'Pieslēgties ar URL shēmu';

  @override
  String get loginByScanningQr => 'Pieslēgties skenējot QR';

  @override
  String get loginByScanningQrHint => 'For web login: log in on this device first, then scan the QR on the webpage.';

  @override
  String get goToLogin => 'Go to login';

  @override
  String get scanQrTitle => 'Scan';

  @override
  String get scanQrHint => 'Position the QR code within the frame';

  @override
  String get chooseFromAlbum => 'Choose from album';

  @override
  String get nostrConnectLoginFirst => 'Please log in to Aegis first (use private key or create account), then scan the QR code again.';

  @override
  String get nostrConnectStartFailed => 'Could not start remote login session. Check relay URL or try again later.';

  @override
  String get addApplicationMethodsHint => 'Varat izvēlēties jebkuru no šīm metodēm savienošanai ar Aegis!';

  @override
  String get urlSchemeLoginHint => 'Atveriet ar lietotni, kas atbalsta Aegis URL shēmu pieslēgšanai';

  @override
  String get name => 'Nosaukums';

  @override
  String get applicationInfo => 'Lietotnes informācija';

  @override
  String get activities => 'Darbības';

  @override
  String get viewPermissions => 'View Permissions';

  @override
  String get permissionsPageDescription => 'This application can use the following capabilities with your Nostr account.';

  @override
  String get permissionsPageNoDeclaredPerms => 'This app did not declare specific permissions when connecting; it will request signatures as needed when you use it.';

  @override
  String get permissionMethodUsageNever => 'Never used';

  @override
  String permissionMethodUsageStats(Object time, int count) {
    return '$time · $count times';
  }

  @override
  String get resetPermissions => 'Reset permissions';

  @override
  String get resetPermissionsConfirm => 'This clears saved permission types and \"always allow\" entries for this app. \"Read your public key\" will still be shown on this page for connected clients. Continue?';

  @override
  String get resetPermissionsSuccess => 'Permissions reset';

  @override
  String get clientPubkey => 'Klienta publiskā atslēga';

  @override
  String get remove => 'Noņemt';

  @override
  String get removeAppConfirm => 'Vai tiešām vēlaties noņemt visas atļaujas no šīs lietotnes?';

  @override
  String get removeSuccess => 'Noņemts';

  @override
  String get nameCannotBeEmpty => 'Nosaukums nevar būt tukšs';

  @override
  String get nameTooLong => 'Nosaukums ir pārāk garš.';

  @override
  String get updateSuccess => 'Atjauninājums veiksmīgs';

  @override
  String get editConfiguration => 'Rediģēt konfigurāciju';

  @override
  String get update => 'Atjaunināt';

  @override
  String get search => 'Meklēt...';

  @override
  String get enterCustomName => 'Ievadiet pielāgotu nosaukumu';

  @override
  String get selectApplication => 'Izvēlieties lietotni';

  @override
  String get addWebApp => 'Pievienot tīmekļa lietotni';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Mana lietotne';

  @override
  String get add => 'Pievienot';

  @override
  String get searchNostrApps => 'Meklēt Nostr lietotnes...';

  @override
  String get urlLabel => 'URL *';

  @override
  String get appNameOptional => 'Lietotnes nosaukums (pēc izvēles)';

  @override
  String get loading => 'Ielādē...';

  @override
  String get noNappsFound => 'Lietotnes nav atrastas';

  @override
  String get nappListLoadFailed => 'Neizdevās ielādēt lietotņu sarakstu';

  @override
  String get favorites => 'Favorīti';

  @override
  String get allApps => 'Visas lietotnes';

  @override
  String get addApp => 'Pievienot lietotni';

  @override
  String get tapToAdd => 'Pieskarieties, lai pievienotu';

  @override
  String get webApp => 'Tīmekļa lietotne';

  @override
  String get userAdded => 'Pievienoja lietotājs';

  @override
  String get invalidUrlHint => 'Nederīga URL. Ievadiet derīgu HTTP vai HTTPS URL.';

  @override
  String get appAlreadyInList => 'Šī lietotne jau ir sarakstā.';

  @override
  String appAdded(String name) {
    return '$name pievienots';
  }

  @override
  String appAddFailed(String error) {
    return 'Lietotnes pievienošana neizdevās: $error';
  }

  @override
  String get deleteApp => 'Dzēst lietotni';

  @override
  String deleteAppConfirm(String name) {
    return 'Vai tiešām vēlaties dzēst \"$name\"?';
  }

  @override
  String get delete => 'Dzēst';

  @override
  String appDeleted(String name) {
    return '$name dzēsts';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Lietotnes dzēšana neizdevās: $error';
  }

  @override
  String get copiedToClipboard => 'Nokopēts starpliktuvē';

  @override
  String get eventDetails => 'Notikuma detaļas';

  @override
  String get eventDetailsCopiedToClipboard => 'Notikuma detaļas nokopētas starpliktuvē';

  @override
  String get noSignedEvents => 'Nav parakstītu notikumu';

  @override
  String get signedEventsEmptyHint => 'Parakstītie notikumi parādīsies šeit, kad tos parakstīsiet';

  @override
  String get rawMetadataCopiedToClipboard => 'Neapstrādāti metadati nokopēti starpliktuvē';

  @override
  String get permissionRequest => 'Atļaujas pieprasījums';

  @override
  String get permissionRequestContent => 'Šī lietotne pieprasa atļauju piekļūt jūsu Nostr kontam';

  @override
  String get grantPermissions => 'Piešķirt atļaujas';

  @override
  String get reject => 'Noraidīt';

  @override
  String get fullAccessGranted => 'Pilna piekļuve piešķirta';

  @override
  String get fullAccessHint => 'Šai lietotnei būs pilna piekļuve jūsu Nostr kontam, ieskaitot:';

  @override
  String get authTrustFully => 'Fully trust this app';

  @override
  String get authTrustFullyHint => 'All future requests will be approved automatically';

  @override
  String get authManualEach => 'Approve each request manually';

  @override
  String get authManualEachHint => 'You will be asked to approve every new action';

  @override
  String get approveActionRequest => 'This app is requesting an action. Allow?';

  @override
  String get permissionAccessPubkey => 'Piekļuve jūsu Nostr publiskajai atslēgai';

  @override
  String get permissionSignEvents => 'Parakstīt Nostr notikumus';

  @override
  String get permissionEncryptDecrypt => 'Šifrēt un atšifrēt notikumus (NIP-04 un NIP-44)';

  @override
  String get permissionNip04Encrypt => 'Encrypt data using NIP-04';

  @override
  String get permissionNip04Decrypt => 'Decrypt data using NIP-04';

  @override
  String get permissionNip44Encrypt => 'Encrypt data using NIP-44';

  @override
  String get permissionNip44Decrypt => 'Decrypt data using NIP-44';

  @override
  String get permissionDecryptZapEvent => 'Decrypt private zaps';

  @override
  String get alwaysAllowThisPermission => 'Always approve this permission';

  @override
  String get batchRememberDurationSection => 'Remember duration';

  @override
  String get batchRememberDurationHint => 'Expand to choose a duration. Selection applies when you approve.';

  @override
  String get batchRememberFiveMinutes => '5 minutes';

  @override
  String get batchRememberThirtyMinutes => '30 minutes';

  @override
  String get batchRememberPermanent => 'Permanent';

  @override
  String batchPermissionRequestsCount(int count) {
    return '$count requests require approval';
  }

  @override
  String permissionSignEventKind(String kind) {
    return 'Sign event (kind $kind)';
  }

  @override
  String get permissionSignKind0 => 'Sign metadata';

  @override
  String get permissionSignKind1 => 'Sign short text note';

  @override
  String get permissionSignKind3 => 'Sign follows';

  @override
  String get permissionSignKind4 => 'Sign encrypted direct messages';

  @override
  String get permissionSignKind5 => 'Sign event deletion request';

  @override
  String get permissionSignKind6 => 'Sign repost';

  @override
  String get permissionSignKind7 => 'Sign reaction';

  @override
  String get permissionSignKind9734 => 'Sign zap request';

  @override
  String get permissionSignKind9735 => 'Sign zap';

  @override
  String get permissionSignKind10000 => 'Sign mute list';

  @override
  String get permissionSignKind10002 => 'Sign relay list metadata';

  @override
  String get permissionSignKind10003 => 'Sign bookmark list';

  @override
  String get permissionSignKind10013 => 'Sign private outbox relay list';

  @override
  String get permissionSignKind31234 => 'Sign generic draft event';

  @override
  String get permissionSignKind30078 => 'Sign application-specific data';

  @override
  String get permissionSignKind22242 => 'Sign client authentication';

  @override
  String get permissionSignKind27235 => 'Sign HTTP auth';

  @override
  String get permissionSignKind30023 => 'Sign long-form content';

  @override
  String get tips => 'Padomi';

  @override
  String get schemeLoginFirst => 'Nevar atrisināt shēmu, vispirms pieslēdzieties.';

  @override
  String get newConnectionRequest => 'Jauns savienojuma pieprasījums';

  @override
  String get newConnectionNoSlotHint => 'Jauna lietotne mēģina savienoties, bet nav brīvas lietotnes. Vispirms izveidojiet jaunu lietotni.';

  @override
  String get copiedSuccessfully => 'Nokopēts';

  @override
  String get importDatabasePathHint => '/path/to/nostr_relay_backup_...';

  @override
  String get relayStatsSize => 'Izmērs';

  @override
  String get relayStatsEvents => 'Notikumi';

  @override
  String get relayStatsUptime => 'Darbības laiks';

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
  String get noResultsFound => 'Rezultāti nav atrasti';

  @override
  String get pleaseSelectApplication => 'Izvēlieties lietotni';

  @override
  String get orEnterCustomName => 'Vai ievadiet pielāgotu nosaukumu';

  @override
  String get continueButton => 'Turpināt';

  @override
  String get goBack => 'Atpakaļ';

  @override
  String get goForward => 'Uz priekšu';

  @override
  String get favorite => 'Favorīts';

  @override
  String get unfavorite => 'Noņemt no favorītiem';

  @override
  String get reload => 'Pārlādēt';

  @override
  String get exit => 'Iziet';

  @override
  String get activitiesLoadFailed => 'Neizdevās ielādēt aktivitātes';

  @override
  String get authorizationModeTitle => 'Authorization mode';

  @override
  String get authorizationModeDescription => 'Default policy when a new app requests permissions.';

  @override
  String get authorizationModeFull => 'Full access';

  @override
  String get authorizationModeFullDescription => 'Grant all permissions at once. One confirmation on first connect. Recommended for trusted apps.';

  @override
  String get authorizationModeSelective => 'Selective';

  @override
  String get authorizationModeSelectiveDescription => 'Choose which permissions to grant each time an app connects.';
}
