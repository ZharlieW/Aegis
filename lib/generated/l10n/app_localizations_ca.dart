// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get settings => 'Configuració';

  @override
  String get logout => 'Tancar sessió';

  @override
  String get login => 'Iniciar sessió';

  @override
  String get usePrivateKey => 'Utilitza la teva clau privada';

  @override
  String get setupAegisWithNsec => 'Configura Aegis amb la teva clau Nostr — admet nsec, ncryptsec i hex.';

  @override
  String get privateKey => 'Clau privada';

  @override
  String get privateKeyHint => 'Clau nsec / ncryptsec / hex';

  @override
  String get password => 'Contrasenya';

  @override
  String get passwordHint => 'Introdueix la contrasenya per desxifrar ncryptsec';

  @override
  String get contentCannotBeEmpty => 'El contingut no pot estar buit!';

  @override
  String get passwordRequiredForNcryptsec => 'Cal contrasenya per a ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'No s\'ha pogut desxifrar ncryptsec. Comprova la contrasenya.';

  @override
  String get invalidPrivateKeyFormat => 'Format de clau privada no vàlid!';

  @override
  String get loginSuccess => 'Sessió iniciada!';

  @override
  String loginFailed(String message) {
    return 'Error d\'accés: $message';
  }

  @override
  String get typeConfirmToProceed => 'Escriu \"confirm\" per continuar';

  @override
  String get logoutConfirm => 'Segur que vols tancar sessió?';

  @override
  String get notLoggedIn => 'No has iniciat sessió';

  @override
  String get language => 'Idioma';

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
  String get addAccount => 'Afegir compte';

  @override
  String get updateSuccessful => 'Actualització correcta!';

  @override
  String get switchAccount => 'Canviar de compte';

  @override
  String get switchAccountConfirm => 'Segur que vols canviar de compte?';

  @override
  String get switchSuccessfully => 'Canvi correcte!';

  @override
  String get renameAccount => 'Canviar nom del compte';

  @override
  String get accountName => 'Nom del compte';

  @override
  String get enterNewName => 'Introdueix el nom nou';

  @override
  String get accounts => 'Comptes';

  @override
  String get localRelay => 'Relay local';

  @override
  String get remote => 'Remot';

  @override
  String get browser => 'Navegador';

  @override
  String get theme => 'Tema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versió';

  @override
  String get appSubtitle => 'Aegis — Signant Nostr';

  @override
  String get darkMode => 'Mode fosc';

  @override
  String get lightMode => 'Mode clar';

  @override
  String get systemDefault => 'Per defecte del sistema';

  @override
  String switchedTo(String mode) {
    return 'Canviat a $mode';
  }

  @override
  String get home => 'Inici';

  @override
  String get waitingForRelayStart => 'Esperant que arrenqui el relay...';

  @override
  String get connected => 'Connectat';

  @override
  String get disconnected => 'Desconnectat';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Error en carregar aplicacions NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Encara no hi ha aplicacions NIP-07.\n\nFes servir el navegador per accedir a aplicacions Nostr!';

  @override
  String get unknown => 'Desconegut';

  @override
  String get active => 'Actiu';

  @override
  String get congratulationsEmptyState => 'Enhorabona!\n\nAra pots fer servir aplicacions compatibles amb Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'El relay local fa servir el port $port, però sembla que una altra app el fa servir. Tanca l\'app en conflicte i torna-ho a provar.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'Signant NIP-46 en marxa!';

  @override
  String get nip46FailedToStart => 'No s\'ha pogut iniciar.';

  @override
  String get retry => 'Tornar a provar';

  @override
  String get clear => 'Netejar';

  @override
  String get clearDatabase => 'Netejar base de dades';

  @override
  String get clearDatabaseConfirm => 'Això esborrarà totes les dades del relay i reiniciarà el relay si està actiu. No es pot desfer.';

  @override
  String get importDatabase => 'Importar base de dades';

  @override
  String get importDatabaseHint => 'Introdueix la ruta de la carpeta de la base de dades a importar. La base existent es farà còpia abans.';

  @override
  String get databaseDirectoryPath => 'Ruta de la carpeta de la base de dades';

  @override
  String get import => 'Importar';

  @override
  String get export => 'Exportar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restartRelay => 'Reiniciar relay';

  @override
  String get restartRelayConfirm => 'Segur que vols reiniciar el relay? Es pararà temporalment i després tornarà a arrencar.';

  @override
  String get relayRestartedSuccess => 'Relay reiniciat';

  @override
  String relayRestartFailed(String message) {
    return 'No s\'ha pogut reiniciar el relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Base de dades netejada';

  @override
  String get databaseClearFailed => 'No s\'ha pogut netejar la base de dades';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get exportDatabase => 'Exportar base de dades';

  @override
  String get exportDatabaseHint => 'La base de dades del relay s\'exportarà com a fitxer ZIP. Pot trigar una mica.';

  @override
  String databaseExportedTo(String path) {
    return 'Base de dades exportada a: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Base de dades exportada com a ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'No s\'ha pogut exportar la base de dades';

  @override
  String get importDatabaseReplaceHint => 'Això substituirà la base actual per la còpia importada. La base existent es farà còpia abans. No es pot desfer.';

  @override
  String get selectDatabaseBackupFile => 'Selecciona el fitxer (ZIP) o la carpeta de còpia';

  @override
  String get selectDatabaseBackupDir => 'Selecciona la carpeta de còpia de la base de dades';

  @override
  String get fileOrDirNotExist => 'El fitxer o carpeta seleccionats no existeixen';

  @override
  String get databaseImportedSuccess => 'Base de dades importada';

  @override
  String get databaseImportFailed => 'No s\'ha pogut importar la base de dades';

  @override
  String get status => 'Estat';

  @override
  String get address => 'Adreça';

  @override
  String get protocol => 'Protocol';

  @override
  String get connections => 'Connexions';

  @override
  String get running => 'En marxa';

  @override
  String get stopped => 'Aturat';

  @override
  String get addressCopiedToClipboard => 'Adreça copiada al porta-retalls';

  @override
  String get exportData => 'Exportar dades';

  @override
  String get importData => 'Importar dades';

  @override
  String get systemLogs => 'Registres del sistema';

  @override
  String get clearAllRelayData => 'Netejar totes les dades del relay';

  @override
  String get noLogsAvailable => 'No hi ha registres';

  @override
  String get passwordRequired => 'Cal la contrasenya';

  @override
  String encryptionFailed(String message) {
    return 'Xifratge fallit: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Clau privada xifrada copiada al porta-retalls';

  @override
  String get accountBackup => 'Còpia del compte';

  @override
  String get publicAccountId => 'ID públic del compte';

  @override
  String get accountPrivateKey => 'Clau privada del compte';

  @override
  String get show => 'Mostrar';

  @override
  String get generate => 'Generar';

  @override
  String get enterEncryptionPassword => 'Introdueix la contrasenya de xifratge';

  @override
  String get privateKeyEncryption => 'Xifratge de clau privada';

  @override
  String get encryptPrivateKeyHint => 'Xifra la teva clau privada per més seguretat. La clau es xifrarà amb una contrasenya.';

  @override
  String get ncryptsecHint => 'La clau xifrada començarà per \"ncryptsec1\" i no es pot fer servir sense contrasenya.';

  @override
  String get losePasswordKeyRecoveryWarning => '⚠️ Avís: si perds la contrasenya, no podràs recuperar la clau.';

  @override
  String get encryptAndCopyPrivateKey => 'Xifrar i copiar clau privada';

  @override
  String get privateKeyEncryptedSuccess => 'Clau privada xifrada!';

  @override
  String get encryptedKeyNcryptsec => 'Clau xifrada (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Crear un compte Nostr nou';

  @override
  String get accountReadyPublicKeyHint => 'El teu compte Nostr està llest! Aquesta és la teva clau pública nostr:';

  @override
  String get nostrPubkey => 'Clau pública Nostr';

  @override
  String get create => 'Crear';

  @override
  String get createSuccess => 'Creat!';

  @override
  String get application => 'Aplicació';

  @override
  String get createApplication => 'Crear aplicació';

  @override
  String get addNewApplication => 'Afegir una aplicació nova';

  @override
  String get addNsecbunkerManually => 'Afegir nsecbunker manualment';

  @override
  String get loginUsingUrlScheme => 'Iniciar sessió amb esquema URL';

  @override
  String get loginByScanningQr => 'Iniciar sessió escanejant QR';

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
  String get addApplicationMethodsHint => 'Pots triar qualsevol d\'aquests mètodes per connectar amb Aegis!';

  @override
  String get urlSchemeLoginHint => 'Obre amb una app que admeti l\'esquema URL d\'Aegis per iniciar sessió';

  @override
  String get name => 'Nom';

  @override
  String get applicationInfo => 'Info de l\'aplicació';

  @override
  String get activities => 'Activitats';

  @override
  String get viewPermissions => 'View Permissions';

  @override
  String get permissionsPageDescription => 'This application can use the following capabilities with your Nostr account.';

  @override
  String get permissionsPageNoDeclaredPerms => 'This app did not declare specific permissions when connecting; it will request signatures as needed when you use it.';

  @override
  String get clientPubkey => 'Clau pública del client';

  @override
  String get remove => 'Eliminar';

  @override
  String get removeAppConfirm => 'Segur que vols treure tots els permisos d\'aquesta aplicació?';

  @override
  String get removeSuccess => 'Eliminat';

  @override
  String get nameCannotBeEmpty => 'El nom no pot estar buit';

  @override
  String get nameTooLong => 'El nom és massa llarg.';

  @override
  String get updateSuccess => 'Actualització correcta';

  @override
  String get editConfiguration => 'Editar configuració';

  @override
  String get update => 'Actualitzar';

  @override
  String get search => 'Cercar...';

  @override
  String get enterCustomName => 'Introdueix un nom personalitzat';

  @override
  String get selectApplication => 'Selecciona una aplicació';

  @override
  String get addWebApp => 'Afegir aplicació web';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'La meva app';

  @override
  String get add => 'Afegir';

  @override
  String get searchNostrApps => 'Cercar aplicacions Nostr...';

  @override
  String get urlLabel => 'URL *';

  @override
  String get appNameOptional => 'Nom de l\'aplicació (opcional)';

  @override
  String get loading => 'Carregant...';

  @override
  String get noNappsFound => 'No s\'han trobat aplicacions';

  @override
  String get nappListLoadFailed => 'No s\'ha pogut carregar la llista d\'aplicacions';

  @override
  String get favorites => 'Preferits';

  @override
  String get allApps => 'Totes les aplicacions';

  @override
  String get addApp => 'Afegir aplicació';

  @override
  String get tapToAdd => 'Toqueu per afegir';

  @override
  String get webApp => 'Aplicació web';

  @override
  String get userAdded => 'Afegit per l\'usuari';

  @override
  String get invalidUrlHint => 'URL no vàlida. Introdueix una URL HTTP o HTTPS vàlida.';

  @override
  String get appAlreadyInList => 'Aquesta app ja és a la llista.';

  @override
  String appAdded(String name) {
    return '$name afegida';
  }

  @override
  String appAddFailed(String error) {
    return 'No s\'ha pogut afegir l\'app: $error';
  }

  @override
  String get deleteApp => 'Eliminar app';

  @override
  String deleteAppConfirm(String name) {
    return 'Segur que vols eliminar \"$name\"?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String appDeleted(String name) {
    return '$name eliminada';
  }

  @override
  String appDeleteFailed(String error) {
    return 'No s\'ha pogut eliminar l\'app: $error';
  }

  @override
  String get copiedToClipboard => 'Copiat al porta-retalls';

  @override
  String get eventDetails => 'Detalls de l\'esdeveniment';

  @override
  String get eventDetailsCopiedToClipboard => 'Detalls de l\'esdeveniment copiats al porta-retalls';

  @override
  String get noSignedEvents => 'Cap esdeveniment signat';

  @override
  String get signedEventsEmptyHint => 'Els esdeveniments signats apareixeran aquí quan els signeu';

  @override
  String get rawMetadataCopiedToClipboard => 'Metadades en brut copiades al porta-retalls';

  @override
  String get permissionRequest => 'Sol·licitud de permisos';

  @override
  String get permissionRequestContent => 'Aquesta aplicació demana permisos per accedir al teu compte Nostr';

  @override
  String get grantPermissions => 'Concedir permisos';

  @override
  String get reject => 'Rebutjar';

  @override
  String get fullAccessGranted => 'Accés complet concedit';

  @override
  String get fullAccessHint => 'Aquesta aplicació tindrà accés complet al teu compte Nostr, incloent:';

  @override
  String get permissionAccessPubkey => 'Accés a la teva clau pública Nostr';

  @override
  String get permissionSignEvents => 'Signar esdeveniments Nostr';

  @override
  String get permissionEncryptDecrypt => 'Xifrar i desxifrar esdeveniments (NIP-04 i NIP-44)';

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
  String get tips => 'Consells';

  @override
  String get schemeLoginFirst => 'No es pot resoldre l\'esquema; inicia sessió abans.';

  @override
  String get newConnectionRequest => 'Nova sol·licitud de connexió';

  @override
  String get newConnectionNoSlotHint => 'Una aplicació nova vol connectar-se, però no hi ha cap aplicació lliure. Crea primer una aplicació nova.';

  @override
  String get copiedSuccessfully => 'Copiat correctament';

  @override
  String get importDatabasePathHint => '/path/to/nostr_relay_backup_...';

  @override
  String get relayStatsSize => 'Mida';

  @override
  String get relayStatsEvents => 'Esdeveniments';

  @override
  String get relayStatsUptime => 'Temps actiu';

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
  String get noResultsFound => 'No s\'han trobat resultats';

  @override
  String get pleaseSelectApplication => 'Seleccioneu una aplicació';

  @override
  String get orEnterCustomName => 'O introduïu un nom personalitzat';

  @override
  String get continueButton => 'Continua';

  @override
  String get goBack => 'Enrere';

  @override
  String get goForward => 'Endavant';

  @override
  String get favorite => 'Preferit';

  @override
  String get unfavorite => 'Treure de preferits';

  @override
  String get reload => 'Actualitzar';

  @override
  String get exit => 'Sortir';

  @override
  String get activitiesLoadFailed => 'No s\'han pogut carregar les activitats';

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
