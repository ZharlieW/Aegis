// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get usePrivateKey => 'استخدم مفتاحك الخاص';

  @override
  String get setupAegisWithNsec => 'إعداد Aegis بمفتاح Nostr الخاص — يدعم nsec وncryptsec وhex.';

  @override
  String get privateKey => 'المفتاح الخاص';

  @override
  String get privateKeyHint => 'مفتاح nsec / ncryptsec / hex';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور لفك تشفير ncryptsec';

  @override
  String get contentCannotBeEmpty => 'المحتوى لا يمكن أن يكون فارغاً!';

  @override
  String get passwordRequiredForNcryptsec => 'كلمة المرور مطلوبة لـ ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'فشل فك تشفير ncryptsec. تحقق من كلمة المرور.';

  @override
  String get invalidPrivateKeyFormat => 'تنسيق المفتاح الخاص غير صالح!';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح!';

  @override
  String loginFailed(String message) {
    return 'فشل تسجيل الدخول: $message';
  }

  @override
  String get typeConfirmToProceed => 'اكتب \"confirm\" للمتابعة';

  @override
  String get logoutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get notLoggedIn => 'غير مسجل الدخول';

  @override
  String get language => 'اللغة';

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
  String get addAccount => 'إضافة حساب';

  @override
  String get updateSuccessful => 'تم التحديث بنجاح!';

  @override
  String get switchAccount => 'تبديل الحساب';

  @override
  String get switchAccountConfirm => 'هل تريد تبديل الحساب؟';

  @override
  String get switchSuccessfully => 'تم التبديل بنجاح!';

  @override
  String get renameAccount => 'إعادة تسمية الحساب';

  @override
  String get accountName => 'اسم الحساب';

  @override
  String get enterNewName => 'أدخل الاسم الجديد';

  @override
  String get accounts => 'الحسابات';

  @override
  String get localRelay => 'الريليه المحلي';

  @override
  String get remote => 'بعيد';

  @override
  String get browser => 'المتصفح';

  @override
  String get theme => 'المظهر';

  @override
  String get github => 'Github';

  @override
  String get version => 'الإصدار';

  @override
  String get appSubtitle => 'Aegis - موقع Nostr';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String switchedTo(String mode) {
    return 'تم التبديل إلى $mode';
  }

  @override
  String get home => 'الرئيسية';

  @override
  String get waitingForRelayStart => 'جاري انتظار بدء الريليه...';

  @override
  String get connected => 'متصل';

  @override
  String get disconnected => 'غير متصل';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'خطأ في تحميل تطبيقات NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'لا توجد تطبيقات NIP-07 بعد.\n\nاستخدم المتصفح للوصول إلى تطبيقات Nostr!';

  @override
  String get unknown => 'غير معروف';

  @override
  String get active => 'نشط';

  @override
  String get congratulationsEmptyState => 'تهانينا!\n\nيمكنك الآن استخدام التطبيقات التي تدعم Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'الريليه المحلي مضبوط على المنفذ $port، لكن يبدو أن تطبيقاً آخر يستخدمه. أغلق التطبيق المعارض وحاول مرة أخرى.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'تم بدء موقع NIP-46!';

  @override
  String get nip46FailedToStart => 'فشل البدء.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get clear => 'مسح';

  @override
  String get clearDatabase => 'مسح قاعدة البيانات';

  @override
  String get clearDatabaseConfirm => 'سيتم حذف جميع بيانات الريليه وإعادة تشغيله إن كان يعمل. لا يمكن التراجع.';

  @override
  String get importDatabase => 'استيراد قاعدة البيانات';

  @override
  String get importDatabaseHint => 'أدخل مسار مجلد قاعدة البيانات للاستيراد. سيتم نسخ القاعدة الحالية احتياطياً قبل الاستيراد.';

  @override
  String get databaseDirectoryPath => 'مسار مجلد قاعدة البيانات';

  @override
  String get import => 'استيراد';

  @override
  String get export => 'تصدير';

  @override
  String get restart => 'إعادة التشغيل';

  @override
  String get restartRelay => 'إعادة تشغيل الريليه';

  @override
  String get restartRelayConfirm => 'هل تريد إعادة تشغيل الريليه؟ سيتم إيقافه مؤقتاً ثم إعادة تشغيله.';

  @override
  String get relayRestartedSuccess => 'تم إعادة تشغيل الريليه بنجاح';

  @override
  String relayRestartFailed(String message) {
    return 'فشل إعادة تشغيل الريليه: $message';
  }

  @override
  String get databaseClearedSuccess => 'تم مسح قاعدة البيانات بنجاح';

  @override
  String get databaseClearFailed => 'فشل مسح قاعدة البيانات';

  @override
  String errorWithMessage(String message) {
    return 'خطأ: $message';
  }

  @override
  String get exportDatabase => 'تصدير قاعدة البيانات';

  @override
  String get exportDatabaseHint => 'سيتم تصدير قاعدة بيانات الريليه كملف ZIP. قد يستغرق ذلك لحظات.';

  @override
  String databaseExportedTo(String path) {
    return 'تم تصدير قاعدة البيانات إلى: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'تم تصدير قاعدة البيانات كملف ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'فشل تصدير قاعدة البيانات';

  @override
  String get importDatabaseReplaceHint => 'سيتم استبدال القاعدة الحالية بالنسخة المستوردة. سيتم نسخ القاعدة الحالية احتياطياً. لا يمكن التراجع.';

  @override
  String get selectDatabaseBackupFile => 'اختر ملف (ZIP) أو مجلد النسخ الاحتياطي';

  @override
  String get selectDatabaseBackupDir => 'اختر مجلد النسخ الاحتياطي';

  @override
  String get fileOrDirNotExist => 'الملف أو المجلد المحدد غير موجود';

  @override
  String get databaseImportedSuccess => 'تم استيراد قاعدة البيانات بنجاح';

  @override
  String get databaseImportFailed => 'فشل استيراد قاعدة البيانات';

  @override
  String get status => 'الحالة';

  @override
  String get address => 'العنوان';

  @override
  String get protocol => 'البروتوكول';

  @override
  String get connections => 'الاتصالات';

  @override
  String get running => 'يعمل';

  @override
  String get stopped => 'متوقف';

  @override
  String get addressCopiedToClipboard => 'تم نسخ العنوان';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get systemLogs => 'سجلات النظام';

  @override
  String get clearAllRelayData => 'مسح جميع بيانات الريليه';

  @override
  String get noLogsAvailable => 'لا توجد سجلات';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String encryptionFailed(String message) {
    return 'فشل التشفير: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'تم نسخ المفتاح الخاص المشفر';

  @override
  String get accountBackup => 'نسخ احتياطي للحساب';

  @override
  String get publicAccountId => 'معرف الحساب العام';

  @override
  String get accountPrivateKey => 'المفتاح الخاص للحساب';

  @override
  String get show => 'إظهار';

  @override
  String get generate => 'إنشاء';

  @override
  String get enterEncryptionPassword => 'أدخل كلمة مرور التشفير';

  @override
  String get privateKeyEncryption => 'تشفير المفتاح الخاص';

  @override
  String get encryptPrivateKeyHint => 'شفر مفتاحك الخاص لتعزيز الأمان. سيتم التشفير بكلمة مرور.';

  @override
  String get ncryptsecHint => 'المفتاح المشفر سيبدأ بـ \"ncryptsec1\" ولا يمكن استخدامه بدون كلمة المرور.';

  @override
  String get encryptAndCopyPrivateKey => 'تشفير ونسخ المفتاح الخاص';

  @override
  String get privateKeyEncryptedSuccess => 'تم تشفير المفتاح الخاص بنجاح!';

  @override
  String get encryptedKeyNcryptsec => 'المفتاح المشفر (ncryptsec):';

  @override
  String get createNewNostrAccount => 'إنشاء حساب Nostr جديد';

  @override
  String get accountReadyPublicKeyHint => 'حساب Nostr جاهز! هذا مفتاحك العام:';

  @override
  String get nostrPubkey => 'المفتاح العام Nostr';

  @override
  String get create => 'إنشاء';

  @override
  String get createSuccess => 'تم الإنشاء بنجاح!';

  @override
  String get application => 'التطبيق';

  @override
  String get createApplication => 'إنشاء تطبيق';

  @override
  String get addNewApplication => 'إضافة تطبيق جديد';

  @override
  String get addNsecbunkerManually => 'إضافة nsecbunker يدوياً';

  @override
  String get loginUsingUrlScheme => 'تسجيل الدخول عبر مخطط URL';

  @override
  String get addApplicationMethodsHint => 'يمكنك اختيار أي من هذه الطرق للاتصال بـ Aegis!';

  @override
  String get urlSchemeLoginHint => 'افتح بتطبيق يدعم مخطط URL لـ Aegis لتسجيل الدخول.';

  @override
  String get name => 'الاسم';

  @override
  String get applicationInfo => 'معلومات التطبيق';

  @override
  String get activities => 'النشاط';

  @override
  String get clientPubkey => 'المفتاح العام للعميل';

  @override
  String get remove => 'إزالة';

  @override
  String get removeAppConfirm => 'هل تريد إزالة جميع الأذونات من هذا التطبيق؟';

  @override
  String get removeSuccess => 'تمت الإزالة بنجاح';

  @override
  String get nameCannotBeEmpty => 'الاسم لا يمكن أن يكون فارغاً';

  @override
  String get nameTooLong => 'الاسم طويل جداً.';

  @override
  String get updateSuccess => 'تم التحديث بنجاح';

  @override
  String get editConfiguration => 'تحرير الإعدادات';

  @override
  String get update => 'تحديث';

  @override
  String get search => 'بحث...';

  @override
  String get enterCustomName => 'أدخل اسماً مخصصاً';

  @override
  String get selectApplication => 'اختر تطبيقاً';

  @override
  String get addWebApp => 'إضافة تطبيق ويب';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'تطبيقي';

  @override
  String get add => 'إضافة';

  @override
  String get searchNostrApps => 'البحث في تطبيقات Nostr...';

  @override
  String get invalidUrlHint => 'رابط غير صالح. أدخل رابط HTTP أو HTTPS صالح.';

  @override
  String get appAlreadyInList => 'هذا التطبيق موجود في القائمة.';

  @override
  String appAdded(String name) {
    return 'تمت إضافة $name';
  }

  @override
  String appAddFailed(String error) {
    return 'فشل إضافة التطبيق: $error';
  }

  @override
  String get deleteApp => 'حذف التطبيق';

  @override
  String deleteAppConfirm(String name) {
    return 'هل تريد حذف \"$name\"?';
  }

  @override
  String get delete => 'حذف';

  @override
  String appDeleted(String name) {
    return 'تم حذف $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'فشل حذف التطبيق: $error';
  }

  @override
  String get copiedToClipboard => 'تم النسخ';

  @override
  String get eventDetails => 'تفاصيل الحدث';

  @override
  String get eventDetailsCopiedToClipboard => 'تم نسخ تفاصيل الحدث';

  @override
  String get rawMetadataCopiedToClipboard => 'تم نسخ البيانات الوصفية الأولية';

  @override
  String get permissionRequest => 'طلب الإذن';

  @override
  String get permissionRequestContent => 'هذا التطبيق يطلب إذناً للوصول إلى حساب Nostr';

  @override
  String get grantPermissions => 'منح الأذونات';

  @override
  String get reject => 'رفض';

  @override
  String get fullAccessGranted => 'تم منح الوصول الكامل';

  @override
  String get fullAccessHint => 'سيكون لهذا التطبيق وصول كامل إلى حساب Nostr، بما في ذلك:';

  @override
  String get permissionAccessPubkey => 'الوصول إلى مفتاحك العام Nostr';

  @override
  String get permissionSignEvents => 'توقيع أحداث Nostr';

  @override
  String get permissionEncryptDecrypt => 'تشفير وفك تشفير الأحداث (NIP-04 و NIP-44)';

  @override
  String get tips => 'نصائح';

  @override
  String get schemeLoginFirst => 'تعذر حل المخطط. سجّل الدخول أولاً.';

  @override
  String get newConnectionRequest => 'طلب اتصال جديد';

  @override
  String get newConnectionNoSlotHint => 'تطبيق جديد يحاول الاتصال لكن لا يوجد تطبيق متاح. أنشئ تطبيقاً جديداً أولاً.';

  @override
  String get copiedSuccessfully => 'تم النسخ بنجاح';

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
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get pleaseSelectApplication => 'يرجى اختيار تطبيق';

  @override
  String get orEnterCustomName => 'أو أدخل اسماً مخصصاً';

  @override
  String get continueButton => 'متابعة';
}
