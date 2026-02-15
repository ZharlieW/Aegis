// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'تأیید';

  @override
  String get cancel => 'لغو';

  @override
  String get settings => 'تنظیمات';

  @override
  String get logout => 'خروج';

  @override
  String get login => 'ورود';

  @override
  String get usePrivateKey => 'از کلید خصوصی استفاده کنید';

  @override
  String get setupAegisWithNsec => 'Aegis را با کلید Nostr خود تنظیم کنید — از nsec، ncryptsec و hex پشتیبانی می‌کند.';

  @override
  String get privateKey => 'کلید خصوصی';

  @override
  String get privateKeyHint => 'کلید nsec / ncryptsec / hex';

  @override
  String get password => 'رمز عبور';

  @override
  String get passwordHint => 'برای رمزگشایی ncryptsec رمز عبور را وارد کنید';

  @override
  String get contentCannotBeEmpty => 'محتوا نمی‌تواند خالی باشد!';

  @override
  String get passwordRequiredForNcryptsec => 'برای ncryptsec رمز عبور لازم است!';

  @override
  String get decryptNcryptsecFailed => 'رمزگشایی ncryptsec ناموفق بود. رمز عبور را بررسی کنید.';

  @override
  String get invalidPrivateKeyFormat => 'فرمت کلید خصوصی نامعتبر است!';

  @override
  String get loginSuccess => 'ورود موفق!';

  @override
  String loginFailed(String message) {
    return 'ورود ناموفق: $message';
  }

  @override
  String get typeConfirmToProceed => 'برای ادامه \"confirm\" را تایپ کنید';

  @override
  String get logoutConfirm => 'آیا مطمئن هستید که می‌خواهید خارج شوید؟';

  @override
  String get notLoggedIn => 'وارد نشده';

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
  String get addAccount => 'افزودن حساب';

  @override
  String get updateSuccessful => 'به‌روزرسانی موفق!';

  @override
  String get switchAccount => 'تعویض حساب';

  @override
  String get switchAccountConfirm => 'آیا مطمئن هستید که می‌خواهید حساب عوض کنید؟';

  @override
  String get switchSuccessfully => 'تعویض موفق!';

  @override
  String get renameAccount => 'تغییر نام حساب';

  @override
  String get accountName => 'نام حساب';

  @override
  String get enterNewName => 'نام جدید وارد کنید';

  @override
  String get accounts => 'حساب‌ها';

  @override
  String get localRelay => 'رله محلی';

  @override
  String get remote => 'از راه دور';

  @override
  String get browser => 'مرورگر';

  @override
  String get theme => 'تم';

  @override
  String get github => 'Github';

  @override
  String get version => 'نسخه';

  @override
  String get appSubtitle => 'Aegis — امضاکننده Nostr';

  @override
  String get darkMode => 'حالت تاریک';

  @override
  String get lightMode => 'حالت روشن';

  @override
  String get systemDefault => 'پیش‌فرض سیستم';

  @override
  String switchedTo(String mode) {
    return 'تغییر به $mode';
  }

  @override
  String get home => 'خانه';

  @override
  String get waitingForRelayStart => 'در انتظار راه‌اندازی رله...';

  @override
  String get connected => 'متصل';

  @override
  String get disconnected => 'قطع شده';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'خطا در بارگذاری برنامه‌های NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'هنوز برنامه NIP-07 ندارید.\n\nاز مرورگر برای دسترسی به برنامه‌های Nostr استفاده کنید!';

  @override
  String get unknown => 'ناشناخته';

  @override
  String get active => 'فعال';

  @override
  String get congratulationsEmptyState => 'تبریک!\n\nاکنون می‌توانید از برنامه‌های سازگار با Aegis استفاده کنید!';

  @override
  String localRelayPortInUse(String port) {
    return 'رله محلی روی پورت $port تنظیم شده اما به نظر می‌رسد برنامه دیگری از آن استفاده می‌کند. برنامه تداخلی را ببندید و دوباره امتحان کنید.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'امضاکننده NIP-46 راه‌اندازی شد!';

  @override
  String get nip46FailedToStart => 'راه‌اندازی ناموفق.';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get clear => 'پاک کردن';

  @override
  String get clearDatabase => 'پاک کردن پایگاه داده';

  @override
  String get clearDatabaseConfirm => 'همه داده‌های رله حذف می‌شود و در صورت اجرا رله مجدداً راه‌اندازی می‌شود. این عمل قابل بازگشت نیست.';

  @override
  String get importDatabase => 'وارد کردن پایگاه داده';

  @override
  String get importDatabaseHint => 'مسیر پوشه پایگاه داده برای وارد کردن را وارد کنید. پایگاه موجود قبل از وارد کردن پشتیبان می‌شود.';

  @override
  String get databaseDirectoryPath => 'مسیر پوشه پایگاه داده';

  @override
  String get import => 'وارد کردن';

  @override
  String get export => 'صادر کردن';

  @override
  String get restart => 'راه‌اندازی مجدد';

  @override
  String get restartRelay => 'راه‌اندازی مجدد رله';

  @override
  String get restartRelayConfirm => 'آیا مطمئن هستید که می‌خواهید رله را مجدداً راه‌اندازی کنید؟ رله موقتاً متوقف و سپس دوباره راه‌اندازی می‌شود.';

  @override
  String get relayRestartedSuccess => 'رله با موفقیت راه‌اندازی مجدد شد';

  @override
  String relayRestartFailed(String message) {
    return 'راه‌اندازی مجدد رله ناموفق: $message';
  }

  @override
  String get databaseClearedSuccess => 'پایگاه داده با موفقیت پاک شد';

  @override
  String get databaseClearFailed => 'پاک کردن پایگاه داده ناموفق';

  @override
  String errorWithMessage(String message) {
    return 'خطا: $message';
  }

  @override
  String get exportDatabase => 'صادر کردن پایگاه داده';

  @override
  String get exportDatabaseHint => 'پایگاه داده رله به صورت فایل ZIP صادر می‌شود. صادر کردن ممکن است کمی طول بکشد.';

  @override
  String databaseExportedTo(String path) {
    return 'پایگاه داده صادر شد به: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'پایگاه داده به صورت ZIP صادر شد: $path';
  }

  @override
  String get databaseExportFailed => 'صادر کردن پایگاه داده ناموفق';

  @override
  String get importDatabaseReplaceHint => 'پایگاه فعلی با پشتیبان وارد شده جایگزین می‌شود. پایگاه موجود قبل از وارد کردن پشتیبان می‌شود. این عمل قابل بازگشت نیست.';

  @override
  String get selectDatabaseBackupFile => 'فایل (ZIP) یا پوشه پشتیبان پایگاه داده را انتخاب کنید';

  @override
  String get selectDatabaseBackupDir => 'پوشه پشتیبان پایگاه داده را انتخاب کنید';

  @override
  String get fileOrDirNotExist => 'فایل یا پوشه انتخاب شده وجود ندارد';

  @override
  String get databaseImportedSuccess => 'پایگاه داده با موفقیت وارد شد';

  @override
  String get databaseImportFailed => 'وارد کردن پایگاه داده ناموفق';

  @override
  String get status => 'وضعیت';

  @override
  String get address => 'نشانی';

  @override
  String get protocol => 'پروتکل';

  @override
  String get connections => 'اتصال‌ها';

  @override
  String get running => 'در حال اجرا';

  @override
  String get stopped => 'متوقف';

  @override
  String get addressCopiedToClipboard => 'نشانی در کلیپ‌بورد کپی شد';

  @override
  String get exportData => 'صادر کردن داده';

  @override
  String get importData => 'وارد کردن داده';

  @override
  String get systemLogs => 'لاگ‌های سیستم';

  @override
  String get clearAllRelayData => 'پاک کردن همه داده‌های رله';

  @override
  String get noLogsAvailable => 'لاگی موجود نیست';

  @override
  String get passwordRequired => 'رمز عبور لازم است';

  @override
  String encryptionFailed(String message) {
    return 'رمزنگاری ناموفق: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'کلید خصوصی رمزنگاری‌شده در کلیپ‌بورد کپی شد';

  @override
  String get accountBackup => 'پشتیبان حساب';

  @override
  String get publicAccountId => 'شناسه عمومی حساب';

  @override
  String get accountPrivateKey => 'کلید خصوصی حساب';

  @override
  String get show => 'نمایش';

  @override
  String get generate => 'تولید';

  @override
  String get enterEncryptionPassword => 'رمز عبور رمزنگاری را وارد کنید';

  @override
  String get privateKeyEncryption => 'رمزنگاری کلید خصوصی';

  @override
  String get encryptPrivateKeyHint => 'کلید خصوصی را برای امنیت بیشتر رمزنگاری کنید. کلید با رمز عبور رمزنگاری می‌شود.';

  @override
  String get ncryptsecHint => 'کلید رمزنگاری‌شده با \"ncryptsec1\" شروع می‌شود و بدون رمز عبور قابل استفاده نیست.';

  @override
  String get encryptAndCopyPrivateKey => 'رمزنگاری و کپی کلید خصوصی';

  @override
  String get privateKeyEncryptedSuccess => 'کلید خصوصی با موفقیت رمزنگاری شد!';

  @override
  String get encryptedKeyNcryptsec => 'کلید رمزنگاری‌شده (ncryptsec):';

  @override
  String get createNewNostrAccount => 'ایجاد حساب Nostr جدید';

  @override
  String get accountReadyPublicKeyHint => 'حساب Nostr شما آماده است! این کلید عمومی nostr شماست:';

  @override
  String get nostrPubkey => 'کلید عمومی Nostr';

  @override
  String get create => 'ایجاد';

  @override
  String get createSuccess => 'با موفقیت ایجاد شد!';

  @override
  String get application => 'برنامه';

  @override
  String get createApplication => 'ایجاد برنامه';

  @override
  String get addNewApplication => 'افزودن برنامه جدید';

  @override
  String get addNsecbunkerManually => 'افزودن nsecbunker دستی';

  @override
  String get loginUsingUrlScheme => 'ورود با طرح URL';

  @override
  String get addApplicationMethodsHint => 'می‌توانید هر یک از این روش‌ها را برای اتصال به Aegis انتخاب کنید!';

  @override
  String get urlSchemeLoginHint => 'با برنامه‌ای که طرح URL Aegis را پشتیبانی می‌کند برای ورود باز کنید';

  @override
  String get name => 'نام';

  @override
  String get applicationInfo => 'اطلاعات برنامه';

  @override
  String get activities => 'فعالیت‌ها';

  @override
  String get clientPubkey => 'کلید عمومی کلاینت';

  @override
  String get remove => 'حذف';

  @override
  String get removeAppConfirm => 'آیا مطمئن هستید که می‌خواهید همه مجوزهای این برنامه را حذف کنید؟';

  @override
  String get removeSuccess => 'حذف موفق';

  @override
  String get nameCannotBeEmpty => 'نام نمی‌تواند خالی باشد';

  @override
  String get nameTooLong => 'نام خیلی طولانی است.';

  @override
  String get updateSuccess => 'به‌روزرسانی موفق';

  @override
  String get editConfiguration => 'ویرایش پیکربندی';

  @override
  String get update => 'به‌روزرسانی';

  @override
  String get search => 'جستجو...';

  @override
  String get enterCustomName => 'نام سفارشی وارد کنید';

  @override
  String get selectApplication => 'یک برنامه انتخاب کنید';

  @override
  String get addWebApp => 'افزودن برنامه وب';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'برنامه من';

  @override
  String get add => 'افزودن';

  @override
  String get searchNostrApps => 'جستجوی برنامه‌های Nostr...';

  @override
  String get invalidUrlHint => 'URL نامعتبر. یک URL معتبر HTTP یا HTTPS وارد کنید.';

  @override
  String get appAlreadyInList => 'این برنامه از قبل در فهرست است.';

  @override
  String appAdded(String name) {
    return '$name اضافه شد';
  }

  @override
  String appAddFailed(String error) {
    return 'افزودن برنامه ناموفق: $error';
  }

  @override
  String get deleteApp => 'حذف برنامه';

  @override
  String deleteAppConfirm(String name) {
    return 'آیا مطمئن هستید که می‌خواهید \"$name\" را حذف کنید؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String appDeleted(String name) {
    return '$name حذف شد';
  }

  @override
  String appDeleteFailed(String error) {
    return 'حذف برنامه ناموفق: $error';
  }

  @override
  String get copiedToClipboard => 'در کلیپ‌بورد کپی شد';

  @override
  String get eventDetails => 'جزئیات رویداد';

  @override
  String get eventDetailsCopiedToClipboard => 'جزئیات رویداد در کلیپ‌بورد کپی شد';

  @override
  String get rawMetadataCopiedToClipboard => 'متادیتای خام در کلیپ‌بورد کپی شد';

  @override
  String get permissionRequest => 'درخواست مجوز';

  @override
  String get permissionRequestContent => 'این برنامه درخواست دسترسی به حساب Nostr شما را دارد';

  @override
  String get grantPermissions => 'اعطای مجوزها';

  @override
  String get reject => 'رد';

  @override
  String get fullAccessGranted => 'دسترسی کامل اعطا شد';

  @override
  String get fullAccessHint => 'این برنامه دسترسی کامل به حساب Nostr شما خواهد داشت، از جمله:';

  @override
  String get permissionAccessPubkey => 'دسترسی به کلید عمومی Nostr شما';

  @override
  String get permissionSignEvents => 'امضای رویدادهای Nostr';

  @override
  String get permissionEncryptDecrypt => 'رمزنگاری و رمزگشایی رویدادها (NIP-04 و NIP-44)';

  @override
  String get tips => 'نکات';

  @override
  String get schemeLoginFirst => 'نمی‌توان طرح را حل کرد، ابتدا وارد شوید.';

  @override
  String get newConnectionRequest => 'درخواست اتصال جدید';

  @override
  String get newConnectionNoSlotHint => 'برنامه جدید می‌خواهد وصل شود اما برنامه خالی در دسترس نیست. ابتدا یک برنامه جدید ایجاد کنید.';

  @override
  String get copiedSuccessfully => 'با موفقیت کپی شد';

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
  String get noResultsFound => 'نتیجه‌ای یافت نشد';

  @override
  String get pleaseSelectApplication => 'لطفاً یک برنامه انتخاب کنید';

  @override
  String get orEnterCustomName => 'یا نام سفارشی وارد کنید';

  @override
  String get continueButton => 'ادامه';
}
