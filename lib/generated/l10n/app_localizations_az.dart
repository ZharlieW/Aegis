// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Təsdiq et';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get settings => 'Parametrlər';

  @override
  String get logout => 'Çıxış';

  @override
  String get login => 'Daxil ol';

  @override
  String get usePrivateKey => 'Özəl açarınızdan istifadə edin';

  @override
  String get setupAegisWithNsec => 'Aegisi Nostr özəl açarınızla quraşdırın — nsec, ncryptsec və hex formatlarını dəstəkləyir.';

  @override
  String get privateKey => 'Özəl açar';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex açar';

  @override
  String get password => 'Parol';

  @override
  String get passwordHint => 'ncryptsec-in şifrəsini açmaq üçün parol daxil edin';

  @override
  String get contentCannotBeEmpty => 'Məzmun boş ola bilməz!';

  @override
  String get passwordRequiredForNcryptsec => 'ncryptsec üçün parol tələb olunur!';

  @override
  String get decryptNcryptsecFailed => 'ncryptsec-in şifrəsini açmaq mümkün olmadı. Parolu yoxlayın.';

  @override
  String get invalidPrivateKeyFormat => 'Özəl açar formatı etibarsızdır!';

  @override
  String get loginSuccess => 'Daxil olma uğurlu!';

  @override
  String loginFailed(String message) {
    return 'Daxil olma uğursuz: $message';
  }

  @override
  String get typeConfirmToProceed => 'Davam etmək üçün \"confirm\" yazın';

  @override
  String get logoutConfirm => 'Çıxmaq istədiyinizə əminsiniz?';

  @override
  String get notLoggedIn => 'Daxil olunmayıb';

  @override
  String get language => 'Dil';

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
  String get addAccount => 'Hesab əlavə et';

  @override
  String get updateSuccessful => 'Yeniləmə uğurlu!';

  @override
  String get switchAccount => 'Hesabı dəyiş';

  @override
  String get switchAccountConfirm => 'Hesabı dəyişmək istədiyinizə əminsiniz?';

  @override
  String get switchSuccessfully => 'Dəyişmə uğurlu!';

  @override
  String get renameAccount => 'Hesabı adlandır';

  @override
  String get accountName => 'Hesab adı';

  @override
  String get enterNewName => 'Yeni ad daxil edin';

  @override
  String get accounts => 'Hesablar';

  @override
  String get localRelay => 'Yerli relay';

  @override
  String get remote => 'Uzaqdan';

  @override
  String get browser => 'Brauzer';

  @override
  String get theme => 'Mövzu';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versiya';

  @override
  String get appSubtitle => 'Aegis — Nostr imzalayıcı';

  @override
  String get darkMode => 'Qaranlıq rejim';

  @override
  String get lightMode => 'İşıqlı rejim';

  @override
  String get systemDefault => 'Sistem defaultu';

  @override
  String switchedTo(String mode) {
    return '$mode rejiminə keçildi';
  }

  @override
  String get home => 'Ana səhifə';

  @override
  String get waitingForRelayStart => 'Relayin işə düşməsini gözləyir...';

  @override
  String get connected => 'Qoşulub';

  @override
  String get disconnected => 'Ayrılıb';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'NIP-07 tətbiqlərinin yüklənməsi xətası: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Hələ NIP-07 tətbiqi yoxdur.\n\nNostr tətbiqlərinə daxil olmaq üçün brauzerdən istifadə edin!';

  @override
  String get unknown => 'Naməlum';

  @override
  String get active => 'Aktiv';

  @override
  String get congratulationsEmptyState => 'Təbriklər!\n\nİndi Aegisi dəstəkləyən tətbiqlərdən istifadə edə bilərsiniz!';

  @override
  String localRelayPortInUse(String port) {
    return 'Yerli relay $port portunda təyin edilib, amma başqa tətbiq artıq istifadə edir. Konflikt tətbiqini bağlayın və yenidən cəhd edin.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'NIP-46 imzalayıcı işə düşdü!';

  @override
  String get nip46FailedToStart => 'İşə düşmə uğursuz.';

  @override
  String get retry => 'Yenidən cəhd';

  @override
  String get clear => 'Təmizlə';

  @override
  String get clearDatabase => 'Verilənlər bazasını təmizlə';

  @override
  String get clearDatabaseConfirm => 'Bütün relay məlumatları silinəcək və işləyirsə relay yenidən işə düşəcək. Bu əməliyyat geri alına bilməz.';

  @override
  String get importDatabase => 'Verilənlər bazasını import et';

  @override
  String get importDatabaseHint => 'İmport üçün verilənlər bazası qovluğunun yolunu daxil edin. Mövcud baza importdan əvvəl ehtiyat nüsxəyə alınacaq.';

  @override
  String get databaseDirectoryPath => 'Verilənlər bazası qovluğunun yolu';

  @override
  String get import => 'İmport';

  @override
  String get export => 'Eksport';

  @override
  String get restart => 'Yenidən işə sal';

  @override
  String get restartRelay => 'Relayi yenidən işə sal';

  @override
  String get restartRelayConfirm => 'Relayi yenidən işə salmaq istədiyinizə əminsiniz? Relay müvəqqəti dayandırılacaq və sonra yenidən işə salınacaq.';

  @override
  String get relayRestartedSuccess => 'Relay yenidən işə salındı';

  @override
  String relayRestartFailed(String message) {
    return 'Relayin yenidən işə salınması uğursuz: $message';
  }

  @override
  String get databaseClearedSuccess => 'Verilənlər bazası təmizləndi';

  @override
  String get databaseClearFailed => 'Verilənlər bazasının təmizlənməsi uğursuz';

  @override
  String errorWithMessage(String message) {
    return 'Xəta: $message';
  }

  @override
  String get exportDatabase => 'Verilənlər bazasını eksport et';

  @override
  String get exportDatabaseHint => 'Relay verilənlər bazası ZIP faylı kimi eksport olunacaq. Eksport bir az vaxt apar bilər.';

  @override
  String databaseExportedTo(String path) {
    return 'Verilənlər bazası eksport olundu: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Verilənlər bazası ZIP kimi eksport olundu: $path';
  }

  @override
  String get databaseExportFailed => 'Verilənlər bazasının eksportu uğursuz';

  @override
  String get importDatabaseReplaceHint => 'Cari baza import olunmuş ehtiyat nüsxə ilə əvəz olunacaq. Mövcud baza importdan əvvəl ehtiyat nüsxəyə alınacaq. Bu əməliyyat geri alına bilməz.';

  @override
  String get selectDatabaseBackupFile => 'Verilənlər bazası ehtiyat faylını (ZIP) və ya qovluğu seçin';

  @override
  String get selectDatabaseBackupDir => 'Verilənlər bazası ehtiyat qovluğunu seçin';

  @override
  String get fileOrDirNotExist => 'Seçilmiş fayl və ya qovluq mövcud deyil';

  @override
  String get databaseImportedSuccess => 'Verilənlər bazası import olundu';

  @override
  String get databaseImportFailed => 'Verilənlər bazasının importu uğursuz';

  @override
  String get status => 'Vəziyyət';

  @override
  String get address => 'Ünvan';

  @override
  String get protocol => 'Protokol';

  @override
  String get connections => 'Bağlantılar';

  @override
  String get running => 'İşləyir';

  @override
  String get stopped => 'Dayandırılıb';

  @override
  String get addressCopiedToClipboard => 'Ünvan buferə kopyalandı';

  @override
  String get exportData => 'Məlumatları eksport et';

  @override
  String get importData => 'Məlumatları import et';

  @override
  String get systemLogs => 'Sistem jurnalları';

  @override
  String get clearAllRelayData => 'Bütün relay məlumatlarını təmizlə';

  @override
  String get noLogsAvailable => 'Jurnal yoxdur';

  @override
  String get passwordRequired => 'Parol tələb olunur';

  @override
  String encryptionFailed(String message) {
    return 'Şifrələmə uğursuz: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Şifrələnmiş özəl açar buferə kopyalandı';

  @override
  String get accountBackup => 'Hesab ehtiyat nüsxəsi';

  @override
  String get publicAccountId => 'İctimai hesab ID';

  @override
  String get accountPrivateKey => 'Hesabın özəl açarı';

  @override
  String get show => 'Göstər';

  @override
  String get generate => 'Yarat';

  @override
  String get enterEncryptionPassword => 'Şifrələmə parolunu daxil edin';

  @override
  String get privateKeyEncryption => 'Özəl açarın şifrələnməsi';

  @override
  String get encryptPrivateKeyHint => 'Təhlükəsizlik üçün özəl açarınızı şifrələyin. Açar parolla şifrələnəcək.';

  @override
  String get ncryptsecHint => 'Şifrələnmiş açar \"ncryptsec1\" ilə başlayacaq və parolsuz istifadə oluna bilməz.';

  @override
  String get losePasswordKeyRecoveryWarning => '⚠️ Xəbərdarlıq: Parolunuzu itirsəniz, açarınızı bərpa edə bilməyəcəksiniz.';

  @override
  String get encryptAndCopyPrivateKey => 'Özəl açarı şifrələ və kopyala';

  @override
  String get privateKeyEncryptedSuccess => 'Özəl açar şifrələndi!';

  @override
  String get encryptedKeyNcryptsec => 'Şifrələnmiş açar (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Yeni Nostr hesabı yarat';

  @override
  String get accountReadyPublicKeyHint => 'Nostr hesabınız hazırdır! Bu sizin nostr ictimai açarınızdır:';

  @override
  String get nostrPubkey => 'Nostr ictimai açarı';

  @override
  String get create => 'Yarat';

  @override
  String get createSuccess => 'Yaradıldı!';

  @override
  String get application => 'Tətbiq';

  @override
  String get createApplication => 'Tətbiq yarat';

  @override
  String get addNewApplication => 'Yeni tətbiq əlavə et';

  @override
  String get addNsecbunkerManually => 'Nsecbunker əlavə et (əl ilə)';

  @override
  String get loginUsingUrlScheme => 'URL sxemi ilə daxil ol';

  @override
  String get addApplicationMethodsHint => 'Aegisə qoşulmaq üçün bu üsullardan hər hansı birini seçə bilərsiniz!';

  @override
  String get urlSchemeLoginHint => 'Daxil olmaq üçün Aegis URL sxemini dəstəkləyən tətbiqlə açın';

  @override
  String get name => 'Ad';

  @override
  String get applicationInfo => 'Tətbiq məlumatı';

  @override
  String get activities => 'Fəaliyyətlər';

  @override
  String get clientPubkey => 'Müştərinin ictimai açarı';

  @override
  String get remove => 'Sil';

  @override
  String get removeAppConfirm => 'Bu tətbiqdən bütün icazələri silmək istədiyinizə əminsiniz?';

  @override
  String get removeSuccess => 'Silindi';

  @override
  String get nameCannotBeEmpty => 'Ad boş ola bilməz';

  @override
  String get nameTooLong => 'Ad çox uzundur.';

  @override
  String get updateSuccess => 'Yeniləmə uğurlu';

  @override
  String get editConfiguration => 'Konfiqurasiyanı redaktə et';

  @override
  String get update => 'Yenilə';

  @override
  String get search => 'Axtar...';

  @override
  String get enterCustomName => 'Xüsusi ad daxil edin';

  @override
  String get selectApplication => 'Tətbiq seçin';

  @override
  String get addWebApp => 'Veb tətbiq əlavə et';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Mənim tətbiqim';

  @override
  String get add => 'Əlavə et';

  @override
  String get searchNostrApps => 'Nostr tətbiqlərini axtar...';

  @override
  String get urlLabel => 'URL *';

  @override
  String get appNameOptional => 'Tətbiq adı (İstəyə bağlı)';

  @override
  String get loading => 'Yüklənir...';

  @override
  String get noNappsFound => 'NApps tapılmadı';

  @override
  String get nappListLoadFailed => 'Tətbiq siyahısı yüklənə bilmədi';

  @override
  String get favorites => 'Sevimlilər';

  @override
  String get allApps => 'Bütün tətbiqlər';

  @override
  String get addApp => 'Tətbiq əlavə et';

  @override
  String get tapToAdd => 'Əlavə etmək üçün toxunun';

  @override
  String get webApp => 'Veb tətbiq';

  @override
  String get userAdded => 'İstifadəçi əlavə etdi';

  @override
  String get invalidUrlHint => 'Etibarsız URL. Etibarlı HTTP və ya HTTPS URL daxil edin.';

  @override
  String get appAlreadyInList => 'Bu tətbiq artıq siyahıdadır.';

  @override
  String appAdded(String name) {
    return '$name əlavə edildi';
  }

  @override
  String appAddFailed(String error) {
    return 'Tətbiq əlavə etmə uğursuz: $error';
  }

  @override
  String get deleteApp => 'Tətbiqi sil';

  @override
  String deleteAppConfirm(String name) {
    return '\"$name\" silmək istədiyinizə əminsiniz?';
  }

  @override
  String get delete => 'Sil';

  @override
  String appDeleted(String name) {
    return '$name silindi';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Tətbiqi silmə uğursuz: $error';
  }

  @override
  String get copiedToClipboard => 'Buferə kopyalandı';

  @override
  String get eventDetails => 'Hadisə təfərrüatları';

  @override
  String get eventDetailsCopiedToClipboard => 'Hadisə təfərrüatları buferə kopyalandı';

  @override
  String get noSignedEvents => 'İmzalanmış hadisə yoxdur';

  @override
  String get signedEventsEmptyHint => 'İmzaladıqda imzalanmış hadisələr burada görünəcək';

  @override
  String get rawMetadataCopiedToClipboard => 'Xam metadata buferə kopyalandı';

  @override
  String get permissionRequest => 'İcazə tələbi';

  @override
  String get permissionRequestContent => 'Bu tətbiq Nostr hesabınıza daxil olmaq üçün icazə tələb edir';

  @override
  String get grantPermissions => 'İcazələr ver';

  @override
  String get reject => 'Rədd et';

  @override
  String get fullAccessGranted => 'Tam giriş verildi';

  @override
  String get fullAccessHint => 'Bu tətbiq Nostr hesabınıza tam giriş əldə edəcək, o cümlədən:';

  @override
  String get permissionAccessPubkey => 'Nostr ictimai açarınıza giriş';

  @override
  String get permissionSignEvents => 'Nostr hadisələrini imzalamaq';

  @override
  String get permissionEncryptDecrypt => 'Hadisələri şifrələmək və açmaq (NIP-04 və NIP-44)';

  @override
  String get tips => 'Məsləhətlər';

  @override
  String get schemeLoginFirst => 'Sxemi həll etmək mümkün deyil, əvvəlcə daxil olun.';

  @override
  String get newConnectionRequest => 'Yeni bağlantı tələbi';

  @override
  String get newConnectionNoSlotHint => 'Yeni tətbiq qoşulmağa cəhd edir, amma boş tətbiq yoxdur. Əvvəlcə yeni tətbiq yaradın.';

  @override
  String get copiedSuccessfully => 'Kopyalandı';

  @override
  String get importDatabasePathHint => '/path/to/nostr_relay_backup_...';

  @override
  String get relayStatsSize => 'Ölçü';

  @override
  String get relayStatsEvents => 'Hadisələr';

  @override
  String get relayStatsUptime => 'İş vaxtı';

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
  String get noResultsFound => 'Nəticə tapılmadı';

  @override
  String get pleaseSelectApplication => 'Zəhmət olmasa tətbiq seçin';

  @override
  String get orEnterCustomName => 'Və ya xüsusi ad daxil edin';

  @override
  String get continueButton => 'Davam et';

  @override
  String get goBack => 'Geri';

  @override
  String get goForward => 'İrəli';

  @override
  String get favorite => 'Sevimli';

  @override
  String get unfavorite => 'Sevimlilərdən çıx';

  @override
  String get reload => 'Yenilə';

  @override
  String get exit => 'Çıxış';

  @override
  String get activitiesLoadFailed => 'Fəaliyyətlər yüklənə bilmədi';
}
