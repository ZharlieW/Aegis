class Nip46CryptoRequestValidator {
  const Nip46CryptoRequestValidator._();

  static bool hasValidNip04Params(List<dynamic> params) {
    if (params.length < 2) return false;
    return params[0] != null && params[1] != null;
  }

  static bool hasValidNip44Params({
    required String serverPrivate,
    required List<dynamic> params,
  }) {
    if (serverPrivate.isEmpty || params.length < 2) return false;
    return params[0] is String && params[1] is String;
  }
}
