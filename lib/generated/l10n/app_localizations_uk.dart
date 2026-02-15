// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get settings => 'Налаштування';

  @override
  String get logout => 'Вийти';

  @override
  String get login => 'Увійти';

  @override
  String get usePrivateKey => 'Використовувати приватний ключ';

  @override
  String get setupAegisWithNsec => 'Налаштуйте Aegis за допомогою ключа Nostr — підтримуються формати nsec, ncryptsec та hex.';

  @override
  String get privateKey => 'Приватний ключ';

  @override
  String get privateKeyHint => 'Ключ nsec / ncryptsec / hex';

  @override
  String get password => 'Пароль';

  @override
  String get passwordHint => 'Введіть пароль для розшифровки ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Вміст не може бути порожнім!';

  @override
  String get passwordRequiredForNcryptsec => 'Пароль потрібен для ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Не вдалося розшифрувати ncryptsec. Перевірте пароль.';

  @override
  String get invalidPrivateKeyFormat => 'Недійсний формат приватного ключа!';

  @override
  String get loginSuccess => 'Вхід виконано успішно!';

  @override
  String loginFailed(String message) {
    return 'Помилка входу: $message';
  }

  @override
  String get typeConfirmToProceed => 'Введіть \"confirm\" для продовження';

  @override
  String get logoutConfirm => 'Ви впевнені, що хочете вийти?';

  @override
  String get notLoggedIn => 'Не ввійшли';

  @override
  String get language => 'Мова';

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
  String get addAccount => 'Додати обліковий запис';

  @override
  String get updateSuccessful => 'Оновлення успішне!';

  @override
  String get switchAccount => 'Перемкнути обліковий запис';

  @override
  String get switchAccountConfirm => 'Ви впевнені, що хочете перемкнути обліковий запис?';

  @override
  String get switchSuccessfully => 'Перемкнення успішне!';

  @override
  String get renameAccount => 'Перейменувати обліковий запис';

  @override
  String get accountName => 'Назва облікового запису';

  @override
  String get enterNewName => 'Введіть нову назву';

  @override
  String get accounts => 'Облікові записи';

  @override
  String get localRelay => 'Локальний реле';

  @override
  String get remote => 'Віддалений';

  @override
  String get browser => 'Браузер';

  @override
  String get theme => 'Тема';

  @override
  String get github => 'Github';

  @override
  String get version => 'Версія';

  @override
  String get appSubtitle => 'Aegis — підписант Nostr';

  @override
  String get darkMode => 'Темний режим';

  @override
  String get lightMode => 'Світлий режим';

  @override
  String get systemDefault => 'За замовчуванням системи';

  @override
  String switchedTo(String mode) {
    return 'Перемкнено на $mode';
  }

  @override
  String get home => 'Головна';

  @override
  String get waitingForRelayStart => 'Очікування запуску реле...';

  @override
  String get connected => 'Підключено';

  @override
  String get disconnected => 'Відключено';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Помилка завантаження додатків NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Ще немає додатків NIP-07.\n\nВикористовуйте браузер для доступу до додатків Nostr!';

  @override
  String get unknown => 'Невідомо';

  @override
  String get active => 'Активний';

  @override
  String get congratulationsEmptyState => 'Вітаємо!\n\nТепер ви можете використовувати додатки з підтримкою Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Локальне реле налаштовано на порт $port, але схоже, його вже використовує інший додаток. Закрийте конфліктний додаток і спробуйте знову.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'Підписант NIP-46 запущено!';

  @override
  String get nip46FailedToStart => 'Не вдалося запустити.';

  @override
  String get retry => 'Повторити';

  @override
  String get clear => 'Очистити';

  @override
  String get clearDatabase => 'Очистити базу даних';

  @override
  String get clearDatabaseConfirm => 'Це видалить усі дані реле та перезапустить реле, якщо воно працює. Цю дію не можна скасувати.';

  @override
  String get importDatabase => 'Імпортувати базу даних';

  @override
  String get importDatabaseHint => 'Введіть шлях до каталогу бази даних для імпорту. Існуюча база буде збережена перед імпортом.';

  @override
  String get databaseDirectoryPath => 'Шлях до каталогу бази даних';

  @override
  String get import => 'Імпорт';

  @override
  String get export => 'Експорт';

  @override
  String get restart => 'Перезапустити';

  @override
  String get restartRelay => 'Перезапустити реле';

  @override
  String get restartRelayConfirm => 'Ви впевнені, що хочете перезапустити реле? Реле буде тимчасово зупинено, а потім перезапущено.';

  @override
  String get relayRestartedSuccess => 'Реле успішно перезапущено';

  @override
  String relayRestartFailed(String message) {
    return 'Не вдалося перезапустити реле: $message';
  }

  @override
  String get databaseClearedSuccess => 'Базу даних успішно очищено';

  @override
  String get databaseClearFailed => 'Не вдалося очистити базу даних';

  @override
  String errorWithMessage(String message) {
    return 'Помилка: $message';
  }

  @override
  String get exportDatabase => 'Експортувати базу даних';

  @override
  String get exportDatabaseHint => 'База даних реле буде експортована як ZIP-файл. Експорт може зайняти кілька хвилин.';

  @override
  String databaseExportedTo(String path) {
    return 'Базу даних експортовано до: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Базу даних експортовано як ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Не вдалося експортувати базу даних';

  @override
  String get importDatabaseReplaceHint => 'Це замінить поточну базу даних імпортованою копією. Існуюча база буде збережена перед імпортом. Цю дію не можна скасувати.';

  @override
  String get selectDatabaseBackupFile => 'Виберіть файл резервної копії (ZIP) або каталог';

  @override
  String get selectDatabaseBackupDir => 'Виберіть каталог резервної копії бази даних';

  @override
  String get fileOrDirNotExist => 'Обраний файл або каталог не існує';

  @override
  String get databaseImportedSuccess => 'Базу даних успішно імпортовано';

  @override
  String get databaseImportFailed => 'Не вдалося імпортувати базу даних';

  @override
  String get status => 'Статус';

  @override
  String get address => 'Адреса';

  @override
  String get protocol => 'Протокол';

  @override
  String get connections => 'З\'єднання';

  @override
  String get running => 'Працює';

  @override
  String get stopped => 'Зупинено';

  @override
  String get addressCopiedToClipboard => 'Адресу скопійовано в буфер обміну';

  @override
  String get exportData => 'Експорт даних';

  @override
  String get importData => 'Імпорт даних';

  @override
  String get systemLogs => 'Системні журнали';

  @override
  String get clearAllRelayData => 'Очистити всі дані реле';

  @override
  String get noLogsAvailable => 'Журнали відсутні';

  @override
  String get passwordRequired => 'Потрібен пароль';

  @override
  String encryptionFailed(String message) {
    return 'Помилка шифрування: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Зашифрований приватний ключ скопійовано в буфер обміну';

  @override
  String get accountBackup => 'Резервна копія облікового запису';

  @override
  String get publicAccountId => 'Публічний ідентифікатор облікового запису';

  @override
  String get accountPrivateKey => 'Приватний ключ облікового запису';

  @override
  String get show => 'Показати';

  @override
  String get generate => 'Згенерувати';

  @override
  String get enterEncryptionPassword => 'Введіть пароль шифрування';

  @override
  String get privateKeyEncryption => 'Шифрування приватного ключа';

  @override
  String get encryptPrivateKeyHint => 'Зашифруйте приватний ключ для підвищення безпеки. Ключ буде зашифровано паролем.';

  @override
  String get ncryptsecHint => 'Зашифрований ключ починатиметься з \"ncryptsec1\" і не може бути використаний без пароля.';

  @override
  String get encryptAndCopyPrivateKey => 'Зашифрувати та скопіювати приватний ключ';

  @override
  String get privateKeyEncryptedSuccess => 'Приватний ключ успішно зашифровано!';

  @override
  String get encryptedKeyNcryptsec => 'Зашифрований ключ (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Створити новий обліковий запис Nostr';

  @override
  String get accountReadyPublicKeyHint => 'Ваш обліковий запис Nostr готовий! Це ваш публічний ключ nostr:';

  @override
  String get nostrPubkey => 'Публічний ключ Nostr';

  @override
  String get create => 'Створити';

  @override
  String get createSuccess => 'Успішно створено!';

  @override
  String get application => 'Додаток';

  @override
  String get createApplication => 'Створити додаток';

  @override
  String get addNewApplication => 'Додати новий додаток';

  @override
  String get addNsecbunkerManually => 'Додати nsecbunker вручну';

  @override
  String get loginUsingUrlScheme => 'Увійти за допомогою URL-схеми';

  @override
  String get addApplicationMethodsHint => 'Ви можете обрати будь-який із цих способів для підключення до Aegis!';

  @override
  String get urlSchemeLoginHint => 'Відкрийте в додатку з підтримкою URL-схеми Aegis для входу';

  @override
  String get name => 'Назва';

  @override
  String get applicationInfo => 'Інформація про додаток';

  @override
  String get activities => 'Активність';

  @override
  String get clientPubkey => 'Публічний ключ клієнта';

  @override
  String get remove => 'Видалити';

  @override
  String get removeAppConfirm => 'Ви впевнені, що хочете видалити всі дозволи цього додатку?';

  @override
  String get removeSuccess => 'Успішно видалено';

  @override
  String get nameCannotBeEmpty => 'Назва не може бути порожньою';

  @override
  String get nameTooLong => 'Назва занадто довга.';

  @override
  String get updateSuccess => 'Оновлення успішне';

  @override
  String get editConfiguration => 'Редагувати налаштування';

  @override
  String get update => 'Оновити';

  @override
  String get search => 'Пошук...';

  @override
  String get enterCustomName => 'Введіть власну назву';

  @override
  String get selectApplication => 'Виберіть додаток';

  @override
  String get addWebApp => 'Додати веб-додаток';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Мій додаток';

  @override
  String get add => 'Додати';

  @override
  String get searchNostrApps => 'Пошук додатків Nostr...';

  @override
  String get invalidUrlHint => 'Недійсна URL. Введіть дійсну HTTP або HTTPS URL.';

  @override
  String get appAlreadyInList => 'Цей додаток уже в списку.';

  @override
  String appAdded(String name) {
    return 'Додано $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Не вдалося додати додаток: $error';
  }

  @override
  String get deleteApp => 'Видалити додаток';

  @override
  String deleteAppConfirm(String name) {
    return 'Ви впевнені, що хочете видалити \"$name\"?';
  }

  @override
  String get delete => 'Видалити';

  @override
  String appDeleted(String name) {
    return 'Видалено $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Не вдалося видалити додаток: $error';
  }

  @override
  String get copiedToClipboard => 'Скопійовано в буфер обміну';

  @override
  String get eventDetails => 'Деталі події';

  @override
  String get eventDetailsCopiedToClipboard => 'Деталі події скопійовано в буфер обміну';

  @override
  String get rawMetadataCopiedToClipboard => 'Сирині метадані скопійовано в буфер обміну';

  @override
  String get permissionRequest => 'Запит дозволу';

  @override
  String get permissionRequestContent => 'Цей додаток запитує дозвіл на доступ до вашого облікового запису Nostr';

  @override
  String get grantPermissions => 'Надати дозволи';

  @override
  String get reject => 'Відхилити';

  @override
  String get fullAccessGranted => 'Повний доступ надано';

  @override
  String get fullAccessHint => 'Цей додаток матиме повний доступ до вашого облікового запису Nostr, зокрема:';

  @override
  String get permissionAccessPubkey => 'Доступ до вашого публічного ключа Nostr';

  @override
  String get permissionSignEvents => 'Підпис подій Nostr';

  @override
  String get permissionEncryptDecrypt => 'Шифрування та розшифрування подій (NIP-04 та NIP-44)';

  @override
  String get tips => 'Поради';

  @override
  String get schemeLoginFirst => 'Не вдалося розв’язати схему, спочатку увійдіть.';

  @override
  String get newConnectionRequest => 'Новий запит на з’єднання';

  @override
  String get newConnectionNoSlotHint => 'Новий додаток намагається підключитися, але немає вільного додатку. Спочатку створіть новий додаток.';

  @override
  String get copiedSuccessfully => 'Успішно скопійовано';

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
  String get noResultsFound => 'Нічого не знайдено';

  @override
  String get pleaseSelectApplication => 'Виберіть додаток';

  @override
  String get orEnterCustomName => 'Або введіть власну назву';

  @override
  String get continueButton => 'Продовжити';
}
