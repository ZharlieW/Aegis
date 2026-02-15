// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Confirmer';

  @override
  String get cancel => 'Annuler';

  @override
  String get settings => 'Paramètres';

  @override
  String get logout => 'Déconnexion';

  @override
  String get login => 'Connexion';

  @override
  String get usePrivateKey => 'Utiliser votre clé privée';

  @override
  String get setupAegisWithNsec => 'Configurez Aegis avec votre clé privée Nostr — prend en charge nsec, ncryptsec et hex.';

  @override
  String get privateKey => 'Clé privée';

  @override
  String get privateKeyHint => 'Clé nsec / ncryptsec / hex';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHint => 'Entrez le mot de passe pour déchiffrer ncryptsec';

  @override
  String get contentCannotBeEmpty => 'Le contenu ne peut pas être vide !';

  @override
  String get passwordRequiredForNcryptsec => 'Un mot de passe est requis pour ncryptsec !';

  @override
  String get decryptNcryptsecFailed => 'Échec du déchiffrement de ncryptsec. Vérifiez votre mot de passe.';

  @override
  String get invalidPrivateKeyFormat => 'Format de clé privée invalide !';

  @override
  String get loginSuccess => 'Connexion réussie !';

  @override
  String loginFailed(String message) {
    return 'Échec de la connexion : $message';
  }

  @override
  String get typeConfirmToProceed => 'Tapez « confirm » pour continuer';

  @override
  String get logoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get notLoggedIn => 'Non connecté';

  @override
  String get language => 'Langue';

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
  String get addAccount => 'Ajouter un compte';

  @override
  String get updateSuccessful => 'Mise à jour réussie !';

  @override
  String get switchAccount => 'Changer de compte';

  @override
  String get switchAccountConfirm => 'Voulez-vous vraiment changer de compte ?';

  @override
  String get switchSuccessfully => 'Changement réussi !';

  @override
  String get renameAccount => 'Renommer le compte';

  @override
  String get accountName => 'Nom du compte';

  @override
  String get enterNewName => 'Entrez le nouveau nom';

  @override
  String get accounts => 'Comptes';

  @override
  String get localRelay => 'Relais local';

  @override
  String get remote => 'Distant';

  @override
  String get browser => 'Navigateur';

  @override
  String get theme => 'Thème';

  @override
  String get github => 'Github';

  @override
  String get version => 'Version';

  @override
  String get appSubtitle => 'Aegis - Signataire Nostr';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String switchedTo(String mode) {
    return 'Passé à $mode';
  }

  @override
  String get home => 'Accueil';

  @override
  String get waitingForRelayStart => 'En attente du démarrage du relais...';

  @override
  String get connected => 'Connecté';

  @override
  String get disconnected => 'Déconnecté';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Erreur lors du chargement des applications NIP-07 : $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Aucune application NIP-07 pour le moment.\n\nUtilisez le navigateur pour accéder aux applications Nostr !';

  @override
  String get unknown => 'Inconnu';

  @override
  String get active => 'Actif';

  @override
  String get congratulationsEmptyState => 'Félicitations !\n\nVous pouvez maintenant utiliser les applications compatibles Aegis !';

  @override
  String localRelayPortInUse(String port) {
    return 'Le relais local est configuré sur le port $port, mais une autre application semble l\'utiliser. Fermez l\'application conflictuelle et réessayez.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => 'Signataire NIP-46 démarré !';

  @override
  String get nip46FailedToStart => 'Échec du démarrage.';

  @override
  String get retry => 'Réessayer';

  @override
  String get clear => 'Effacer';

  @override
  String get clearDatabase => 'Effacer la base de données';

  @override
  String get clearDatabaseConfirm => 'Toutes les données du relais seront supprimées et le relais redémarré s\'il est en cours. Cette action est irréversible.';

  @override
  String get importDatabase => 'Importer la base de données';

  @override
  String get importDatabaseHint => 'Entrez le chemin du répertoire de la base de données à importer. La base existante sera sauvegardée avant l\'import.';

  @override
  String get databaseDirectoryPath => 'Chemin du répertoire de la base de données';

  @override
  String get import => 'Importer';

  @override
  String get export => 'Exporter';

  @override
  String get restart => 'Redémarrer';

  @override
  String get restartRelay => 'Redémarrer le relais';

  @override
  String get restartRelayConfirm => 'Voulez-vous vraiment redémarrer le relais ? Il sera temporairement arrêté puis redémarré.';

  @override
  String get relayRestartedSuccess => 'Relais redémarré avec succès';

  @override
  String relayRestartFailed(String message) {
    return 'Échec du redémarrage du relais : $message';
  }

  @override
  String get databaseClearedSuccess => 'Base de données effacée avec succès';

  @override
  String get databaseClearFailed => 'Échec de l\'effacement de la base de données';

  @override
  String errorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get exportDatabase => 'Exporter la base de données';

  @override
  String get exportDatabaseHint => 'La base de données du relais sera exportée en fichier ZIP. L\'export peut prendre un moment.';

  @override
  String databaseExportedTo(String path) {
    return 'Base de données exportée vers : $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Base de données exportée en ZIP : $path';
  }

  @override
  String get databaseExportFailed => 'Échec de l\'export de la base de données';

  @override
  String get importDatabaseReplaceHint => 'La base actuelle sera remplacée par la sauvegarde importée. La base existante sera sauvegardée avant. Cette action est irréversible.';

  @override
  String get selectDatabaseBackupFile => 'Sélectionner le fichier (ZIP) ou le répertoire de sauvegarde';

  @override
  String get selectDatabaseBackupDir => 'Sélectionner le répertoire de sauvegarde';

  @override
  String get fileOrDirNotExist => 'Le fichier ou répertoire sélectionné n\'existe pas';

  @override
  String get databaseImportedSuccess => 'Base de données importée avec succès';

  @override
  String get databaseImportFailed => 'Échec de l\'import de la base de données';

  @override
  String get status => 'État';

  @override
  String get address => 'Adresse';

  @override
  String get protocol => 'Protocole';

  @override
  String get connections => 'Connexions';

  @override
  String get running => 'En cours';

  @override
  String get stopped => 'Arrêté';

  @override
  String get addressCopiedToClipboard => 'Adresse copiée dans le presse-papiers';

  @override
  String get exportData => 'Exporter les données';

  @override
  String get importData => 'Importer les données';

  @override
  String get systemLogs => 'Journaux système';

  @override
  String get clearAllRelayData => 'Effacer toutes les données du relais';

  @override
  String get noLogsAvailable => 'Aucun journal disponible';

  @override
  String get passwordRequired => 'Un mot de passe est requis';

  @override
  String encryptionFailed(String message) {
    return 'Échec du chiffrement : $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Clé privée chiffrée copiée dans le presse-papiers';

  @override
  String get accountBackup => 'Sauvegarde du compte';

  @override
  String get publicAccountId => 'ID public du compte';

  @override
  String get accountPrivateKey => 'Clé privée du compte';

  @override
  String get show => 'Afficher';

  @override
  String get generate => 'Générer';

  @override
  String get enterEncryptionPassword => 'Entrez le mot de passe de chiffrement';

  @override
  String get privateKeyEncryption => 'Chiffrement de la clé privée';

  @override
  String get encryptPrivateKeyHint => 'Chiffrez votre clé privée pour plus de sécurité. Elle sera chiffrée avec un mot de passe.';

  @override
  String get ncryptsecHint => 'La clé chiffrée commencera par « ncryptsec1 » et ne pourra pas être utilisée sans le mot de passe.';

  @override
  String get encryptAndCopyPrivateKey => 'Chiffrer et copier la clé privée';

  @override
  String get privateKeyEncryptedSuccess => 'Clé privée chiffrée avec succès !';

  @override
  String get encryptedKeyNcryptsec => 'Clé chiffrée (ncryptsec) :';

  @override
  String get createNewNostrAccount => 'Créer un nouveau compte Nostr';

  @override
  String get accountReadyPublicKeyHint => 'Votre compte Nostr est prêt ! Voici votre clé publique nostr :';

  @override
  String get nostrPubkey => 'Clé publique Nostr';

  @override
  String get create => 'Créer';

  @override
  String get createSuccess => 'Création réussie !';

  @override
  String get application => 'Application';

  @override
  String get createApplication => 'Créer une application';

  @override
  String get addNewApplication => 'Ajouter une nouvelle application';

  @override
  String get addNsecbunkerManually => 'Ajouter un nsecbunker manuellement';

  @override
  String get loginUsingUrlScheme => 'Se connecter via URL Scheme';

  @override
  String get addApplicationMethodsHint => 'Vous pouvez choisir l\'une de ces méthodes pour vous connecter à Aegis !';

  @override
  String get urlSchemeLoginHint => 'Ouvrez avec une application prenant en charge le schéma d\'URL Aegis pour vous connecter.';

  @override
  String get name => 'Nom';

  @override
  String get applicationInfo => 'Informations sur l\'application';

  @override
  String get activities => 'Activités';

  @override
  String get clientPubkey => 'Clé publique du client';

  @override
  String get remove => 'Supprimer';

  @override
  String get removeAppConfirm => 'Voulez-vous vraiment supprimer toutes les autorisations de cette application ?';

  @override
  String get removeSuccess => 'Suppression réussie';

  @override
  String get nameCannotBeEmpty => 'Le nom ne peut pas être vide';

  @override
  String get nameTooLong => 'Le nom est trop long.';

  @override
  String get updateSuccess => 'Mise à jour réussie';

  @override
  String get editConfiguration => 'Modifier la configuration';

  @override
  String get update => 'Mettre à jour';

  @override
  String get search => 'Rechercher...';

  @override
  String get enterCustomName => 'Entrez un nom personnalisé';

  @override
  String get selectApplication => 'Sélectionner une application';

  @override
  String get addWebApp => 'Ajouter une application web';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Mon application';

  @override
  String get add => 'Ajouter';

  @override
  String get searchNostrApps => 'Rechercher des applications Nostr...';

  @override
  String get invalidUrlHint => 'URL invalide. Entrez une URL HTTP ou HTTPS valide.';

  @override
  String get appAlreadyInList => 'Cette application est déjà dans la liste.';

  @override
  String appAdded(String name) {
    return 'Ajouté $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Échec de l\'ajout de l\'application : $error';
  }

  @override
  String get deleteApp => 'Supprimer l\'application';

  @override
  String deleteAppConfirm(String name) {
    return 'Voulez-vous vraiment supprimer « $name » ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String appDeleted(String name) {
    return 'Supprimé $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Échec de la suppression de l\'application : $error';
  }

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get eventDetails => 'Détails de l\'événement';

  @override
  String get eventDetailsCopiedToClipboard => 'Détails de l\'événement copiés dans le presse-papiers';

  @override
  String get rawMetadataCopiedToClipboard => 'Métadonnées brutes copiées dans le presse-papiers';

  @override
  String get permissionRequest => 'Demande de permission';

  @override
  String get permissionRequestContent => 'Cette application demande l\'accès à votre compte Nostr';

  @override
  String get grantPermissions => 'Accorder les permissions';

  @override
  String get reject => 'Refuser';

  @override
  String get fullAccessGranted => 'Accès complet accordé';

  @override
  String get fullAccessHint => 'Cette application aura un accès complet à votre compte Nostr, notamment :';

  @override
  String get permissionAccessPubkey => 'Accéder à votre clé publique Nostr';

  @override
  String get permissionSignEvents => 'Signer les événements Nostr';

  @override
  String get permissionEncryptDecrypt => 'Chiffrer et déchiffrer les événements (NIP-04 et NIP-44)';

  @override
  String get tips => 'Conseils';

  @override
  String get schemeLoginFirst => 'Impossible de résoudre le schéma. Connectez-vous d\'abord.';

  @override
  String get newConnectionRequest => 'Nouvelle demande de connexion';

  @override
  String get newConnectionNoSlotHint => 'Une nouvelle application tente de se connecter, mais aucune application n\'est disponible. Créez d\'abord une nouvelle application.';

  @override
  String get copiedSuccessfully => 'Copié avec succès';

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
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String get pleaseSelectApplication => 'Veuillez sélectionner une application';

  @override
  String get orEnterCustomName => 'Ou entrez un nom personnalisé';

  @override
  String get continueButton => 'Continuer';
}
