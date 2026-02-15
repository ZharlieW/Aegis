// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get usePrivateKey => 'Use your private key';

  @override
  String get setupAegisWithNsec => 'Set up Aegis with your Nostr private key — supports nsec, ncryptsec, and hex formats.';

  @override
  String get privateKey => 'Private Key';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex key';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter password to decrypt ncryptsec';

  @override
  String get contentCannotBeEmpty => 'The content cannot be empty!';

  @override
  String get passwordRequiredForNcryptsec => 'Password is required for ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Failed to decrypt ncryptsec. Please check your password.';

  @override
  String get invalidPrivateKeyFormat => 'Invalid private key format!';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String loginFailed(String message) {
    return 'Login failed: $message';
  }

  @override
  String get typeConfirmToProceed => 'Type \"confirm\" to proceed';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get language => 'Language';

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
  String get addAccount => 'Add Account';

  @override
  String get updateSuccessful => 'Update successful!';

  @override
  String get switchAccount => 'Switch account';

  @override
  String get switchAccountConfirm => 'Are you sure you want to switch accounts?';

  @override
  String get switchSuccessfully => 'Switch successfully!';

  @override
  String get renameAccount => 'Rename Account';

  @override
  String get accountName => 'Account Name';

  @override
  String get enterNewName => 'Enter new name';

  @override
  String get accounts => 'Accounts';

  @override
  String get localRelay => 'Local Relay';

  @override
  String get remote => 'Remote';

  @override
  String get browser => 'Browser';

  @override
  String get theme => 'Theme';

  @override
  String get github => 'Github';

  @override
  String get version => 'Version';

  @override
  String get appSubtitle => 'Aegis - Nostr Signer';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String switchedTo(String mode) {
    return 'Switched to $mode';
  }

  @override
  String get home => 'Home';

  @override
  String get waitingForRelayStart => 'Waiting for relay to start...';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Error loading NIP-07 applications: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'No NIP-07 applications yet.\n\nUse Browser to access Nostr apps!';

  @override
  String get unknown => 'Unknown';

  @override
  String get active => 'Active';

  @override
  String get congratulationsEmptyState => 'Congratulations!\n\nNow you can start using apps that support Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'The local relay is set to use port $port, but it appears another app is already using this port. Please close the conflicting app and try again.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'NIP-46 Signer started!';

  @override
  String get nip46FailedToStart => 'Failed to start.';

  @override
  String get retry => 'Retry';

  @override
  String get clear => 'Clear';

  @override
  String get clearDatabase => 'Clear Database';

  @override
  String get clearDatabaseConfirm => 'This will delete all relay data and restart the relay if it is running. This action cannot be undone.';

  @override
  String get importDatabase => 'Import Database';

  @override
  String get importDatabaseHint => 'Enter the path to the database directory to import. The existing database will be backed up before import.';

  @override
  String get databaseDirectoryPath => 'Database directory path';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get restart => 'Restart';

  @override
  String get restartRelay => 'Restart Relay';

  @override
  String get restartRelayConfirm => 'Are you sure you want to restart the relay? The relay will be temporarily stopped and then restarted.';

  @override
  String get relayRestartedSuccess => 'Relay restarted successfully';

  @override
  String relayRestartFailed(String message) {
    return 'Failed to restart relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Database cleared successfully';

  @override
  String get databaseClearFailed => 'Failed to clear database';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get exportDatabase => 'Export Database';

  @override
  String get exportDatabaseHint => 'This will export the relay database as a ZIP file. The export may take a few moments.';

  @override
  String databaseExportedTo(String path) {
    return 'Database exported to: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Database exported as ZIP file: $path';
  }

  @override
  String get databaseExportFailed => 'Failed to export database';

  @override
  String get importDatabaseReplaceHint => 'This will replace the current database with the imported backup. The existing database will be backed up before import. This action cannot be undone.';

  @override
  String get selectDatabaseBackupFile => 'Select database backup file (ZIP) or directory';

  @override
  String get selectDatabaseBackupDir => 'Select database backup directory';

  @override
  String get fileOrDirNotExist => 'Selected file or directory does not exist';

  @override
  String get databaseImportedSuccess => 'Database imported successfully';

  @override
  String get databaseImportFailed => 'Failed to import database';

  @override
  String get status => 'Status';

  @override
  String get address => 'Address';

  @override
  String get protocol => 'Protocol';

  @override
  String get connections => 'Connections';

  @override
  String get running => 'Running';

  @override
  String get stopped => 'Stopped';

  @override
  String get addressCopiedToClipboard => 'Address copied to clipboard';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get systemLogs => 'System Logs';

  @override
  String get clearAllRelayData => 'Clear All Relay Data';

  @override
  String get noLogsAvailable => 'No logs available';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String encryptionFailed(String message) {
    return 'Encryption failed: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Encrypted private key copied to clipboard';

  @override
  String get accountBackup => 'Account backup';

  @override
  String get publicAccountId => 'Public account ID';

  @override
  String get accountPrivateKey => 'Account private key';

  @override
  String get show => 'Show';

  @override
  String get generate => 'Generate';

  @override
  String get enterEncryptionPassword => 'Enter encryption password';

  @override
  String get privateKeyEncryption => 'Private Key Encryption';

  @override
  String get encryptPrivateKeyHint => 'Encrypt your private key to enhance security. The key will be encrypted using a password.';

  @override
  String get ncryptsecHint => 'The encrypted key will start with \"ncryptsec1\" and cannot be used without the password.';

  @override
  String get encryptAndCopyPrivateKey => 'Encrypt and Copy Private Key';

  @override
  String get privateKeyEncryptedSuccess => 'Private key encrypted successfully!';

  @override
  String get encryptedKeyNcryptsec => 'Encrypted key (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Create a new Nostr account';

  @override
  String get accountReadyPublicKeyHint => 'Your Nostr account is ready! This is your nostr public key:';

  @override
  String get nostrPubkey => 'Nostr Pubkey';

  @override
  String get create => 'Create';

  @override
  String get createSuccess => 'Create successfully!';

  @override
  String get application => 'Application';

  @override
  String get createApplication => 'Create Application';

  @override
  String get addNewApplication => 'Add a new application';

  @override
  String get addNsecbunkerManually => 'Add a nsecbunker manually';

  @override
  String get loginUsingUrlScheme => 'Login using URL Scheme';

  @override
  String get addApplicationMethodsHint => 'You can choose any of these methods to connect with Aegis!';

  @override
  String get urlSchemeLoginHint => 'Open with an app that supports Aegis URL scheme to log in';

  @override
  String get name => 'Name';

  @override
  String get applicationInfo => 'Application Info';

  @override
  String get activities => 'Activities';

  @override
  String get clientPubkey => 'Client pubkey';

  @override
  String get remove => 'Remove';

  @override
  String get removeAppConfirm => 'Are you sure you want to remove all permissions from this application?';

  @override
  String get removeSuccess => 'Remove success';

  @override
  String get nameCannotBeEmpty => 'The name cannot be empty';

  @override
  String get nameTooLong => 'The name is too long.';

  @override
  String get updateSuccess => 'Update success';

  @override
  String get editConfiguration => 'Edit configuration';

  @override
  String get update => 'Update';

  @override
  String get search => 'Search...';

  @override
  String get enterCustomName => 'Enter a custom name';

  @override
  String get selectApplication => 'Select an application';

  @override
  String get addWebApp => 'Add Web App';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'My App';

  @override
  String get add => 'Add';

  @override
  String get searchNostrApps => 'Search Nostr Apps...';

  @override
  String get invalidUrlHint => 'Invalid URL. Please enter a valid HTTP or HTTPS URL.';

  @override
  String get appAlreadyInList => 'This app is already in the list.';

  @override
  String appAdded(String name) {
    return 'Added $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Failed to add app: $error';
  }

  @override
  String get deleteApp => 'Delete App';

  @override
  String deleteAppConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String appDeleted(String name) {
    return 'Deleted $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Failed to delete app: $error';
  }

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get eventDetails => 'Event Details';

  @override
  String get eventDetailsCopiedToClipboard => 'Event details copied to clipboard';

  @override
  String get rawMetadataCopiedToClipboard => 'Raw metadata copied to clipboard';

  @override
  String get permissionRequest => 'Permission Request';

  @override
  String get permissionRequestContent => 'This application is requesting permissions to access your Nostr account';

  @override
  String get grantPermissions => 'Grant Permissions';

  @override
  String get reject => 'Reject';

  @override
  String get fullAccessGranted => 'Full Access Granted';

  @override
  String get fullAccessHint => 'This application will have full access to your Nostr account, including:';

  @override
  String get permissionAccessPubkey => 'Access your Nostr public key';

  @override
  String get permissionSignEvents => 'Sign Nostr events';

  @override
  String get permissionEncryptDecrypt => 'Encrypt and decrypt events (NIP-04 & NIP-44)';

  @override
  String get tips => 'Tips';

  @override
  String get schemeLoginFirst => 'Unable to resolve scheme, please login first.';

  @override
  String get newConnectionRequest => 'New Connection Request';

  @override
  String get newConnectionNoSlotHint => 'A new application is trying to connect, but no unused application is available. Please create a new application first.';

  @override
  String get copiedSuccessfully => 'Copied successfully';

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
  String get noResultsFound => 'No results found';

  @override
  String get pleaseSelectApplication => 'Please select an application';

  @override
  String get orEnterCustomName => 'Or enter a custom name';

  @override
  String get continueButton => 'Continue';
}
