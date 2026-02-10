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
}
