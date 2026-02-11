// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get usePrivateKey => 'ใช้คีย์ส่วนตัว';

  @override
  String get setupAegisWithNsec => 'ตั้งค่า Aegis ด้วยคีย์ Nostr — รองรับ nsec, ncryptsec และ hex';

  @override
  String get privateKey => 'คีย์ส่วนตัว';

  @override
  String get privateKeyHint => 'คีย์ nsec / ncryptsec / hex';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get passwordHint => 'ใส่รหัสผ่านเพื่อถอดรหัส ncryptsec';

  @override
  String get contentCannotBeEmpty => 'เนื้อหาไม่สามารถว่างได้!';

  @override
  String get passwordRequiredForNcryptsec => 'ต้องใช้รหัสผ่านสำหรับ ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'ถอดรหัส ncryptsec ไม่สำเร็จ โปรดตรวจสอบรหัสผ่าน';

  @override
  String get invalidPrivateKeyFormat => 'รูปแบบคีย์ส่วนตัวไม่ถูกต้อง!';

  @override
  String get loginSuccess => 'เข้าสู่ระบบสำเร็จ!';

  @override
  String loginFailed(String message) {
    return 'เข้าสู่ระบบไม่สำเร็จ: $message';
  }

  @override
  String get typeConfirmToProceed => 'พิมพ์ \"confirm\" เพื่อดำเนินการ';

  @override
  String get logoutConfirm => 'คุณต้องการออกจากระบบหรือไม่?';

  @override
  String get notLoggedIn => 'ยังไม่ได้เข้าสู่ระบบ';

  @override
  String get language => 'ภาษา';

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
  String get addAccount => 'เพิ่มบัญชี';

  @override
  String get updateSuccessful => 'อัปเดตสำเร็จ!';

  @override
  String get switchAccount => 'สลับบัญชี';

  @override
  String get switchAccountConfirm => 'คุณต้องการสลับบัญชีหรือไม่?';

  @override
  String get switchSuccessfully => 'สลับสำเร็จ!';

  @override
  String get renameAccount => 'เปลี่ยนชื่อบัญชี';

  @override
  String get accountName => 'ชื่อบัญชี';

  @override
  String get enterNewName => 'ใส่ชื่อใหม่';

  @override
  String get accounts => 'บัญชี';

  @override
  String get localRelay => 'รีเลย์ท้องถิ่น';

  @override
  String get remote => 'ระยะไกล';

  @override
  String get browser => 'เบราว์เซอร์';

  @override
  String get theme => 'ธีม';

  @override
  String get github => 'Github';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get appSubtitle => 'Aegis - ตัวลงนาม Nostr';

  @override
  String get darkMode => 'โหมดมืด';

  @override
  String get lightMode => 'โหมดสว่าง';

  @override
  String get systemDefault => 'ตามระบบ';

  @override
  String switchedTo(String mode) {
    return 'เปลี่ยนเป็น $mode แล้ว';
  }

  @override
  String get home => 'หน้าหลัก';

  @override
  String get waitingForRelayStart => 'กำลังรอรีเลย์เริ่มทำงาน...';

  @override
  String get connected => 'เชื่อมต่อแล้ว';

  @override
  String get disconnected => 'ตัดการเชื่อมต่อ';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'โหลดแอป NIP-07 ไม่สำเร็จ: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'ยังไม่มีแอป NIP-07\n\nใช้เบราว์เซอร์เพื่อเข้าถึงแอป Nostr!';

  @override
  String get unknown => 'ไม่ทราบ';

  @override
  String get active => 'ใช้งาน';

  @override
  String get congratulationsEmptyState => 'ยินดีด้วย!\n\nตอนนี้คุณสามารถใช้แอปที่รองรับ Aegis ได้แล้ว!';

  @override
  String localRelayPortInUse(String port) {
    return 'รีเลย์ท้องถิ่นตั้งใช้พอร์ต $port แต่ดูเหมือนแอปอื่นใช้อยู่ ปิดแอปที่ขัดแย้งแล้วลองใหม่';
  }

  @override
  String get nip46Started => 'เริ่มตัวลงนาม NIP-46 แล้ว!';

  @override
  String get nip46FailedToStart => 'เริ่มไม่สำเร็จ';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get clear => 'ล้าง';

  @override
  String get clearDatabase => 'ล้างฐานข้อมูล';

  @override
  String get clearDatabaseConfirm => 'ข้อมูลรีเลย์ทั้งหมดจะถูกลบ และรีเลย์จะรีสตาร์ทถ้ากำลังทำงาน การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get importDatabase => 'นำเข้าฐานข้อมูล';

  @override
  String get importDatabaseHint => 'ใส่เส้นทางโฟลเดอร์ฐานข้อมูลที่จะนำเข้า ฐานข้อมูลเดิมจะถูกสำรองก่อนนำเข้า';

  @override
  String get databaseDirectoryPath => 'เส้นทางโฟลเดอร์ฐานข้อมูล';

  @override
  String get import => 'นำเข้า';

  @override
  String get export => 'ส่งออก';

  @override
  String get restart => 'รีสตาร์ท';

  @override
  String get restartRelay => 'รีสตาร์ทรีเลย์';

  @override
  String get restartRelayConfirm => 'คุณต้องการรีสตาร์ทรีเลย์หรือไม่? รีเลย์จะหยุดชั่วคราวแล้วเริ่มใหม่';

  @override
  String get relayRestartedSuccess => 'รีสตาร์ทรีเลย์สำเร็จ';

  @override
  String relayRestartFailed(String message) {
    return 'รีสตาร์ทรีเลย์ไม่สำเร็จ: $message';
  }

  @override
  String get databaseClearedSuccess => 'ล้างฐานข้อมูลสำเร็จ';

  @override
  String get databaseClearFailed => 'ล้างฐานข้อมูลไม่สำเร็จ';

  @override
  String errorWithMessage(String message) {
    return 'ข้อผิดพลาด: $message';
  }

  @override
  String get exportDatabase => 'ส่งออกฐานข้อมูล';

  @override
  String get exportDatabaseHint => 'ฐานข้อมูลรีเลย์จะถูกส่งออกเป็นไฟล์ ZIP อาจใช้เวลาสักครู่';

  @override
  String databaseExportedTo(String path) {
    return 'ส่งออกฐานข้อมูลไปที่: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'ส่งออกฐานข้อมูลเป็น ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'ส่งออกฐานข้อมูลไม่สำเร็จ';

  @override
  String get importDatabaseReplaceHint => 'ฐานข้อมูลปัจจุบันจะถูกแทนที่ด้วยข้อมูลที่นำเข้า ฐานข้อมูลเดิมจะถูกสำรองก่อน การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get selectDatabaseBackupFile => 'เลือกไฟล์ (ZIP) หรือโฟลเดอร์สำรอง';

  @override
  String get selectDatabaseBackupDir => 'เลือกโฟลเดอร์สำรอง';

  @override
  String get fileOrDirNotExist => 'ไฟล์หรือโฟลเดอร์ที่เลือกไม่มีอยู่';

  @override
  String get databaseImportedSuccess => 'นำเข้าฐานข้อมูลสำเร็จ';

  @override
  String get databaseImportFailed => 'นำเข้าฐานข้อมูลไม่สำเร็จ';

  @override
  String get status => 'สถานะ';

  @override
  String get address => 'ที่อยู่';

  @override
  String get protocol => 'โปรโตคอล';

  @override
  String get connections => 'การเชื่อมต่อ';

  @override
  String get running => 'กำลังทำงาน';

  @override
  String get stopped => 'หยุดแล้ว';

  @override
  String get addressCopiedToClipboard => 'คัดลอกที่อยู่แล้ว';

  @override
  String get exportData => 'ส่งออกข้อมูล';

  @override
  String get importData => 'นำเข้าข้อมูล';

  @override
  String get systemLogs => 'บันทึกระบบ';

  @override
  String get clearAllRelayData => 'ล้างข้อมูลรีเลย์ทั้งหมด';

  @override
  String get noLogsAvailable => 'ไม่มีบันทึก';

  @override
  String get passwordRequired => 'ต้องใช้รหัสผ่าน';

  @override
  String encryptionFailed(String message) {
    return 'การเข้ารหัสล้มเหลว: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'คัดลอกคีย์ส่วนตัวที่เข้ารหัสแล้ว';

  @override
  String get accountBackup => 'สำรองบัญชี';

  @override
  String get publicAccountId => 'รหัสบัญชีสาธารณะ';

  @override
  String get accountPrivateKey => 'คีย์ส่วนตัวบัญชี';

  @override
  String get show => 'แสดง';

  @override
  String get generate => 'สร้าง';

  @override
  String get enterEncryptionPassword => 'ใส่รหัสผ่านการเข้ารหัส';

  @override
  String get privateKeyEncryption => 'การเข้ารหัสคีย์ส่วนตัว';

  @override
  String get encryptPrivateKeyHint => 'เข้ารหัสคีย์ส่วนตัวเพื่อความปลอดภัย คีย์จะถูกเข้ารหัสด้วยรหัสผ่าน';

  @override
  String get ncryptsecHint => 'คีย์ที่เข้ารหัสจะขึ้นต้นด้วย \"ncryptsec1\" และใช้ไม่ได้โดยไม่มีรหัสผ่าน';

  @override
  String get encryptAndCopyPrivateKey => 'เข้ารหัสและคัดลอกคีย์ส่วนตัว';

  @override
  String get privateKeyEncryptedSuccess => 'เข้ารหัสคีย์ส่วนตัวสำเร็จ!';

  @override
  String get encryptedKeyNcryptsec => 'คีย์ที่เข้ารหัส (ncryptsec):';

  @override
  String get createNewNostrAccount => 'สร้างบัญชี Nostr ใหม่';

  @override
  String get accountReadyPublicKeyHint => 'บัญชี Nostr พร้อมแล้ว! นี่คือคีย์สาธารณะ nostr ของคุณ:';

  @override
  String get nostrPubkey => 'คีย์สาธารณะ Nostr';

  @override
  String get create => 'สร้าง';

  @override
  String get createSuccess => 'สร้างสำเร็จ!';

  @override
  String get application => 'แอป';

  @override
  String get createApplication => 'สร้างแอป';

  @override
  String get addNewApplication => 'เพิ่มแอปใหม่';

  @override
  String get addNsecbunkerManually => 'เพิ่ม nsecbunker ด้วยตนเอง';

  @override
  String get loginUsingUrlScheme => 'เข้าสู่ระบบด้วย URL Scheme';

  @override
  String get addApplicationMethodsHint => 'คุณสามารถเลือกวิธีใดวิธีหนึ่งเพื่อเชื่อมต่อกับ Aegis!';

  @override
  String get urlSchemeLoginHint => 'เปิดด้วยแอปที่รองรับ URL scheme ของ Aegis เพื่อเข้าสู่ระบบ';

  @override
  String get name => 'ชื่อ';

  @override
  String get applicationInfo => 'ข้อมูลแอป';

  @override
  String get activities => 'กิจกรรม';

  @override
  String get clientPubkey => 'คีย์สาธารณะไคลเอ็นต์';

  @override
  String get remove => 'ลบ';

  @override
  String get removeAppConfirm => 'คุณต้องการลบสิทธิ์ทั้งหมดของแอปนี้หรือไม่?';

  @override
  String get removeSuccess => 'ลบสำเร็จ';

  @override
  String get nameCannotBeEmpty => 'ชื่อไม่สามารถว่างได้';

  @override
  String get nameTooLong => 'ชื่อยาวเกินไป';

  @override
  String get updateSuccess => 'อัปเดตสำเร็จ';

  @override
  String get editConfiguration => 'แก้ไขการตั้งค่า';

  @override
  String get update => 'อัปเดต';

  @override
  String get search => 'ค้นหา...';

  @override
  String get enterCustomName => 'ใส่ชื่อที่กำหนดเอง';

  @override
  String get selectApplication => 'เลือกแอป';

  @override
  String get addWebApp => 'เพิ่มเว็บแอป';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'แอปของฉัน';

  @override
  String get add => 'เพิ่ม';

  @override
  String get searchNostrApps => 'ค้นหาแอป Nostr...';

  @override
  String get invalidUrlHint => 'URL ไม่ถูกต้อง กรุณาใส่ URL HTTP หรือ HTTPS ที่ถูกต้อง';

  @override
  String get appAlreadyInList => 'แอปนี้อยู่ในรายการแล้ว';

  @override
  String appAdded(String name) {
    return 'เพิ่ม $name แล้ว';
  }

  @override
  String appAddFailed(String error) {
    return 'เพิ่มแอปไม่สำเร็จ: $error';
  }

  @override
  String get deleteApp => 'ลบแอป';

  @override
  String deleteAppConfirm(String name) {
    return 'คุณต้องการลบ \"$name\" หรือไม่?';
  }

  @override
  String get delete => 'ลบ';

  @override
  String appDeleted(String name) {
    return 'ลบ $name แล้ว';
  }

  @override
  String appDeleteFailed(String error) {
    return 'ลบแอปไม่สำเร็จ: $error';
  }

  @override
  String get copiedToClipboard => 'คัดลอกแล้ว';

  @override
  String get eventDetails => 'รายละเอียดเหตุการณ์';

  @override
  String get eventDetailsCopiedToClipboard => 'คัดลอกรายละเอียดเหตุการณ์แล้ว';

  @override
  String get rawMetadataCopiedToClipboard => 'คัดลอกเมตาดาต้าดิบแล้ว';

  @override
  String get permissionRequest => 'คำขอลิทธิ์';

  @override
  String get permissionRequestContent => 'แอปนี้กำลังขอสิทธิ์เข้าถึงบัญชี Nostr ของคุณ';

  @override
  String get grantPermissions => 'อนุญาต';

  @override
  String get reject => 'ปฏิเสธ';

  @override
  String get fullAccessGranted => 'ให้สิทธิ์เข้าถึงเต็มแล้ว';

  @override
  String get fullAccessHint => 'แอปนี้จะมีสิทธิ์เข้าถึงบัญชี Nostr ของคุณอย่างเต็มที่ รวมถึง:';

  @override
  String get permissionAccessPubkey => 'เข้าถึงคีย์สาธารณะ Nostr';

  @override
  String get permissionSignEvents => 'ลงนามเหตุการณ์ Nostr';

  @override
  String get permissionEncryptDecrypt => 'เข้ารหัสและถอดรหัสเหตุการณ์ (NIP-04 และ NIP-44)';

  @override
  String get tips => 'เคล็ดลับ';

  @override
  String get schemeLoginFirst => 'ไม่สามารถแก้ scheme ได้ กรุณาเข้าสู่ระบบก่อน';

  @override
  String get newConnectionRequest => 'คำขอเชื่อมต่อใหม่';

  @override
  String get newConnectionNoSlotHint => 'แอปใหม่พยายามเชื่อมต่อแต่ไม่มีแอปว่าง กรุณาสร้างแอปใหม่ก่อน';

  @override
  String get copiedSuccessfully => 'คัดลอกสำเร็จ';

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
  String get noResultsFound => 'ไม่พบผลลัพธ์';

  @override
  String get pleaseSelectApplication => 'กรุณาเลือกแอป';

  @override
  String get orEnterCustomName => 'หรือใส่ชื่อที่กำหนดเอง';

  @override
  String get continueButton => 'ดำเนินการต่อ';
}
