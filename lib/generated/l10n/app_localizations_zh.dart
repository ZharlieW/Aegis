// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => '确认';

  @override
  String get cancel => '取消';

  @override
  String get settings => '设置';

  @override
  String get logout => '退出登录';

  @override
  String get login => '登录';

  @override
  String get usePrivateKey => '使用私钥登录';

  @override
  String get setupAegisWithNsec => '使用 Nostr 私钥配置 Aegis，支持 nsec、ncryptsec 和 hex 格式。';

  @override
  String get privateKey => '私钥';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex 密钥';

  @override
  String get password => '密码';

  @override
  String get passwordHint => '输入密码以解密 ncryptsec';

  @override
  String get contentCannotBeEmpty => '内容不能为空！';

  @override
  String get passwordRequiredForNcryptsec => 'ncryptsec 需要输入密码！';

  @override
  String get decryptNcryptsecFailed => '解密 ncryptsec 失败，请检查密码。';

  @override
  String get invalidPrivateKeyFormat => '私钥格式无效！';

  @override
  String get loginSuccess => '登录成功！';

  @override
  String loginFailed(String message) {
    return '登录失败：$message';
  }

  @override
  String get typeConfirmToProceed => '输入「confirm」以继续';

  @override
  String get logoutConfirm => '确定要退出登录吗？';

  @override
  String get notLoggedIn => '未登录';

  @override
  String get language => '语言';

  @override
  String get english => 'English';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get japanese => '日语';

  @override
  String get korean => '韩语';

  @override
  String get spanish => '西班牙语';

  @override
  String get french => '法语';

  @override
  String get german => '德语';

  @override
  String get portuguese => '葡萄牙语';

  @override
  String get russian => '俄语';

  @override
  String get arabic => '阿拉伯语';

  @override
  String get azerbaijani => '阿塞拜疆语';

  @override
  String get bulgarian => '保加利亚语';

  @override
  String get catalan => '加泰罗尼亚语';

  @override
  String get czech => '捷克语';

  @override
  String get danish => '丹麦语';

  @override
  String get greek => '希腊语';

  @override
  String get estonian => '爱沙尼亚语';

  @override
  String get farsi => '波斯语';

  @override
  String get hindi => '印地语';

  @override
  String get hungarian => '匈牙利语';

  @override
  String get indonesian => '印尼语';

  @override
  String get italian => '意大利语';

  @override
  String get latvian => '拉脱维亚语';

  @override
  String get dutch => '荷兰语';

  @override
  String get polish => '波兰语';

  @override
  String get swedish => '瑞典语';

  @override
  String get thai => '泰语';

  @override
  String get turkish => '土耳其语';

  @override
  String get ukrainian => '乌克兰语';

  @override
  String get urdu => '乌尔都语';

  @override
  String get vietnamese => '越南语';

  @override
  String get traditionalChinese => '繁体中文';

  @override
  String get addAccount => '添加账号';

  @override
  String get updateSuccessful => '更新成功！';

  @override
  String get switchAccount => '切换账号';

  @override
  String get switchAccountConfirm => '确定要切换账号吗？';

  @override
  String get switchSuccessfully => '切换成功！';

  @override
  String get renameAccount => '重命名账号';

  @override
  String get accountName => '账号名称';

  @override
  String get enterNewName => '输入新名称';

  @override
  String get accounts => '账号';

  @override
  String get localRelay => '本地 Relay';

  @override
  String get remote => '远程';

  @override
  String get browser => '浏览器';

  @override
  String get theme => '主题';

  @override
  String get github => 'Github';

  @override
  String get version => '版本';

  @override
  String get appSubtitle => 'Aegis - Nostr 签名器';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightMode => '浅色模式';

  @override
  String get systemDefault => '跟随系统';

  @override
  String switchedTo(String mode) {
    return '已切换至 $mode';
  }

  @override
  String get home => '首页';

  @override
  String get waitingForRelayStart => '正在等待 Relay 启动...';

  @override
  String get connected => '已连接';

  @override
  String get disconnected => '未连接';

  @override
  String errorLoadingNip07Applications(String error) {
    return '加载 NIP-07 应用失败：$error';
  }

  @override
  String get noNip07ApplicationsHint => '暂无 NIP-07 应用。\n\n使用浏览器访问 Nostr 应用！';

  @override
  String get unknown => '未知';

  @override
  String get active => '活跃';

  @override
  String get congratulationsEmptyState => '恭喜！\n\n现在可以开始使用支持 Aegis 的应用了！';

  @override
  String localRelayPortInUse(String port) {
    return '本地 Relay 使用端口 $port，但该端口似乎已被其他应用占用。请关闭冲突应用后重试。';
  }

  @override
  String get localRelayChangePort => '修改端口';

  @override
  String get localRelayChangePortHint => '修改端口后，请在应用中更新 signer 链接（bunker URL）。';

  @override
  String get nip46Started => 'NIP-46 签名器已启动！';

  @override
  String get nip46FailedToStart => '启动失败。';

  @override
  String get retry => '重试';

  @override
  String get clear => '清除';

  @override
  String get clearDatabase => '清除数据库';

  @override
  String get clearDatabaseConfirm => '将删除所有 Relay 数据，若 Relay 正在运行则会重启。此操作不可撤销。';

  @override
  String get importDatabase => '导入数据库';

  @override
  String get importDatabaseHint => '输入要导入的数据库目录路径。导入前会备份现有数据库。';

  @override
  String get databaseDirectoryPath => '数据库目录路径';

  @override
  String get import => '导入';

  @override
  String get export => '导出';

  @override
  String get restart => '重启';

  @override
  String get restartRelay => '重启 Relay';

  @override
  String get restartRelayConfirm => '确定要重启 Relay 吗？Relay 将暂时停止后重新启动。';

  @override
  String get relayRestartedSuccess => 'Relay 已成功重启';

  @override
  String relayRestartFailed(String message) {
    return '重启 Relay 失败：$message';
  }

  @override
  String get databaseClearedSuccess => '数据库已成功清除';

  @override
  String get databaseClearFailed => '清除数据库失败';

  @override
  String errorWithMessage(String message) {
    return '错误：$message';
  }

  @override
  String get exportDatabase => '导出数据库';

  @override
  String get exportDatabaseHint => '将把 Relay 数据库导出为 ZIP 文件，导出可能需要片刻。';

  @override
  String databaseExportedTo(String path) {
    return '数据库已导出至：$path';
  }

  @override
  String databaseExportedZip(String path) {
    return '数据库已导出为 ZIP 文件：$path';
  }

  @override
  String get databaseExportFailed => '导出数据库失败';

  @override
  String get importDatabaseReplaceHint => '将用导入的备份替换当前数据库。导入前会备份现有数据库。此操作不可撤销。';

  @override
  String get selectDatabaseBackupFile => '选择数据库备份文件（ZIP）或目录';

  @override
  String get selectDatabaseBackupDir => '选择数据库备份目录';

  @override
  String get fileOrDirNotExist => '所选文件或目录不存在';

  @override
  String get databaseImportedSuccess => '数据库已成功导入';

  @override
  String get databaseImportFailed => '导入数据库失败';

  @override
  String get status => '状态';

  @override
  String get address => '地址';

  @override
  String get protocol => '协议';

  @override
  String get connections => '连接数';

  @override
  String get running => '运行中';

  @override
  String get stopped => '已停止';

  @override
  String get addressCopiedToClipboard => '地址已复制到剪贴板';

  @override
  String get exportData => '导出数据';

  @override
  String get importData => '导入数据';

  @override
  String get systemLogs => '系统日志';

  @override
  String get clearAllRelayData => '清除所有 Relay 数据';

  @override
  String get noLogsAvailable => '暂无日志';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String encryptionFailed(String message) {
    return '加密失败：$message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => '加密私钥已复制到剪贴板';

  @override
  String get accountBackup => '账号备份';

  @override
  String get publicAccountId => '公开账号 ID';

  @override
  String get accountPrivateKey => '账号私钥';

  @override
  String get show => '显示';

  @override
  String get generate => '生成';

  @override
  String get enterEncryptionPassword => '输入加密密码';

  @override
  String get privateKeyEncryption => '私钥加密';

  @override
  String get encryptPrivateKeyHint => '加密私钥以提高安全性。将使用密码对私钥进行加密。';

  @override
  String get ncryptsecHint => '加密后的密钥将以「ncryptsec1」开头，无密码无法使用。';

  @override
  String get encryptAndCopyPrivateKey => '加密并复制私钥';

  @override
  String get privateKeyEncryptedSuccess => '私钥加密成功！';

  @override
  String get encryptedKeyNcryptsec => '加密密钥（ncryptsec）：';

  @override
  String get createNewNostrAccount => '创建新的 Nostr 账号';

  @override
  String get accountReadyPublicKeyHint => '您的 Nostr 账号已就绪！这是您的 nostr 公钥：';

  @override
  String get nostrPubkey => 'Nostr 公钥';

  @override
  String get create => '创建';

  @override
  String get createSuccess => '创建成功！';

  @override
  String get application => '应用';

  @override
  String get createApplication => '创建应用';

  @override
  String get addNewApplication => '添加新应用';

  @override
  String get addNsecbunkerManually => '手动添加 nsecbunker';

  @override
  String get loginUsingUrlScheme => '通过 URL Scheme 登录';

  @override
  String get addApplicationMethodsHint => '您可以选择以下任一方式与 Aegis 连接！';

  @override
  String get urlSchemeLoginHint => '请使用支持 Aegis URL  scheme 的应用打开以登录';

  @override
  String get name => '名称';

  @override
  String get applicationInfo => '应用信息';

  @override
  String get activities => '动态';

  @override
  String get clientPubkey => '客户端公钥';

  @override
  String get remove => '移除';

  @override
  String get removeAppConfirm => '确定要移除此应用的所有权限吗？';

  @override
  String get removeSuccess => '移除成功';

  @override
  String get nameCannotBeEmpty => '名称不能为空';

  @override
  String get nameTooLong => '名称过长。';

  @override
  String get updateSuccess => '更新成功';

  @override
  String get editConfiguration => '编辑配置';

  @override
  String get update => '更新';

  @override
  String get search => '搜索...';

  @override
  String get enterCustomName => '输入自定义名称';

  @override
  String get selectApplication => '选择应用';

  @override
  String get addWebApp => '添加网页应用';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => '我的应用';

  @override
  String get add => '添加';

  @override
  String get searchNostrApps => '搜索 Nostr 应用...';

  @override
  String get invalidUrlHint => '无效的 URL，请输入有效的 HTTP 或 HTTPS 地址。';

  @override
  String get appAlreadyInList => '该应用已在列表中。';

  @override
  String appAdded(String name) {
    return '已添加 $name';
  }

  @override
  String appAddFailed(String error) {
    return '添加应用失败：$error';
  }

  @override
  String get deleteApp => '删除应用';

  @override
  String deleteAppConfirm(String name) {
    return '确定要删除「$name」吗？';
  }

  @override
  String get delete => '删除';

  @override
  String appDeleted(String name) {
    return '已删除 $name';
  }

  @override
  String appDeleteFailed(String error) {
    return '删除应用失败：$error';
  }

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get eventDetails => '事件详情';

  @override
  String get eventDetailsCopiedToClipboard => '事件详情已复制到剪贴板';

  @override
  String get rawMetadataCopiedToClipboard => '原始元数据已复制到剪贴板';

  @override
  String get permissionRequest => '权限请求';

  @override
  String get permissionRequestContent => '此应用正在请求访问您的 Nostr 账号的权限';

  @override
  String get grantPermissions => '授予权限';

  @override
  String get reject => '拒绝';

  @override
  String get fullAccessGranted => '已授予完整访问权限';

  @override
  String get fullAccessHint => '此应用将拥有您 Nostr 账号的完整访问权限，包括：';

  @override
  String get permissionAccessPubkey => '访问您的 Nostr 公钥';

  @override
  String get permissionSignEvents => '签名 Nostr 事件';

  @override
  String get permissionEncryptDecrypt => '加密与解密事件（NIP-04 与 NIP-44）';

  @override
  String get tips => '提示';

  @override
  String get schemeLoginFirst => '无法解析链接，请先登录。';

  @override
  String get newConnectionRequest => '新连接请求';

  @override
  String get newConnectionNoSlotHint => '有新应用尝试连接，但没有可用的应用槽位。请先创建新应用。';

  @override
  String get copiedSuccessfully => '复制成功';

  @override
  String get importDatabasePathHint => '/路径/到/nostr_relay_backup_...';

  @override
  String get relayStatsSize => '大小';

  @override
  String get relayStatsEvents => '事件数';

  @override
  String get relayStatsUptime => '运行时长';

  @override
  String get shareRelayBackupSubject => 'Nostr 中继数据库备份';

  @override
  String get shareRelayBackupIosText => 'Nostr 中继数据库备份\n\n点击「存储到文件」保存到「文件」应用。';

  @override
  String get shareRelayBackupIosSnackbar => '数据库已导出为 ZIP 文件。在分享面板中使用「存储到文件」保存。';

  @override
  String databaseExportedToIosHint(String path) {
    return '数据库已导出至：$path\n\n可通过「文件」应用 > 我的 iPhone > Aegis 访问。';
  }

  @override
  String get shareRelayBackupAndroidText => 'Nostr 中继数据库备份\n\n选择保存 ZIP 文件的位置。';

  @override
  String get shareRelayBackupAndroidSnackbar => '数据库已导出为 ZIP 文件。请在分享面板中选择保存位置。';

  @override
  String get protocolWs => 'WS';

  @override
  String get protocolWss => 'WSS';

  @override
  String get confirmLiteral => 'confirm';

  @override
  String get errorCannotDetermineHomeDir => '无法确定主目录';

  @override
  String get errorZipFileNotFound => '未找到 ZIP 文件';

  @override
  String get unitBytes => 'B';

  @override
  String get unitKB => 'KB';

  @override
  String get unitMB => 'MB';

  @override
  String get unitGB => 'GB';

  @override
  String get durationZero => '0秒';

  @override
  String get durationDayShort => '天';

  @override
  String get durationHourShort => '时';

  @override
  String get durationMinuteShort => '分';

  @override
  String get durationSecondShort => '秒';

  @override
  String get noResultsFound => '未找到结果';

  @override
  String get pleaseSelectApplication => '请选择一个应用';

  @override
  String get orEnterCustomName => '或输入自定义名称';

  @override
  String get continueButton => '继续';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => '確認';

  @override
  String get cancel => '取消';

  @override
  String get settings => '設定';

  @override
  String get logout => '登出';

  @override
  String get login => '登入';

  @override
  String get usePrivateKey => '使用私鑰登入';

  @override
  String get setupAegisWithNsec => '使用 Nostr 私鑰設定 Aegis，支援 nsec、ncryptsec 與 hex 格式。';

  @override
  String get privateKey => '私鑰';

  @override
  String get privateKeyHint => 'nsec / ncryptsec / hex 金鑰';

  @override
  String get password => '密碼';

  @override
  String get passwordHint => '輸入密碼以解密 ncryptsec';

  @override
  String get contentCannotBeEmpty => '內容不可為空！';

  @override
  String get passwordRequiredForNcryptsec => 'ncryptsec 需要密碼！';

  @override
  String get decryptNcryptsecFailed => '解密 ncryptsec 失敗，請檢查密碼。';

  @override
  String get invalidPrivateKeyFormat => '私鑰格式無效！';

  @override
  String get loginSuccess => '登入成功！';

  @override
  String loginFailed(String message) {
    return '登入失敗：$message';
  }

  @override
  String get typeConfirmToProceed => '輸入「confirm」以繼續';

  @override
  String get logoutConfirm => '確定要登出嗎？';

  @override
  String get notLoggedIn => '未登入';

  @override
  String get language => '語言';

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
  String get addAccount => '新增帳號';

  @override
  String get updateSuccessful => '更新成功！';

  @override
  String get switchAccount => '切換帳號';

  @override
  String get switchAccountConfirm => '確定要切換帳號嗎？';

  @override
  String get switchSuccessfully => '切換成功！';

  @override
  String get renameAccount => '重新命名帳號';

  @override
  String get accountName => '帳號名稱';

  @override
  String get enterNewName => '輸入新名稱';

  @override
  String get accounts => '帳號';

  @override
  String get localRelay => '本機 Relay';

  @override
  String get remote => '遠端';

  @override
  String get browser => '瀏覽器';

  @override
  String get theme => '主題';

  @override
  String get github => 'Github';

  @override
  String get version => '版本';

  @override
  String get appSubtitle => 'Aegis - Nostr 簽署器';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightMode => '淺色模式';

  @override
  String get systemDefault => '跟隨系統';

  @override
  String switchedTo(String mode) {
    return '已切換至 $mode';
  }

  @override
  String get home => '首頁';

  @override
  String get waitingForRelayStart => '正在等待 Relay 啟動...';

  @override
  String get connected => '已連線';

  @override
  String get disconnected => '未連線';

  @override
  String errorLoadingNip07Applications(String error) {
    return '載入 NIP-07 應用失敗：$error';
  }

  @override
  String get noNip07ApplicationsHint => '尚無 NIP-07 應用。\n\n請使用瀏覽器存取 Nostr 應用！';

  @override
  String get unknown => '未知';

  @override
  String get active => '使用中';

  @override
  String get congratulationsEmptyState => '恭喜！\n\n現在可以開始使用支援 Aegis 的應用了！';

  @override
  String localRelayPortInUse(String port) {
    return '本機 Relay 使用埠 $port，但該埠似乎已被其他應用使用。請關閉衝突應用後再試。';
  }

  @override
  String get nip46Started => 'NIP-46 簽署器已啟動！';

  @override
  String get nip46FailedToStart => '啟動失敗。';

  @override
  String get retry => '重試';

  @override
  String get clear => '清除';

  @override
  String get clearDatabase => '清除資料庫';

  @override
  String get clearDatabaseConfirm => '將刪除所有 Relay 資料，若 Relay 正在執行則會重啟。此操作無法復原。';

  @override
  String get importDatabase => '匯入資料庫';

  @override
  String get importDatabaseHint => '輸入要匯入的資料庫目錄路徑。匯入前會備份現有資料庫。';

  @override
  String get databaseDirectoryPath => '資料庫目錄路徑';

  @override
  String get import => '匯入';

  @override
  String get export => '匯出';

  @override
  String get restart => '重新啟動';

  @override
  String get restartRelay => '重新啟動 Relay';

  @override
  String get restartRelayConfirm => '確定要重新啟動 Relay 嗎？Relay 將暫時停止後再啟動。';

  @override
  String get relayRestartedSuccess => 'Relay 已成功重新啟動';

  @override
  String relayRestartFailed(String message) {
    return '重新啟動 Relay 失敗：$message';
  }

  @override
  String get databaseClearedSuccess => '資料庫已成功清除';

  @override
  String get databaseClearFailed => '清除資料庫失敗';

  @override
  String errorWithMessage(String message) {
    return '錯誤：$message';
  }

  @override
  String get exportDatabase => '匯出資料庫';

  @override
  String get exportDatabaseHint => '將把 Relay 資料庫匯出為 ZIP 檔案，匯出可能需要片刻。';

  @override
  String databaseExportedTo(String path) {
    return '資料庫已匯出至：$path';
  }

  @override
  String databaseExportedZip(String path) {
    return '資料庫已匯出為 ZIP 檔案：$path';
  }

  @override
  String get databaseExportFailed => '匯出資料庫失敗';

  @override
  String get importDatabaseReplaceHint => '將以匯入的備份取代目前資料庫。匯入前會備份現有資料庫。此操作無法復原。';

  @override
  String get selectDatabaseBackupFile => '選擇資料庫備份檔案（ZIP）或目錄';

  @override
  String get selectDatabaseBackupDir => '選擇資料庫備份目錄';

  @override
  String get fileOrDirNotExist => '所選檔案或目錄不存在';

  @override
  String get databaseImportedSuccess => '資料庫已成功匯入';

  @override
  String get databaseImportFailed => '匯入資料庫失敗';

  @override
  String get status => '狀態';

  @override
  String get address => '位址';

  @override
  String get protocol => '通訊協定';

  @override
  String get connections => '連線數';

  @override
  String get running => '執行中';

  @override
  String get stopped => '已停止';

  @override
  String get addressCopiedToClipboard => '位址已複製到剪貼簿';

  @override
  String get exportData => '匯出資料';

  @override
  String get importData => '匯入資料';

  @override
  String get systemLogs => '系統記錄';

  @override
  String get clearAllRelayData => '清除所有 Relay 資料';

  @override
  String get noLogsAvailable => '尚無記錄';

  @override
  String get passwordRequired => '請輸入密碼';

  @override
  String encryptionFailed(String message) {
    return '加密失敗：$message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => '加密私鑰已複製到剪貼簿';

  @override
  String get accountBackup => '帳號備份';

  @override
  String get publicAccountId => '公開帳號 ID';

  @override
  String get accountPrivateKey => '帳號私鑰';

  @override
  String get show => '顯示';

  @override
  String get generate => '產生';

  @override
  String get enterEncryptionPassword => '輸入加密密碼';

  @override
  String get privateKeyEncryption => '私鑰加密';

  @override
  String get encryptPrivateKeyHint => '加密私鑰以提升安全性。將使用密碼加密私鑰。';

  @override
  String get ncryptsecHint => '加密後的金鑰將以「ncryptsec1」開頭，無密碼無法使用。';

  @override
  String get encryptAndCopyPrivateKey => '加密並複製私鑰';

  @override
  String get privateKeyEncryptedSuccess => '私鑰加密成功！';

  @override
  String get encryptedKeyNcryptsec => '加密金鑰（ncryptsec）：';

  @override
  String get createNewNostrAccount => '建立新的 Nostr 帳號';

  @override
  String get accountReadyPublicKeyHint => '您的 Nostr 帳號已就緒！這是您的 nostr 公鑰：';

  @override
  String get nostrPubkey => 'Nostr 公鑰';

  @override
  String get create => '建立';

  @override
  String get createSuccess => '建立成功！';

  @override
  String get application => '應用程式';

  @override
  String get createApplication => '建立應用程式';

  @override
  String get addNewApplication => '新增應用程式';

  @override
  String get addNsecbunkerManually => '手動新增 nsecbunker';

  @override
  String get loginUsingUrlScheme => '透過 URL Scheme 登入';

  @override
  String get addApplicationMethodsHint => '您可選擇以下任一方式與 Aegis 連線！';

  @override
  String get urlSchemeLoginHint => '請使用支援 Aegis URL scheme 的應用程式開啟以登入';

  @override
  String get name => '名稱';

  @override
  String get applicationInfo => '應用程式資訊';

  @override
  String get activities => '動態';

  @override
  String get clientPubkey => '用戶端公鑰';

  @override
  String get remove => '移除';

  @override
  String get removeAppConfirm => '確定要移除此應用程式的所有權限嗎？';

  @override
  String get removeSuccess => '移除成功';

  @override
  String get nameCannotBeEmpty => '名稱不可為空';

  @override
  String get nameTooLong => '名稱過長。';

  @override
  String get updateSuccess => '更新成功';

  @override
  String get editConfiguration => '編輯設定';

  @override
  String get update => '更新';

  @override
  String get search => '搜尋...';

  @override
  String get enterCustomName => '輸入自訂名稱';

  @override
  String get selectApplication => '選擇應用程式';

  @override
  String get addWebApp => '新增網頁應用程式';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => '我的應用程式';

  @override
  String get add => '新增';

  @override
  String get searchNostrApps => '搜尋 Nostr 應用程式...';

  @override
  String get invalidUrlHint => '無效的 URL，請輸入有效的 HTTP 或 HTTPS 網址。';

  @override
  String get appAlreadyInList => '此應用程式已在清單中。';

  @override
  String appAdded(String name) {
    return '已新增 $name';
  }

  @override
  String appAddFailed(String error) {
    return '新增應用程式失敗：$error';
  }

  @override
  String get deleteApp => '刪除應用程式';

  @override
  String deleteAppConfirm(String name) {
    return '確定要刪除「$name」嗎？';
  }

  @override
  String get delete => '刪除';

  @override
  String appDeleted(String name) {
    return '已刪除 $name';
  }

  @override
  String appDeleteFailed(String error) {
    return '刪除應用程式失敗：$error';
  }

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get eventDetails => '事件詳情';

  @override
  String get eventDetailsCopiedToClipboard => '事件詳情已複製到剪貼簿';

  @override
  String get rawMetadataCopiedToClipboard => '原始中繼資料已複製到剪貼簿';

  @override
  String get permissionRequest => '權限請求';

  @override
  String get permissionRequestContent => '此應用程式正在請求存取您的 Nostr 帳號的權限';

  @override
  String get grantPermissions => '授予權限';

  @override
  String get reject => '拒絕';

  @override
  String get fullAccessGranted => '已授予完整存取權限';

  @override
  String get fullAccessHint => '此應用程式將擁有您 Nostr 帳號的完整存取權限，包括：';

  @override
  String get permissionAccessPubkey => '存取您的 Nostr 公鑰';

  @override
  String get permissionSignEvents => '簽署 Nostr 事件';

  @override
  String get permissionEncryptDecrypt => '加密與解密事件（NIP-04 與 NIP-44）';

  @override
  String get tips => '提示';

  @override
  String get schemeLoginFirst => '無法解析連結，請先登入。';

  @override
  String get newConnectionRequest => '新連線請求';

  @override
  String get newConnectionNoSlotHint => '有新應用程式嘗試連線，但沒有可用的應用程式槽位。請先建立新應用程式。';

  @override
  String get copiedSuccessfully => '複製成功';

  @override
  String get noResultsFound => '找不到結果';

  @override
  String get pleaseSelectApplication => '請選擇應用程式';

  @override
  String get orEnterCustomName => '或輸入自訂名稱';

  @override
  String get continueButton => '繼續';
}
