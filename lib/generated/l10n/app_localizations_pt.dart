// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Aegis';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get settings => 'Definições';

  @override
  String get logout => 'Terminar sessão';

  @override
  String get login => 'Iniciar sessão';

  @override
  String get usePrivateKey => 'Usar a tua chave privada';

  @override
  String get setupAegisWithNsec => 'Configura o Aegis com a tua chave privada Nostr — suporta formatos nsec, ncryptsec e hex.';

  @override
  String get privateKey => 'Chave privada';

  @override
  String get privateKeyHint => 'Chave nsec / ncryptsec / hex';

  @override
  String get password => 'Palavra-passe';

  @override
  String get passwordHint => 'Introduz a palavra-passe para desencriptar ncryptsec';

  @override
  String get contentCannotBeEmpty => 'O conteúdo não pode estar vazio!';

  @override
  String get passwordRequiredForNcryptsec => 'É necessária palavra-passe para ncryptsec!';

  @override
  String get decryptNcryptsecFailed => 'Falha ao desencriptar ncryptsec. Verifica a tua palavra-passe.';

  @override
  String get invalidPrivateKeyFormat => 'Formato de chave privada inválido!';

  @override
  String get loginSuccess => 'Sessão iniciada com sucesso!';

  @override
  String loginFailed(String message) {
    return 'Falha ao iniciar sessão: $message';
  }

  @override
  String get typeConfirmToProceed => 'Escreve \"confirm\" para continuar';

  @override
  String get logoutConfirm => 'Tens a certeza que queres terminar a sessão?';

  @override
  String get notLoggedIn => 'Sessão não iniciada';

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
  String get addAccount => 'Adicionar conta';

  @override
  String get updateSuccessful => 'Atualização concluída!';

  @override
  String get switchAccount => 'Mudar de conta';

  @override
  String get switchAccountConfirm => 'Tens a certeza que queres mudar de conta?';

  @override
  String get switchSuccessfully => 'Mudança concluída!';

  @override
  String get renameAccount => 'Renomear conta';

  @override
  String get accountName => 'Nome da conta';

  @override
  String get enterNewName => 'Introduz o novo nome';

  @override
  String get accounts => 'Contas';

  @override
  String get localRelay => 'Relay local';

  @override
  String get remote => 'Remoto';

  @override
  String get browser => 'Browser';

  @override
  String get theme => 'Tema';

  @override
  String get github => 'Github';

  @override
  String get version => 'Versão';

  @override
  String get appSubtitle => 'Aegis - Assinante Nostr';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get systemDefault => 'Predefinido do sistema';

  @override
  String switchedTo(String mode) {
    return 'Mudado para $mode';
  }

  @override
  String get home => 'Início';

  @override
  String get waitingForRelayStart => 'À espera que o relay inicie...';

  @override
  String get connected => 'Ligado';

  @override
  String get disconnected => 'Desligado';

  @override
  String errorLoadingNip07Applications(String error) {
    return 'Erro ao carregar aplicações NIP-07: $error';
  }

  @override
  String get noNip07ApplicationsHint => 'Ainda não há aplicações NIP-07.\n\nUsa o browser para aceder a apps Nostr!';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get active => 'Ativo';

  @override
  String get congratulationsEmptyState => 'Parabéns!\n\nJá podes usar aplicações compatíveis com Aegis!';

  @override
  String localRelayPortInUse(String port) {
    return 'O relay local está definido para a porta $port, mas outra aplicação parece estar a usá-la. Fecha a aplicação em conflito e tenta novamente.';
  }

  @override
  String get nip46Started => 'Assinante NIP-46 iniciado!';

  @override
  String get nip46FailedToStart => 'Falha ao iniciar.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get clear => 'Limpar';

  @override
  String get clearDatabase => 'Limpar base de dados';

  @override
  String get clearDatabaseConfirm => 'Todos os dados do relay serão apagados e o relay reiniciado se estiver em execução. Esta ação não pode ser anulada.';

  @override
  String get importDatabase => 'Importar base de dados';

  @override
  String get importDatabaseHint => 'Introduz o caminho do diretório da base de dados a importar. A base existente será cópia de segurança antes da importação.';

  @override
  String get databaseDirectoryPath => 'Caminho do diretório da base de dados';

  @override
  String get import => 'Importar';

  @override
  String get export => 'Exportar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restartRelay => 'Reiniciar relay';

  @override
  String get restartRelayConfirm => 'Tens a certeza que queres reiniciar o relay? Será parado temporariamente e depois reiniciado.';

  @override
  String get relayRestartedSuccess => 'Relay reiniciado com sucesso';

  @override
  String relayRestartFailed(String message) {
    return 'Falha ao reiniciar o relay: $message';
  }

  @override
  String get databaseClearedSuccess => 'Base de dados limpa com sucesso';

  @override
  String get databaseClearFailed => 'Falha ao limpar a base de dados';

  @override
  String errorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get exportDatabase => 'Exportar base de dados';

  @override
  String get exportDatabaseHint => 'A base de dados do relay será exportada como ficheiro ZIP. Pode demorar um pouco.';

  @override
  String databaseExportedTo(String path) {
    return 'Base de dados exportada para: $path';
  }

  @override
  String databaseExportedZip(String path) {
    return 'Base de dados exportada como ZIP: $path';
  }

  @override
  String get databaseExportFailed => 'Falha ao exportar a base de dados';

  @override
  String get importDatabaseReplaceHint => 'A base atual será substituída pela cópia importada. A base existente será cópia de segurança antes. Esta ação não pode ser anulada.';

  @override
  String get selectDatabaseBackupFile => 'Selecionar ficheiro (ZIP) ou diretório de cópia da base de dados';

  @override
  String get selectDatabaseBackupDir => 'Selecionar diretório de cópia da base de dados';

  @override
  String get fileOrDirNotExist => 'O ficheiro ou diretório selecionado não existe';

  @override
  String get databaseImportedSuccess => 'Base de dados importada com sucesso';

  @override
  String get databaseImportFailed => 'Falha ao importar a base de dados';

  @override
  String get status => 'Estado';

  @override
  String get address => 'Endereço';

  @override
  String get protocol => 'Protocolo';

  @override
  String get connections => 'Ligações';

  @override
  String get running => 'A executar';

  @override
  String get stopped => 'Parado';

  @override
  String get addressCopiedToClipboard => 'Endereço copiado para a área de transferência';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get importData => 'Importar dados';

  @override
  String get systemLogs => 'Registos do sistema';

  @override
  String get clearAllRelayData => 'Limpar todos os dados do relay';

  @override
  String get noLogsAvailable => 'Sem registos disponíveis';

  @override
  String get passwordRequired => 'É necessária palavra-passe';

  @override
  String encryptionFailed(String message) {
    return 'Falha na encriptação: $message';
  }

  @override
  String get encryptedKeyCopiedToClipboard => 'Chave privada encriptada copiada para a área de transferência';

  @override
  String get accountBackup => 'Cópia de segurança da conta';

  @override
  String get publicAccountId => 'ID público da conta';

  @override
  String get accountPrivateKey => 'Chave privada da conta';

  @override
  String get show => 'Mostrar';

  @override
  String get generate => 'Gerar';

  @override
  String get enterEncryptionPassword => 'Introduz a palavra-passe de encriptação';

  @override
  String get privateKeyEncryption => 'Encriptação da chave privada';

  @override
  String get encryptPrivateKeyHint => 'Encripta a tua chave privada para maior segurança. Será encriptada com uma palavra-passe.';

  @override
  String get ncryptsecHint => 'A chave encriptada começará por \"ncryptsec1\" e não pode ser usada sem a palavra-passe.';

  @override
  String get encryptAndCopyPrivateKey => 'Encriptar e copiar chave privada';

  @override
  String get privateKeyEncryptedSuccess => 'Chave privada encriptada com sucesso!';

  @override
  String get encryptedKeyNcryptsec => 'Chave encriptada (ncryptsec):';

  @override
  String get createNewNostrAccount => 'Criar nova conta Nostr';

  @override
  String get accountReadyPublicKeyHint => 'A tua conta Nostr está pronta! Esta é a tua chave pública nostr:';

  @override
  String get nostrPubkey => 'Chave pública Nostr';

  @override
  String get create => 'Criar';

  @override
  String get createSuccess => 'Criado com sucesso!';

  @override
  String get application => 'Aplicação';

  @override
  String get createApplication => 'Criar aplicação';

  @override
  String get addNewApplication => 'Adicionar nova aplicação';

  @override
  String get addNsecbunkerManually => 'Adicionar nsecbunker manualmente';

  @override
  String get loginUsingUrlScheme => 'Iniciar sessão com URL Scheme';

  @override
  String get addApplicationMethodsHint => 'Podes escolher qualquer destes métodos para te ligares ao Aegis!';

  @override
  String get urlSchemeLoginHint => 'Abre com uma app que suporte o esquema de URL do Aegis para iniciar sessão.';

  @override
  String get name => 'Nome';

  @override
  String get applicationInfo => 'Informação da aplicação';

  @override
  String get activities => 'Atividade';

  @override
  String get clientPubkey => 'Chave pública do cliente';

  @override
  String get remove => 'Remover';

  @override
  String get removeAppConfirm => 'Tens a certeza que queres remover todas as permissões desta aplicação?';

  @override
  String get removeSuccess => 'Removido com sucesso';

  @override
  String get nameCannotBeEmpty => 'O nome não pode estar vazio';

  @override
  String get nameTooLong => 'O nome é demasiado longo.';

  @override
  String get updateSuccess => 'Atualização concluída';

  @override
  String get editConfiguration => 'Editar configuração';

  @override
  String get update => 'Atualizar';

  @override
  String get search => 'Pesquisar...';

  @override
  String get enterCustomName => 'Introduz um nome personalizado';

  @override
  String get selectApplication => 'Selecionar uma aplicação';

  @override
  String get addWebApp => 'Adicionar aplicação web';

  @override
  String get urlHint => 'https://example.com';

  @override
  String get appNameHint => 'A minha app';

  @override
  String get add => 'Adicionar';

  @override
  String get searchNostrApps => 'Pesquisar aplicações Nostr...';

  @override
  String get invalidUrlHint => 'URL inválida. Introduz um URL HTTP ou HTTPS válido.';

  @override
  String get appAlreadyInList => 'Esta aplicação já está na lista.';

  @override
  String appAdded(String name) {
    return 'Adicionado $name';
  }

  @override
  String appAddFailed(String error) {
    return 'Falha ao adicionar a aplicação: $error';
  }

  @override
  String get deleteApp => 'Eliminar aplicação';

  @override
  String deleteAppConfirm(String name) {
    return 'Tens a certeza que queres eliminar \"$name\"?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String appDeleted(String name) {
    return 'Eliminado $name';
  }

  @override
  String appDeleteFailed(String error) {
    return 'Falha ao eliminar a aplicação: $error';
  }

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get eventDetails => 'Detalhes do evento';

  @override
  String get eventDetailsCopiedToClipboard => 'Detalhes do evento copiados para a área de transferência';

  @override
  String get rawMetadataCopiedToClipboard => 'Metadados brutos copiados para a área de transferência';

  @override
  String get permissionRequest => 'Pedido de permissão';

  @override
  String get permissionRequestContent => 'Esta aplicação está a pedir permissão para aceder à tua conta Nostr';

  @override
  String get grantPermissions => 'Conceder permissões';

  @override
  String get reject => 'Rejeitar';

  @override
  String get fullAccessGranted => 'Acesso total concedido';

  @override
  String get fullAccessHint => 'Esta aplicação terá acesso total à tua conta Nostr, incluindo:';

  @override
  String get permissionAccessPubkey => 'Aceder à tua chave pública Nostr';

  @override
  String get permissionSignEvents => 'Assinar eventos Nostr';

  @override
  String get permissionEncryptDecrypt => 'Encriptar e desencriptar eventos (NIP-04 e NIP-44)';

  @override
  String get tips => 'Dicas';

  @override
  String get schemeLoginFirst => 'Não foi possível resolver o esquema. Inicia sessão primeiro.';

  @override
  String get newConnectionRequest => 'Novo pedido de ligação';

  @override
  String get newConnectionNoSlotHint => 'Uma nova aplicação está a tentar ligar-se, mas não há nenhuma aplicação disponível. Cria primeiro uma nova aplicação.';

  @override
  String get copiedSuccessfully => 'Copiado com sucesso';

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
  String get noResultsFound => 'Nenhum resultado encontrado';

  @override
  String get pleaseSelectApplication => 'Por favor seleciona uma aplicação';

  @override
  String get orEnterCustomName => 'Ou introduz um nome personalizado';

  @override
  String get continueButton => 'Continuar';
}
