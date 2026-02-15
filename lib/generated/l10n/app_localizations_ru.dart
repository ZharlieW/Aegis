// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get cancel => 'Отмена';

  @override
  String get settings => 'Настройки';

  @override
  String get logout => 'Выйти';

  @override
  String get login => 'Войти';

  @override
  String get usePrivateKey => 'Использовать приватный ключ';

  @override
  String get setupAegisWithNsec => 'Настройте Aegis с вашим Nostr-ключом — поддерживаются форматы nsec, ncryptsec и hex.';

  @override
  String get privateKey => 'Приватный ключ';

  @override
  String get privateKeyHint => 'Ключ nsec / ncryptsec / hex';

  @override
  String get password => 'Пароль';

  @override
  String get passwordHint => 'Введите пароль для расшифровки ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Содержимое не может быть пустым!';

  @override
  String get passwordRequiredForNcryptsec => 'Для ncryptsec требуется пароль!';

  @override
  String get decryptNcryptsecFailed => 'Не удалось расшифровать ncryptsec. Проверьте пароль.';

  @override
  String get invalidPrivateKeyFormat => 'Недопустимый формат приватного ключа!';

  @override
  String get loginSuccess => 'Вход выполнен!';

  @override
  String loginFailed(String message) {
    return 'Ошибка входа: $message';
  }

  @override
  String get typeConfirmToProceed => 'Введите «confirm» для продолжения';

  @override
  String get logoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get notLoggedIn => 'Не выполнен вход';

  @override
  String get language => 'Язык';

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
  String get addAccount => 'Добавить аккаунт';

  @override
  String get updateSuccessful => 'Обновление выполнено!';

  @override
  String get switchAccount => 'Сменить аккаунт';

  @override
  String get switchAccountConfirm => 'Вы уверены, что хотите сменить аккаунт?';

  @override
  String get switchSuccessfully => 'Переключение выполнено!';

  @override
  String get renameAccount => 'Переименовать аккаунт';

  @override
  String get accountName => 'Имя аккаунта';

  @override
  String get enterNewName => 'Введите новое имя';

  @override
  String get accounts => 'Аккаунты';

  @override
  String get localRelay => 'Локальный релей';

  @override
  String get remote => 'Удалённый';

  @override
  String get browser => 'Браузер';

  @override
  String get theme => 'Тема';

  @override
  String get github => 'Github';

  @override
  String get version => 'Версия';

  @override
  String get appSubtitle => 'Aegis — подписание Nostr';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get lightMode => 'Светлая тема';

  @override
  String get systemDefault => 'Системная';

  @override
  String switchedTo(String mode) {
    return 'Переключено на $mode';
  }

  @override
  String get home => 'Главная';

  @override
  String get waitingForRelayStart => 'Ожидание запуска релея...';

  @override
  String get connected => 'Подключено';

  @override
  String get disconnected => 'Отключено';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Ошибка загрузки приложений NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Пока нет приложений NIP-07.\n\nИспользуйте браузер для доступа к приложениям Nostr!';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get active => 'Активно';

  @override
  String get congratulationsEmptyState => 'Поздравляем!\n\nТеперь вы можете использовать приложения с поддержкой Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Локальный релей настроен на порт $port, но его, похоже, уже использует другое приложение. Закройте конфликтующее приложение и попробуйте снова.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'Подписание NIP-46 запущено!';

  @override
  String get nip46FailedToStart => 'Не удалось запустить.';

  @override
  String get retry => 'Повторить';

  @override
  String get clear => 'Очистить';

  @override
  String get clearDatabase => 'Очистить базу данных';

  @override
  String get clearDatabaseConfirm => 'Все данные релея будут удалены, при запущенном релее он будет перезапущен. Это действие нельзя отменить.';

  @override
  String get importDatabase => 'Импорт базы данных';

  @override
  String get importDatabaseHint => 'Введите путь к каталогу базы данных для импорта. Текущая база будет сохранена перед импортом.';

  @override
  String get databaseDirectoryPath => 'Путь к каталогу базы данных';

  @override
  String get import => 'Импорт';

  @override
  String get export => 'Экспорт';

  @override
  String get restart => 'Перезапуск';

  @override
  String get restartRelay => 'Перезапустить релей';

  @override
  String get restartRelayConfirm => 'Перезапустить релей? Он будет временно остановлен и затем запущен снова.';

  @override
  String get relayRestartedSuccess => 'Релей успешно перезапущен';

  @override
  String relayRestartFailed(String message) {
    return 'Не удалось перезапустить релей: $message';
  }

  @override
  String get databaseClearedSuccess => 'База данных успешно очищена';

  @override
  String get databaseClearFailed => 'Не удалось очистить базу данных';

  @override
  String errorWithMessage(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get exportDatabase => 'Экспорт базы данных';

  @override
  String get exportDatabaseHint => 'База данных релея будет экспортирована в ZIP-файл. Экспорт может занять некоторое время.';

  @override
  String databaseExportedTo(String path) {
    return 'База данных экспортирована в: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'База данных экспортирована как ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Не удалось экспортировать базу данных';

  @override
  String get importDatabaseReplaceHint => 'Текущая база будет заменена импортируемой копией. Текущая база будет сохранена перед импортом. Это действие нельзя отменить.';

  @override
  String get selectDatabaseBackupFile => 'Выберите файл (ZIP) или каталог резервной копии';

  @override
  String get selectDatabaseBackupDir => 'Выберите каталог резервной копии';

  @override
  String get fileOrDirNotExist => 'Выбранный файл или каталог не существует';

  @override
  String get databaseImportedSuccess => 'База данных успешно импортирована';

  @override
  String get databaseImportFailed => 'Не удалось импортировать базу данных';

  @override
  String get status => 'Статус';

  @override
  String get address => 'Адрес';

  @override
  String get protocol => 'Протокол';

  @override
  String get connections => 'Подключения';

  @override
  String get running => 'Запущен';

  @override
  String get stopped => 'Остановлен';

  @override
  String get addressCopiedToClipboard => 'Адрес скопирован в буфер обмена';

  @override
  String get exportData => 'Экспорт данных';

  @override
  String get importData => 'Импорт данных';

  @override
  String get systemLogs => 'Системные журналы';

  @override
  String get clearAllRelayData => 'Очистить все данные релея';

  @override
  String get noLogsAvailable => 'Нет доступных журналов';

  @override
  String get passwordRequired => 'Требуется пароль';

  @override
  String encryptionFailed(String message) {
    return 'Ошибка шифрования: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Зашифрованный приватный ключ скопирован в буфер обмена';

  @override
  String get accountBackup => 'Резервная копия аккаунта';

  @override
  String get publicAccountId => 'Публичный ID аккаунта';

  @override
  String get accountPrivateKey => 'Приватный ключ аккаунта';

  @override
  String get show => 'Показать';

  @override
  String get generate => 'Создать';

  @override
  String get enterEncryptionPassword => 'Введите пароль шифрования';

  @override
  String get privateKeyEncryption => 'Шифрование приватного ключа';

  @override
  String get encryptPrivateKeyHint => 'Зашифруйте приватный ключ для повышения безопасности. Он будет зашифрован паролем.';

  @override
  String get ncryptsecHint => 'Зашифрованный ключ будет начинаться с «ncryptsec1» и не может быть использован без пароля.';

  @override
  String get encryptAndCopyPrivateKey => 'Зашифровать и скопировать приватный ключ';

  @override
  String get privateKeyEncryptedSuccess => 'Приватный ключ успешно зашифрован!';

  @override
  String get encryptedKeyNcryptsec => 'Зашифрованный ключ (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Создать новый аккаунт Nostr';

  @override
  String get accountReadyPublicKeyHint => 'Ваш аккаунт Nostr готов! Это ваш открытый ключ nostr:';

  @override
  String get nostrPubkey => 'Открытый ключ Nostr';

  @override
  String get create => 'Создать';

  @override
  String get createSuccess => 'Успешно создано!';

  @override
  String get application => 'Приложение';

  @override
  String get createApplication => 'Создать приложение';

  @override
  String get addNewApplication => 'Добавить новое приложение';

  @override
  String get addNsecbunkerManually => 'Добавить nsecbunker вручную';

  @override
  String get loginUsingUrlScheme => 'Войти по URL-схеме';

  @override
  String get addApplicationMethodsHint => 'Вы можете выбрать любой из этих способов для подключения к Aegis!';

  @override
  String get urlSchemeLoginHint => 'Откройте в приложении с поддержкой URL-схемы Aegis для входа.';

  @override
  String get name => 'Имя';

  @override
  String get applicationInfo => 'Информация о приложении';

  @override
  String get activities => 'Активность';

  @override
  String get clientPubkey => 'Открытый ключ клиента';

  @override
  String get remove => 'Удалить';

  @override
  String get removeAppConfirm => 'Удалить все разрешения этого приложения?';

  @override
  String get removeSuccess => 'Успешно удалено';

  @override
  String get nameCannotBeEmpty => 'Имя не может быть пустым';

  @override
  String get nameTooLong => 'Имя слишком длинное.';

  @override
  String get updateSuccess => 'Обновление выполнено';

  @override
  String get editConfiguration => 'Редактировать настройки';

  @override
  String get update => 'Обновить';

  @override
  String get search => 'Поиск...';

  @override
  String get enterCustomName => 'Введите своё имя';

  @override
  String get selectApplication => 'Выберите приложение';

  @override
  String get addWebApp => 'Добавить веб-приложение';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Моё приложение';

  @override
  String get add => 'Добавить';

  @override
  String get searchNostrApps => 'Поиск приложений Nostr...';

  @override
  String get invalidUrlHint => 'Недопустимый URL. Введите корректный HTTP- или HTTPS-адрес.';

  @override
  String get appAlreadyInList => 'Это приложение уже в списке.';

  @override
  String appAdded(String name) {
    return 'Добавлено $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Не удалось добавить приложение: $error';
  }

  @override
  String get deleteApp => 'Удалить приложение';

  @override
  String deleteAppConfirm(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get delete => 'Удалить';

  @override
  String appDeleted(String name) {
    return 'Удалено $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Не удалось удалить приложение: $error';
  }

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get eventDetails => 'Подробности события';

  @override
  String get eventDetailsCopiedToClipboard => 'Подробности события скопированы в буфер обмена';

  @override
  String get rawMetadataCopiedToClipboard => 'Исходные метаданные скопированы в буфер обмена';

  @override
  String get permissionRequest => 'Запрос разрешения';

  @override
  String get permissionRequestContent => 'Это приложение запрашивает доступ к вашему аккаунту Nostr';

  @override
  String get grantPermissions => 'Предоставить разрешения';

  @override
  String get reject => 'Отклонить';

  @override
  String get fullAccessGranted => 'Полный доступ предоставлен';

  @override
  String get fullAccessHint => 'Это приложение получит полный доступ к вашему аккаунту Nostr, в том числе:';

  @override
  String get permissionAccessPubkey => 'Доступ к вашему открытому ключу Nostr';

  @override
  String get permissionSignEvents => 'Подписание событий Nostr';

  @override
  String get permissionEncryptDecrypt => 'Шифрование и расшифровка событий (NIP-04 и NIP-44)';

  @override
  String get tips => 'Подсказки';

  @override
  String get schemeLoginFirst => 'Не удалось обработать ссылку. Сначала войдите.';

  @override
  String get newConnectionRequest => 'Новый запрос подключения';

  @override
  String get newConnectionNoSlotHint => 'Новое приложение пытается подключиться, но нет доступных слотов. Сначала создайте новое приложение.';

  @override
  String get copiedSuccessfully => 'Успешно скопировано';

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
  String get noResultsFound => 'Ничего не найдено';

  @override
  String get pleaseSelectApplication => 'Выберите приложение';

  @override
  String get orEnterCustomName => 'Или введите своё название';

  @override
  String get continueButton => 'Продолжить';
}
