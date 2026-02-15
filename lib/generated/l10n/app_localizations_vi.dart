// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get cancel => 'Hủy';

  @override
  String get settings => 'Cài đặt';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get login => 'Đăng nhập';

  @override
  String get usePrivateKey => 'Dùng khóa riêng của bạn';

  @override
  String get setupAegisWithNsec => 'Thiết lập Aegis bằng khóa Nostr — hỗ trợ nsec, ncryptsec và hex.';

  @override
  String get privateKey => 'Khóa riêng';

  @override
  String get privateKeyHint => 'Khóa nsec / ncryptsec / hex';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordHint => 'Nhập mật khẩu để giải mã ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Nội dung không được để trống!';

  @override
  String get passwordRequiredForNcryptsec => 'Cần mật khẩu cho ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Giải mã ncryptsec thất bại. Vui lòng kiểm tra mật khẩu.';

  @override
  String get invalidPrivateKeyFormat => 'Định dạng khóa riêng không hợp lệ!';

  @override
  String get loginSuccess => 'Đăng nhập thành công!';

  @override
  String loginFailed(String message) {
    return 'Đăng nhập thất bại: $message';
  }

  @override
  String get typeConfirmToProceed => 'Gõ \"confirm\" để tiếp tục';

  @override
  String get logoutConfirm => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get notLoggedIn => 'Chưa đăng nhập';

  @override
  String get language => 'Ngôn ngữ';

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
  String get addAccount => 'Thêm tài khoản';

  @override
  String get updateSuccessful => 'Cập nhật thành công!';

  @override
  String get switchAccount => 'Chuyển tài khoản';

  @override
  String get switchAccountConfirm => 'Bạn có chắc muốn chuyển tài khoản?';

  @override
  String get switchSuccessfully => 'Chuyển thành công!';

  @override
  String get renameAccount => 'Đổi tên tài khoản';

  @override
  String get accountName => 'Tên tài khoản';

  @override
  String get enterNewName => 'Nhập tên mới';

  @override
  String get accounts => 'Tài khoản';

  @override
  String get localRelay => 'Relay cục bộ';

  @override
  String get remote => 'Từ xa';

  @override
  String get browser => 'Trình duyệt';

  @override
  String get theme => 'Giao diện';

  @override
  String get github => 'Github';

  @override
  String get version => 'Phiên bản';

  @override
  String get appSubtitle => 'Aegis - Ký Nostr';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get lightMode => 'Chế độ sáng';

  @override
  String get systemDefault => 'Mặc định hệ thống';

  @override
  String switchedTo(String mode) {
    return 'Đã chuyển sang $mode';
  }

  @override
  String get home => 'Trang chủ';

  @override
  String get waitingForRelayStart => 'Đang chờ relay khởi động...';

  @override
  String get connected => 'Đã kết nối';

  @override
  String get disconnected => 'Ngắt kết nối';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Lỗi tải ứng dụng NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Chưa có ứng dụng NIP-07.\n\nDùng Trình duyệt để truy cập ứng dụng Nostr!';

  @override
  String get unknown => 'Không xác định';

  @override
  String get active => 'Hoạt động';

  @override
  String get congratulationsEmptyState => 'Chúc mừng!\n\nBạn có thể dùng ứng dụng hỗ trợ Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Relay cục bộ dùng cổng $port, nhưng có vẻ ứng dụng khác đang dùng. Hãy đóng ứng dụng đó và thử lại.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'Đã bắt đầu ký NIP-46!';

  @override
  String get nip46FailedToStart => 'Khởi động thất bại.';

  @override
  String get retry => 'Thử lại';

  @override
  String get clear => 'Xóa';

  @override
  String get clearDatabase => 'Xóa cơ sở dữ liệu';

  @override
  String get clearDatabaseConfirm => 'Mọi dữ liệu relay sẽ bị xóa và relay sẽ khởi động lại nếu đang chạy. Không thể hoàn tác.';

  @override
  String get importDatabase => 'Nhập cơ sở dữ liệu';

  @override
  String get importDatabaseHint => 'Nhập đường dẫn thư mục cơ sở dữ liệu cần nhập. Cơ sở hiện có sẽ được sao lưu trước.';

  @override
  String get databaseDirectoryPath => 'Đường dẫn thư mục cơ sở dữ liệu';

  @override
  String get import => 'Nhập';

  @override
  String get export => 'Xuất';

  @override
  String get restart => 'Khởi động lại';

  @override
  String get restartRelay => 'Khởi động lại relay';

  @override
  String get restartRelayConfirm => 'Bạn có chắc muốn khởi động lại relay? Relay sẽ tạm dừng rồi chạy lại.';

  @override
  String get relayRestartedSuccess => 'Đã khởi động lại relay thành công';

  @override
  String relayRestartFailed(String message) {
    return 'Khởi động lại relay thất bại: $message';
  }

  @override
  String get databaseClearedSuccess => 'Đã xóa cơ sở dữ liệu thành công';

  @override
  String get databaseClearFailed => 'Xóa cơ sở dữ liệu thất bại';

  @override
  String errorWithMessage(String message) {
    return 'Lỗi: $message';
  }

  @override
  String get exportDatabase => 'Xuất cơ sở dữ liệu';

  @override
  String get exportDatabaseHint => 'Cơ sở dữ liệu relay sẽ được xuất ra file ZIP. Có thể mất vài phút.';

  @override
  String databaseExportedTo(String path) {
    return 'Đã xuất cơ sở dữ liệu tới: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Đã xuất cơ sở dữ liệu dạng ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Xuất cơ sở dữ liệu thất bại';

  @override
  String get importDatabaseReplaceHint => 'Cơ sở hiện tại sẽ bị thay bằng bản nhập. Cơ sở hiện có sẽ được sao lưu trước. Không thể hoàn tác.';

  @override
  String get selectDatabaseBackupFile => 'Chọn file (ZIP) hoặc thư mục sao lưu';

  @override
  String get selectDatabaseBackupDir => 'Chọn thư mục sao lưu';

  @override
  String get fileOrDirNotExist => 'File hoặc thư mục đã chọn không tồn tại';

  @override
  String get databaseImportedSuccess => 'Đã nhập cơ sở dữ liệu thành công';

  @override
  String get databaseImportFailed => 'Nhập cơ sở dữ liệu thất bại';

  @override
  String get status => 'Trạng thái';

  @override
  String get address => 'Địa chỉ';

  @override
  String get protocol => 'Giao thức';

  @override
  String get connections => 'Kết nối';

  @override
  String get running => 'Đang chạy';

  @override
  String get stopped => 'Đã dừng';

  @override
  String get addressCopiedToClipboard => 'Đã sao địa chỉ vào clipboard';

  @override
  String get exportData => 'Xuất dữ liệu';

  @override
  String get importData => 'Nhập dữ liệu';

  @override
  String get systemLogs => 'Nhật ký hệ thống';

  @override
  String get clearAllRelayData => 'Xóa mọi dữ liệu relay';

  @override
  String get noLogsAvailable => 'Không có nhật ký';

  @override
  String get passwordRequired => 'Cần nhập mật khẩu';

  @override
  String encryptionFailed(String message) {
    return 'Mã hóa thất bại: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Đã sao khóa riêng đã mã hóa vào clipboard';

  @override
  String get accountBackup => 'Sao lưu tài khoản';

  @override
  String get publicAccountId => 'ID tài khoản công khai';

  @override
  String get accountPrivateKey => 'Khóa riêng tài khoản';

  @override
  String get show => 'Hiện';

  @override
  String get generate => 'Tạo';

  @override
  String get enterEncryptionPassword => 'Nhập mật khẩu mã hóa';

  @override
  String get privateKeyEncryption => 'Mã hóa khóa riêng';

  @override
  String get encryptPrivateKeyHint => 'Mã hóa khóa riêng để bảo mật hơn. Khóa sẽ được mã hóa bằng mật khẩu.';

  @override
  String get ncryptsecHint => 'Khóa mã hóa sẽ bắt đầu bằng \"ncryptsec1\" và không dùng được nếu thiếu mật khẩu.';

  @override
  String get encryptAndCopyPrivateKey => 'Mã hóa và sao khóa riêng';

  @override
  String get privateKeyEncryptedSuccess => 'Đã mã hóa khóa riêng thành công!';

  @override
  String get encryptedKeyNcryptsec => 'Khóa đã mã hóa (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Tạo tài khoản Nostr mới';

  @override
  String get accountReadyPublicKeyHint => 'Tài khoản Nostr đã sẵn sàng! Đây là khóa công khai nostr của bạn:';

  @override
  String get nostrPubkey => 'Khóa công khai Nostr';

  @override
  String get create => 'Tạo';

  @override
  String get createSuccess => 'Tạo thành công!';

  @override
  String get application => 'Ứng dụng';

  @override
  String get createApplication => 'Tạo ứng dụng';

  @override
  String get addNewApplication => 'Thêm ứng dụng mới';

  @override
  String get addNsecbunkerManually => 'Thêm nsecbunker thủ công';

  @override
  String get loginUsingUrlScheme => 'Đăng nhập bằng URL Scheme';

  @override
  String get addApplicationMethodsHint => 'Bạn có thể chọn một trong các cách sau để kết nối Aegis!';

  @override
  String get urlSchemeLoginHint => 'Mở bằng ứng dụng hỗ trợ URL scheme Aegis để đăng nhập.';

  @override
  String get name => 'Tên';

  @override
  String get applicationInfo => 'Thông tin ứng dụng';

  @override
  String get activities => 'Hoạt động';

  @override
  String get clientPubkey => 'Khóa công khai máy khách';

  @override
  String get remove => 'Gỡ';

  @override
  String get removeAppConfirm => 'Gỡ mọi quyền của ứng dụng này?';

  @override
  String get removeSuccess => 'Đã gỡ thành công';

  @override
  String get nameCannotBeEmpty => 'Tên không được để trống';

  @override
  String get nameTooLong => 'Tên quá dài.';

  @override
  String get updateSuccess => 'Cập nhật thành công';

  @override
  String get editConfiguration => 'Sửa cấu hình';

  @override
  String get update => 'Cập nhật';

  @override
  String get search => 'Tìm...';

  @override
  String get enterCustomName => 'Nhập tên tùy chọn';

  @override
  String get selectApplication => 'Chọn ứng dụng';

  @override
  String get addWebApp => 'Thêm ứng dụng web';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Ứng dụng của tôi';

  @override
  String get add => 'Thêm';

  @override
  String get searchNostrApps => 'Tìm ứng dụng Nostr...';

  @override
  String get invalidUrlHint => 'URL không hợp lệ. Nhập URL HTTP hoặc HTTPS hợp lệ.';

  @override
  String get appAlreadyInList => 'Ứng dụng này đã có trong danh sách.';

  @override
  String appAdded(String name) {
    return 'Đã thêm $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Thêm ứng dụng thất bại: $error';
  }

  @override
  String get deleteApp => 'Xóa ứng dụng';

  @override
  String deleteAppConfirm(String name) {
    return 'Bạn có chắc muốn xóa \"$name\"?';
  }

  @override
  String get delete => 'Xóa';

  @override
  String appDeleted(String name) {
    return 'Đã xóa $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Xóa ứng dụng thất bại: $error';
  }

  @override
  String get copiedToClipboard => 'Đã sao vào clipboard';

  @override
  String get eventDetails => 'Chi tiết sự kiện';

  @override
  String get eventDetailsCopiedToClipboard => 'Đã sao chi tiết sự kiện vào clipboard';

  @override
  String get rawMetadataCopiedToClipboard => 'Đã sao siêu dữ liệu thô vào clipboard';

  @override
  String get permissionRequest => 'Yêu cầu quyền';

  @override
  String get permissionRequestContent => 'Ứng dụng này đang yêu cầu quyền truy cập tài khoản Nostr của bạn';

  @override
  String get grantPermissions => 'Cấp quyền';

  @override
  String get reject => 'Từ chối';

  @override
  String get fullAccessGranted => 'Đã cấp quyền truy cập đầy đủ';

  @override
  String get fullAccessHint => 'Ứng dụng này sẽ có quyền truy cập đầy đủ tài khoản Nostr của bạn, bao gồm:';

  @override
  String get permissionAccessPubkey => 'Truy cập khóa công khai Nostr';

  @override
  String get permissionSignEvents => 'Ký sự kiện Nostr';

  @override
  String get permissionEncryptDecrypt => 'Mã hóa và giải mã sự kiện (NIP-04 và NIP-44)';

  @override
  String get tips => 'Mẹo';

  @override
  String get schemeLoginFirst => 'Không thể xử lý scheme. Vui lòng đăng nhập trước.';

  @override
  String get newConnectionRequest => 'Yêu cầu kết nối mới';

  @override
  String get newConnectionNoSlotHint => 'Một ứng dụng mới đang cố kết nối nhưng không còn chỗ. Hãy tạo ứng dụng mới trước.';

  @override
  String get copiedSuccessfully => 'Đã sao thành công';

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
  String get noResultsFound => 'Không tìm thấy kết quả';

  @override
  String get pleaseSelectApplication => 'Vui lòng chọn ứng dụng';

  @override
  String get orEnterCustomName => 'Hoặc nhập tên tùy chỉnh';

  @override
  String get continueButton => 'Tiếp tục';
}
