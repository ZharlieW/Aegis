// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => '確認';

  @override
  String get cancel => 'キャンセル';

  @override
  String get settings => '設定';

  @override
  String get logout => 'ログアウト';

  @override
  String get login => 'ログイン';

  @override
  String get usePrivateKey => '秘密鍵でログイン';

  @override
  String get setupAegisWithNsec => 'Nostr 秘密鍵で Aegis を設定 — nsec、ncryptsec、hex 形式に対応。';

  @override
  String get privateKey => '秘密鍵';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex キー';

  @override
  String get password => 'パスワード';

  @override
  String get passwordHint => 'ncryptsec を復号するパスワードを入力';

  @override
  String get contentCannotBeEmpty => '内容を入力してください！';

  @override
  String get passwordRequiredForNcryptsec => 'ncryptsec にはパスワードが必要です！';

  @override
  String get decryptNcryptsecFailed => 'ncryptsec の復号に失敗しました。パスワードを確認してください。';

  @override
  String get invalidPrivateKeyFormat => '秘密鍵の形式が無効です！';

  @override
  String get loginSuccess => 'ログインに成功しました！';

  @override
  String loginFailed(String message) {
    return 'ログインに失敗しました：$message';
  }

  @override
  String get typeConfirmToProceed => '続行するには「confirm」と入力';

  @override
  String get logoutConfirm => 'ログアウトしてもよろしいですか？';

  @override
  String get notLoggedIn => '未ログイン';

  @override
  String get language => '言語';

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
  String get addAccount => 'アカウントを追加';

  @override
  String get updateSuccessful => '更新に成功しました！';

  @override
  String get switchAccount => 'アカウントを切り替え';

  @override
  String get switchAccountConfirm => 'アカウントを切り替えてもよろしいですか？';

  @override
  String get switchSuccessfully => '切り替えに成功しました！';

  @override
  String get renameAccount => 'アカウント名を変更';

  @override
  String get accountName => 'アカウント名';

  @override
  String get enterNewName => '新しい名前を入力';

  @override
  String get accounts => 'アカウント';

  @override
  String get localRelay => 'ローカル Relay';

  @override
  String get remote => 'リモート';

  @override
  String get browser => 'ブラウザ';

  @override
  String get theme => 'テーマ';

  @override
  String get github => 'Github';

  @override
  String get version => 'バージョン';

  @override
  String get appSubtitle => 'Aegis - Nostr 署名';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get lightMode => 'ライトモード';

  @override
  String get systemDefault => 'システムに従う';

  @override
  String switchedTo(String mode) {
    return '$mode に切り替えました';
  }

  @override
  String get home => 'ホーム';

  @override
  String get waitingForRelayStart => 'Relay の起動を待っています...';

  @override
  String get connected => '接続済み';

  @override
  String get disconnected => '未接続';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'NIP-07 アプリの読み込みに失敗しました：$error';
  }

  @override
  String get noNip07ApplicationsHint => 'NIP-07 アプリはまだありません。\n\nブラウザで Nostr アプリにアクセスしてください！';

  @override
  String get unknown => '不明';

  @override
  String get active => 'アクティブ';

  @override
  String get congratulationsEmptyState => 'おめでとうございます！\n\nAegis 対応アプリの利用を開始できます！';

  @override
  String localRelayPortInUse(String port) {
    return 'ローカル Relay はポート $port を使用する設定ですが、別のアプリが既に使用しているようです。競合するアプリを終了してから再試行してください。';
  }

  @override
  String get nip46Started => 'NIP-46 署名を開始しました！';

  @override
  String get nip46FailedToStart => '開始に失敗しました。';

  @override
  String get retry => '再試行';

  @override
  String get clear => 'クリア';

  @override
  String get clearDatabase => 'データベースをクリア';

  @override
  String get clearDatabaseConfirm => 'すべての Relay データが削除され、実行中の場合は Relay が再起動します。この操作は元に戻せません。';

  @override
  String get importDatabase => 'データベースをインポート';

  @override
  String get importDatabaseHint => 'インポートするデータベースディレクトリのパスを入力してください。既存のデータベースはインポート前にバックアップされます。';

  @override
  String get databaseDirectoryPath => 'データベースディレクトリのパス';

  @override
  String get import => 'インポート';

  @override
  String get export => 'エクスポート';

  @override
  String get restart => '再起動';

  @override
  String get restartRelay => 'Relay を再起動';

  @override
  String get restartRelayConfirm => 'Relay を再起動してもよろしいですか？一時停止してから再起動します。';

  @override
  String get relayRestartedSuccess => 'Relay の再起動に成功しました';

  @override
  String relayRestartFailed(String message) {
    return 'Relay の再起動に失敗しました：$message';
  }

  @override
  String get databaseClearedSuccess => 'データベースのクリアに成功しました';

  @override
  String get databaseClearFailed => 'データベースのクリアに失敗しました';

  @override
  String errorWithMessage(String message) {
    return 'エラー：$message';
  }

  @override
  String get exportDatabase => 'データベースをエクスポート';

  @override
  String get exportDatabaseHint => 'Relay データベースを ZIP ファイルとしてエクスポートします。しばらくかかる場合があります。';

  @override
  String databaseExportedTo(String path) {
    return 'データベースをエクスポートしました：$path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'データベースを ZIP ファイルとしてエクスポートしました：$path';
  }

  @override
  String get databaseExportFailed => 'データベースのエクスポートに失敗しました';

  @override
  String get importDatabaseReplaceHint => '現在のデータベースがインポートしたバックアップで置き換わります。既存のデータベースはインポート前にバックアップされます。この操作は元に戻せません。';

  @override
  String get selectDatabaseBackupFile => 'データベースバックアップファイル（ZIP）またはディレクトリを選択';

  @override
  String get selectDatabaseBackupDir => 'データベースバックアップディレクトリを選択';

  @override
  String get fileOrDirNotExist => '選択したファイルまたはディレクトリが存在しません';

  @override
  String get databaseImportedSuccess => 'データベースのインポートに成功しました';

  @override
  String get databaseImportFailed => 'データベースのインポートに失敗しました';

  @override
  String get status => '状態';

  @override
  String get address => 'アドレス';

  @override
  String get protocol => 'プロトコル';

  @override
  String get connections => '接続数';

  @override
  String get running => '実行中';

  @override
  String get stopped => '停止中';

  @override
  String get addressCopiedToClipboard => 'アドレスをクリップボードにコピーしました';

  @override
  String get exportData => 'データをエクスポート';

  @override
  String get importData => 'データをインポート';

  @override
  String get systemLogs => 'システムログ';

  @override
  String get clearAllRelayData => 'すべての Relay データをクリア';

  @override
  String get noLogsAvailable => 'ログがありません';

  @override
  String get passwordRequired => 'パスワードを入力してください';

  @override
  String encryptionFailed(String message) {
    return '暗号化に失敗しました：$message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => '暗号化された秘密鍵をクリップボードにコピーしました';

  @override
  String get accountBackup => 'アカウントバックアップ';

  @override
  String get publicAccountId => '公開アカウント ID';

  @override
  String get accountPrivateKey => 'アカウント秘密鍵';

  @override
  String get show => '表示';

  @override
  String get generate => '生成';

  @override
  String get enterEncryptionPassword => '暗号化パスワードを入力';

  @override
  String get privateKeyEncryption => '秘密鍵の暗号化';

  @override
  String get encryptPrivateKeyHint => '秘密鍵を暗号化してセキュリティを高めます。パスワードで暗号化されます。';

  @override
  String get ncryptsecHint => '暗号化されたキーは「ncryptsec1」で始まり、パスワードがないと使用できません。';

  @override
  String get encryptAndCopyPrivateKey => '暗号化して秘密鍵をコピー';

  @override
  String get privateKeyEncryptedSuccess => '秘密鍵の暗号化に成功しました！';

  @override
  String get encryptedKeyNcryptsec => '暗号化キー（ncryptsec）：';

  @override
  String get createNewNostrAccount => '新しい Nostr アカウントを作成';

  @override
  String get accountReadyPublicKeyHint => 'Nostr アカウントの準備ができました！これがあなたの nostr 公開鍵です：';

  @override
  String get nostrPubkey => 'Nostr 公開鍵';

  @override
  String get create => '作成';

  @override
  String get createSuccess => '作成に成功しました！';

  @override
  String get application => 'アプリ';

  @override
  String get createApplication => 'アプリを作成';

  @override
  String get addNewApplication => '新しいアプリを追加';

  @override
  String get addNsecbunkerManually => 'nsecbunker を手動で追加';

  @override
  String get loginUsingUrlScheme => 'URL スキームでログイン';

  @override
  String get addApplicationMethodsHint => '以下のいずれかの方法で Aegis に接続できます！';

  @override
  String get urlSchemeLoginHint => 'Aegis URL スキームに対応したアプリで開いてログインしてください。';

  @override
  String get name => '名前';

  @override
  String get applicationInfo => 'アプリ情報';

  @override
  String get activities => 'アクティビティ';

  @override
  String get clientPubkey => 'クライアント公開鍵';

  @override
  String get remove => '削除';

  @override
  String get removeAppConfirm => 'このアプリのすべての権限を削除してもよろしいですか？';

  @override
  String get removeSuccess => '削除に成功しました';

  @override
  String get nameCannotBeEmpty => '名前を入力してください';

  @override
  String get nameTooLong => '名前が長すぎます。';

  @override
  String get updateSuccess => '更新に成功しました';

  @override
  String get editConfiguration => '設定を編集';

  @override
  String get update => '更新';

  @override
  String get search => '検索...';

  @override
  String get enterCustomName => 'カスタム名を入力';

  @override
  String get selectApplication => 'アプリを選択';

  @override
  String get addWebApp => 'Web アプリを追加';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'マイアプリ';

  @override
  String get add => '追加';

  @override
  String get searchNostrApps => 'Nostr アプリを検索...';

  @override
  String get invalidUrlHint => '無効な URL です。有効な HTTP または HTTPS の URL を入力してください。';

  @override
  String get appAlreadyInList => 'このアプリは既にリストにあります。';

  @override
  String appAdded(String name) {
    return '$name を追加しました';
  }

  @override
  String appAddFailed(String error) {
    return 'アプリの追加に失敗しました：$error';
  }

  @override
  String get deleteApp => 'アプリを削除';

  @override
  String deleteAppConfirm(String name) {
    return '「$name」を削除してもよろしいですか？';
  }

  @override
  String get delete => '削除';

  @override
  String appDeleted(String name) {
    return '$name を削除しました';
  }

  @override
  String appDeleteFailed(String error) {
    return 'アプリの削除に失敗しました：$error';
  }

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get eventDetails => 'イベント詳細';

  @override
  String get eventDetailsCopiedToClipboard => 'イベント詳細をクリップボードにコピーしました';

  @override
  String get rawMetadataCopiedToClipboard => '生メタデータをクリップボードにコピーしました';

  @override
  String get permissionRequest => '権限リクエスト';

  @override
  String get permissionRequestContent => 'このアプリは Nostr アカウントへのアクセス権限を要求しています';

  @override
  String get grantPermissions => '権限を付与';

  @override
  String get reject => '拒否';

  @override
  String get fullAccessGranted => 'フルアクセスを付与しました';

  @override
  String get fullAccessHint => 'このアプリは Nostr アカウントへのフルアクセスを持ちます。次のことが含まれます：';

  @override
  String get permissionAccessPubkey => 'Nostr 公開鍵へのアクセス';

  @override
  String get permissionSignEvents => 'Nostr イベントの署名';

  @override
  String get permissionEncryptDecrypt => 'イベントの暗号化・復号（NIP-04 & NIP-44）';

  @override
  String get tips => 'ヒント';

  @override
  String get schemeLoginFirst => 'スキームを解決できません。先にログインしてください。';

  @override
  String get newConnectionRequest => '新しい接続リクエスト';

  @override
  String get newConnectionNoSlotHint => '新しいアプリが接続しようとしていますが、使用可能なアプリがありません。先に新しいアプリを作成してください。';

  @override
  String get copiedSuccessfully => 'コピーに成功しました';

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
  String get noResultsFound => '結果が見つかりません';

  @override
  String get pleaseSelectApplication => 'アプリを選択してください';

  @override
  String get orEnterCustomName => 'またはカスタム名を入力';

  @override
  String get continueButton => '続ける';
}
