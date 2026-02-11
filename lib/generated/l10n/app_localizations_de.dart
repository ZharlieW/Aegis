// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get logout => 'Abmelden';

  @override
  String get login => 'Anmelden';

  @override
  String get usePrivateKey => 'Mit privatem Schlüssel anmelden';

  @override
  String get setupAegisWithNsec => 'Aegis mit deinem Nostr-Schlüssel einrichten — unterstützt nsec, ncryptsec und hex.';

  @override
  String get privateKey => 'Privater Schlüssel';

  @override
  String get privateKeyHint => 'nsec- / ncryptsec- / hex-Schlüssel';

  @override
  String get password => 'Passwort';

  @override
  String get passwordHint => 'Passwort zum Entschlüsseln von ncryptsec eingeben';

  @override
  String get contentCannotBeEmpty => 'Der Inhalt darf nicht leer sein!';

  @override
  String get passwordRequiredForNcryptsec => 'Für ncryptsec ist ein Passwort erforderlich!';

  @override
  String get decryptNcryptsecFailed => 'Entschlüsselung von ncryptsec fehlgeschlagen. Bitte Passwort prüfen.';

  @override
  String get invalidPrivateKeyFormat => 'Ungültiges Format des privaten Schlüssels!';

  @override
  String get loginSuccess => 'Anmeldung erfolgreich!';

  @override
  String loginFailed(String message) {
    return 'Anmeldung fehlgeschlagen: $message';
  }

  @override
  String get typeConfirmToProceed => 'Zum Fortfahren „confirm“ eingeben';

  @override
  String get logoutConfirm => 'Möchtest du dich wirklich abmelden?';

  @override
  String get notLoggedIn => 'Nicht angemeldet';

  @override
  String get language => 'Sprache';

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
  String get addAccount => 'Konto hinzufügen';

  @override
  String get updateSuccessful => 'Aktualisierung erfolgreich!';

  @override
  String get switchAccount => 'Konto wechseln';

  @override
  String get switchAccountConfirm => 'Möchtest du wirklich das Konto wechseln?';

  @override
  String get switchSuccessfully => 'Wechsel erfolgreich!';

  @override
  String get renameAccount => 'Konto umbenennen';

  @override
  String get accountName => 'Kontoname';

  @override
  String get enterNewName => 'Neuen Namen eingeben';

  @override
  String get accounts => 'Konten';

  @override
  String get localRelay => 'Lokales Relay';

  @override
  String get remote => 'Remote';

  @override
  String get browser => 'Browser';

  @override
  String get theme => 'Design';

  @override
  String get github => 'Github';

  @override
  String get version => 'Version';

  @override
  String get appSubtitle => 'Aegis – Nostr-Signer';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get lightMode => 'Hellmodus';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String switchedTo(String mode) {
    return 'Gewechselt zu $mode';
  }

  @override
  String get home => 'Start';

  @override
  String get waitingForRelayStart => 'Warte auf Relay-Start...';

  @override
  String get connected => 'Verbunden';

  @override
  String get disconnected => 'Getrennt';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Fehler beim Laden der NIP-07-Anwendungen: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Noch keine NIP-07-Anwendungen.\n\nNutze den Browser für Nostr-Apps!';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get active => 'Aktiv';

  @override
  String get congratulationsEmptyState => 'Herzlichen Glückwunsch!\n\nDu kannst jetzt Aegis-kompatible Apps nutzen!';

  @override
  String localRelayPortInUse(String port) {
    return 'Das lokale Relay nutzt Port $port, aber eine andere App scheint ihn bereits zu verwenden. Bitte die andere App schließen und erneut versuchen.';
  }

  @override
  String get nip46Started => 'NIP-46-Signer gestartet!';

  @override
  String get nip46FailedToStart => 'Start fehlgeschlagen.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get clear => 'Löschen';

  @override
  String get clearDatabase => 'Datenbank löschen';

  @override
  String get clearDatabaseConfirm => 'Alle Relay-Daten werden gelöscht; bei laufendem Relay wird es neu gestartet. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get importDatabase => 'Datenbank importieren';

  @override
  String get importDatabaseHint => 'Pfad zum zu importierenden Datenbankverzeichnis eingeben. Die bestehende Datenbank wird vor dem Import gesichert.';

  @override
  String get databaseDirectoryPath => 'Pfad zum Datenbankverzeichnis';

  @override
  String get import => 'Importieren';

  @override
  String get export => 'Exportieren';

  @override
  String get restart => 'Neu starten';

  @override
  String get restartRelay => 'Relay neu starten';

  @override
  String get restartRelayConfirm => 'Relay wirklich neu starten? Es wird kurz gestoppt und dann neu gestartet.';

  @override
  String get relayRestartedSuccess => 'Relay erfolgreich neu gestartet';

  @override
  String relayRestartFailed(String message) {
    return 'Neustart des Relay fehlgeschlagen: $message';
  }

  @override
  String get databaseClearedSuccess => 'Datenbank erfolgreich gelöscht';

  @override
  String get databaseClearFailed => 'Löschen der Datenbank fehlgeschlagen';

  @override
  String errorWithMessage(String message) {
    return 'Fehler: $message';
  }

  @override
  String get exportDatabase => 'Datenbank exportieren';

  @override
  String get exportDatabaseHint => 'Die Relay-Datenbank wird als ZIP exportiert. Der Vorgang kann einen Moment dauern.';

  @override
  String databaseExportedTo(String path) {
    return 'Datenbank exportiert nach: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Datenbank als ZIP exportiert: $path';
  }

  @override
  String get databaseExportFailed => 'Export der Datenbank fehlgeschlagen';

  @override
  String get importDatabaseReplaceHint => 'Die aktuelle Datenbank wird durch den Import ersetzt. Die bestehende wird vorher gesichert. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get selectDatabaseBackupFile => 'Datenbank-Backup (ZIP) oder Verzeichnis wählen';

  @override
  String get selectDatabaseBackupDir => 'Datenbank-Backup-Verzeichnis wählen';

  @override
  String get fileOrDirNotExist => 'Die gewählte Datei oder das Verzeichnis existiert nicht';

  @override
  String get databaseImportedSuccess => 'Datenbank erfolgreich importiert';

  @override
  String get databaseImportFailed => 'Import der Datenbank fehlgeschlagen';

  @override
  String get status => 'Status';

  @override
  String get address => 'Adresse';

  @override
  String get protocol => 'Protokoll';

  @override
  String get connections => 'Verbindungen';

  @override
  String get running => 'Läuft';

  @override
  String get stopped => 'Gestoppt';

  @override
  String get addressCopiedToClipboard => 'Adresse in die Zwischenablage kopiert';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get importData => 'Daten importieren';

  @override
  String get systemLogs => 'Systemprotokolle';

  @override
  String get clearAllRelayData => 'Alle Relay-Daten löschen';

  @override
  String get noLogsAvailable => 'Keine Protokolle vorhanden';

  @override
  String get passwordRequired => 'Passwort erforderlich';

  @override
  String encryptionFailed(String message) {
    return 'Verschlüsselung fehlgeschlagen: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Verschlüsselter privater Schlüssel in die Zwischenablage kopiert';

  @override
  String get accountBackup => 'Kontosicherung';

  @override
  String get publicAccountId => 'Öffentliche Konto-ID';

  @override
  String get accountPrivateKey => 'Privater Kontoschlüssel';

  @override
  String get show => 'Anzeigen';

  @override
  String get generate => 'Erzeugen';

  @override
  String get enterEncryptionPassword => 'Verschlüsselungspasswort eingeben';

  @override
  String get privateKeyEncryption => 'Verschlüsselung des privaten Schlüssels';

  @override
  String get encryptPrivateKeyHint => 'Verschlüssele deinen privaten Schlüssel zur Sicherheit. Er wird mit einem Passwort verschlüsselt.';

  @override
  String get ncryptsecHint => 'Der verschlüsselte Schlüssel beginnt mit „ncryptsec1“ und ist ohne Passwort nicht nutzbar.';

  @override
  String get encryptAndCopyPrivateKey => 'Verschlüsseln und privaten Schlüssel kopieren';

  @override
  String get privateKeyEncryptedSuccess => 'Privater Schlüssel erfolgreich verschlüsselt!';

  @override
  String get encryptedKeyNcryptsec => 'Verschlüsselter Schlüssel (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Neues Nostr-Konto anlegen';

  @override
  String get accountReadyPublicKeyHint => 'Dein Nostr-Konto ist bereit! Das ist dein nostr-öffentlicher Schlüssel:';

  @override
  String get nostrPubkey => 'Nostr-öffentlicher Schlüssel';

  @override
  String get create => 'Erstellen';

  @override
  String get createSuccess => 'Erfolgreich erstellt!';

  @override
  String get application => 'Anwendung';

  @override
  String get createApplication => 'Anwendung erstellen';

  @override
  String get addNewApplication => 'Neue Anwendung hinzufügen';

  @override
  String get addNsecbunkerManually => 'Nsecbunker manuell hinzufügen';

  @override
  String get loginUsingUrlScheme => 'Mit URL-Schema anmelden';

  @override
  String get addApplicationMethodsHint => 'Du kannst eine dieser Methoden nutzen, um dich mit Aegis zu verbinden!';

  @override
  String get urlSchemeLoginHint => 'Mit einer App öffnen, die das Aegis-URL-Schema unterstützt, um dich anzumelden.';

  @override
  String get name => 'Name';

  @override
  String get applicationInfo => 'Anwendungsinfo';

  @override
  String get activities => 'Aktivitäten';

  @override
  String get clientPubkey => 'Öffentlicher Client-Schlüssel';

  @override
  String get remove => 'Entfernen';

  @override
  String get removeAppConfirm => 'Alle Berechtigungen dieser Anwendung wirklich entfernen?';

  @override
  String get removeSuccess => 'Erfolgreich entfernt';

  @override
  String get nameCannotBeEmpty => 'Der Name darf nicht leer sein';

  @override
  String get nameTooLong => 'Der Name ist zu lang.';

  @override
  String get updateSuccess => 'Aktualisierung erfolgreich';

  @override
  String get editConfiguration => 'Konfiguration bearbeiten';

  @override
  String get update => 'Aktualisieren';

  @override
  String get search => 'Suchen...';

  @override
  String get enterCustomName => 'Benutzerdefinierten Namen eingeben';

  @override
  String get selectApplication => 'Anwendung auswählen';

  @override
  String get addWebApp => 'Web-App hinzufügen';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Meine App';

  @override
  String get add => 'Hinzufügen';

  @override
  String get searchNostrApps => 'Nostr-Apps suchen...';

  @override
  String get invalidUrlHint => 'Ungültige URL. Bitte eine gültige HTTP- oder HTTPS-URL eingeben.';

  @override
  String get appAlreadyInList => 'Diese App ist bereits in der Liste.';

  @override
  String appAdded(String name) {
    return '$name hinzugefügt';
  }

  @override
  String appAddFailed(String error) {
    return 'App konnte nicht hinzugefügt werden: $error';
  }

  @override
  String get deleteApp => 'App löschen';

  @override
  String deleteAppConfirm(String name) {
    return '\"$name\" wirklich löschen?';
  }

  @override
  String get delete => 'Löschen';

  @override
  String appDeleted(String name) {
    return '$name gelöscht';
  }

  @override
  String appDeleteFailed(String error) {
    return 'App konnte nicht gelöscht werden: $error';
  }

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get eventDetails => 'Ereignisdetails';

  @override
  String get eventDetailsCopiedToClipboard => 'Ereignisdetails in die Zwischenablage kopiert';

  @override
  String get rawMetadataCopiedToClipboard => 'Rohe Metadaten in die Zwischenablage kopiert';

  @override
  String get permissionRequest => 'Berechtigungsanfrage';

  @override
  String get permissionRequestContent => 'Diese Anwendung fordert Zugriff auf dein Nostr-Konto an';

  @override
  String get grantPermissions => 'Berechtigungen erteilen';

  @override
  String get reject => 'Ablehnen';

  @override
  String get fullAccessGranted => 'Voller Zugriff erteilt';

  @override
  String get fullAccessHint => 'Diese Anwendung hat vollen Zugriff auf dein Nostr-Konto, u. a.:';

  @override
  String get permissionAccessPubkey => 'Zugriff auf deinen Nostr-öffentlichen Schlüssel';

  @override
  String get permissionSignEvents => 'Nostr-Ereignisse signieren';

  @override
  String get permissionEncryptDecrypt => 'Ereignisse verschlüsseln und entschlüsseln (NIP-04 & NIP-44)';

  @override
  String get tips => 'Tipps';

  @override
  String get schemeLoginFirst => 'Schema konnte nicht aufgelöst werden. Bitte zuerst anmelden.';

  @override
  String get newConnectionRequest => 'Neue Verbindungsanfrage';

  @override
  String get newConnectionNoSlotHint => 'Eine neue Anwendung möchte sich verbinden, aber es ist keine freie Anwendung verfügbar. Bitte zuerst eine neue Anwendung anlegen.';

  @override
  String get copiedSuccessfully => 'Erfolgreich kopiert';

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
  String get noResultsFound => 'Keine Ergebnisse gefunden';

  @override
  String get pleaseSelectApplication => 'Bitte wähle eine Anwendung';

  @override
  String get orEnterCustomName => 'Oder gib einen eigenen Namen ein';

  @override
  String get continueButton => 'Weiter';
}
