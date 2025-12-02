# Using iOS URL Scheme Redirection

On iOS, you can redirect users to Aegis using custom URL schemes. Aegis supports two URL schemes:
- `aegis://` - The primary scheme
- `nostrsigner://` - An alternative scheme for compatibility

## Aegis NIP-46 x-callback-url Integration Guide

### Full Invocation Format
```text
# Using aegis:// scheme
aegis://x-callback-url/auth/nip46?
    method=connect&
    nostrconnect=<URLEncodedNCURI>&
    x-source=<SourceApp>&
    x-success=<SourceApp>://x-callback-url/authSuccess&
    x-error=<SourceApp>://x-callback-url/authError

# Using nostrsigner:// scheme
nostrsigner://x-callback-url/auth/nip46?
    method=connect&
    nostrconnect=<URLEncodedNCURI>&
    x-source=<SourceApp>&
    x-success=<SourceApp>://x-callback-url/authSuccess&
    x-error=<SourceApp>://x-callback-url/authError
```

### Parameter Reference
| Parameter | Required | Description |
|-----------|----------|-------------|
| `method` | Yes | Must be set to `connect` for NIP-46 authentication |
| `nostrconnect` | Yes | The **Nostr Connect URI** (defined in [NIP-46](https://github.com/nostr-protocol/nips/blob/master/46.md)), after `Uri.encodeComponent`; contains pubkey, relay list, etc. |
| `x-source` | Yes | Identifier (custom scheme) of the source app |
| `x-success` | Yes | Callback URL to invoke when the user authorises successfully |
| `x-error` | Yes | Callback URL to invoke when an internal error occurs |

---

## Callback Format

### Success (`x-success`)
```text
sourceApp://x-callback-url/authSuccess?
    x-source=aegis&relay=wss://127.0.0.1:28443 (iOS) or ws://127.0.0.1:8081

# Or when using nostrsigner:// scheme:
sourceApp://x-callback-url/authSuccess?
    x-source=nostrsigner&relay=wss://127.0.0.1:28443 (iOS) or ws://127.0.0.1:8081
```
| Parameter | Description |
|-----------|-------------|
| `x-source` | Either `aegis` or `nostrsigner`, indicating the response comes from Aegis |

### Failure / Rejection (`x-error`)
```text
sourceApp://x-callback-url/authError?
    x-source=aegis&
    errorCode=<Code>&
    errorMessage=<Message>

# Or when using nostrsigner:// scheme:
sourceApp://x-callback-url/authError?
    x-source=nostrsigner&
    errorCode=<Code>&
    errorMessage=<Message>
```
| Parameter | Description |
|-----------|-------------|
| `errorCode` | One of the codes in the table below |
| `errorMessage` | Human-readable error description |

Common `errorCode` values:

| Code | Meaning |
|------|---------|
| 1001 | The user rejected the authorization request |
| 2001 | Required parameter is missing or malformed |
| 2002 | Failed to parse the Nostr Connect URI |
| 2003 | Invalid or missing method parameter |

---

## Sample Code (Flutter)
```dart
import 'package:url_launcher/url_launcher.dart';

Future<void> openAegisAuth() async {
  // 1. Build your Nostr Connect URI
  final ncUri = 'nostrconnect://…';

  // 2. Assemble the Aegis x-callback-url (using aegis:// scheme)
  final uri = Uri(
    scheme: 'aegis',
    host: 'x-callback-url',
    path: '/auth/nip46',
    queryParameters: {
      'method': 'connect',
      'nostrconnect': Uri.encodeComponent(ncUri),
      'x-source': '<SourceApp>',
      'x-success': '<SourceApp>://x-callback-url/authSuccess',
      'x-error' : '<SourceApp>://x-callback-url/authError',
    },
  );

  // Alternative: Using nostrsigner:// scheme
  final nostrsignerUri = Uri(
    scheme: 'nostrsigner',
    host: 'x-callback-url',
    path: '/auth/nip46',
    queryParameters: {
      'method': 'connect',
      'nostrconnect': Uri.encodeComponent(ncUri),
      'x-source': '<SourceApp>',
      'x-success': '<SourceApp>://x-callback-url/authSuccess',
      'x-error' : '<SourceApp>://x-callback-url/authError',
    },
  );

}
```

Calling this schemeURL from your iOS app will redirect to Aegis for signing authorization.

## Complete Example

Here's a complete example showing how to integrate with Aegis using both schemes:

```dart
import 'package:url_launcher/url_launcher.dart';

class AegisIntegration {
  static Future<void> requestNostrConnectAuth({
    required String nostrConnectUri,
    required String sourceAppScheme,
    String? successCallback,
    String? errorCallback,
  }) async {
    // Choose which scheme to use
    final scheme = 'nostrsigner'; // or 'aegis'
    
    final uri = Uri(
      scheme: scheme,
      host: 'x-callback-url',
      path: '/auth/nip46',
      queryParameters: {
        'method': 'connect',
        'nostrconnect': Uri.encodeComponent(nostrConnectUri),
        'x-source': sourceAppScheme,
        if (successCallback != null) 'x-success': successCallback,
        if (errorCallback != null) 'x-error': errorCallback,
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch Aegis');
    }
  }
}

// Usage example:
void example() async {
  try {
    await AegisIntegration.requestNostrConnectAuth(
      nostrConnectUri: 'nostrconnect://...',
      sourceAppScheme: 'myapp',
      successCallback: 'myapp://x-callback-url/authSuccess',
      errorCallback: 'myapp://x-callback-url/authError',
    );
  } catch (e) {
    print('Failed to launch Aegis: $e');
  }
}
```

