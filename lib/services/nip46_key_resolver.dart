import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/logger.dart';

/// Resolves server pubkeys, applications by remote signer pubkey, and private keys for NIP-46.
class Nip46KeyResolver {
  bool _accountsInitialized = false;

  Future<void> ensureAccountsInitialized() async {
    if (_accountsInitialized) return;
    try {
      await AccountManager.sharedInstance.initAccountList();
      _accountsInitialized = true;
    } catch (e) {
      AegisLogger.error('Failed to initialize account cache', e);
    }
  }

  Future<List<String>> getAllServerPubkeys() async {
    await ensureAccountsInitialized();
    final manager = AccountManager.sharedInstance;
    final currentPubkey = Account.sharedInstance.currentPubkey;
    final storedAccounts = await AccountManager.getAllAccount();
    final pubkeys = <String>{};

    for (final appNotifier in manager.applicationMap.values) {
      final app = appNotifier.value;
      final remoteSignerPubkey = (app.remoteSignerPubkey != null &&
              app.remoteSignerPubkey!.isNotEmpty)
          ? app.remoteSignerPubkey!
          : app.pubkey;
      if (remoteSignerPubkey.isNotEmpty) pubkeys.add(remoteSignerPubkey);
    }

    if (currentPubkey.isNotEmpty) {
      try {
        final currentApps =
            await ClientAuthDBISAR.getAllFromDB(currentPubkey);
        for (final app in currentApps) {
          final remoteSignerPubkey = (app.remoteSignerPubkey != null &&
                  app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey;
          if (remoteSignerPubkey.isNotEmpty) pubkeys.add(remoteSignerPubkey);
        }
      } catch (e) {
        AegisLogger.warning('Failed to get applications for current account', e);
      }
    }

    if (pubkeys.isEmpty) {
      if (currentPubkey.isNotEmpty) pubkeys.add(currentPubkey);
      pubkeys.addAll(manager.accountMap.keys.where((key) => key.isNotEmpty));
      pubkeys.addAll(storedAccounts.keys.where((key) => key.isNotEmpty));
    }

    return pubkeys.toList();
  }

  /// Returns map with 'app' (ClientAuthDBISAR?) and 'userPubkey' (String).
  Future<Map<String, dynamic>?> findApplicationByRemoteSignerPubkey(
    String remoteSignerPubkey,
  ) async {
    await ensureAccountsInitialized();
    final manager = AccountManager.sharedInstance;
    final account = Account.sharedInstance;

    for (final appNotifier in manager.applicationMap.values) {
      final app = appNotifier.value;
      final appRemoteSignerPubkey = (app.remoteSignerPubkey != null &&
              app.remoteSignerPubkey!.isNotEmpty)
          ? app.remoteSignerPubkey!
          : app.pubkey;
      if (appRemoteSignerPubkey == remoteSignerPubkey) {
        return {'app': app, 'userPubkey': app.pubkey};
      }
    }

    final currentPubkey = account.currentPubkey;
    if (currentPubkey.isNotEmpty) {
      try {
        final currentApps =
            await ClientAuthDBISAR.getAllFromDB(currentPubkey);
        for (final app in currentApps) {
          final appRemoteSignerPubkey = (app.remoteSignerPubkey != null &&
                  app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey;
          if (appRemoteSignerPubkey == remoteSignerPubkey) {
            return {'app': app, 'userPubkey': app.pubkey};
          }
        }
      } catch (e) {
        AegisLogger.warning(
            'Failed to search applications for remote signer pubkey', e);
      }
    }

    final storedAccounts = await AccountManager.getAllAccount();
    for (final userPubkey in storedAccounts.keys) {
      try {
        final apps = await ClientAuthDBISAR.getAllFromDB(userPubkey);
        for (final app in apps) {
          final appRemoteSignerPubkey = (app.remoteSignerPubkey != null &&
                  app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey;
          if (appRemoteSignerPubkey == remoteSignerPubkey) {
            return {'app': app, 'userPubkey': app.pubkey};
          }
        }
      } catch (_) {}
    }

    if (remoteSignerPubkey == currentPubkey && currentPubkey.isNotEmpty) {
      return {'app': null, 'userPubkey': currentPubkey};
    }
    if (manager.accountMap.containsKey(remoteSignerPubkey)) {
      return {'app': null, 'userPubkey': remoteSignerPubkey};
    }
    if (storedAccounts.containsKey(remoteSignerPubkey)) {
      return {'app': null, 'userPubkey': remoteSignerPubkey};
    }

    return null;
  }

  Future<ClientAuthDBISAR?> findUnusedApplicationByRemoteSignerPubkey(
    String remoteSignerPubkey,
  ) async {
    await ensureAccountsInitialized();
    final manager = AccountManager.sharedInstance;
    final account = Account.sharedInstance;

    for (final appNotifier in manager.applicationMap.values) {
      final app = appNotifier.value;
      final appRemoteSignerPubkey = (app.remoteSignerPubkey != null &&
              app.remoteSignerPubkey!.isNotEmpty)
          ? app.remoteSignerPubkey!
          : app.pubkey;
      if (appRemoteSignerPubkey == remoteSignerPubkey &&
          app.clientPubkey.isEmpty) {
        return app;
      }
    }

    final currentPubkey = account.currentPubkey;
    if (currentPubkey.isNotEmpty) {
      try {
        final currentApps =
            await ClientAuthDBISAR.getAllFromDB(currentPubkey);
        for (final app in currentApps) {
          final appRemoteSignerPubkey = (app.remoteSignerPubkey != null &&
                  app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey;
          if (appRemoteSignerPubkey == remoteSignerPubkey &&
              app.clientPubkey.isEmpty) {
            return app;
          }
        }
      } catch (e) {
        AegisLogger.warning(
            'Failed to search applications for remote signer pubkey', e);
      }
    }

    final storedAccounts = await AccountManager.getAllAccount();
    for (final userPubkey in storedAccounts.keys) {
      try {
        final apps = await ClientAuthDBISAR.getAllFromDB(userPubkey);
        for (final app in apps) {
          final appRemoteSignerPubkey = (app.remoteSignerPubkey != null &&
                  app.remoteSignerPubkey!.isNotEmpty)
              ? app.remoteSignerPubkey!
              : app.pubkey;
          if (appRemoteSignerPubkey == remoteSignerPubkey &&
              app.clientPubkey.isEmpty) {
            return app;
          }
        }
      } catch (_) {}
    }

    return null;
  }

  Future<String?> getUserPrivateKey(String userPubkey) async {
    await ensureAccountsInitialized();
    final manager = AccountManager.sharedInstance;
    final storedUser = manager.accountMap[userPubkey];
    if (storedUser?.privkey != null && storedUser!.privkey!.isNotEmpty) {
      return storedUser.privkey!;
    }
    if (userPubkey == Account.sharedInstance.currentPubkey) {
      return Account.sharedInstance.currentPrivkey;
    }
    AegisLogger.warning(
        '🔐 [NIP-46] No private key found for userPubkey: ${userPubkey.length > 16 ? userPubkey.substring(0, 16) : userPubkey}...');
    return null;
  }

  Future<String?> getServerPrivateKey(String serverPubkey) async {
    await ensureAccountsInitialized();

    final appInfo = await findApplicationByRemoteSignerPubkey(serverPubkey);
    if (appInfo != null) {
      final app = appInfo['app'] as ClientAuthDBISAR?;
      final userPubkey = appInfo['userPubkey'] as String;

      if (app != null &&
          app.remoteSignerPrivateKey != null &&
          app.remoteSignerPrivateKey!.isNotEmpty) {
        return app.remoteSignerPrivateKey!;
      }

      final manager = AccountManager.sharedInstance;
      final storedUser = manager.accountMap[userPubkey];
      if (storedUser?.privkey != null && storedUser!.privkey!.isNotEmpty) {
        return storedUser.privkey!;
      }
      if (userPubkey == Account.sharedInstance.currentPubkey) {
        return Account.sharedInstance.currentPrivkey;
      }
    }

    final manager = AccountManager.sharedInstance;
    final storedUser = manager.accountMap[serverPubkey];
    if (storedUser?.privkey != null && storedUser!.privkey!.isNotEmpty) {
      return storedUser.privkey!;
    }
    if (serverPubkey == Account.sharedInstance.currentPubkey) {
      return Account.sharedInstance.currentPrivkey;
    }

    AegisLogger.warning(
        '🔐 [NIP-46] No private key found for serverPubkey: ${serverPubkey.length > 16 ? serverPubkey.substring(0, 16) : serverPubkey}...');
    return null;
  }
}
