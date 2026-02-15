// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get login => 'लॉग इन';

  @override
  String get usePrivateKey => 'अपनी निजी कुंजी का उपयोग करें';

  @override
  String get setupAegisWithNsec => 'अपनी Nostr निजी कुंजी से Aegis सेट करें — nsec, ncryptsec और hex फॉर्मेट सपोर्ट करता है।';

  @override
  String get privateKey => 'निजी कुंजी';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex कुंजी';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordHint => 'ncryptsec डिक्रिप्ट करने के लिए पासवर्ड दर्ज करें';

  @override
  String get contentCannotBeEmpty => 'सामग्री खाली नहीं हो सकती!';

  @override
  String get passwordRequiredForNcryptsec => 'ncryptsec के लिए पासवर्ड ज़रूरी है!';

  @override
  String get decryptNcryptsecFailed => 'ncryptsec डिक्रिप्ट नहीं हो सका। पासवर्ड जाँचें।';

  @override
  String get invalidPrivateKeyFormat => 'अमान्य निजी कुंजी फॉर्मेट!';

  @override
  String get loginSuccess => 'लॉग इन सफल!';

  @override
  String loginFailed(String message) {
    return 'लॉग इन विफल: $message';
  }

  @override
  String get typeConfirmToProceed => 'जारी रखने के लिए \"confirm\" टाइप करें';

  @override
  String get logoutConfirm => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get notLoggedIn => 'लॉग इन नहीं है';

  @override
  String get language => 'भाषा';

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
  String get addAccount => 'खाता जोड़ें';

  @override
  String get updateSuccessful => 'अपडेट सफल!';

  @override
  String get switchAccount => 'खाता बदलें';

  @override
  String get switchAccountConfirm => 'क्या आप खाता बदलना चाहते हैं?';

  @override
  String get switchSuccessfully => 'बदलाव सफल!';

  @override
  String get renameAccount => 'खाता का नाम बदलें';

  @override
  String get accountName => 'खाता नाम';

  @override
  String get enterNewName => 'नया नाम दर्ज करें';

  @override
  String get accounts => 'खाते';

  @override
  String get localRelay => 'लोकल रिले';

  @override
  String get remote => 'रिमोट';

  @override
  String get browser => 'ब्राउज़र';

  @override
  String get theme => 'थीम';

  @override
  String get github => 'Github';

  @override
  String get version => 'वर्जन';

  @override
  String get appSubtitle => 'Aegis — Nostr साइनर';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get lightMode => 'लाइट मोड';

  @override
  String get systemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String switchedTo(String mode) {
    return '$mode पर स्विच किया';
  }

  @override
  String get home => 'होम';

  @override
  String get waitingForRelayStart => 'रिले शुरू होने का इंतज़ार...';

  @override
  String get connected => 'कनेक्टेड';

  @override
  String get disconnected => 'डिस्कनेक्ट';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'NIP-07 ऐप लोड करने में त्रुटि: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'अभी कोई NIP-07 ऐप नहीं।\n\nNostr ऐप खोलने के लिए ब्राउज़र इस्तेमाल करें!';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get active => 'सक्रिय';

  @override
  String get congratulationsEmptyState => 'बधाई!\n\nअब आप Aegis सपोर्ट वाले ऐप इस्तेमाल कर सकते हैं!';

  @override
  String localRelayPortInUse(String port) {
    return 'लोकल रिले पोर्ट $port पर सेट है लेकिन दूसरा ऐप इस्तेमाल कर रहा लगता है। कॉन्फ्लिक्ट ऐप बंद करके दोबारा कोशिश करें।';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'NIP-46 साइनर शुरू!';

  @override
  String get nip46FailedToStart => 'शुरू नहीं हो सका।';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get clearDatabase => 'डेटाबेस साफ़ करें';

  @override
  String get clearDatabaseConfirm => 'सभी रिले डेटा हट जाएगा और चल रहा हो तो रिले रीस्टार्ट होगा। यह एक्शन पूर्ववत नहीं हो सकता।';

  @override
  String get importDatabase => 'डेटाबेस इम्पोर्ट करें';

  @override
  String get importDatabaseHint => 'इम्पोर्ट करने के लिए डेटाबेस फ़ोल्डर पथ दर्ज करें। मौजूदा डेटाबेस का बैकअप पहले लिया जाएगा।';

  @override
  String get databaseDirectoryPath => 'डेटाबेस फ़ोल्डर पथ';

  @override
  String get import => 'इम्पोर्ट';

  @override
  String get export => 'एक्सपोर्ट';

  @override
  String get restart => 'रीस्टार्ट';

  @override
  String get restartRelay => 'रिले रीस्टार्ट करें';

  @override
  String get restartRelayConfirm => 'क्या आप रिले रीस्टार्ट करना चाहते हैं? रिले थोड़ी देर रुकेगा फिर दोबारा चलेगा।';

  @override
  String get relayRestartedSuccess => 'रिले सफलतापूर्वक रीस्टार्ट';

  @override
  String relayRestartFailed(String message) {
    return 'रिले रीस्टार्ट विफल: $message';
  }

  @override
  String get databaseClearedSuccess => 'डेटाबेस साफ़ हो गया';

  @override
  String get databaseClearFailed => 'डेटाबेस साफ़ करने में विफल';

  @override
  String errorWithMessage(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get exportDatabase => 'डेटाबेस एक्सपोर्ट करें';

  @override
  String get exportDatabaseHint => 'रिले डेटाबेस ZIP फ़ाइल के रूप में एक्सपोर्ट होगा। एक्सपोर्ट में थोड़ा समय लग सकता है।';

  @override
  String databaseExportedTo(String path) {
    return 'डेटाबेस एक्सपोर्ट हुआ: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'डेटाबेस ZIP के रूप में एक्सपोर्ट: $path';
  }

  @override
  String get databaseExportFailed => 'डेटाबेस एक्सपोर्ट विफल';

  @override
  String get importDatabaseReplaceHint => 'मौजूदा डेटाबेस इम्पोर्ट बैकअप से बदल जाएगा। इम्पोर्ट से पहले मौजूदा डेटाबेस का बैकअप लिया जाएगा। यह एक्शन पूर्ववत नहीं हो सकता।';

  @override
  String get selectDatabaseBackupFile => 'डेटाबेस बैकअप फ़ाइल (ZIP) या फ़ोल्डर चुनें';

  @override
  String get selectDatabaseBackupDir => 'डेटाबेस बैकअप फ़ोल्डर चुनें';

  @override
  String get fileOrDirNotExist => 'चुनी फ़ाइल या फ़ोल्डर मौजूद नहीं';

  @override
  String get databaseImportedSuccess => 'डेटाबेस सफलतापूर्वक इम्पोर्ट';

  @override
  String get databaseImportFailed => 'डेटाबेस इम्पोर्ट विफल';

  @override
  String get status => 'स्टेटस';

  @override
  String get address => 'पता';

  @override
  String get protocol => 'प्रोटोकॉल';

  @override
  String get connections => 'कनेक्शन';

  @override
  String get running => 'चल रहा';

  @override
  String get stopped => 'रुका';

  @override
  String get addressCopiedToClipboard => 'पता क्लिपबोर्ड पर कॉपी';

  @override
  String get exportData => 'डेटा एक्सपोर्ट';

  @override
  String get importData => 'डेटा इम्पोर्ट';

  @override
  String get systemLogs => 'सिस्टम लॉग';

  @override
  String get clearAllRelayData => 'सभी रिले डेटा साफ़ करें';

  @override
  String get noLogsAvailable => 'कोई लॉग नहीं';

  @override
  String get passwordRequired => 'पासवर्ड ज़रूरी';

  @override
  String encryptionFailed(String message) {
    return 'एन्क्रिप्शन विफल: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'एन्क्रिप्टेड निजी कुंजी क्लिपबोर्ड पर कॉपी';

  @override
  String get accountBackup => 'खाता बैकअप';

  @override
  String get publicAccountId => 'पब्लिक खाता ID';

  @override
  String get accountPrivateKey => 'खाते की निजी कुंजी';

  @override
  String get show => 'दिखाएं';

  @override
  String get generate => 'जनरेट';

  @override
  String get enterEncryptionPassword => 'एन्क्रिप्शन पासवर्ड दर्ज करें';

  @override
  String get privateKeyEncryption => 'निजी कुंजी एन्क्रिप्शन';

  @override
  String get encryptPrivateKeyHint => 'सुरक्षा के लिए निजी कुंजी एन्क्रिप्ट करें। कुंजी पासवर्ड से एन्क्रिप्ट होगी।';

  @override
  String get ncryptsecHint => 'एन्क्रिप्टेड कुंजी \"ncryptsec1\" से शुरू होगी और बिना पासवर्ड इस्तेमाल नहीं हो सकती।';

  @override
  String get encryptAndCopyPrivateKey => 'निजी कुंजी एन्क्रिप्ट और कॉपी करें';

  @override
  String get privateKeyEncryptedSuccess => 'निजी कुंजी एन्क्रिप्ट हो गई!';

  @override
  String get encryptedKeyNcryptsec => 'एन्क्रिप्टेड कुंजी (ncryptsec):';

  @override
  String get createNewNostrAccount => 'नया Nostr खाता बनाएं';

  @override
  String get accountReadyPublicKeyHint => 'आपका Nostr खाता तैयार! यह आपकी nostr पब्लिक कुंजी है:';

  @override
  String get nostrPubkey => 'Nostr पब्लिक कुंजी';

  @override
  String get create => 'बनाएं';

  @override
  String get createSuccess => 'बन गया!';

  @override
  String get application => 'ऐप';

  @override
  String get createApplication => 'ऐप बनाएं';

  @override
  String get addNewApplication => 'नया ऐप जोड़ें';

  @override
  String get addNsecbunkerManually => 'nsecbunker मैन्युअल जोड़ें';

  @override
  String get loginUsingUrlScheme => 'URL स्कीम से लॉग इन';

  @override
  String get addApplicationMethodsHint => 'Aegis से कनेक्ट करने के लिए इनमें से कोई तरीका चुन सकते हैं!';

  @override
  String get urlSchemeLoginHint => 'लॉग इन के लिए Aegis URL स्कीम सपोर्ट वाले ऐप से खोलें';

  @override
  String get name => 'नाम';

  @override
  String get applicationInfo => 'ऐप जानकारी';

  @override
  String get activities => 'एक्टिविटी';

  @override
  String get clientPubkey => 'क्लाइंट पब्लिक कुंजी';

  @override
  String get remove => 'हटाएं';

  @override
  String get removeAppConfirm => 'क्या आप इस ऐप की सभी अनुमतियाँ हटाना चाहते हैं?';

  @override
  String get removeSuccess => 'हटा दिया';

  @override
  String get nameCannotBeEmpty => 'नाम खाली नहीं हो सकता';

  @override
  String get nameTooLong => 'नाम बहुत लंबा।';

  @override
  String get updateSuccess => 'अपडेट सफल';

  @override
  String get editConfiguration => 'कॉन्फ़िग संपादित करें';

  @override
  String get update => 'अपडेट';

  @override
  String get search => 'खोजें...';

  @override
  String get enterCustomName => 'कस्टम नाम दर्ज करें';

  @override
  String get selectApplication => 'ऐप चुनें';

  @override
  String get addWebApp => 'वेब ऐप जोड़ें';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'मेरा ऐप';

  @override
  String get add => 'जोड़ें';

  @override
  String get searchNostrApps => 'Nostr ऐप खोजें...';

  @override
  String get invalidUrlHint => 'अमान्य URL। वैध HTTP या HTTPS URL दर्ज करें।';

  @override
  String get appAlreadyInList => 'यह ऐप पहले से सूची में है।';

  @override
  String appAdded(String name) {
    return '$name जोड़ा गया';
  }

  @override
  String appAddFailed(String error) {
    return 'ऐप जोड़ने में विफल: $error';
  }

  @override
  String get deleteApp => 'ऐप हटाएं';

  @override
  String deleteAppConfirm(String name) {
    return 'क्या आप \"$name\" हटाना चाहते हैं?';
  }

  @override
  String get delete => 'हटाएं';

  @override
  String appDeleted(String name) {
    return '$name हटा दिया';
  }

  @override
  String appDeleteFailed(String error) {
    return 'ऐप हटाने में विफल: $error';
  }

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी';

  @override
  String get eventDetails => 'इवेंट विवरण';

  @override
  String get eventDetailsCopiedToClipboard => 'इवेंट विवरण क्लिपबोर्ड पर कॉपी';

  @override
  String get rawMetadataCopiedToClipboard => 'रॉ मेटाडेटा क्लिपबोर्ड पर कॉपी';

  @override
  String get permissionRequest => 'अनुमति अनुरोध';

  @override
  String get permissionRequestContent => 'यह ऐप आपके Nostr खाते तक पहुँच की अनुमति माँग रहा है';

  @override
  String get grantPermissions => 'अनुमति दें';

  @override
  String get reject => 'अस्वीकार';

  @override
  String get fullAccessGranted => 'पूर्ण पहुँच दी गई';

  @override
  String get fullAccessHint => 'इस ऐप को आपके Nostr खाते की पूर्ण पहुँच होगी, जिसमें:';

  @override
  String get permissionAccessPubkey => 'आपकी Nostr पब्लिक कुंजी तक पहुँच';

  @override
  String get permissionSignEvents => 'Nostr इवेंट पर साइन करना';

  @override
  String get permissionEncryptDecrypt => 'इवेंट एन्क्रिप्ट/डिक्रिप्ट (NIP-04 और NIP-44)';

  @override
  String get tips => 'टिप्स';

  @override
  String get schemeLoginFirst => 'स्कीम हल नहीं हो सकता, पहले लॉग इन करें।';

  @override
  String get newConnectionRequest => 'नया कनेक्शन अनुरोध';

  @override
  String get newConnectionNoSlotHint => 'नया ऐप कनेक्ट करने की कोशिश कर रहा है लेकिन कोई खाली ऐप नहीं। पहले नया ऐप बनाएं।';

  @override
  String get copiedSuccessfully => 'कॉपी हो गया';

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
  String get noResultsFound => 'कोई परिणाम नहीं मिला';

  @override
  String get pleaseSelectApplication => 'कृपया एक ऐप चुनें';

  @override
  String get orEnterCustomName => 'या कस्टम नाम दर्ज करें';

  @override
  String get continueButton => 'जारी रखें';
}
