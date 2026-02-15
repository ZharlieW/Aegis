import 'package:get_it/get_it.dart';

import 'package:aegis/core/contracts/account_repository_interface.dart';
import 'package:aegis/core/contracts/relay_service_interface.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/relay_service.dart';

final GetIt getIt = GetIt.instance;

/// Registers core services. Call once from main after bindings.
void setupServiceLocator() {
  getIt.registerSingleton<IRelayService>(RelayService.instance);
  getIt.registerSingleton<ICurrentAccount>(_CurrentAccountAdapter());
}

/// Adapter so Account singleton can be used as ICurrentAccount.
class _CurrentAccountAdapter implements ICurrentAccount {
  @override
  String get currentPubkey => Account.sharedInstance.currentPubkey;

  @override
  String get currentPrivkey => Account.sharedInstance.currentPrivkey;

  @override
  bool get isLoggedIn =>
      currentPubkey.isNotEmpty && currentPrivkey.isNotEmpty;
}
