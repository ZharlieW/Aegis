// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Επιβεβαίωση';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get logout => 'Αποσύνδεση';

  @override
  String get login => 'Σύνδεση';

  @override
  String get usePrivateKey => 'Χρήση ιδιωτικού κλειδιού';

  @override
  String get setupAegisWithNsec => 'Ρυθμίστε το Aegis με το ιδιωτικό κλειδί Nostr σας — υποστηρίζει μορφές nsec, ncryptsec και hex.';

  @override
  String get privateKey => 'Ιδιωτικό κλειδί';

  @override
  String get privateKeyHint => 'Κλειδί nsec / ncryptsec / hex';

  @override
  String get password => 'Κωδικός πρόσβασης';

  @override
  String get passwordHint => 'Εισάγετε κωδικό για αποκρυπτογράφηση ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Το περιεχόμενο δεν μπορεί να είναι κενό!';

  @override
  String get passwordRequiredForNcryptsec => 'Απαιτείται κωδικός για το ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Αποτυχία αποκρυπτογράφησης ncryptsec. Ελέγξτε τον κωδικό σας.';

  @override
  String get invalidPrivateKeyFormat => 'Μη έγκυρη μορφή ιδιωτικού κλειδιού!';

  @override
  String get loginSuccess => 'Επιτυχής σύνδεση!';

  @override
  String loginFailed(String message) {
    return 'Αποτυχία σύνδεσης: $message';
  }

  @override
  String get typeConfirmToProceed => 'Πληκτρολογήστε \"confirm\" για συνέχεια';

  @override
  String get logoutConfirm => 'Είστε σίγουροι ότι θέλετε να αποσυνδεθείτε;';

  @override
  String get notLoggedIn => 'Δεν έχετε συνδεθεί';

  @override
  String get language => 'Γλώσσα';

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
  String get addAccount => 'Προσθήκη λογαριασμού';

  @override
  String get updateSuccessful => 'Επιτυχής ενημέρωση!';

  @override
  String get switchAccount => 'Αλλαγή λογαριασμού';

  @override
  String get switchAccountConfirm => 'Είστε σίγουροι ότι θέλετε να αλλάξετε λογαριασμό;';

  @override
  String get switchSuccessfully => 'Επιτυχής αλλαγή!';

  @override
  String get renameAccount => 'Μετονομασία λογαριασμού';

  @override
  String get accountName => 'Όνομα λογαριασμού';

  @override
  String get enterNewName => 'Εισάγετε νέο όνομα';

  @override
  String get accounts => 'Λογαριασμοί';

  @override
  String get localRelay => 'Τοπικό relay';

  @override
  String get remote => 'Απομακρυσμένο';

  @override
  String get browser => 'Πρόγραμμα περιήγησης';

  @override
  String get theme => 'Θέμα';

  @override
  String get github => 'Github';

  @override
  String get version => 'Έκδοση';

  @override
  String get appSubtitle => 'Aegis — Υπογράφων Nostr';

  @override
  String get darkMode => 'Σκοτεινή λειτουργία';

  @override
  String get lightMode => 'Φωτεινή λειτουργία';

  @override
  String get systemDefault => 'Προεπιλογή συστήματος';

  @override
  String switchedTo(String mode) {
    return 'Αλλαγή σε $mode';
  }

  @override
  String get home => 'Αρχική';

  @override
  String get waitingForRelayStart => 'Αναμονή εκκίνησης relay...';

  @override
  String get connected => 'Συνδεδεμένο';

  @override
  String get disconnected => 'Αποσυνδεδεμένο';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Σφάλμα φόρτωσης εφαρμογών NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Δεν υπάρχουν ακόμα εφαρμογές NIP-07.\n\nΧρησιμοποιήστε το πρόγραμμα περιήγησης για πρόσβαση σε εφαρμογές Nostr!';

  @override
  String get unknown => 'Άγνωστο';

  @override
  String get active => 'Ενεργό';

  @override
  String get congratulationsEmptyState => 'Συγχαρητήρια!\n\nΤώρα μπορείτε να χρησιμοποιήσετε εφαρμογές που υποστηρίζουν το Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'Το τοπικό relay χρησιμοποιεί θύρα $port, αλλά φαίνεται ότι άλλη εφαρμογή την χρησιμοποιεί. Κλείστε την αντίθετη εφαρμογή και δοκιμάστε ξανά.';
  }

  @override
  String get nip46Started => 'Ο υπογράφων NIP-46 ξεκίνησε!';

  @override
  String get nip46FailedToStart => 'Αποτυχία εκκίνησης.';

  @override
  String get retry => 'Επανάληψη';

  @override
  String get clear => 'Εκκαθάριση';

  @override
  String get clearDatabase => 'Εκκαθάριση βάσης δεδομένων';

  @override
  String get clearDatabaseConfirm => 'Θα διαγραφούν όλα τα δεδομένα relay και θα γίνει επανεκκίνηση αν τρέχει. Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get importDatabase => 'Εισαγωγή βάσης δεδομένων';

  @override
  String get importDatabaseHint => 'Εισάγετε τη διαδρομή του φακέλου βάσης δεδομένων για εισαγωγή. Η υπάρχουσα βάση θα δημιουργηθεί αντίγραφο πριν την εισαγωγή.';

  @override
  String get databaseDirectoryPath => 'Διαδρομή φακέλου βάσης δεδομένων';

  @override
  String get import => 'Εισαγωγή';

  @override
  String get export => 'Εξαγωγή';

  @override
  String get restart => 'Επανεκκίνηση';

  @override
  String get restartRelay => 'Επανεκκίνηση relay';

  @override
  String get restartRelayConfirm => 'Είστε σίγουροι ότι θέλετε να επανεκκινήσετε το relay; Θα σταματήσει προσωρινά και μετά θα ξαναρχίσει.';

  @override
  String get relayRestartedSuccess => 'Το relay επανεκκινήθηκε';

  @override
  String relayRestartFailed(String message) {
    return 'Αποτυχία επανεκκίνησης relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Η βάση δεδομένων εκκαθαρίστηκε';

  @override
  String get databaseClearFailed => 'Αποτυχία εκκαθάρισης βάσης δεδομένων';

  @override
  String errorWithMessage(String message) {
    return 'Σφάλμα: $message';
  }

  @override
  String get exportDatabase => 'Εξαγωγή βάσης δεδομένων';

  @override
  String get exportDatabaseHint => 'Η βάση δεδομένων relay θα εξαχθεί ως αρχείο ZIP. Η εξαγωγή μπορεί να πάρει λίγο.';

  @override
  String databaseExportedTo(String path) {
    return 'Βάση δεδομένων εξαχθεί σε: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Βάση δεδομένων εξαχθεί ως ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Αποτυχία εξαγωγής βάσης δεδομένων';

  @override
  String get importDatabaseReplaceHint => 'Θα αντικατασταθεί η τρέχουσα βάση με το εισαγόμενο αντίγραφο. Η υπάρχουσα βάση θα δημιουργηθεί αντίγραφο πριν την εισαγωγή. Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get selectDatabaseBackupFile => 'Επιλέξτε αρχείο αντίγραφου (ZIP) ή φάκελο';

  @override
  String get selectDatabaseBackupDir => 'Επιλέξτε φάκελο αντίγραφου βάσης δεδομένων';

  @override
  String get fileOrDirNotExist => 'Το επιλεγμένο αρχείο ή φάκελος δεν υπάρχει';

  @override
  String get databaseImportedSuccess => 'Η βάση δεδομένων εισήχθη';

  @override
  String get databaseImportFailed => 'Αποτυχία εισαγωγής βάσης δεδομένων';

  @override
  String get status => 'Κατάσταση';

  @override
  String get address => 'Διεύθυνση';

  @override
  String get protocol => 'Πρωτόκολλο';

  @override
  String get connections => 'Συνδέσεις';

  @override
  String get running => 'Εκτελείται';

  @override
  String get stopped => 'Σταματημένο';

  @override
  String get addressCopiedToClipboard => 'Η διεύθυνση αντιγράφηκε';

  @override
  String get exportData => 'Εξαγωγή δεδομένων';

  @override
  String get importData => 'Εισαγωγή δεδομένων';

  @override
  String get systemLogs => 'Αρχεία καταγραφής συστήματος';

  @override
  String get clearAllRelayData => 'Εκκαθάριση όλων των δεδομένων relay';

  @override
  String get noLogsAvailable => 'Δεν υπάρχουν αρχεία καταγραφής';

  @override
  String get passwordRequired => 'Απαιτείται κωδικός';

  @override
  String encryptionFailed(String message) {
    return 'Αποτυχία κρυπτογράφησης: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Το κρυπτογραφημένο ιδιωτικό κλειδί αντιγράφηκε';

  @override
  String get accountBackup => 'Αντίγραφο ασφαλείας λογαριασμού';

  @override
  String get publicAccountId => 'Δημόσιο ID λογαριασμού';

  @override
  String get accountPrivateKey => 'Ιδιωτικό κλειδί λογαριασμού';

  @override
  String get show => 'Εμφάνιση';

  @override
  String get generate => 'Δημιουργία';

  @override
  String get enterEncryptionPassword => 'Εισάγετε κωδικό κρυπτογράφησης';

  @override
  String get privateKeyEncryption => 'Κρυπτογράφηση ιδιωτικού κλειδιού';

  @override
  String get encryptPrivateKeyHint => 'Κρυπτογραφήστε το ιδιωτικό σας κλειδί για ασφάλεια. Το κλειδί θα κρυπτογραφηθεί με κωδικό.';

  @override
  String get ncryptsecHint => 'Το κρυπτογραφημένο κλειδί θα ξεκινά με \"ncryptsec1\" και δεν μπορεί να χρησιμοποιηθεί χωρίς κωδικό.';

  @override
  String get encryptAndCopyPrivateKey => 'Κρυπτογράφηση και αντιγραφή ιδιωτικού κλειδιού';

  @override
  String get privateKeyEncryptedSuccess => 'Το ιδιωτικό κλειδί κρυπτογραφήθηκε!';

  @override
  String get encryptedKeyNcryptsec => 'Κρυπτογραφημένο κλειδί (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Δημιουργία νέου λογαριασμού Nostr';

  @override
  String get accountReadyPublicKeyHint => 'Ο λογαριασμός Nostr σας είναι έτοιμος! Αυτό είναι το δημόσιο κλειδί nostr σας:';

  @override
  String get nostrPubkey => 'Δημόσιο κλειδί Nostr';

  @override
  String get create => 'Δημιουργία';

  @override
  String get createSuccess => 'Δημιουργήθηκε!';

  @override
  String get application => 'Εφαρμογή';

  @override
  String get createApplication => 'Δημιουργία εφαρμογής';

  @override
  String get addNewApplication => 'Προσθήκη νέας εφαρμογής';

  @override
  String get addNsecbunkerManually => 'Προσθήκη nsecbunker χειροκίνητα';

  @override
  String get loginUsingUrlScheme => 'Σύνδεση με σχήμα URL';

  @override
  String get addApplicationMethodsHint => 'Μπορείτε να επιλέξετε οποιαδήποτε από αυτές τις μεθόδους για σύνδεση με το Aegis!';

  @override
  String get urlSchemeLoginHint => 'Ανοίξτε με εφαρμογή που υποστηρίζει σχήμα URL Aegis για σύνδεση';

  @override
  String get name => 'Όνομα';

  @override
  String get applicationInfo => 'Πληροφορίες εφαρμογής';

  @override
  String get activities => 'Δραστηριότητες';

  @override
  String get clientPubkey => 'Δημόσιο κλειδί πελάτη';

  @override
  String get remove => 'Αφαίρεση';

  @override
  String get removeAppConfirm => 'Είστε σίγουροι ότι θέλετε να αφαιρέσετε όλα τα δικαιώματα από αυτή την εφαρμογή;';

  @override
  String get removeSuccess => 'Αφαιρέθηκε';

  @override
  String get nameCannotBeEmpty => 'Το όνομα δεν μπορεί να είναι κενό';

  @override
  String get nameTooLong => 'Το όνομα είναι πολύ μεγάλο.';

  @override
  String get updateSuccess => 'Επιτυχής ενημέρωση';

  @override
  String get editConfiguration => 'Επεξεργασία ρυθμίσεων';

  @override
  String get update => 'Ενημέρωση';

  @override
  String get search => 'Αναζήτηση...';

  @override
  String get enterCustomName => 'Εισάγετε προσαρμοσμένο όνομα';

  @override
  String get selectApplication => 'Επιλέξτε εφαρμογή';

  @override
  String get addWebApp => 'Προσθήκη εφαρμογής ιστού';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Η εφαρμογή μου';

  @override
  String get add => 'Προσθήκη';

  @override
  String get searchNostrApps => 'Αναζήτηση εφαρμογών Nostr...';

  @override
  String get invalidUrlHint => 'Μη έγκυρη URL. Εισάγετε έγκυρη HTTP ή HTTPS URL.';

  @override
  String get appAlreadyInList => 'Αυτή η εφαρμογή είναι ήδη στη λίστα.';

  @override
  String appAdded(String name) {
    return 'Προστέθηκε το $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Αποτυχία προσθήκης εφαρμογής: $error';
  }

  @override
  String get deleteApp => 'Διαγραφή εφαρμογής';

  @override
  String deleteAppConfirm(String name) {
    return 'Είστε σίγουροι ότι θέλετε να διαγράψετε το \"$name\";';
  }

  @override
  String get delete => 'Διαγραφή';

  @override
  String appDeleted(String name) {
    return 'Διαγράφηκε το $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Αποτυχία διαγραφής εφαρμογής: $error';
  }

  @override
  String get copiedToClipboard => 'Αντιγράφηκε';

  @override
  String get eventDetails => 'Λεπτομέρειες συμβάντος';

  @override
  String get eventDetailsCopiedToClipboard => 'Οι λεπτομέρειες συμβάντος αντιγράφηκαν';

  @override
  String get rawMetadataCopiedToClipboard => 'Τα ακατέργαστα μεταδεδομένα αντιγράφηκαν';

  @override
  String get permissionRequest => 'Αίτηση δικαιώματος';

  @override
  String get permissionRequestContent => 'Αυτή η εφαρμογή ζητά δικαιώματα πρόσβασης στον λογαριασμό Nostr σας';

  @override
  String get grantPermissions => 'Χορήγηση δικαιωμάτων';

  @override
  String get reject => 'Απόρριψη';

  @override
  String get fullAccessGranted => 'Πλήρης πρόσβαση παραχωρήθηκε';

  @override
  String get fullAccessHint => 'Αυτή η εφαρμογή θα έχει πλήρη πρόσβαση στον λογαριασμό Nostr σας, συμπεριλαμβανομένων:';

  @override
  String get permissionAccessPubkey => 'Πρόσβαση στο δημόσιο κλειδί Nostr σας';

  @override
  String get permissionSignEvents => 'Υπογραφή συμβάντων Nostr';

  @override
  String get permissionEncryptDecrypt => 'Κρυπτογράφηση και αποκρυπτογράφηση συμβάντων (NIP-04 και NIP-44)';

  @override
  String get tips => 'Συμβουλές';

  @override
  String get schemeLoginFirst => 'Δεν μπορεί να επιλυθεί το σχήμα, συνδεθείτε πρώτα.';

  @override
  String get newConnectionRequest => 'Νέο αίτημα σύνδεσης';

  @override
  String get newConnectionNoSlotHint => 'Μια νέα εφαρμογή προσπαθεί να συνδεθεί, αλλά δεν υπάρχει διαθέσιμη εφαρμογή. Δημιουργήστε πρώτα νέα εφαρμογή.';

  @override
  String get copiedSuccessfully => 'Αντιγράφηκε επιτυχώς';

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
  String get noResultsFound => 'Δεν βρέθηκαν αποτελέσματα';

  @override
  String get pleaseSelectApplication => 'Επιλέξτε μια εφαρμογή';

  @override
  String get orEnterCustomName => 'Ή εισάγετε προσαρμοσμένο όνομα';

  @override
  String get continueButton => 'Συνέχεια';
}
