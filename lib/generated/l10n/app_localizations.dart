import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_az.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('az'),
    Locale('bg'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('lv'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Aegis'**
  String get appTitle;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @usePrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Use your private key'**
  String get usePrivateKey;

  /// No description provided for @setupAegisWithNsec.
  ///
  /// In en, this message translates to:
  /// **'Set up Aegis with your Nostr private key — supports nsec, ncryptsec, and hex formats.'**
  String get setupAegisWithNsec;

  /// No description provided for @privateKey.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get privateKey;

  /// No description provided for @privateKeyHint.
  ///
  /// In en, this message translates to:
  /// **'nsec / ncryptsec / hex key'**
  String get privateKeyHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password to decrypt ncryptsec'**
  String get passwordHint;

  /// No description provided for @contentCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'The content cannot be empty!'**
  String get contentCannotBeEmpty;

  /// No description provided for @passwordRequiredForNcryptsec.
  ///
  /// In en, this message translates to:
  /// **'Password is required for ncryptsec!'**
  String get passwordRequiredForNcryptsec;

  /// No description provided for @decryptNcryptsecFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to decrypt ncryptsec. Please check your password.'**
  String get decryptNcryptsecFailed;

  /// No description provided for @invalidPrivateKeyFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid private key format!'**
  String get invalidPrivateKeyFormat;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {message}'**
  String loginFailed(String message);

  /// No description provided for @typeConfirmToProceed.
  ///
  /// In en, this message translates to:
  /// **'Type \"confirm\" to proceed'**
  String get typeConfirmToProceed;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @simplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @azerbaijani.
  ///
  /// In en, this message translates to:
  /// **'Azərbaycan'**
  String get azerbaijani;

  /// No description provided for @bulgarian.
  ///
  /// In en, this message translates to:
  /// **'Български'**
  String get bulgarian;

  /// No description provided for @catalan.
  ///
  /// In en, this message translates to:
  /// **'Català'**
  String get catalan;

  /// No description provided for @czech.
  ///
  /// In en, this message translates to:
  /// **'Čeština'**
  String get czech;

  /// No description provided for @danish.
  ///
  /// In en, this message translates to:
  /// **'Dansk'**
  String get danish;

  /// No description provided for @greek.
  ///
  /// In en, this message translates to:
  /// **'Ελληνικά'**
  String get greek;

  /// No description provided for @estonian.
  ///
  /// In en, this message translates to:
  /// **'Eesti'**
  String get estonian;

  /// No description provided for @farsi.
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get farsi;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @hungarian.
  ///
  /// In en, this message translates to:
  /// **'Magyar'**
  String get hungarian;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get indonesian;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// No description provided for @latvian.
  ///
  /// In en, this message translates to:
  /// **'Latviešu'**
  String get latvian;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get dutch;

  /// No description provided for @polish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get polish;

  /// No description provided for @swedish.
  ///
  /// In en, this message translates to:
  /// **'Svenska'**
  String get swedish;

  /// No description provided for @thai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get thai;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @ukrainian.
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get ukrainian;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get urdu;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @traditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get traditionalChinese;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @updateSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Update successful!'**
  String get updateSuccessful;

  /// No description provided for @switchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch account'**
  String get switchAccount;

  /// No description provided for @switchAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to switch accounts?'**
  String get switchAccountConfirm;

  /// No description provided for @switchSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Switch successfully!'**
  String get switchSuccessfully;

  /// No description provided for @renameAccount.
  ///
  /// In en, this message translates to:
  /// **'Rename Account'**
  String get renameAccount;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// No description provided for @enterNewName.
  ///
  /// In en, this message translates to:
  /// **'Enter new name'**
  String get enterNewName;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @localRelay.
  ///
  /// In en, this message translates to:
  /// **'Local Relay'**
  String get localRelay;

  /// No description provided for @remote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remote;

  /// No description provided for @browser.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get browser;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'Github'**
  String get github;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Aegis - Nostr Signer'**
  String get appSubtitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @switchedTo.
  ///
  /// In en, this message translates to:
  /// **'Switched to {mode}'**
  String switchedTo(String mode);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @waitingForRelayStart.
  ///
  /// In en, this message translates to:
  /// **'Waiting for relay to start...'**
  String get waitingForRelayStart;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @errorLoadingNip07Applications.
  ///
  /// In en, this message translates to:
  /// **'Error loading NIP-07 applications: {error}'**
  String errorLoadingNip07Applications(String error);

  /// No description provided for @noNip07ApplicationsHint.
  ///
  /// In en, this message translates to:
  /// **'No NIP-07 applications yet.\n\nUse Browser to access Nostr apps!'**
  String get noNip07ApplicationsHint;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @congratulationsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!\n\nNow you can start using apps that support Aegis!'**
  String get congratulationsEmptyState;

  /// No description provided for @localRelayPortInUse.
  ///
  /// In en, this message translates to:
  /// **'The local relay is set to use port {port}, but it appears another app is already using this port. Please close the conflicting app and try again.'**
  String localRelayPortInUse(String port);

  /// No description provided for @nip46Started.
  ///
  /// In en, this message translates to:
  /// **'NIP-46 Signer started!'**
  String get nip46Started;

  /// No description provided for @nip46FailedToStart.
  ///
  /// In en, this message translates to:
  /// **'Failed to start.'**
  String get nip46FailedToStart;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearDatabase.
  ///
  /// In en, this message translates to:
  /// **'Clear Database'**
  String get clearDatabase;

  /// No description provided for @clearDatabaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will delete all relay data and restart the relay if it is running. This action cannot be undone.'**
  String get clearDatabaseConfirm;

  /// No description provided for @importDatabase.
  ///
  /// In en, this message translates to:
  /// **'Import Database'**
  String get importDatabase;

  /// No description provided for @importDatabaseHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the path to the database directory to import. The existing database will be backed up before import.'**
  String get importDatabaseHint;

  /// No description provided for @databaseDirectoryPath.
  ///
  /// In en, this message translates to:
  /// **'Database directory path'**
  String get databaseDirectoryPath;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @restartRelay.
  ///
  /// In en, this message translates to:
  /// **'Restart Relay'**
  String get restartRelay;

  /// No description provided for @restartRelayConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restart the relay? The relay will be temporarily stopped and then restarted.'**
  String get restartRelayConfirm;

  /// No description provided for @relayRestartedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Relay restarted successfully'**
  String get relayRestartedSuccess;

  /// No description provided for @relayRestartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to restart relay: {message}'**
  String relayRestartFailed(String message);

  /// No description provided for @databaseClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Database cleared successfully'**
  String get databaseClearedSuccess;

  /// No description provided for @databaseClearFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear database'**
  String get databaseClearFailed;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @exportDatabase.
  ///
  /// In en, this message translates to:
  /// **'Export Database'**
  String get exportDatabase;

  /// No description provided for @exportDatabaseHint.
  ///
  /// In en, this message translates to:
  /// **'This will export the relay database as a ZIP file. The export may take a few moments.'**
  String get exportDatabaseHint;

  /// No description provided for @databaseExportedTo.
  ///
  /// In en, this message translates to:
  /// **'Database exported to: {path}'**
  String databaseExportedTo(String path);

  /// No description provided for @databaseExportedZip.
  ///
  /// In en, this message translates to:
  /// **'Database exported as ZIP file: {path}'**
  String databaseExportedZip(String path);

  /// No description provided for @databaseExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export database'**
  String get databaseExportFailed;

  /// No description provided for @importDatabaseReplaceHint.
  ///
  /// In en, this message translates to:
  /// **'This will replace the current database with the imported backup. The existing database will be backed up before import. This action cannot be undone.'**
  String get importDatabaseReplaceHint;

  /// No description provided for @selectDatabaseBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Select database backup file (ZIP) or directory'**
  String get selectDatabaseBackupFile;

  /// No description provided for @selectDatabaseBackupDir.
  ///
  /// In en, this message translates to:
  /// **'Select database backup directory'**
  String get selectDatabaseBackupDir;

  /// No description provided for @fileOrDirNotExist.
  ///
  /// In en, this message translates to:
  /// **'Selected file or directory does not exist'**
  String get fileOrDirNotExist;

  /// No description provided for @databaseImportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Database imported successfully'**
  String get databaseImportedSuccess;

  /// No description provided for @databaseImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to import database'**
  String get databaseImportFailed;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @protocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocol;

  /// No description provided for @connections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get connections;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// No description provided for @addressCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Address copied to clipboard'**
  String get addressCopiedToClipboard;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @systemLogs.
  ///
  /// In en, this message translates to:
  /// **'System Logs'**
  String get systemLogs;

  /// No description provided for @clearAllRelayData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Relay Data'**
  String get clearAllRelayData;

  /// No description provided for @noLogsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No logs available'**
  String get noLogsAvailable;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @encryptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Encryption failed: {message}'**
  String encryptionFailed(String message);

  /// No description provided for @encryptedKeyCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Encrypted private key copied to clipboard'**
  String get encryptedKeyCopiedToClipboard;

  /// No description provided for @accountBackup.
  ///
  /// In en, this message translates to:
  /// **'Account backup'**
  String get accountBackup;

  /// No description provided for @publicAccountId.
  ///
  /// In en, this message translates to:
  /// **'Public account ID'**
  String get publicAccountId;

  /// No description provided for @accountPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Account private key'**
  String get accountPrivateKey;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @enterEncryptionPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter encryption password'**
  String get enterEncryptionPassword;

  /// No description provided for @privateKeyEncryption.
  ///
  /// In en, this message translates to:
  /// **'Private Key Encryption'**
  String get privateKeyEncryption;

  /// No description provided for @encryptPrivateKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Encrypt your private key to enhance security. The key will be encrypted using a password.'**
  String get encryptPrivateKeyHint;

  /// No description provided for @ncryptsecHint.
  ///
  /// In en, this message translates to:
  /// **'The encrypted key will start with \"ncryptsec1\" and cannot be used without the password.'**
  String get ncryptsecHint;

  /// No description provided for @encryptAndCopyPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Encrypt and Copy Private Key'**
  String get encryptAndCopyPrivateKey;

  /// No description provided for @privateKeyEncryptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Private key encrypted successfully!'**
  String get privateKeyEncryptedSuccess;

  /// No description provided for @encryptedKeyNcryptsec.
  ///
  /// In en, this message translates to:
  /// **'Encrypted key (ncryptsec):'**
  String get encryptedKeyNcryptsec;

  /// No description provided for @createNewNostrAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new Nostr account'**
  String get createNewNostrAccount;

  /// No description provided for @accountReadyPublicKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Your Nostr account is ready! This is your nostr public key:'**
  String get accountReadyPublicKeyHint;

  /// No description provided for @nostrPubkey.
  ///
  /// In en, this message translates to:
  /// **'Nostr Pubkey'**
  String get nostrPubkey;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createSuccess.
  ///
  /// In en, this message translates to:
  /// **'Create successfully!'**
  String get createSuccess;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @createApplication.
  ///
  /// In en, this message translates to:
  /// **'Create Application'**
  String get createApplication;

  /// No description provided for @addNewApplication.
  ///
  /// In en, this message translates to:
  /// **'Add a new application'**
  String get addNewApplication;

  /// No description provided for @addNsecbunkerManually.
  ///
  /// In en, this message translates to:
  /// **'Add a nsecbunker manually'**
  String get addNsecbunkerManually;

  /// No description provided for @loginUsingUrlScheme.
  ///
  /// In en, this message translates to:
  /// **'Login using URL Scheme'**
  String get loginUsingUrlScheme;

  /// No description provided for @addApplicationMethodsHint.
  ///
  /// In en, this message translates to:
  /// **'You can choose any of these methods to connect with Aegis!'**
  String get addApplicationMethodsHint;

  /// No description provided for @urlSchemeLoginHint.
  ///
  /// In en, this message translates to:
  /// **'Open with an app that supports Aegis URL scheme to log in'**
  String get urlSchemeLoginHint;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @applicationInfo.
  ///
  /// In en, this message translates to:
  /// **'Application Info'**
  String get applicationInfo;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @clientPubkey.
  ///
  /// In en, this message translates to:
  /// **'Client pubkey'**
  String get clientPubkey;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all permissions from this application?'**
  String get removeAppConfirm;

  /// No description provided for @removeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Remove success'**
  String get removeSuccess;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'The name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'The name is too long.'**
  String get nameTooLong;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update success'**
  String get updateSuccess;

  /// No description provided for @editConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Edit configuration'**
  String get editConfiguration;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @enterCustomName.
  ///
  /// In en, this message translates to:
  /// **'Enter a custom name'**
  String get enterCustomName;

  /// No description provided for @selectApplication.
  ///
  /// In en, this message translates to:
  /// **'Select an application'**
  String get selectApplication;

  /// No description provided for @addWebApp.
  ///
  /// In en, this message translates to:
  /// **'Add Web App'**
  String get addWebApp;

  /// No description provided for @urlHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com'**
  String get urlHint;

  /// No description provided for @appNameHint.
  ///
  /// In en, this message translates to:
  /// **'My App'**
  String get appNameHint;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @searchNostrApps.
  ///
  /// In en, this message translates to:
  /// **'Search Nostr Apps...'**
  String get searchNostrApps;

  /// No description provided for @invalidUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL. Please enter a valid HTTP or HTTPS URL.'**
  String get invalidUrlHint;

  /// No description provided for @appAlreadyInList.
  ///
  /// In en, this message translates to:
  /// **'This app is already in the list.'**
  String get appAlreadyInList;

  /// No description provided for @appAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {name}'**
  String appAdded(String name);

  /// No description provided for @appAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add app: {error}'**
  String appAddFailed(String error);

  /// No description provided for @deleteApp.
  ///
  /// In en, this message translates to:
  /// **'Delete App'**
  String get deleteApp;

  /// No description provided for @deleteAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteAppConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @appDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted {name}'**
  String appDeleted(String name);

  /// No description provided for @appDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete app: {error}'**
  String appDeleteFailed(String error);

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @eventDetailsCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Event details copied to clipboard'**
  String get eventDetailsCopiedToClipboard;

  /// No description provided for @rawMetadataCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Raw metadata copied to clipboard'**
  String get rawMetadataCopiedToClipboard;

  /// No description provided for @permissionRequest.
  ///
  /// In en, this message translates to:
  /// **'Permission Request'**
  String get permissionRequest;

  /// No description provided for @permissionRequestContent.
  ///
  /// In en, this message translates to:
  /// **'This application is requesting permissions to access your Nostr account'**
  String get permissionRequestContent;

  /// No description provided for @grantPermissions.
  ///
  /// In en, this message translates to:
  /// **'Grant Permissions'**
  String get grantPermissions;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @fullAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'Full Access Granted'**
  String get fullAccessGranted;

  /// No description provided for @fullAccessHint.
  ///
  /// In en, this message translates to:
  /// **'This application will have full access to your Nostr account, including:'**
  String get fullAccessHint;

  /// No description provided for @permissionAccessPubkey.
  ///
  /// In en, this message translates to:
  /// **'Access your Nostr public key'**
  String get permissionAccessPubkey;

  /// No description provided for @permissionSignEvents.
  ///
  /// In en, this message translates to:
  /// **'Sign Nostr events'**
  String get permissionSignEvents;

  /// No description provided for @permissionEncryptDecrypt.
  ///
  /// In en, this message translates to:
  /// **'Encrypt and decrypt events (NIP-04 & NIP-44)'**
  String get permissionEncryptDecrypt;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @schemeLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Unable to resolve scheme, please login first.'**
  String get schemeLoginFirst;

  /// No description provided for @newConnectionRequest.
  ///
  /// In en, this message translates to:
  /// **'New Connection Request'**
  String get newConnectionRequest;

  /// No description provided for @newConnectionNoSlotHint.
  ///
  /// In en, this message translates to:
  /// **'A new application is trying to connect, but no unused application is available. Please create a new application first.'**
  String get newConnectionNoSlotHint;

  /// No description provided for @copiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Copied successfully'**
  String get copiedSuccessfully;

  /// No description provided for @importDatabasePathHint.
  ///
  /// In en, this message translates to:
  /// **'/path/to/nostr_relay_backup_...'**
  String get importDatabasePathHint;

  /// No description provided for @relayStatsSize.
  ///
  /// In en, this message translates to:
  /// **'SIZE'**
  String get relayStatsSize;

  /// No description provided for @relayStatsEvents.
  ///
  /// In en, this message translates to:
  /// **'EVENTS'**
  String get relayStatsEvents;

  /// No description provided for @relayStatsUptime.
  ///
  /// In en, this message translates to:
  /// **'UPTIME'**
  String get relayStatsUptime;

  /// No description provided for @shareRelayBackupSubject.
  ///
  /// In en, this message translates to:
  /// **'Nostr Relay Database Backup'**
  String get shareRelayBackupSubject;

  /// No description provided for @shareRelayBackupIosText.
  ///
  /// In en, this message translates to:
  /// **'Nostr Relay Database Backup\n\nTap \"Save to Files\" to save to Files app.'**
  String get shareRelayBackupIosText;

  /// No description provided for @shareRelayBackupIosSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Database exported as ZIP file. Use \"Save to Files\" in the share sheet to save.'**
  String get shareRelayBackupIosSnackbar;

  /// No description provided for @databaseExportedToIosHint.
  ///
  /// In en, this message translates to:
  /// **'Database exported to: {path}\n\nYou can access it via Files app > On My iPhone > Aegis'**
  String databaseExportedToIosHint(String path);

  /// No description provided for @shareRelayBackupAndroidText.
  ///
  /// In en, this message translates to:
  /// **'Nostr Relay Database Backup\n\nChoose where to save the ZIP file.'**
  String get shareRelayBackupAndroidText;

  /// No description provided for @shareRelayBackupAndroidSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Database exported as ZIP file. Choose where to save in the share sheet.'**
  String get shareRelayBackupAndroidSnackbar;

  /// No description provided for @protocolWs.
  ///
  /// In en, this message translates to:
  /// **'WS'**
  String get protocolWs;

  /// No description provided for @protocolWss.
  ///
  /// In en, this message translates to:
  /// **'WSS'**
  String get protocolWss;

  /// No description provided for @confirmLiteral.
  ///
  /// In en, this message translates to:
  /// **'confirm'**
  String get confirmLiteral;

  /// No description provided for @errorCannotDetermineHomeDir.
  ///
  /// In en, this message translates to:
  /// **'Cannot determine home directory'**
  String get errorCannotDetermineHomeDir;

  /// No description provided for @errorZipFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'ZIP file not found'**
  String get errorZipFileNotFound;

  /// No description provided for @unitBytes.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get unitBytes;

  /// No description provided for @unitKB.
  ///
  /// In en, this message translates to:
  /// **'KB'**
  String get unitKB;

  /// No description provided for @unitMB.
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get unitMB;

  /// No description provided for @unitGB.
  ///
  /// In en, this message translates to:
  /// **'GB'**
  String get unitGB;

  /// No description provided for @durationZero.
  ///
  /// In en, this message translates to:
  /// **'0s'**
  String get durationZero;

  /// No description provided for @durationDayShort.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get durationDayShort;

  /// No description provided for @durationHourShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get durationHourShort;

  /// No description provided for @durationMinuteShort.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get durationMinuteShort;

  /// No description provided for @durationSecondShort.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get durationSecondShort;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @pleaseSelectApplication.
  ///
  /// In en, this message translates to:
  /// **'Please select an application'**
  String get pleaseSelectApplication;

  /// No description provided for @orEnterCustomName.
  ///
  /// In en, this message translates to:
  /// **'Or enter a custom name'**
  String get orEnterCustomName;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'az', 'bg', 'ca', 'cs', 'da', 'de', 'el', 'en', 'es', 'et', 'fa', 'fr', 'hi', 'hu', 'id', 'it', 'ja', 'ko', 'lv', 'nl', 'pl', 'pt', 'ru', 'sv', 'th', 'tr', 'uk', 'ur', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'az': return AppLocalizationsAz();
    case 'bg': return AppLocalizationsBg();
    case 'ca': return AppLocalizationsCa();
    case 'cs': return AppLocalizationsCs();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'et': return AppLocalizationsEt();
    case 'fa': return AppLocalizationsFa();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'hu': return AppLocalizationsHu();
    case 'id': return AppLocalizationsId();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'lv': return AppLocalizationsLv();
    case 'nl': return AppLocalizationsNl();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'sv': return AppLocalizationsSv();
    case 'th': return AppLocalizationsTh();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'ur': return AppLocalizationsUr();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
