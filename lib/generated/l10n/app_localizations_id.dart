// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get cancel => 'Batal';

  @override
  String get settings => 'Pengaturan';

  @override
  String get logout => 'Keluar';

  @override
  String get login => 'Masuk';

  @override
  String get usePrivateKey => 'Gunakan kunci pribadi Anda';

  @override
  String get setupAegisWithNsec => 'Siapkan Aegis dengan kunci Nostr Anda — mendukung format nsec, ncryptsec, dan hex.';

  @override
  String get privateKey => 'Kunci Pribadi';

  @override
  String get privateKeyHint => 'Kunci nsec / ncryptsec / hex';

  @override
  String get password => 'Kata sandi';

  @override
  String get passwordHint => 'Masukkan kata sandi untuk mendekripsi ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Konten tidak boleh kosong!';

  @override
  String get passwordRequiredForNcryptsec => 'Kata sandi diperlukan untuk ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Gagal mendekripsi ncryptsec. Silakan periksa kata sandi Anda.';

  @override
  String get invalidPrivateKeyFormat => 'Format kunci pribadi tidak valid!';

  @override
  String get loginSuccess => 'Login berhasil!';

  @override
  String loginFailed(String message) {
    return 'Login gagal: $message';
  }

  @override
  String get typeConfirmToProceed => 'Ketik \"confirm\" untuk melanjutkan';

  @override
  String get logoutConfirm => 'Apakah Anda yakin ingin keluar?';

  @override
  String get notLoggedIn => 'Belum masuk';

  @override
  String get language => 'Bahasa';

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
  String get addAccount => 'Tambah Akun';

  @override
  String get updateSuccessful => 'Pembaruan berhasil!';

  @override
  String get switchAccount => 'Ganti akun';

  @override
  String get switchAccountConfirm => 'Apakah Anda yakin ingin mengganti akun?';

  @override
  String get switchSuccessfully => 'Berhasil mengganti!';

  @override
  String get renameAccount => 'Ubah Nama Akun';

  @override
  String get accountName => 'Nama Akun';

  @override
  String get enterNewName => 'Masukkan nama baru';

  @override
  String get accounts => 'Akun';

  @override
  String get localRelay => 'Relay Lokal';

  @override
  String get remote => 'Jauh';

  @override
  String get browser => 'Browser';

  @override
  String get theme => 'Tema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versi';

  @override
  String get appSubtitle => 'Aegis - Penandatangan Nostr';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get lightMode => 'Mode Terang';

  @override
  String get systemDefault => 'Default Sistem';

  @override
  String switchedTo(String mode) {
    return 'Beralih ke $mode';
  }

  @override
  String get home => 'Beranda';

  @override
  String get waitingForRelayStart => 'Menunggu relay mulai...';

  @override
  String get connected => 'Terhubung';

  @override
  String get disconnected => 'Terputus';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Gagal memuat aplikasi NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Belum ada aplikasi NIP-07.\n\nGunakan Browser untuk mengakses aplikasi Nostr!';

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String get active => 'Aktif';

  @override
  String get congratulationsEmptyState => 'Selamat!\n\nSekarang Anda dapat mulai menggunakan aplikasi yang mendukung Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Relay lokal diatur menggunakan port $port, tetapi tampaknya aplikasi lain sudah menggunakannya. Silakan tutup aplikasi yang konflik dan coba lagi.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'Penandatangan NIP-46 dimulai!';

  @override
  String get nip46FailedToStart => 'Gagal memulai.';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get clear => 'Bersihkan';

  @override
  String get clearDatabase => 'Bersihkan Basis Data';

  @override
  String get clearDatabaseConfirm => 'Ini akan menghapus semua data relay dan me-restart relay jika sedang berjalan. Tindakan ini tidak dapat dibatalkan.';

  @override
  String get importDatabase => 'Impor Basis Data';

  @override
  String get importDatabaseHint => 'Masukkan path ke direktori basis data untuk diimpor. Basis data yang ada akan dicadangkan sebelum impor.';

  @override
  String get databaseDirectoryPath => 'Path direktori basis data';

  @override
  String get import => 'Impor';

  @override
  String get export => 'Ekspor';

  @override
  String get restart => 'Restart';

  @override
  String get restartRelay => 'Restart Relay';

  @override
  String get restartRelayConfirm => 'Apakah Anda yakin ingin me-restart relay? Relay akan dihentikan sementara lalu di-restart.';

  @override
  String get relayRestartedSuccess => 'Relay berhasil di-restart';

  @override
  String relayRestartFailed(String message) {
    return 'Gagal me-restart relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Basis data berhasil dibersihkan';

  @override
  String get databaseClearFailed => 'Gagal membersihkan basis data';

  @override
  String errorWithMessage(String message) {
    return 'Kesalahan: $message';
  }

  @override
  String get exportDatabase => 'Ekspor Basis Data';

  @override
  String get exportDatabaseHint => 'Ini akan mengekspor basis data relay sebagai file ZIP. Ekspor mungkin memakan waktu beberapa saat.';

  @override
  String databaseExportedTo(String path) {
    return 'Basis data diekspor ke: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Basis data diekspor sebagai file ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Gagal mengekspor basis data';

  @override
  String get importDatabaseReplaceHint => 'Ini akan mengganti basis data saat ini dengan cadangan yang diimpor. Basis data yang ada akan dicadangkan sebelum impor. Tindakan ini tidak dapat dibatalkan.';

  @override
  String get selectDatabaseBackupFile => 'Pilih file cadangan basis data (ZIP) atau direktori';

  @override
  String get selectDatabaseBackupDir => 'Pilih direktori cadangan basis data';

  @override
  String get fileOrDirNotExist => 'File atau direktori yang dipilih tidak ada';

  @override
  String get databaseImportedSuccess => 'Basis data berhasil diimpor';

  @override
  String get databaseImportFailed => 'Gagal mengimpor basis data';

  @override
  String get status => 'Status';

  @override
  String get address => 'Alamat';

  @override
  String get protocol => 'Protokol';

  @override
  String get connections => 'Koneksi';

  @override
  String get running => 'Berjalan';

  @override
  String get stopped => 'Berhenti';

  @override
  String get addressCopiedToClipboard => 'Alamat disalin ke clipboard';

  @override
  String get exportData => 'Ekspor Data';

  @override
  String get importData => 'Impor Data';

  @override
  String get systemLogs => 'Log Sistem';

  @override
  String get clearAllRelayData => 'Bersihkan Semua Data Relay';

  @override
  String get noLogsAvailable => 'Tidak ada log tersedia';

  @override
  String get passwordRequired => 'Kata sandi diperlukan';

  @override
  String encryptionFailed(String message) {
    return 'Enkripsi gagal: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Kunci pribadi terenkripsi disalin ke clipboard';

  @override
  String get accountBackup => 'Cadangan akun';

  @override
  String get publicAccountId => 'ID akun publik';

  @override
  String get accountPrivateKey => 'Kunci pribadi akun';

  @override
  String get show => 'Tampilkan';

  @override
  String get generate => 'Buat';

  @override
  String get enterEncryptionPassword => 'Masukkan kata sandi enkripsi';

  @override
  String get privateKeyEncryption => 'Enkripsi Kunci Pribadi';

  @override
  String get encryptPrivateKeyHint => 'Enkripsi kunci pribadi Anda untuk meningkatkan keamanan. Kunci akan dienkripsi menggunakan kata sandi.';

  @override
  String get ncryptsecHint => 'Kunci terenkripsi akan dimulai dengan \"ncryptsec1\" dan tidak dapat digunakan tanpa kata sandi.';

  @override
  String get encryptAndCopyPrivateKey => 'Enkripsi dan Salin Kunci Pribadi';

  @override
  String get privateKeyEncryptedSuccess => 'Kunci pribadi berhasil dienkripsi!';

  @override
  String get encryptedKeyNcryptsec => 'Kunci terenkripsi (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Buat akun Nostr baru';

  @override
  String get accountReadyPublicKeyHint => 'Akun Nostr Anda siap! Ini adalah kunci publik nostr Anda:';

  @override
  String get nostrPubkey => 'Nostr Pubkey';

  @override
  String get create => 'Buat';

  @override
  String get createSuccess => 'Berhasil dibuat!';

  @override
  String get application => 'Aplikasi';

  @override
  String get createApplication => 'Buat Aplikasi';

  @override
  String get addNewApplication => 'Tambah aplikasi baru';

  @override
  String get addNsecbunkerManually => 'Tambah nsecbunker secara manual';

  @override
  String get loginUsingUrlScheme => 'Login menggunakan URL Scheme';

  @override
  String get addApplicationMethodsHint => 'Anda dapat memilih salah satu metode ini untuk terhubung dengan Aegis!';

  @override
  String get urlSchemeLoginHint => 'Buka dengan aplikasi yang mendukung skema URL Aegis untuk masuk';

  @override
  String get name => 'Nama';

  @override
  String get applicationInfo => 'Info Aplikasi';

  @override
  String get activities => 'Aktivitas';

  @override
  String get clientPubkey => 'Pubkey klien';

  @override
  String get remove => 'Hapus';

  @override
  String get removeAppConfirm => 'Apakah Anda yakin ingin menghapus semua izin dari aplikasi ini?';

  @override
  String get removeSuccess => 'Berhasil dihapus';

  @override
  String get nameCannotBeEmpty => 'Nama tidak boleh kosong';

  @override
  String get nameTooLong => 'Nama terlalu panjang.';

  @override
  String get updateSuccess => 'Pembaruan berhasil';

  @override
  String get editConfiguration => 'Edit konfigurasi';

  @override
  String get update => 'Perbarui';

  @override
  String get search => 'Cari...';

  @override
  String get enterCustomName => 'Masukkan nama kustom';

  @override
  String get selectApplication => 'Pilih aplikasi';

  @override
  String get addWebApp => 'Tambah Aplikasi Web';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Aplikasi Saya';

  @override
  String get add => 'Tambah';

  @override
  String get searchNostrApps => 'Cari Aplikasi Nostr...';

  @override
  String get invalidUrlHint => 'URL tidak valid. Silakan masukkan URL HTTP atau HTTPS yang valid.';

  @override
  String get appAlreadyInList => 'Aplikasi ini sudah ada dalam daftar.';

  @override
  String appAdded(String name) {
    return '$name ditambahkan';
  }

  @override
  String appAddFailed(String error) {
    return 'Gagal menambah aplikasi: $error';
  }

  @override
  String get deleteApp => 'Hapus Aplikasi';

  @override
  String deleteAppConfirm(String name) {
    return 'Apakah Anda yakin ingin menghapus \"$name\"?';
  }

  @override
  String get delete => 'Hapus';

  @override
  String appDeleted(String name) {
    return '$name dihapus';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Gagal menghapus aplikasi: $error';
  }

  @override
  String get copiedToClipboard => 'Disalin ke clipboard';

  @override
  String get eventDetails => 'Detail Acara';

  @override
  String get eventDetailsCopiedToClipboard => 'Detail acara disalin ke clipboard';

  @override
  String get rawMetadataCopiedToClipboard => 'Metadata mentah disalin ke clipboard';

  @override
  String get permissionRequest => 'Permintaan Izin';

  @override
  String get permissionRequestContent => 'Aplikasi ini meminta izin untuk mengakses akun Nostr Anda';

  @override
  String get grantPermissions => 'Berikan Izin';

  @override
  String get reject => 'Tolak';

  @override
  String get fullAccessGranted => 'Akses Penuh Diberikan';

  @override
  String get fullAccessHint => 'Aplikasi ini akan memiliki akses penuh ke akun Nostr Anda, termasuk:';

  @override
  String get permissionAccessPubkey => 'Akses kunci publik Nostr Anda';

  @override
  String get permissionSignEvents => 'Tandatangani acara Nostr';

  @override
  String get permissionEncryptDecrypt => 'Enkripsi dan dekripsi acara (NIP-04 & NIP-44)';

  @override
  String get tips => 'Tips';

  @override
  String get schemeLoginFirst => 'Tidak dapat menyelesaikan skema, silakan masuk terlebih dahulu.';

  @override
  String get newConnectionRequest => 'Permintaan Koneksi Baru';

  @override
  String get newConnectionNoSlotHint => 'Aplikasi baru mencoba terhubung, tetapi tidak ada aplikasi yang tidak terpakai. Silakan buat aplikasi baru terlebih dahulu.';

  @override
  String get copiedSuccessfully => 'Berhasil disalin';

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
  String get noResultsFound => 'Tidak ada hasil ditemukan';

  @override
  String get pleaseSelectApplication => 'Silakan pilih aplikasi';

  @override
  String get orEnterCustomName => 'Atau masukkan nama kustom';

  @override
  String get continueButton => 'Lanjutkan';
}
