// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';

  @override
  String get settings => '설정';

  @override
  String get logout => '로그아웃';

  @override
  String get login => '로그인';

  @override
  String get usePrivateKey => '개인 키로 로그인';

  @override
  String get setupAegisWithNsec => 'Nostr 개인 키로 Aegis 설정 — nsec, ncryptsec, hex 형식 지원.';

  @override
  String get privateKey => '개인 키';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex 키';

  @override
  String get password => '비밀번호';

  @override
  String get passwordHint => 'ncryptsec 복호화용 비밀번호 입력';

  @override
  String get contentCannotBeEmpty => '내용을 입력해 주세요!';

  @override
  String get passwordRequiredForNcryptsec => 'ncryptsec에는 비밀번호가 필요합니다!';

  @override
  String get decryptNcryptsecFailed => 'ncryptsec 복호화에 실패했습니다. 비밀번호를 확인해 주세요.';

  @override
  String get invalidPrivateKeyFormat => '개인 키 형식이 올바르지 않습니다!';

  @override
  String get loginSuccess => '로그인 성공!';

  @override
  String loginFailed(String message) {
    return '로그인 실패: $message';
  }

  @override
  String get typeConfirmToProceed => '계속하려면 \"confirm\" 입력';

  @override
  String get logoutConfirm => '로그아웃하시겠습니까?';

  @override
  String get notLoggedIn => '로그인되지 않음';

  @override
  String get language => '언어';

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
  String get addAccount => '계정 추가';

  @override
  String get updateSuccessful => '업데이트 성공!';

  @override
  String get switchAccount => '계정 전환';

  @override
  String get switchAccountConfirm => '계정을 전환하시겠습니까?';

  @override
  String get switchSuccessfully => '전환 성공!';

  @override
  String get renameAccount => '계정 이름 변경';

  @override
  String get accountName => '계정 이름';

  @override
  String get enterNewName => '새 이름 입력';

  @override
  String get accounts => '계정';

  @override
  String get localRelay => '로컬 릴레이';

  @override
  String get remote => '원격';

  @override
  String get browser => '브라우저';

  @override
  String get theme => '테마';

  @override
  String get github => 'Github';

  @override
  String get version => '버전';

  @override
  String get appSubtitle => 'Aegis - Nostr 서명';

  @override
  String get darkMode => '다크 모드';

  @override
  String get lightMode => '라이트 모드';

  @override
  String get systemDefault => '시스템 기본값';

  @override
  String switchedTo(String mode) {
    return '$mode(으)로 전환됨';
  }

  @override
  String get home => '홈';

  @override
  String get waitingForRelayStart => '릴레이 시작 대기 중...';

  @override
  String get connected => '연결됨';

  @override
  String get disconnected => '연결 끊김';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'NIP-07 앱 로드 실패: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'NIP-07 앱이 아직 없습니다.\n\n브라우저에서 Nostr 앱에 접속하세요!';

  @override
  String get unknown => '알 수 없음';

  @override
  String get active => '활성';

  @override
  String get congratulationsEmptyState => '축하합니다!\n\nAegis를 지원하는 앱을 사용할 수 있습니다!';

  @override
  String localRelayPortInUse(String port) {
    return '로컬 릴레이가 포트 $port를 사용하도록 설정되어 있으나, 다른 앱이 이미 사용 중인 것 같습니다. 해당 앱을 종료한 후 다시 시도해 주세요.';
  }

  @override
  String get nip46Started => 'NIP-46 서명이 시작되었습니다!';

  @override
  String get nip46FailedToStart => '시작에 실패했습니다.';

  @override
  String get retry => '다시 시도';

  @override
  String get clear => '지우기';

  @override
  String get clearDatabase => '데이터베이스 지우기';

  @override
  String get clearDatabaseConfirm => '모든 릴레이 데이터가 삭제되며, 실행 중이면 릴레이가 재시작됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get importDatabase => '데이터베이스 가져오기';

  @override
  String get importDatabaseHint => '가져올 데이터베이스 디렉터리 경로를 입력하세요. 기존 데이터베이스는 가져오기 전에 백업됩니다.';

  @override
  String get databaseDirectoryPath => '데이터베이스 디렉터리 경로';

  @override
  String get import => '가져오기';

  @override
  String get export => '내보내기';

  @override
  String get restart => '재시작';

  @override
  String get restartRelay => '릴레이 재시작';

  @override
  String get restartRelayConfirm => '릴레이를 재시작하시겠습니까? 일시 중지 후 다시 시작됩니다.';

  @override
  String get relayRestartedSuccess => '릴레이 재시작 성공';

  @override
  String relayRestartFailed(String message) {
    return '릴레이 재시작 실패: $message';
  }

  @override
  String get databaseClearedSuccess => '데이터베이스 지우기 성공';

  @override
  String get databaseClearFailed => '데이터베이스 지우기 실패';

  @override
  String errorWithMessage(String message) {
    return '오류: $message';
  }

  @override
  String get exportDatabase => '데이터베이스 내보내기';

  @override
  String get exportDatabaseHint => '릴레이 데이터베이스를 ZIP 파일로 내보냅니다. 잠시 걸릴 수 있습니다.';

  @override
  String databaseExportedTo(String path) {
    return '데이터베이스 내보냄: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return '데이터베이스를 ZIP 파일로 내보냄: $path';
  }

  @override
  String get databaseExportFailed => '데이터베이스 내보내기 실패';

  @override
  String get importDatabaseReplaceHint => '현재 데이터베이스가 가져온 백업으로 대체됩니다. 기존 데이터베이스는 가져오기 전에 백업됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get selectDatabaseBackupFile => '데이터베이스 백업 파일(ZIP) 또는 디렉터리 선택';

  @override
  String get selectDatabaseBackupDir => '데이터베이스 백업 디렉터리 선택';

  @override
  String get fileOrDirNotExist => '선택한 파일 또는 디렉터리가 없습니다';

  @override
  String get databaseImportedSuccess => '데이터베이스 가져오기 성공';

  @override
  String get databaseImportFailed => '데이터베이스 가져오기 실패';

  @override
  String get status => '상태';

  @override
  String get address => '주소';

  @override
  String get protocol => '프로토콜';

  @override
  String get connections => '연결 수';

  @override
  String get running => '실행 중';

  @override
  String get stopped => '중지됨';

  @override
  String get addressCopiedToClipboard => '주소가 클립보드에 복사됨';

  @override
  String get exportData => '데이터 내보내기';

  @override
  String get importData => '데이터 가져오기';

  @override
  String get systemLogs => '시스템 로그';

  @override
  String get clearAllRelayData => '모든 릴레이 데이터 지우기';

  @override
  String get noLogsAvailable => '로그 없음';

  @override
  String get passwordRequired => '비밀번호를 입력해 주세요';

  @override
  String encryptionFailed(String message) {
    return '암호화 실패: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => '암호화된 개인 키가 클립보드에 복사됨';

  @override
  String get accountBackup => '계정 백업';

  @override
  String get publicAccountId => '공개 계정 ID';

  @override
  String get accountPrivateKey => '계정 개인 키';

  @override
  String get show => '표시';

  @override
  String get generate => '생성';

  @override
  String get enterEncryptionPassword => '암호화 비밀번호 입력';

  @override
  String get privateKeyEncryption => '개인 키 암호화';

  @override
  String get encryptPrivateKeyHint => '개인 키를 암호화하여 보안을 높입니다. 비밀번호로 암호화됩니다.';

  @override
  String get ncryptsecHint => '암호화된 키는 \"ncryptsec1\"로 시작하며, 비밀번호 없이는 사용할 수 없습니다.';

  @override
  String get encryptAndCopyPrivateKey => '암호화 후 개인 키 복사';

  @override
  String get privateKeyEncryptedSuccess => '개인 키 암호화 성공!';

  @override
  String get encryptedKeyNcryptsec => '암호화 키(ncryptsec):';

  @override
  String get createNewNostrAccount => '새 Nostr 계정 만들기';

  @override
  String get accountReadyPublicKeyHint => 'Nostr 계정이 준비되었습니다! 이것이 nostr 공개 키입니다:';

  @override
  String get nostrPubkey => 'Nostr 공개 키';

  @override
  String get create => '만들기';

  @override
  String get createSuccess => '만들기 성공!';

  @override
  String get application => '앱';

  @override
  String get createApplication => '앱 만들기';

  @override
  String get addNewApplication => '새 앱 추가';

  @override
  String get addNsecbunkerManually => 'nsecbunker 수동 추가';

  @override
  String get loginUsingUrlScheme => 'URL 스킴으로 로그인';

  @override
  String get addApplicationMethodsHint => '다음 방법 중 하나로 Aegis에 연결할 수 있습니다!';

  @override
  String get urlSchemeLoginHint => 'Aegis URL 스킴을 지원하는 앱으로 열어 로그인하세요.';

  @override
  String get name => '이름';

  @override
  String get applicationInfo => '앱 정보';

  @override
  String get activities => '활동';

  @override
  String get clientPubkey => '클라이언트 공개 키';

  @override
  String get remove => '제거';

  @override
  String get removeAppConfirm => '이 앱의 모든 권한을 제거하시겠습니까?';

  @override
  String get removeSuccess => '제거 성공';

  @override
  String get nameCannotBeEmpty => '이름을 입력해 주세요';

  @override
  String get nameTooLong => '이름이 너무 깁니다.';

  @override
  String get updateSuccess => '업데이트 성공';

  @override
  String get editConfiguration => '구성 편집';

  @override
  String get update => '업데이트';

  @override
  String get search => '검색...';

  @override
  String get enterCustomName => '사용자 지정 이름 입력';

  @override
  String get selectApplication => '앱 선택';

  @override
  String get addWebApp => '웹 앱 추가';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => '내 앱';

  @override
  String get add => '추가';

  @override
  String get searchNostrApps => 'Nostr 앱 검색...';

  @override
  String get invalidUrlHint => '잘못된 URL입니다. 올바른 HTTP 또는 HTTPS URL을 입력하세요.';

  @override
  String get appAlreadyInList => '이 앱은 이미 목록에 있습니다.';

  @override
  String appAdded(String name) {
    return '$name 추가됨';
  }

  @override
  String appAddFailed(String error) {
    return '앱 추가 실패: $error';
  }

  @override
  String get deleteApp => '앱 삭제';

  @override
  String deleteAppConfirm(String name) {
    return '「$name」을(를) 삭제하시겠습니까?';
  }

  @override
  String get delete => '삭제';

  @override
  String appDeleted(String name) {
    return '$name 삭제됨';
  }

  @override
  String appDeleteFailed(String error) {
    return '앱 삭제 실패: $error';
  }

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get eventDetails => '이벤트 세부정보';

  @override
  String get eventDetailsCopiedToClipboard => '이벤트 세부정보가 클립보드에 복사됨';

  @override
  String get rawMetadataCopiedToClipboard => '원시 메타데이터가 클립보드에 복사됨';

  @override
  String get permissionRequest => '권한 요청';

  @override
  String get permissionRequestContent => '이 앱이 Nostr 계정 액세스 권한을 요청하고 있습니다';

  @override
  String get grantPermissions => '권한 부여';

  @override
  String get reject => '거부';

  @override
  String get fullAccessGranted => '전체 액세스 부여됨';

  @override
  String get fullAccessHint => '이 앱은 Nostr 계정에 대한 전체 액세스 권한을 가지며, 다음을 포함합니다:';

  @override
  String get permissionAccessPubkey => 'Nostr 공개 키 액세스';

  @override
  String get permissionSignEvents => 'Nostr 이벤트 서명';

  @override
  String get permissionEncryptDecrypt => '이벤트 암호화·복호화(NIP-04 & NIP-44)';

  @override
  String get tips => '팁';

  @override
  String get schemeLoginFirst => '스킴을 확인할 수 없습니다. 먼저 로그인하세요.';

  @override
  String get newConnectionRequest => '새 연결 요청';

  @override
  String get newConnectionNoSlotHint => '새 앱이 연결을 시도하고 있지만 사용 가능한 앱이 없습니다. 먼저 새 앱을 만드세요.';

  @override
  String get copiedSuccessfully => '복사 성공';

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
  String get noResultsFound => '검색 결과가 없습니다';

  @override
  String get pleaseSelectApplication => '앱을 선택해 주세요';

  @override
  String get orEnterCustomName => '또는 사용자 지정 이름 입력';

  @override
  String get continueButton => '계속';
}
