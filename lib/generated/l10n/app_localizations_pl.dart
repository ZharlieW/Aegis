// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get cancel => 'Anuluj';

  @override
  String get settings => 'Ustawienia';

  @override
  String get logout => 'Wyloguj';

  @override
  String get login => 'Zaloguj';

  @override
  String get usePrivateKey => 'Użyj klucza prywatnego';

  @override
  String get setupAegisWithNsec => 'Skonfiguruj Aegis kluczem Nostr — obsługuje formaty nsec, ncryptsec i hex.';

  @override
  String get privateKey => 'Klucz prywatny';

  @override
  String get privateKeyHint => 'Klucz nsec / ncryptsec / hex';

  @override
  String get password => 'Hasło';

  @override
  String get passwordHint => 'Wprowadź hasło, aby odszyfrować ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Treść nie może być pusta!';

  @override
  String get passwordRequiredForNcryptsec => 'Hasło jest wymagane dla ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Nie udało się odszyfrować ncryptsec. Sprawdź hasło.';

  @override
  String get invalidPrivateKeyFormat => 'Nieprawidłowy format klucza prywatnego!';

  @override
  String get loginSuccess => 'Zalogowano pomyślnie!';

  @override
  String loginFailed(String message) {
    return 'Logowanie nie powiodło się: $message';
  }

  @override
  String get typeConfirmToProceed => 'Wpisz \"confirm\", aby kontynuować';

  @override
  String get logoutConfirm => 'Czy na pewno chcesz się wylogować?';

  @override
  String get notLoggedIn => 'Nie zalogowano';

  @override
  String get language => 'Język';

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
  String get addAccount => 'Dodaj konto';

  @override
  String get updateSuccessful => 'Aktualizacja powiodła się!';

  @override
  String get switchAccount => 'Przełącz konto';

  @override
  String get switchAccountConfirm => 'Czy na pewno chcesz przełączyć konto?';

  @override
  String get switchSuccessfully => 'Przełączono pomyślnie!';

  @override
  String get renameAccount => 'Zmień nazwę konta';

  @override
  String get accountName => 'Nazwa konta';

  @override
  String get enterNewName => 'Wprowadź nową nazwę';

  @override
  String get accounts => 'Konta';

  @override
  String get localRelay => 'Relay lokalny';

  @override
  String get remote => 'Zdalny';

  @override
  String get browser => 'Przeglądarka';

  @override
  String get theme => 'Motyw';

  @override
  String get github => 'Github';

  @override
  String get version => 'Wersja';

  @override
  String get appSubtitle => 'Aegis — Podpis Nostr';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get lightMode => 'Tryb jasny';

  @override
  String get systemDefault => 'Domyślny systemowy';

  @override
  String switchedTo(String mode) {
    return 'Przełączono na $mode';
  }

  @override
  String get home => 'Strona główna';

  @override
  String get waitingForRelayStart => 'Oczekiwanie na uruchomienie relay...';

  @override
  String get connected => 'Połączono';

  @override
  String get disconnected => 'Rozłączono';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Błąd ładowania aplikacji NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Brak aplikacji NIP-07.\n\nUżyj przeglądarki, aby uzyskać dostęp do aplikacji Nostr!';

  @override
  String get unknown => 'Nieznany';

  @override
  String get active => 'Aktywny';

  @override
  String get congratulationsEmptyState => 'Gratulacje!\n\nMożesz teraz korzystać z aplikacji obsługujących Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Relay lokalny jest ustawiony na port $port, ale wygląda na to, że inna aplikacja go już używa. Zamknij konfliktującą aplikację i spróbuj ponownie.';
  }

  @override
  String get nip46Started => 'Podpis NIP-46 uruchomiony!';

  @override
  String get nip46FailedToStart => 'Uruchomienie nie powiodło się.';

  @override
  String get retry => 'Ponów';

  @override
  String get clear => 'Wyczyść';

  @override
  String get clearDatabase => 'Wyczyść bazę danych';

  @override
  String get clearDatabaseConfirm => 'Spowoduje to usunięcie wszystkich danych relay i ponowne uruchomienie relay, jeśli działa. Tej operacji nie można cofnąć.';

  @override
  String get importDatabase => 'Importuj bazę danych';

  @override
  String get importDatabaseHint => 'Wprowadź ścieżkę do katalogu bazy danych do importu. Istniejąca baza zostanie utworzona w kopii zapasowej przed importem.';

  @override
  String get databaseDirectoryPath => 'Ścieżka katalogu bazy danych';

  @override
  String get import => 'Importuj';

  @override
  String get export => 'Eksportuj';

  @override
  String get restart => 'Uruchom ponownie';

  @override
  String get restartRelay => 'Uruchom ponownie relay';

  @override
  String get restartRelayConfirm => 'Czy na pewno chcesz ponownie uruchomić relay? Relay zostanie tymczasowo zatrzymany, a następnie uruchomiony.';

  @override
  String get relayRestartedSuccess => 'Relay uruchomiony ponownie pomyślnie';

  @override
  String relayRestartFailed(String message) {
    return 'Nie udało się ponownie uruchomić relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Baza danych wyczyszczona pomyślnie';

  @override
  String get databaseClearFailed => 'Nie udało się wyczyścić bazy danych';

  @override
  String errorWithMessage(String message) {
    return 'Błąd: $message';
  }

  @override
  String get exportDatabase => 'Eksportuj bazę danych';

  @override
  String get exportDatabaseHint => 'Baza danych relay zostanie wyeksportowana jako plik ZIP. Eksport może chwilę potrwać.';

  @override
  String databaseExportedTo(String path) {
    return 'Baza danych wyeksportowana do: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Baza danych wyeksportowana jako ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Nie udało się wyeksportować bazy danych';

  @override
  String get importDatabaseReplaceHint => 'Spowoduje to zastąpienie bieżącej bazy danych zaimportowaną kopią. Istniejąca baza zostanie utworzona w kopii zapasowej przed importem. Tej operacji nie można cofnąć.';

  @override
  String get selectDatabaseBackupFile => 'Wybierz plik kopii zapasowej (ZIP) lub katalog';

  @override
  String get selectDatabaseBackupDir => 'Wybierz katalog kopii zapasowej bazy danych';

  @override
  String get fileOrDirNotExist => 'Wybrany plik lub katalog nie istnieje';

  @override
  String get databaseImportedSuccess => 'Baza danych zaimportowana pomyślnie';

  @override
  String get databaseImportFailed => 'Nie udało się zaimportować bazy danych';

  @override
  String get status => 'Status';

  @override
  String get address => 'Adres';

  @override
  String get protocol => 'Protokół';

  @override
  String get connections => 'Połączenia';

  @override
  String get running => 'Działa';

  @override
  String get stopped => 'Zatrzymany';

  @override
  String get addressCopiedToClipboard => 'Adres skopiowany do schowka';

  @override
  String get exportData => 'Eksportuj dane';

  @override
  String get importData => 'Importuj dane';

  @override
  String get systemLogs => 'Logi systemowe';

  @override
  String get clearAllRelayData => 'Wyczyść wszystkie dane relay';

  @override
  String get noLogsAvailable => 'Brak dostępnych logów';

  @override
  String get passwordRequired => 'Wymagane hasło';

  @override
  String encryptionFailed(String message) {
    return 'Szyfrowanie nie powiodło się: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Zaszyfrowany klucz prywatny skopiowany do schowka';

  @override
  String get accountBackup => 'Kopia zapasowa konta';

  @override
  String get publicAccountId => 'Publiczny identyfikator konta';

  @override
  String get accountPrivateKey => 'Klucz prywatny konta';

  @override
  String get show => 'Pokaż';

  @override
  String get generate => 'Generuj';

  @override
  String get enterEncryptionPassword => 'Wprowadź hasło szyfrowania';

  @override
  String get privateKeyEncryption => 'Szyfrowanie klucza prywatnego';

  @override
  String get encryptPrivateKeyHint => 'Zaszyfruj klucz prywatny, aby zwiększyć bezpieczeństwo. Klucz zostanie zaszyfrowany hasłem.';

  @override
  String get ncryptsecHint => 'Zaszyfrowany klucz będzie zaczynał się od \"ncryptsec1\" i nie może być użyty bez hasła.';

  @override
  String get encryptAndCopyPrivateKey => 'Zaszyfruj i skopiuj klucz prywatny';

  @override
  String get privateKeyEncryptedSuccess => 'Klucz prywatny zaszyfrowany pomyślnie!';

  @override
  String get encryptedKeyNcryptsec => 'Klucz zaszyfrowany (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Utwórz nowe konto Nostr';

  @override
  String get accountReadyPublicKeyHint => 'Twoje konto Nostr jest gotowe! To jest Twój publiczny klucz nostr:';

  @override
  String get nostrPubkey => 'Klucz publiczny Nostr';

  @override
  String get create => 'Utwórz';

  @override
  String get createSuccess => 'Utworzono pomyślnie!';

  @override
  String get application => 'Aplikacja';

  @override
  String get createApplication => 'Utwórz aplikację';

  @override
  String get addNewApplication => 'Dodaj nową aplikację';

  @override
  String get addNsecbunkerManually => 'Dodaj nsecbunker ręcznie';

  @override
  String get loginUsingUrlScheme => 'Zaloguj przez schemat URL';

  @override
  String get addApplicationMethodsHint => 'Możesz wybrać jedną z tych metod, aby połączyć się z Aegis!';

  @override
  String get urlSchemeLoginHint => 'Otwórz w aplikacji obsługującej schemat URL Aegis, aby się zalogować';

  @override
  String get name => 'Nazwa';

  @override
  String get applicationInfo => 'Informacje o aplikacji';

  @override
  String get activities => 'Aktywności';

  @override
  String get clientPubkey => 'Klucz publiczny klienta';

  @override
  String get remove => 'Usuń';

  @override
  String get removeAppConfirm => 'Czy na pewno chcesz usunąć wszystkie uprawnienia tej aplikacji?';

  @override
  String get removeSuccess => 'Usunięto pomyślnie';

  @override
  String get nameCannotBeEmpty => 'Nazwa nie może być pusta';

  @override
  String get nameTooLong => 'Nazwa jest zbyt długa.';

  @override
  String get updateSuccess => 'Aktualizacja powiodła się';

  @override
  String get editConfiguration => 'Edytuj konfigurację';

  @override
  String get update => 'Aktualizuj';

  @override
  String get search => 'Szukaj...';

  @override
  String get enterCustomName => 'Wprowadź niestandardową nazwę';

  @override
  String get selectApplication => 'Wybierz aplikację';

  @override
  String get addWebApp => 'Dodaj aplikację webową';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Moja aplikacja';

  @override
  String get add => 'Dodaj';

  @override
  String get searchNostrApps => 'Szukaj aplikacji Nostr...';

  @override
  String get invalidUrlHint => 'Nieprawidłowy adres URL. Wprowadź prawidłowy adres HTTP lub HTTPS.';

  @override
  String get appAlreadyInList => 'Ta aplikacja jest już na liście.';

  @override
  String appAdded(String name) {
    return 'Dodano $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Nie udało się dodać aplikacji: $error';
  }

  @override
  String get deleteApp => 'Usuń aplikację';

  @override
  String deleteAppConfirm(String name) {
    return 'Czy na pewno chcesz usunąć \"$name\"?';
  }

  @override
  String get delete => 'Usuń';

  @override
  String appDeleted(String name) {
    return 'Usunięto $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Nie udało się usunąć aplikacji: $error';
  }

  @override
  String get copiedToClipboard => 'Skopiowano do schowka';

  @override
  String get eventDetails => 'Szczegóły zdarzenia';

  @override
  String get eventDetailsCopiedToClipboard => 'Szczegóły zdarzenia skopiowane do schowka';

  @override
  String get rawMetadataCopiedToClipboard => 'Surowe metadane skopiowane do schowka';

  @override
  String get permissionRequest => 'Żądanie uprawnień';

  @override
  String get permissionRequestContent => 'Ta aplikacja prosi o uprawnienia do Twojego konta Nostr';

  @override
  String get grantPermissions => 'Przyznaj uprawnienia';

  @override
  String get reject => 'Odrzuć';

  @override
  String get fullAccessGranted => 'Przyznano pełny dostęp';

  @override
  String get fullAccessHint => 'Ta aplikacja będzie miała pełny dostęp do Twojego konta Nostr, w tym:';

  @override
  String get permissionAccessPubkey => 'Dostęp do publicznego klucza Nostr';

  @override
  String get permissionSignEvents => 'Podpisywanie zdarzeń Nostr';

  @override
  String get permissionEncryptDecrypt => 'Szyfrowanie i odszyfrowywanie zdarzeń (NIP-04 i NIP-44)';

  @override
  String get tips => 'Wskazówki';

  @override
  String get schemeLoginFirst => 'Nie można rozwiązać schematu, zaloguj się najpierw.';

  @override
  String get newConnectionRequest => 'Nowe żądanie połączenia';

  @override
  String get newConnectionNoSlotHint => 'Nowa aplikacja próbuje się połączyć, ale nie ma dostępnej wolnej aplikacji. Najpierw utwórz nową aplikację.';

  @override
  String get copiedSuccessfully => 'Skopiowano pomyślnie';

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
  String get noResultsFound => 'Nie znaleziono wyników';

  @override
  String get pleaseSelectApplication => 'Wybierz aplikację';

  @override
  String get orEnterCustomName => 'Lub wprowadź niestandardową nazwę';

  @override
  String get continueButton => 'Kontynuuj';
}
