// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Onayla';

  @override
  String get cancel => 'İptal';

  @override
  String get settings => 'Ayarlar';

  @override
  String get logout => 'Çıkış yap';

  @override
  String get login => 'Giriş yap';

  @override
  String get usePrivateKey => 'Özel anahtarını kullan';

  @override
  String get setupAegisWithNsec => 'Aegis\'i Nostr özel anahtarınla kur — nsec, ncryptsec ve hex destekler.';

  @override
  String get privateKey => 'Özel anahtar';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex anahtar';

  @override
  String get password => 'Parola';

  @override
  String get passwordHint => 'ncryptsec\'in şifresini çözmek için parolayı gir';

  @override
  String get contentCannotBeEmpty => 'İçerik boş olamaz!';

  @override
  String get passwordRequiredForNcryptsec => 'ncryptsec için parola gerekli!';

  @override
  String get decryptNcryptsecFailed => 'ncryptsec şifresi çözülemedi. Parolayı kontrol et.';

  @override
  String get invalidPrivateKeyFormat => 'Geçersiz özel anahtar biçimi!';

  @override
  String get loginSuccess => 'Giriş başarılı!';

  @override
  String loginFailed(String message) {
    return 'Giriş başarısız: $message';
  }

  @override
  String get typeConfirmToProceed => 'Devam etmek için \"confirm\" yaz';

  @override
  String get logoutConfirm => 'Çıkış yapmak istediğinden emin misin?';

  @override
  String get notLoggedIn => 'Giriş yapılmadı';

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
  String get addAccount => 'Hesap ekle';

  @override
  String get updateSuccessful => 'Güncelleme başarılı!';

  @override
  String get switchAccount => 'Hesap değiştir';

  @override
  String get switchAccountConfirm => 'Hesap değiştirmek istediğinden emin misin?';

  @override
  String get switchSuccessfully => 'Geçiş başarılı!';

  @override
  String get renameAccount => 'Hesabı yeniden adlandır';

  @override
  String get accountName => 'Hesap adı';

  @override
  String get enterNewName => 'Yeni ad gir';

  @override
  String get accounts => 'Hesaplar';

  @override
  String get localRelay => 'Yerel röle';

  @override
  String get remote => 'Uzak';

  @override
  String get browser => 'Tarayıcı';

  @override
  String get theme => 'Tema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Sürüm';

  @override
  String get appSubtitle => 'Aegis - Nostr imzalayıcı';

  @override
  String get darkMode => 'Karanlık mod';

  @override
  String get lightMode => 'Açık mod';

  @override
  String get systemDefault => 'Sistem varsayılanı';

  @override
  String switchedTo(String mode) {
    return '$mode olarak değiştirildi';
  }

  @override
  String get home => 'Ana sayfa';

  @override
  String get waitingForRelayStart => 'Röle başlatılıyor...';

  @override
  String get connected => 'Bağlı';

  @override
  String get disconnected => 'Bağlı değil';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'NIP-07 uygulamaları yüklenirken hata: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Henüz NIP-07 uygulaması yok.\n\nNostr uygulamalarına Tarayıcı ile eriş!';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get active => 'Aktif';

  @override
  String get congratulationsEmptyState => 'Tebrikler!\n\nAegis destekleyen uygulamaları kullanmaya başlayabilirsin!';

  @override
  String localRelayPortInUse(String port) {
    return 'Yerel röle $port portunu kullanacak şekilde ayarlı ama başka bir uygulama kullanıyor gibi. Çakışan uygulamayı kapatıp tekrar dene.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'NIP-46 imzalayıcı başlatıldı!';

  @override
  String get nip46FailedToStart => 'Başlatılamadı.';

  @override
  String get retry => 'Yeniden dene';

  @override
  String get clear => 'Temizle';

  @override
  String get clearDatabase => 'Veritabanını temizle';

  @override
  String get clearDatabaseConfirm => 'Tüm röle verileri silinecek, çalışıyorsa röle yeniden başlatılacak. Bu işlem geri alınamaz.';

  @override
  String get importDatabase => 'Veritabanını içe aktar';

  @override
  String get importDatabaseHint => 'İçe aktarılacak veritabanı dizininin yolunu gir. Mevcut veritabanı yedeklenecek.';

  @override
  String get databaseDirectoryPath => 'Veritabanı dizin yolu';

  @override
  String get import => 'İçe aktar';

  @override
  String get export => 'Dışa aktar';

  @override
  String get restart => 'Yeniden başlat';

  @override
  String get restartRelay => 'Röleyi yeniden başlat';

  @override
  String get restartRelayConfirm => 'Röleyi yeniden başlatmak istediğinden emin misin? Geçici olarak durdurulup tekrar başlatılacak.';

  @override
  String get relayRestartedSuccess => 'Röle başarıyla yeniden başlatıldı';

  @override
  String relayRestartFailed(String message) {
    return 'Röle yeniden başlatılamadı: $message';
  }

  @override
  String get databaseClearedSuccess => 'Veritabanı başarıyla temizlendi';

  @override
  String get databaseClearFailed => 'Veritabanı temizlenemedi';

  @override
  String errorWithMessage(String message) {
    return 'Hata: $message';
  }

  @override
  String get exportDatabase => 'Veritabanını dışa aktar';

  @override
  String get exportDatabaseHint => 'Röle veritabanı ZIP olarak dışa aktarılacak. Biraz sürebilir.';

  @override
  String databaseExportedTo(String path) {
    return 'Veritabanı şuraya aktarıldı: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Veritabanı ZIP olarak aktarıldı: $path';
  }

  @override
  String get databaseExportFailed => 'Veritabanı dışa aktarılamadı';

  @override
  String get importDatabaseReplaceHint => 'Mevcut veritabanı içe aktarılan yedekle değiştirilecek. Mevcut veritabanı yedeklenecek. Bu işlem geri alınamaz.';

  @override
  String get selectDatabaseBackupFile => 'Veritabanı yedeği (ZIP) dosyası veya dizin seç';

  @override
  String get selectDatabaseBackupDir => 'Veritabanı yedek dizinini seç';

  @override
  String get fileOrDirNotExist => 'Seçilen dosya veya dizin yok';

  @override
  String get databaseImportedSuccess => 'Veritabanı başarıyla içe aktarıldı';

  @override
  String get databaseImportFailed => 'Veritabanı içe aktarılamadı';

  @override
  String get status => 'Durum';

  @override
  String get address => 'Adres';

  @override
  String get protocol => 'Protokol';

  @override
  String get connections => 'Bağlantılar';

  @override
  String get running => 'Çalışıyor';

  @override
  String get stopped => 'Durduruldu';

  @override
  String get addressCopiedToClipboard => 'Adres panoya kopyalandı';

  @override
  String get exportData => 'Veriyi dışa aktar';

  @override
  String get importData => 'Veriyi içe aktar';

  @override
  String get systemLogs => 'Sistem günlükleri';

  @override
  String get clearAllRelayData => 'Tüm röle verilerini temizle';

  @override
  String get noLogsAvailable => 'Günlük yok';

  @override
  String get passwordRequired => 'Parola gerekli';

  @override
  String encryptionFailed(String message) {
    return 'Şifreleme başarısız: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Şifreli özel anahtar panoya kopyalandı';

  @override
  String get accountBackup => 'Hesap yedeği';

  @override
  String get publicAccountId => 'Genel hesap kimliği';

  @override
  String get accountPrivateKey => 'Hesap özel anahtarı';

  @override
  String get show => 'Göster';

  @override
  String get generate => 'Oluştur';

  @override
  String get enterEncryptionPassword => 'Şifreleme parolası gir';

  @override
  String get privateKeyEncryption => 'Özel anahtar şifreleme';

  @override
  String get encryptPrivateKeyHint => 'Güvenlik için özel anahtarını şifrele. Parolayla şifrelenecek.';

  @override
  String get ncryptsecHint => 'Şifreli anahtar \"ncryptsec1\" ile başlayacak ve parola olmadan kullanılamaz.';

  @override
  String get encryptAndCopyPrivateKey => 'Şifrele ve özel anahtarı kopyala';

  @override
  String get privateKeyEncryptedSuccess => 'Özel anahtar başarıyla şifrelendi!';

  @override
  String get encryptedKeyNcryptsec => 'Şifreli anahtar (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Yeni Nostr hesabı oluştur';

  @override
  String get accountReadyPublicKeyHint => 'Nostr hesabın hazır! Bu senin nostr genel anahtarın:';

  @override
  String get nostrPubkey => 'Nostr genel anahtarı';

  @override
  String get create => 'Oluştur';

  @override
  String get createSuccess => 'Başarıyla oluşturuldu!';

  @override
  String get application => 'Uygulama';

  @override
  String get createApplication => 'Uygulama oluştur';

  @override
  String get addNewApplication => 'Yeni uygulama ekle';

  @override
  String get addNsecbunkerManually => 'nsecbunker\'ı elle ekle';

  @override
  String get loginUsingUrlScheme => 'URL Scheme ile giriş yap';

  @override
  String get addApplicationMethodsHint => 'Aegis\'e bağlanmak için bu yöntemlerden birini seçebilirsin!';

  @override
  String get urlSchemeLoginHint => 'Giriş yapmak için Aegis URL scheme destekleyen bir uygulamayla aç.';

  @override
  String get name => 'Ad';

  @override
  String get applicationInfo => 'Uygulama bilgisi';

  @override
  String get activities => 'Etkinlikler';

  @override
  String get clientPubkey => 'İstemci genel anahtarı';

  @override
  String get remove => 'Kaldır';

  @override
  String get removeAppConfirm => 'Bu uygulamanın tüm izinlerini kaldırmak istediğinden emin misin?';

  @override
  String get removeSuccess => 'Başarıyla kaldırıldı';

  @override
  String get nameCannotBeEmpty => 'Ad boş olamaz';

  @override
  String get nameTooLong => 'Ad çok uzun.';

  @override
  String get updateSuccess => 'Güncelleme başarılı';

  @override
  String get editConfiguration => 'Yapılandırmayı düzenle';

  @override
  String get update => 'Güncelle';

  @override
  String get search => 'Ara...';

  @override
  String get enterCustomName => 'Özel ad gir';

  @override
  String get selectApplication => 'Uygulama seç';

  @override
  String get addWebApp => 'Web uygulaması ekle';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Uygulamam';

  @override
  String get add => 'Ekle';

  @override
  String get searchNostrApps => 'Nostr uygulamalarında ara...';

  @override
  String get invalidUrlHint => 'Geçersiz URL. Geçerli bir HTTP veya HTTPS URL gir.';

  @override
  String get appAlreadyInList => 'Bu uygulama zaten listede.';

  @override
  String appAdded(String name) {
    return '$name eklendi';
  }

  @override
  String appAddFailed(String error) {
    return 'Uygulama eklenemedi: $error';
  }

  @override
  String get deleteApp => 'Uygulamayı sil';

  @override
  String deleteAppConfirm(String name) {
    return '\"$name\" silinsin mi?';
  }

  @override
  String get delete => 'Sil';

  @override
  String appDeleted(String name) {
    return '$name silindi';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Uygulama silinemedi: $error';
  }

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get eventDetails => 'Olay ayrıntıları';

  @override
  String get eventDetailsCopiedToClipboard => 'Olay ayrıntıları panoya kopyalandı';

  @override
  String get rawMetadataCopiedToClipboard => 'Ham meta veriler panoya kopyalandı';

  @override
  String get permissionRequest => 'İzin isteği';

  @override
  String get permissionRequestContent => 'Bu uygulama Nostr hesabına erişim izni istiyor';

  @override
  String get grantPermissions => 'İzin ver';

  @override
  String get reject => 'Reddet';

  @override
  String get fullAccessGranted => 'Tam erişim verildi';

  @override
  String get fullAccessHint => 'Bu uygulama Nostr hesabına tam erişime sahip olacak:';

  @override
  String get permissionAccessPubkey => 'Nostr genel anahtarına erişim';

  @override
  String get permissionSignEvents => 'Nostr olaylarını imzala';

  @override
  String get permissionEncryptDecrypt => 'Olayları şifrele ve çöz (NIP-04 ve NIP-44)';

  @override
  String get tips => 'İpuçları';

  @override
  String get schemeLoginFirst => 'Şema çözülemedi. Önce giriş yap.';

  @override
  String get newConnectionRequest => 'Yeni bağlantı isteği';

  @override
  String get newConnectionNoSlotHint => 'Yeni bir uygulama bağlanmaya çalışıyor ama boş uygulama yok. Önce yeni uygulama oluştur.';

  @override
  String get copiedSuccessfully => 'Başarıyla kopyalandı';

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
  String get noResultsFound => 'Sonuç bulunamadı';

  @override
  String get pleaseSelectApplication => 'Lütfen bir uygulama seçin';

  @override
  String get orEnterCustomName => 'Veya özel bir ad girin';

  @override
  String get continueButton => 'Devam';
}
