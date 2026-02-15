// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Потвърди';

  @override
  String get cancel => 'Отказ';

  @override
  String get settings => 'Настройки';

  @override
  String get logout => 'Изход';

  @override
  String get login => 'Вход';

  @override
  String get usePrivateKey => 'Използвайте частния си ключ';

  @override
  String get setupAegisWithNsec => 'Настройте Aegis с вашия Nostr частен ключ — поддържа nsec, ncryptsec и hex формати.';

  @override
  String get privateKey => 'Частен ключ';

  @override
  String get privateKeyHint => 'Ключ nsec / ncryptsec / hex';

  @override
  String get password => 'Парола';

  @override
  String get passwordHint => 'Въведете парола за декриптиране на ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Съдържанието не може да е празно!';

  @override
  String get passwordRequiredForNcryptsec => 'Паролата е задължителна за ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Декриптирането на ncryptsec не успя. Проверете паролата.';

  @override
  String get invalidPrivateKeyFormat => 'Невалиден формат на частния ключ!';

  @override
  String get loginSuccess => 'Входът е успешен!';

  @override
  String loginFailed(String message) {
    return 'Входът не успя: $message';
  }

  @override
  String get typeConfirmToProceed => 'Напишете \"confirm\" за да продължите';

  @override
  String get logoutConfirm => 'Сигурни ли сте, че искате да излезете?';

  @override
  String get notLoggedIn => 'Не сте влезли';

  @override
  String get language => 'Език';

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
  String get addAccount => 'Добавяне на акаунт';

  @override
  String get updateSuccessful => 'Актуализацията е успешна!';

  @override
  String get switchAccount => 'Смяна на акаунт';

  @override
  String get switchAccountConfirm => 'Сигурни ли сте, че искате да смените акаунта?';

  @override
  String get switchSuccessfully => 'Смяната е успешна!';

  @override
  String get renameAccount => 'Преименуване на акаунт';

  @override
  String get accountName => 'Име на акаунт';

  @override
  String get enterNewName => 'Въведете ново име';

  @override
  String get accounts => 'Акаунти';

  @override
  String get localRelay => 'Локален релей';

  @override
  String get remote => 'Отдалечен';

  @override
  String get browser => 'Браузър';

  @override
  String get theme => 'Тема';

  @override
  String get github => 'Github';

  @override
  String get version => 'Версия';

  @override
  String get appSubtitle => 'Aegis — Подписващ Nostr';

  @override
  String get darkMode => 'Тъмен режим';

  @override
  String get lightMode => 'Светъл режим';

  @override
  String get systemDefault => 'Системен по подразбиране';

  @override
  String switchedTo(String mode) {
    return 'Превключено на $mode';
  }

  @override
  String get home => 'Начало';

  @override
  String get waitingForRelayStart => 'Изчакване на стартиране на релея...';

  @override
  String get connected => 'Свързано';

  @override
  String get disconnected => 'Прекъснато';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Грешка при зареждане на приложения NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Все още няма приложения NIP-07.\n\nИзползвайте браузъра за достъп до приложения Nostr!';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get active => 'Активно';

  @override
  String get congratulationsEmptyState => 'Поздравления!\n\nСега можете да използвате приложения с поддръжка на Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Локалният релей е зададен на порт $port, но изглежда друга програма го използва. Затворете конфликтната програма и опитайте отново.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'Подписващият NIP-46 е стартиран!';

  @override
  String get nip46FailedToStart => 'Стартирането не успя.';

  @override
  String get retry => 'Опитайте отново';

  @override
  String get clear => 'Изчистване';

  @override
  String get clearDatabase => 'Изчистване на базата данни';

  @override
  String get clearDatabaseConfirm => 'Това ще изтрие всички данни на релея и ще рестартира релея, ако работи. Това действие не може да бъде отменено.';

  @override
  String get importDatabase => 'Импорт на база данни';

  @override
  String get importDatabaseHint => 'Въведете пътя до папката с базата данни за импорт. Съществуващата база ще бъде архивирана преди импорта.';

  @override
  String get databaseDirectoryPath => 'Път до папката с база данни';

  @override
  String get import => 'Импорт';

  @override
  String get export => 'Експорт';

  @override
  String get restart => 'Рестартиране';

  @override
  String get restartRelay => 'Рестартиране на релей';

  @override
  String get restartRelayConfirm => 'Сигурни ли сте, че искате да рестартирате релея? Релейът ще бъде временно спрян и след това рестартиран.';

  @override
  String get relayRestartedSuccess => 'Релейът е рестартиран успешно';

  @override
  String relayRestartFailed(String message) {
    return 'Рестартирането на релея не успя: $message';
  }

  @override
  String get databaseClearedSuccess => 'Базата данни е изчистена успешно';

  @override
  String get databaseClearFailed => 'Изчистването на базата данни не успя';

  @override
  String errorWithMessage(String message) {
    return 'Грешка: $message';
  }

  @override
  String get exportDatabase => 'Експорт на база данни';

  @override
  String get exportDatabaseHint => 'Базата данни на релея ще бъде експортирана като ZIP файл. Експортът може да отнеме момент.';

  @override
  String databaseExportedTo(String path) {
    return 'Базата данни е експортирана в: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Базата данни е експортирана като ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Експортът на базата данни не успя';

  @override
  String get importDatabaseReplaceHint => 'Това ще замени текущата база данни с импортирания архив. Съществуващата база ще бъде архивирана преди импорта. Това действие не може да бъде отменено.';

  @override
  String get selectDatabaseBackupFile => 'Изберете архивен файл (ZIP) или папка на базата данни';

  @override
  String get selectDatabaseBackupDir => 'Изберете папка с архив на базата данни';

  @override
  String get fileOrDirNotExist => 'Избраният файл или папка не съществува';

  @override
  String get databaseImportedSuccess => 'Базата данни е импортирана успешно';

  @override
  String get databaseImportFailed => 'Импортът на базата данни не успя';

  @override
  String get status => 'Статус';

  @override
  String get address => 'Адрес';

  @override
  String get protocol => 'Протокол';

  @override
  String get connections => 'Връзки';

  @override
  String get running => 'Работи';

  @override
  String get stopped => 'Спряно';

  @override
  String get addressCopiedToClipboard => 'Адресът е копиран в клипборда';

  @override
  String get exportData => 'Експорт на данни';

  @override
  String get importData => 'Импорт на данни';

  @override
  String get systemLogs => 'Системни дневници';

  @override
  String get clearAllRelayData => 'Изчистване на всички данни на релея';

  @override
  String get noLogsAvailable => 'Няма налични дневници';

  @override
  String get passwordRequired => 'Паролата е задължителна';

  @override
  String encryptionFailed(String message) {
    return 'Криптирането не успя: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Криптираният частен ключ е копиран в клипборда';

  @override
  String get accountBackup => 'Архив на акаунт';

  @override
  String get publicAccountId => 'Публичен идентификатор на акаунт';

  @override
  String get accountPrivateKey => 'Частен ключ на акаунт';

  @override
  String get show => 'Показване';

  @override
  String get generate => 'Генериране';

  @override
  String get enterEncryptionPassword => 'Въведете парола за криптиране';

  @override
  String get privateKeyEncryption => 'Криптиране на частен ключ';

  @override
  String get encryptPrivateKeyHint => 'Криптирайте частния си ключ за повишена сигурност. Ключът ще бъде криптиран с парола.';

  @override
  String get ncryptsecHint => 'Криптираният ключ ще започва с \"ncryptsec1\" и не може да се използва без парола.';

  @override
  String get encryptAndCopyPrivateKey => 'Криптиране и копиране на частен ключ';

  @override
  String get privateKeyEncryptedSuccess => 'Частният ключ е криптиран успешно!';

  @override
  String get encryptedKeyNcryptsec => 'Криптиран ключ (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Създаване на нов акаунт Nostr';

  @override
  String get accountReadyPublicKeyHint => 'Вашият акаунт Nostr е готов! Това е вашият публичен ключ nostr:';

  @override
  String get nostrPubkey => 'Публичен ключ Nostr';

  @override
  String get create => 'Създаване';

  @override
  String get createSuccess => 'Успешно създадено!';

  @override
  String get application => 'Приложение';

  @override
  String get createApplication => 'Създаване на приложение';

  @override
  String get addNewApplication => 'Добавяне на ново приложение';

  @override
  String get addNsecbunkerManually => 'Добавяне на nsecbunker ръчно';

  @override
  String get loginUsingUrlScheme => 'Вход чрез URL схема';

  @override
  String get addApplicationMethodsHint => 'Можете да изберете някой от тези методи за свързване с Aegis!';

  @override
  String get urlSchemeLoginHint => 'Отворете с приложение, поддържащо URL схемата на Aegis за вход';

  @override
  String get name => 'Име';

  @override
  String get applicationInfo => 'Информация за приложението';

  @override
  String get activities => 'Дейности';

  @override
  String get clientPubkey => 'Публичен ключ на клиента';

  @override
  String get remove => 'Премахване';

  @override
  String get removeAppConfirm => 'Сигурни ли сте, че искате да премахнете всички разрешения от това приложение?';

  @override
  String get removeSuccess => 'Успешно премахнато';

  @override
  String get nameCannotBeEmpty => 'Името не може да е празно';

  @override
  String get nameTooLong => 'Името е твърде дълго.';

  @override
  String get updateSuccess => 'Актуализацията е успешна';

  @override
  String get editConfiguration => 'Редактиране на конфигурация';

  @override
  String get update => 'Актуализация';

  @override
  String get search => 'Търсене...';

  @override
  String get enterCustomName => 'Въведете персонализирано име';

  @override
  String get selectApplication => 'Изберете приложение';

  @override
  String get addWebApp => 'Добавяне на уеб приложение';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Моето приложение';

  @override
  String get add => 'Добавяне';

  @override
  String get searchNostrApps => 'Търсене на приложения Nostr...';

  @override
  String get invalidUrlHint => 'Невалиден URL. Въведете валиден HTTP или HTTPS URL.';

  @override
  String get appAlreadyInList => 'Това приложение вече е в списъка.';

  @override
  String appAdded(String name) {
    return '$name е добавено';
  }

  @override
  String appAddFailed(String error) {
    return 'Добавянето на приложението не успя: $error';
  }

  @override
  String get deleteApp => 'Изтриване на приложение';

  @override
  String deleteAppConfirm(String name) {
    return 'Сигурни ли сте, че искате да изтриете \"$name\"?';
  }

  @override
  String get delete => 'Изтриване';

  @override
  String appDeleted(String name) {
    return '$name е изтрито';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Изтриването на приложението не успя: $error';
  }

  @override
  String get copiedToClipboard => 'Копирано в клипборда';

  @override
  String get eventDetails => 'Подробности за събитието';

  @override
  String get eventDetailsCopiedToClipboard => 'Подробностите за събитието са копирани в клипборда';

  @override
  String get rawMetadataCopiedToClipboard => 'Суровите метаданни са копирани в клипборда';

  @override
  String get permissionRequest => 'Заявка за разрешение';

  @override
  String get permissionRequestContent => 'Това приложение иска разрешение за достъп до вашия акаунт Nostr';

  @override
  String get grantPermissions => 'Предоставяне на разрешения';

  @override
  String get reject => 'Отхвърляне';

  @override
  String get fullAccessGranted => 'Пълен достъп е предоставен';

  @override
  String get fullAccessHint => 'Това приложение ще има пълен достъп до вашия акаунт Nostr, включително:';

  @override
  String get permissionAccessPubkey => 'Достъп до вашия публичен ключ Nostr';

  @override
  String get permissionSignEvents => 'Подписване на събития Nostr';

  @override
  String get permissionEncryptDecrypt => 'Криптиране и декриптиране на събития (NIP-04 и NIP-44)';

  @override
  String get tips => 'Съвети';

  @override
  String get schemeLoginFirst => 'Не може да се разреши схемата, първо влезте.';

  @override
  String get newConnectionRequest => 'Нова заявка за връзка';

  @override
  String get newConnectionNoSlotHint => 'Ново приложение се опитва да се свърже, но няма налично свободно приложение. Първо създайте ново приложение.';

  @override
  String get copiedSuccessfully => 'Успешно копирано';

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
  String get noResultsFound => 'Няма намерени резултати';

  @override
  String get pleaseSelectApplication => 'Моля, изберете приложение';

  @override
  String get orEnterCustomName => 'Или въведете собствено име';

  @override
  String get continueButton => 'Продължи';
}
