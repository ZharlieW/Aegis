// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get cancel => 'منسوخ';

  @override
  String get settings => 'ترتیبات';

  @override
  String get logout => 'لاگ آؤٹ';

  @override
  String get login => 'لاگ ان';

  @override
  String get usePrivateKey => 'اپنی نجی کلید استعمال کریں';

  @override
  String get setupAegisWithNsec => 'Aegis کو اپنی Nostr نجی کلید سے سیٹ کریں — nsec، ncryptsec اور hex فارمیٹس سپورٹ کرتا ہے۔';

  @override
  String get privateKey => 'نجی کلید';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex کلید';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get passwordHint => 'ncryptsec ڈیکرپٹ کرنے کے لیے پاس ورڈ درج کریں';

  @override
  String get contentCannotBeEmpty => 'مواد خالی نہیں ہو سکتا!';

  @override
  String get passwordRequiredForNcryptsec => 'ncryptsec کے لیے پاس ورڈ ضروری ہے!';

  @override
  String get decryptNcryptsecFailed => 'ncryptsec ڈیکرپٹ نہیں ہو سکا۔ پاس ورڈ چیک کریں۔';

  @override
  String get invalidPrivateKeyFormat => 'نجی کلید کا فارمیٹ غلط ہے!';

  @override
  String get loginSuccess => 'لاگ ان کامیاب!';

  @override
  String loginFailed(String message) {
    return 'لاگ ان ناکام: $message';
  }

  @override
  String get typeConfirmToProceed => 'جاری رکھنے کے لیے \"confirm\" ٹائپ کریں';

  @override
  String get logoutConfirm => 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get notLoggedIn => 'لاگ ان نہیں ہے';

  @override
  String get language => 'زبان';

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
  String get addAccount => 'اکاؤنٹ شامل کریں';

  @override
  String get updateSuccessful => 'اپڈیٹ کامیاب!';

  @override
  String get switchAccount => 'اکاؤنٹ بدلیں';

  @override
  String get switchAccountConfirm => 'کیا آپ اکاؤنٹ بدلنا چاہتے ہیں؟';

  @override
  String get switchSuccessfully => 'تبدیلی کامیاب!';

  @override
  String get renameAccount => 'اکاؤنٹ کا نام بدلیں';

  @override
  String get accountName => 'اکاؤنٹ کا نام';

  @override
  String get enterNewName => 'نیا نام درج کریں';

  @override
  String get accounts => 'اکاؤنٹس';

  @override
  String get localRelay => 'لوکل ریلے';

  @override
  String get remote => 'ریموٹ';

  @override
  String get browser => 'براؤزر';

  @override
  String get theme => 'تھیم';

  @override
  String get github => 'Github';

  @override
  String get version => 'ورژن';

  @override
  String get appSubtitle => 'Aegis — Nostr دستخط کنندہ';

  @override
  String get darkMode => 'ڈارک موڈ';

  @override
  String get lightMode => 'لائٹ موڈ';

  @override
  String get systemDefault => 'سسٹم ڈیفالٹ';

  @override
  String switchedTo(String mode) {
    return '$mode پر سوئچ ہو گیا';
  }

  @override
  String get home => 'ہوم';

  @override
  String get waitingForRelayStart => 'ریلے شروع ہونے کا انتظار...';

  @override
  String get connected => 'منسلک';

  @override
  String get disconnected => 'منقطع';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'NIP-07 ایپس لوڈ کرنے میں خرابی: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'ابھی NIP-07 ایپس نہیں۔\n\nNostr ایپس کے لیے براؤزر استعمال کریں!';

  @override
  String get unknown => 'نامعلوم';

  @override
  String get active => 'فعال';

  @override
  String get congratulationsEmptyState => 'مبارک ہو!\n\nاب آپ Aegis سپورٹ والی ایپس استعمال کر سکتے ہیں!';

  @override
  String localRelayPortInUse(String port) {
    return 'لوکل ریلے پورٹ $port پر سیٹ ہے لیکن دوسری ایپ استعمال کر رہی لگتی ہے۔ conflicting ایپ بند کر کے دوبارہ کوشش کریں۔';
  }

  @override
  String get nip46Started => 'NIP-46 دستخط کنندہ شروع!';

  @override
  String get nip46FailedToStart => 'شروع نہیں ہو سکا۔';

  @override
  String get retry => 'دوبارہ کوشش';

  @override
  String get clear => 'صاف کریں';

  @override
  String get clearDatabase => 'ڈیٹا بیس صاف کریں';

  @override
  String get clearDatabaseConfirm => 'تمام ریلے ڈیٹا حذف ہو جائے گا اور چل رہا ہو تو ریلے ریسٹارٹ ہو گا۔ یہ ایکشن واپس نہیں ہو سکتا۔';

  @override
  String get importDatabase => 'ڈیٹا بیس درآمد کریں';

  @override
  String get importDatabaseHint => 'درآمد کے لیے ڈیٹا بیس فولڈر کا راستہ درج کریں۔ موجودہ ڈیٹا بیس کا بیک اپ پہلے لیا جائے گا۔';

  @override
  String get databaseDirectoryPath => 'ڈیٹا بیس فولڈر کا راستہ';

  @override
  String get import => 'درآمد';

  @override
  String get export => 'برآمد';

  @override
  String get restart => 'ریسٹارٹ';

  @override
  String get restartRelay => 'ریلے ریسٹارٹ کریں';

  @override
  String get restartRelayConfirm => 'کیا آپ ریلے ریسٹارٹ کرنا چاہتے ہیں؟ ریلے عارضی طور پر رک جائے گا پھر دوبارہ شروع ہو گا۔';

  @override
  String get relayRestartedSuccess => 'ریلے کامیابی سے ریسٹارٹ';

  @override
  String relayRestartFailed(String message) {
    return 'ریلے ریسٹارٹ ناکام: $message';
  }

  @override
  String get databaseClearedSuccess => 'ڈیٹا بیس صاف ہو گیا';

  @override
  String get databaseClearFailed => 'ڈیٹا بیس صاف کرنا ناکام';

  @override
  String errorWithMessage(String message) {
    return 'خرابی: $message';
  }

  @override
  String get exportDatabase => 'ڈیٹا بیس برآمد کریں';

  @override
  String get exportDatabaseHint => 'ریلے ڈیٹا بیس ZIP فائل کے طور پر برآمد ہو گی۔ برآمد میں تھوڑا وقت لگ سکتا ہے۔';

  @override
  String databaseExportedTo(String path) {
    return 'ڈیٹا بیس برآمد ہوا: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'ڈیٹا بیس ZIP کے طور پر برآمد: $path';
  }

  @override
  String get databaseExportFailed => 'ڈیٹا بیس برآمد ناکام';

  @override
  String get importDatabaseReplaceHint => 'موجودہ ڈیٹا بیس درآمد شدہ بیک اپ سے بدل جائے گی۔ درآمد سے پہلے موجودہ ڈیٹا بیس کا بیک اپ لیا جائے گا۔ یہ ایکشن واپس نہیں ہو سکتا۔';

  @override
  String get selectDatabaseBackupFile => 'ڈیٹا بیس بیک اپ فائل (ZIP) یا فولڈر منتخب کریں';

  @override
  String get selectDatabaseBackupDir => 'ڈیٹا بیس بیک اپ فولڈر منتخب کریں';

  @override
  String get fileOrDirNotExist => 'منتخب فائل یا فولڈر موجود نہیں';

  @override
  String get databaseImportedSuccess => 'ڈیٹا بیس کامیابی سے درآمد';

  @override
  String get databaseImportFailed => 'ڈیٹا بیس درآمد ناکام';

  @override
  String get status => 'حیثیت';

  @override
  String get address => 'پتہ';

  @override
  String get protocol => 'پروٹوکول';

  @override
  String get connections => 'کنکشن';

  @override
  String get running => 'چل رہا';

  @override
  String get stopped => 'رک گیا';

  @override
  String get addressCopiedToClipboard => 'پتہ کلپ بورڈ پر کاپی';

  @override
  String get exportData => 'ڈیٹا برآمد';

  @override
  String get importData => 'ڈیٹا درآمد';

  @override
  String get systemLogs => 'سسٹم لاگز';

  @override
  String get clearAllRelayData => 'تمام ریلے ڈیٹا صاف کریں';

  @override
  String get noLogsAvailable => 'لاگز دستیاب نہیں';

  @override
  String get passwordRequired => 'پاس ورڈ ضروری';

  @override
  String encryptionFailed(String message) {
    return 'خفیہ کاری ناکام: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'خفیہ نجی کلید کلپ بورڈ پر کاپی';

  @override
  String get accountBackup => 'اکاؤنٹ بیک اپ';

  @override
  String get publicAccountId => 'عوامی اکاؤنٹ ID';

  @override
  String get accountPrivateKey => 'اکاؤنٹ کی نجی کلید';

  @override
  String get show => 'دکھائیں';

  @override
  String get generate => 'بنائیں';

  @override
  String get enterEncryptionPassword => 'خفیہ کاری کا پاس ورڈ درج کریں';

  @override
  String get privateKeyEncryption => 'نجی کلید کی خفیہ کاری';

  @override
  String get encryptPrivateKeyHint => 'سیکیورٹی کے لیے نجی کلید خفیہ کریں۔ کلید پاس ورڈ سے خفیہ ہو گی۔';

  @override
  String get ncryptsecHint => 'خفیہ کلید \"ncryptsec1\" سے شروع ہو گی اور بغیر پاس ورڈ استعمال نہیں ہو سکتی۔';

  @override
  String get encryptAndCopyPrivateKey => 'نجی کلید خفیہ اور کاپی کریں';

  @override
  String get privateKeyEncryptedSuccess => 'نجی کلید خفیہ ہو گئی!';

  @override
  String get encryptedKeyNcryptsec => 'خفیہ کلید (ncryptsec):';

  @override
  String get createNewNostrAccount => 'نیا Nostr اکاؤنٹ بنائیں';

  @override
  String get accountReadyPublicKeyHint => 'آپ کا Nostr اکاؤنٹ تیار! یہ آپ کی nostr عوامی کلید ہے:';

  @override
  String get nostrPubkey => 'Nostr عوامی کلید';

  @override
  String get create => 'بنائیں';

  @override
  String get createSuccess => 'بن گیا!';

  @override
  String get application => 'ایپ';

  @override
  String get createApplication => 'ایپ بنائیں';

  @override
  String get addNewApplication => 'نیا ایپ شامل کریں';

  @override
  String get addNsecbunkerManually => 'nsecbunker دستی شامل کریں';

  @override
  String get loginUsingUrlScheme => 'URL سکیم سے لاگ ان';

  @override
  String get addApplicationMethodsHint => 'Aegis سے جوڑنے کے لیے ان میں سے کوئی طریقہ منتخب کر سکتے ہیں!';

  @override
  String get urlSchemeLoginHint => 'لاگ ان کے لیے Aegis URL سکیم سپورٹ والی ایپ سے کھولیں';

  @override
  String get name => 'نام';

  @override
  String get applicationInfo => 'ایپ کی معلومات';

  @override
  String get activities => 'سرگرمیاں';

  @override
  String get clientPubkey => 'کلائنٹ عوامی کلید';

  @override
  String get remove => 'ہٹائیں';

  @override
  String get removeAppConfirm => 'کیا آپ اس ایپ کی تمام اجازتیں ہٹانا چاہتے ہیں؟';

  @override
  String get removeSuccess => 'ہٹا دیا';

  @override
  String get nameCannotBeEmpty => 'نام خالی نہیں ہو سکتا';

  @override
  String get nameTooLong => 'نام بہت لمبا۔';

  @override
  String get updateSuccess => 'اپڈیٹ کامیاب';

  @override
  String get editConfiguration => 'کنفیگریشن میں ترمیم';

  @override
  String get update => 'اپڈیٹ';

  @override
  String get search => 'تلاش...';

  @override
  String get enterCustomName => 'اپنا نام درج کریں';

  @override
  String get selectApplication => 'ایپ منتخب کریں';

  @override
  String get addWebApp => 'ویب ایپ شامل کریں';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'میری ایپ';

  @override
  String get add => 'شامل کریں';

  @override
  String get searchNostrApps => 'Nostr ایپس تلاش کریں...';

  @override
  String get invalidUrlHint => 'غلط URL۔ درست HTTP یا HTTPS URL درج کریں۔';

  @override
  String get appAlreadyInList => 'یہ ایپ پہلے سے فہرست میں ہے۔';

  @override
  String appAdded(String name) {
    return '$name شامل ہو گیا';
  }

  @override
  String appAddFailed(String error) {
    return 'ایپ شامل کرنا ناکام: $error';
  }

  @override
  String get deleteApp => 'ایپ حذف کریں';

  @override
  String deleteAppConfirm(String name) {
    return 'کیا آپ \"$name\" حذف کرنا چاہتے ہیں؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String appDeleted(String name) {
    return '$name حذف ہو گیا';
  }

  @override
  String appDeleteFailed(String error) {
    return 'ایپ حذف کرنا ناکام: $error';
  }

  @override
  String get copiedToClipboard => 'کلپ بورڈ پر کاپی';

  @override
  String get eventDetails => 'ایونٹ کی تفصیلات';

  @override
  String get eventDetailsCopiedToClipboard => 'ایونٹ کی تفصیلات کلپ بورڈ پر کاپی';

  @override
  String get rawMetadataCopiedToClipboard => 'خام میٹا ڈیٹا کلپ بورڈ پر کاپی';

  @override
  String get permissionRequest => 'اجازت کی درخواست';

  @override
  String get permissionRequestContent => 'یہ ایپ آپ کے Nostr اکاؤنٹ تک رسائی کی اجازت مانگ رہی ہے';

  @override
  String get grantPermissions => 'اجازتیں دیں';

  @override
  String get reject => 'مسترد';

  @override
  String get fullAccessGranted => 'مکمل رسائی دی گئی';

  @override
  String get fullAccessHint => 'اس ایپ کو آپ کے Nostr اکاؤنٹ کی مکمل رسائی ہو گی، بشمول:';

  @override
  String get permissionAccessPubkey => 'آپ کی Nostr عوامی کلید تک رسائی';

  @override
  String get permissionSignEvents => 'Nostr ایونٹس پر دستخط';

  @override
  String get permissionEncryptDecrypt => 'ایونٹس خفیہ/ڈیکرپٹ (NIP-04 اور NIP-44)';

  @override
  String get tips => 'نکات';

  @override
  String get schemeLoginFirst => 'سکیم حل نہیں ہو سکتا، پہلے لاگ ان کریں۔';

  @override
  String get newConnectionRequest => 'نیا کنکشن درخواست';

  @override
  String get newConnectionNoSlotHint => 'نیا ایپ جوڑنے کی کوشش کر رہا ہے لیکن خالی ایپ دستیاب نہیں۔ پہلے نیا ایپ بنائیں۔';

  @override
  String get copiedSuccessfully => 'کامیابی سے کاپی';

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
  String get noResultsFound => 'کوئی نتیجہ نہیں ملا';

  @override
  String get pleaseSelectApplication => 'براہ کرم ایک ایپ منتخب کریں';

  @override
  String get orEnterCustomName => 'یا اپنا نام درج کریں';

  @override
  String get continueButton => 'جاری رکھیں';
}
