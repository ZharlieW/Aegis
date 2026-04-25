// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Conferma';

  @override
  String get cancel => 'Annulla';

  @override
  String get settings => 'Impostazioni';

  @override
  String get logout => 'Esci';

  @override
  String get login => 'Accedi';

  @override
  String get usePrivateKey => 'Usa la tua chiave privata';

  @override
  String get setupAegisWithNsec => 'Configura Aegis con la tua chiave privata Nostr — supporta formati nsec, ncryptsec e hex.';

  @override
  String get privateKey => 'Chiave privata';

  @override
  String get privateKeyHint => 'Chiave nsec / ncryptsec / hex';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Inserisci la password per decifrare ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Il contenuto non può essere vuoto!';

  @override
  String get passwordRequiredForNcryptsec => 'La password è obbligatoria per ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Decifratura di ncryptsec non riuscita. Controlla la password.';

  @override
  String get invalidPrivateKeyFormat => 'Formato chiave privata non valido!';

  @override
  String get loginSuccess => 'Accesso riuscito!';

  @override
  String loginFailed(String message) {
    return 'Accesso fallito: $message';
  }

  @override
  String get typeConfirmToProceed => 'Digita \"confirm\" per procedere';

  @override
  String get logoutConfirm => 'Vuoi uscire?';

  @override
  String get notLoggedIn => 'Non connesso';

  @override
  String get language => 'Lingua';

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
  String get addAccount => 'Aggiungi account';

  @override
  String get updateSuccessful => 'Aggiornamento riuscito!';

  @override
  String get switchAccount => 'Cambia account';

  @override
  String get switchAccountConfirm => 'Vuoi cambiare account?';

  @override
  String get switchSuccessfully => 'Cambio riuscito!';

  @override
  String get renameAccount => 'Rinomina account';

  @override
  String get accountName => 'Nome account';

  @override
  String get enterNewName => 'Inserisci il nuovo nome';

  @override
  String get accounts => 'Account';

  @override
  String get localRelay => 'Relay locale';

  @override
  String get remote => 'Remoto';

  @override
  String get browser => 'Browser';

  @override
  String get theme => 'Tema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versione';

  @override
  String get appSubtitle => 'Aegis - Firma Nostr';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get lightMode => 'Modalità chiara';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String switchedTo(String mode) {
    return 'Passato a $mode';
  }

  @override
  String get home => 'Home';

  @override
  String get waitingForRelayStart => 'Attendere avvio del relay...';

  @override
  String get connected => 'Connesso';

  @override
  String get disconnected => 'Disconnesso';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Errore nel caricamento delle app NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Nessuna app NIP-07 ancora.\n\nUsa il browser per accedere alle app Nostr!';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get active => 'Attivo';

  @override
  String get congratulationsEmptyState => 'Congratulazioni!\n\nOra puoi usare le app che supportano Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Il relay locale è impostato sulla porta $port, ma un\'altra app sembra usarla. Chiudi l\'app in conflitto e riprova.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'Firma NIP-46 avviata!';

  @override
  String get nip46FailedToStart => 'Avvio fallito.';

  @override
  String get retry => 'Riprova';

  @override
  String get clear => 'Cancella';

  @override
  String get clearDatabase => 'Cancella database';

  @override
  String get clearDatabaseConfirm => 'Verranno eliminati tutti i dati del relay e il relay verrà riavviato se in esecuzione. Questa azione non può essere annullata.';

  @override
  String get importDatabase => 'Importa database';

  @override
  String get importDatabaseHint => 'Inserisci il percorso della directory del database da importare. Il database esistente verrà salvato prima dell\'importazione.';

  @override
  String get databaseDirectoryPath => 'Percorso directory database';

  @override
  String get import => 'Importa';

  @override
  String get export => 'Esporta';

  @override
  String get restart => 'Riavvia';

  @override
  String get restartRelay => 'Riavvia relay';

  @override
  String get restartRelayConfirm => 'Vuoi riavviare il relay? Verrà arrestato temporaneamente e poi riavviato.';

  @override
  String get relayRestartedSuccess => 'Relay riavviato con successo';

  @override
  String relayRestartFailed(String message) {
    return 'Riavvio del relay fallito: $message';
  }

  @override
  String get databaseClearedSuccess => 'Database cancellato con successo';

  @override
  String get databaseClearFailed => 'Cancellazione del database fallita';

  @override
  String errorWithMessage(String message) {
    return 'Errore: $message';
  }

  @override
  String get exportDatabase => 'Esporta database';

  @override
  String get exportDatabaseHint => 'Il database del relay verrà esportato come file ZIP. L\'operazione può richiedere qualche momento.';

  @override
  String databaseExportedTo(String path) {
    return 'Database esportato in: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Database esportato come ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Esportazione del database fallita';

  @override
  String get importDatabaseReplaceHint => 'Il database corrente verrà sostituito dal backup importato. Quello esistente verrà salvato prima. Questa azione non può essere annullata.';

  @override
  String get selectDatabaseBackupFile => 'Seleziona file (ZIP) o directory di backup';

  @override
  String get selectDatabaseBackupDir => 'Seleziona directory di backup';

  @override
  String get fileOrDirNotExist => 'Il file o la directory selezionati non esistono';

  @override
  String get databaseImportedSuccess => 'Database importato con successo';

  @override
  String get databaseImportFailed => 'Importazione del database fallita';

  @override
  String get status => 'Stato';

  @override
  String get address => 'Indirizzo';

  @override
  String get protocol => 'Protocollo';

  @override
  String get connections => 'Connessioni';

  @override
  String get lastReconnectAt => 'Last reconnect';

  @override
  String get neverReconnected => 'Never';

  @override
  String get reconnectNow => 'Reconnect now';

  @override
  String get reconnecting => 'Reconnecting...';

  @override
  String get running => 'In esecuzione';

  @override
  String get stopped => 'Fermato';

  @override
  String get addressCopiedToClipboard => 'Indirizzo copiato negli appunti';

  @override
  String get exportData => 'Esporta dati';

  @override
  String get importData => 'Importa dati';

  @override
  String get systemLogs => 'Log di sistema';

  @override
  String get clearAllRelayData => 'Cancella tutti i dati del relay';

  @override
  String get noLogsAvailable => 'Nessun log disponibile';

  @override
  String get passwordRequired => 'Password richiesta';

  @override
  String encryptionFailed(String message) {
    return 'Crittografia fallita: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Chiave privata crittografata copiata negli appunti';

  @override
  String get accountBackup => 'Backup account';

  @override
  String get publicAccountId => 'ID account pubblico';

  @override
  String get accountPrivateKey => 'Chiave privata account';

  @override
  String get show => 'Mostra';

  @override
  String get generate => 'Genera';

  @override
  String get enterEncryptionPassword => 'Inserisci password di crittografia';

  @override
  String get privateKeyEncryption => 'Crittografia chiave privata';

  @override
  String get encryptPrivateKeyHint => 'Crittografa la chiave privata per maggiore sicurezza. Verrà crittografata con una password.';

  @override
  String get ncryptsecHint => 'La chiave crittografata inizierà con \"ncryptsec1\" e non potrà essere usata senza la password.';

  @override
  String get losePasswordKeyRecoveryWarning => '⚠️ Attenzione: se perdi la password non potrai recuperare la chiave.';

  @override
  String get encryptAndCopyPrivateKey => 'Crittografa e copia chiave privata';

  @override
  String get privateKeyEncryptedSuccess => 'Chiave privata crittografata con successo!';

  @override
  String get encryptedKeyNcryptsec => 'Chiave crittografata (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Crea un nuovo account Nostr';

  @override
  String get accountReadyPublicKeyHint => 'Il tuo account Nostr è pronto! Questa è la tua chiave pubblica nostr:';

  @override
  String get nostrPubkey => 'Chiave pubblica Nostr';

  @override
  String get create => 'Crea';

  @override
  String get createSuccess => 'Creazione riuscita!';

  @override
  String get application => 'Applicazione';

  @override
  String get createApplication => 'Crea applicazione';

  @override
  String get addNewApplication => 'Aggiungi nuova applicazione';

  @override
  String get addNsecbunkerManually => 'Aggiungi nsecbunker manualmente';

  @override
  String get loginUsingUrlScheme => 'Accedi con URL Scheme';

  @override
  String get loginByScanningQr => 'Accedi scansionando il QR';

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
  String get addApplicationMethodsHint => 'Puoi scegliere uno di questi metodi per connetterti ad Aegis!';

  @override
  String get urlSchemeLoginHint => 'Apri con un\'app che supporta lo schema URL Aegis per accedere.';

  @override
  String get name => 'Nome';

  @override
  String get applicationInfo => 'Info applicazione';

  @override
  String get activities => 'Attività';

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
  String get clientPubkey => 'Chiave pubblica client';

  @override
  String get remove => 'Rimuovi';

  @override
  String get removeAppConfirm => 'Rimuovere tutte le autorizzazioni di questa applicazione?';

  @override
  String get removeSuccess => 'Rimozione riuscita';

  @override
  String get nameCannotBeEmpty => 'Il nome non può essere vuoto';

  @override
  String get nameTooLong => 'Il nome è troppo lungo.';

  @override
  String get updateSuccess => 'Aggiornamento riuscito';

  @override
  String get editConfiguration => 'Modifica configurazione';

  @override
  String get update => 'Aggiorna';

  @override
  String get search => 'Cerca...';

  @override
  String get enterCustomName => 'Inserisci un nome personalizzato';

  @override
  String get selectApplication => 'Seleziona un\'applicazione';

  @override
  String get addWebApp => 'Aggiungi app web';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'La mia app';

  @override
  String get add => 'Aggiungi';

  @override
  String get searchNostrApps => 'Cerca app Nostr...';

  @override
  String get urlLabel => 'URL *';

  @override
  String get appNameOptional => 'Nome app (opzionale)';

  @override
  String get loading => 'Caricamento...';

  @override
  String get noNappsFound => 'Nessuna applicazione trovata';

  @override
  String get nappListLoadFailed => 'Impossibile caricare l\'elenco delle applicazioni';

  @override
  String get favorites => 'Preferiti';

  @override
  String get allApps => 'Tutte le applicazioni';

  @override
  String get addApp => 'Aggiungi app';

  @override
  String get tapToAdd => 'Tocca per aggiungere';

  @override
  String get webApp => 'App web';

  @override
  String get userAdded => 'Aggiunto dall\'utente';

  @override
  String get invalidUrlHint => 'URL non valido. Inserisci un URL HTTP o HTTPS valido.';

  @override
  String get appAlreadyInList => 'Questa app è già nella lista.';

  @override
  String appAdded(String name) {
    return 'Aggiunto $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Aggiunta dell\'app fallita: $error';
  }

  @override
  String get deleteApp => 'Elimina app';

  @override
  String deleteAppConfirm(String name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get delete => 'Elimina';

  @override
  String appDeleted(String name) {
    return 'Eliminato $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Eliminazione dell\'app fallita: $error';
  }

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get eventDetails => 'Dettagli evento';

  @override
  String get eventDetailsCopiedToClipboard => 'Dettagli evento copiati negli appunti';

  @override
  String get noSignedEvents => 'Nessun evento firmato';

  @override
  String get signedEventsEmptyHint => 'Gli eventi firmati appariranno qui quando li firmi';

  @override
  String get rawMetadataCopiedToClipboard => 'Metadati grezzi copiati negli appunti';

  @override
  String get permissionRequest => 'Richiesta di autorizzazione';

  @override
  String get permissionRequestContent => 'Questa applicazione richiede l\'accesso al tuo account Nostr';

  @override
  String get grantPermissions => 'Concedi autorizzazioni';

  @override
  String get reject => 'Rifiuta';

  @override
  String get fullAccessGranted => 'Accesso completo concesso';

  @override
  String get fullAccessHint => 'Questa applicazione avrà accesso completo al tuo account Nostr, incluso:';

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
  String get permissionAccessPubkey => 'Accedi alla tua chiave pubblica Nostr';

  @override
  String get permissionSignEvents => 'Firma eventi Nostr';

  @override
  String get permissionEncryptDecrypt => 'Crittografa e decifra eventi (NIP-04 e NIP-44)';

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
  String get tips => 'Suggerimenti';

  @override
  String get schemeLoginFirst => 'Impossibile risolvere lo schema. Accedi prima.';

  @override
  String get newConnectionRequest => 'Nuova richiesta di connessione';

  @override
  String get newConnectionNoSlotHint => 'Una nuova applicazione sta cercando di connettersi, ma non c\'è spazio. Crea prima una nuova applicazione.';

  @override
  String get copiedSuccessfully => 'Copiato con successo';

  @override
  String get importDatabasePathHint => '/path/to/nostr_relay_backup_...';

  @override
  String get relayStatsSize => 'Dimensione';

  @override
  String get relayStatsEvents => 'Eventi';

  @override
  String get relayStatsUptime => 'Uptime';

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
  String get noResultsFound => 'Nessun risultato trovato';

  @override
  String get pleaseSelectApplication => 'Seleziona un\'applicazione';

  @override
  String get orEnterCustomName => 'Oppure inserisci un nome personalizzato';

  @override
  String get continueButton => 'Continua';

  @override
  String get goBack => 'Indietro';

  @override
  String get goForward => 'Avanti';

  @override
  String get favorite => 'Preferito';

  @override
  String get unfavorite => 'Rimuovi dai preferiti';

  @override
  String get reload => 'Ricarica';

  @override
  String get exit => 'Esci';

  @override
  String get activitiesLoadFailed => 'Impossibile caricare le attività';

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
