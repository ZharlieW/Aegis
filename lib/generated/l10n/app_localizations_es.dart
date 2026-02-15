// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get settings => 'Ajustes';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get usePrivateKey => 'Usar tu clave privada';

  @override
  String get setupAegisWithNsec => 'Configura Aegis con tu clave privada Nostr — admite formatos nsec, ncryptsec y hex.';

  @override
  String get privateKey => 'Clave privada';

  @override
  String get privateKeyHint => 'Clave nsec / ncryptsec / hex';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => 'Introduce la contraseña para descifrar ncryptsec';

  @override
  String get contentCannotBeEmpty => '¡El contenido no puede estar vacío!';

  @override
  String get passwordRequiredForNcryptsec => '¡Se requiere contraseña para ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Error al descifrar ncryptsec. Comprueba tu contraseña.';

  @override
  String get invalidPrivateKeyFormat => '¡Formato de clave privada no válido!';

  @override
  String get loginSuccess => '¡Sesión iniciada correctamente!';

  @override
  String loginFailed(String message) {
    return 'Error al iniciar sesión: $message';
  }

  @override
  String get typeConfirmToProceed => 'Escribe \"confirm\" para continuar';

  @override
  String get logoutConfirm => '¿Seguro que quieres cerrar sesión?';

  @override
  String get notLoggedIn => 'No has iniciado sesión';

  @override
  String get language => 'Idioma';

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
  String get addAccount => 'Añadir cuenta';

  @override
  String get updateSuccessful => '¡Actualización correcta!';

  @override
  String get switchAccount => 'Cambiar de cuenta';

  @override
  String get switchAccountConfirm => '¿Seguro que quieres cambiar de cuenta?';

  @override
  String get switchSuccessfully => '¡Cambio correcto!';

  @override
  String get renameAccount => 'Renombrar cuenta';

  @override
  String get accountName => 'Nombre de cuenta';

  @override
  String get enterNewName => 'Introduce el nuevo nombre';

  @override
  String get accounts => 'Cuentas';

  @override
  String get localRelay => 'Relay local';

  @override
  String get remote => 'Remoto';

  @override
  String get browser => 'Navegador';

  @override
  String get theme => 'Tema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versión';

  @override
  String get appSubtitle => 'Aegis - Firmante Nostr';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String switchedTo(String mode) {
    return 'Cambiado a $mode';
  }

  @override
  String get home => 'Inicio';

  @override
  String get waitingForRelayStart => 'Esperando a que arranque el relay...';

  @override
  String get connected => 'Conectado';

  @override
  String get disconnected => 'Desconectado';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Error al cargar aplicaciones NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Aún no hay aplicaciones NIP-07.\n\n¡Usa el navegador para acceder a apps Nostr!';

  @override
  String get unknown => 'Desconocido';

  @override
  String get active => 'Activo';

  @override
  String get congratulationsEmptyState => '¡Enhorabuena!\n\nYa puedes usar aplicaciones compatibles con Aegis.';

  @override
  String localRelayPortInUse(String port) {
    return 'El relay local usa el puerto $port, pero parece que otra aplicación ya lo está usando. Cierra la aplicación en conflicto e inténtalo de nuevo.';
  }

  @override
  String get localRelayChangePort => 'Change port';

  @override
  String get localRelayChangePortHint => 'After changing the port, you need to update the signer link (bunker URL) in your applications.';

  @override
  String get nip46Started => '¡Firmante NIP-46 iniciado!';

  @override
  String get nip46FailedToStart => 'Error al iniciar.';

  @override
  String get retry => 'Reintentar';

  @override
  String get clear => 'Borrar';

  @override
  String get clearDatabase => 'Borrar base de datos';

  @override
  String get clearDatabaseConfirm => 'Se eliminarán todos los datos del relay y se reiniciará si está en ejecución. Esta acción no se puede deshacer.';

  @override
  String get importDatabase => 'Importar base de datos';

  @override
  String get importDatabaseHint => 'Introduce la ruta del directorio de la base de datos a importar. La base de datos actual se respaldará antes de importar.';

  @override
  String get databaseDirectoryPath => 'Ruta del directorio de la base de datos';

  @override
  String get import => 'Importar';

  @override
  String get export => 'Exportar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restartRelay => 'Reiniciar relay';

  @override
  String get restartRelayConfirm => '¿Seguro que quieres reiniciar el relay? Se detendrá temporalmente y se volverá a iniciar.';

  @override
  String get relayRestartedSuccess => 'Relay reiniciado correctamente';

  @override
  String relayRestartFailed(String message) {
    return 'Error al reiniciar el relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Base de datos borrada correctamente';

  @override
  String get databaseClearFailed => 'Error al borrar la base de datos';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get exportDatabase => 'Exportar base de datos';

  @override
  String get exportDatabaseHint => 'Se exportará la base de datos del relay como archivo ZIP. Puede tardar un momento.';

  @override
  String databaseExportedTo(String path) {
    return 'Base de datos exportada a: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Base de datos exportada como ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Error al exportar la base de datos';

  @override
  String get importDatabaseReplaceHint => 'La base de datos actual se sustituirá por la copia importada. La base actual se respaldará antes. Esta acción no se puede deshacer.';

  @override
  String get selectDatabaseBackupFile => 'Seleccionar archivo (ZIP) o directorio de copia de la base de datos';

  @override
  String get selectDatabaseBackupDir => 'Seleccionar directorio de copia de la base de datos';

  @override
  String get fileOrDirNotExist => 'El archivo o directorio seleccionado no existe';

  @override
  String get databaseImportedSuccess => 'Base de datos importada correctamente';

  @override
  String get databaseImportFailed => 'Error al importar la base de datos';

  @override
  String get status => 'Estado';

  @override
  String get address => 'Dirección';

  @override
  String get protocol => 'Protocolo';

  @override
  String get connections => 'Conexiones';

  @override
  String get running => 'En ejecución';

  @override
  String get stopped => 'Detenido';

  @override
  String get addressCopiedToClipboard => 'Dirección copiada al portapapeles';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get importData => 'Importar datos';

  @override
  String get systemLogs => 'Registros del sistema';

  @override
  String get clearAllRelayData => 'Borrar todos los datos del relay';

  @override
  String get noLogsAvailable => 'No hay registros';

  @override
  String get passwordRequired => 'Se requiere contraseña';

  @override
  String encryptionFailed(String message) {
    return 'Error de cifrado: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Clave privada cifrada copiada al portapapeles';

  @override
  String get accountBackup => 'Copia de seguridad de la cuenta';

  @override
  String get publicAccountId => 'ID público de la cuenta';

  @override
  String get accountPrivateKey => 'Clave privada de la cuenta';

  @override
  String get show => 'Mostrar';

  @override
  String get generate => 'Generar';

  @override
  String get enterEncryptionPassword => 'Introduce la contraseña de cifrado';

  @override
  String get privateKeyEncryption => 'Cifrado de clave privada';

  @override
  String get encryptPrivateKeyHint => 'Cifra tu clave privada para mayor seguridad. Se cifrará con una contraseña.';

  @override
  String get ncryptsecHint => 'La clave cifrada comenzará por \"ncryptsec1\" y no podrá usarse sin la contraseña.';

  @override
  String get encryptAndCopyPrivateKey => 'Cifrar y copiar clave privada';

  @override
  String get privateKeyEncryptedSuccess => '¡Clave privada cifrada correctamente!';

  @override
  String get encryptedKeyNcryptsec => 'Clave cifrada (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Crear una cuenta Nostr nueva';

  @override
  String get accountReadyPublicKeyHint => '¡Tu cuenta Nostr está lista! Esta es tu clave pública nostr:';

  @override
  String get nostrPubkey => 'Clave pública Nostr';

  @override
  String get create => 'Crear';

  @override
  String get createSuccess => '¡Creado correctamente!';

  @override
  String get application => 'Aplicación';

  @override
  String get createApplication => 'Crear aplicación';

  @override
  String get addNewApplication => 'Añadir una aplicación nueva';

  @override
  String get addNsecbunkerManually => 'Añadir nsecbunker manualmente';

  @override
  String get loginUsingUrlScheme => 'Iniciar sesión con URL Scheme';

  @override
  String get addApplicationMethodsHint => '¡Puedes elegir cualquiera de estos métodos para conectar con Aegis!';

  @override
  String get urlSchemeLoginHint => 'Abre con una app que soporte el esquema de URL de Aegis para iniciar sesión.';

  @override
  String get name => 'Nombre';

  @override
  String get applicationInfo => 'Información de la aplicación';

  @override
  String get activities => 'Actividad';

  @override
  String get clientPubkey => 'Clave pública del cliente';

  @override
  String get remove => 'Quitar';

  @override
  String get removeAppConfirm => '¿Seguro que quieres quitar todos los permisos de esta aplicación?';

  @override
  String get removeSuccess => 'Eliminado correctamente';

  @override
  String get nameCannotBeEmpty => 'El nombre no puede estar vacío';

  @override
  String get nameTooLong => 'El nombre es demasiado largo.';

  @override
  String get updateSuccess => 'Actualización correcta';

  @override
  String get editConfiguration => 'Editar configuración';

  @override
  String get update => 'Actualizar';

  @override
  String get search => 'Buscar...';

  @override
  String get enterCustomName => 'Introduce un nombre personalizado';

  @override
  String get selectApplication => 'Seleccionar una aplicación';

  @override
  String get addWebApp => 'Añadir aplicación web';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'Mi app';

  @override
  String get add => 'Añadir';

  @override
  String get searchNostrApps => 'Buscar aplicaciones Nostr...';

  @override
  String get invalidUrlHint => 'URL no válida. Introduce una URL HTTP o HTTPS válida.';

  @override
  String get appAlreadyInList => 'Esta aplicación ya está en la lista.';

  @override
  String appAdded(String name) {
    return 'Añadido $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Error al añadir la aplicación: $error';
  }

  @override
  String get deleteApp => 'Eliminar aplicación';

  @override
  String deleteAppConfirm(String name) {
    return '¿Seguro que quieres eliminar \"$name\"?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String appDeleted(String name) {
    return 'Eliminado $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Error al eliminar la aplicación: $error';
  }

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get eventDetails => 'Detalles del evento';

  @override
  String get eventDetailsCopiedToClipboard => 'Detalles del evento copiados al portapapeles';

  @override
  String get rawMetadataCopiedToClipboard => 'Metadatos crudos copiados al portapapeles';

  @override
  String get permissionRequest => 'Solicitud de permisos';

  @override
  String get permissionRequestContent => 'Esta aplicación solicita permisos para acceder a tu cuenta Nostr';

  @override
  String get grantPermissions => 'Conceder permisos';

  @override
  String get reject => 'Rechazar';

  @override
  String get fullAccessGranted => 'Acceso completo concedido';

  @override
  String get fullAccessHint => 'Esta aplicación tendrá acceso completo a tu cuenta Nostr, incluido:';

  @override
  String get permissionAccessPubkey => 'Acceso a tu clave pública Nostr';

  @override
  String get permissionSignEvents => 'Firmar eventos Nostr';

  @override
  String get permissionEncryptDecrypt => 'Cifrar y descifrar eventos (NIP-04 y NIP-44)';

  @override
  String get tips => 'Consejos';

  @override
  String get schemeLoginFirst => 'No se puede resolver el esquema. Inicia sesión primero.';

  @override
  String get newConnectionRequest => 'Nueva solicitud de conexión';

  @override
  String get newConnectionNoSlotHint => 'Una aplicación nueva intenta conectarse, pero no hay ninguna disponible. Crea primero una aplicación nueva.';

  @override
  String get copiedSuccessfully => 'Copiado correctamente';

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
  String get noResultsFound => 'No se encontraron resultados';

  @override
  String get pleaseSelectApplication => 'Por favor selecciona una aplicación';

  @override
  String get orEnterCustomName => 'O introduce un nombre personalizado';

  @override
  String get continueButton => 'Continuar';
}
