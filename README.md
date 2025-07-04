# Aegis - Nostr Signer

[![Download on TestFlight](https://img.shields.io/badge/TestFlight-Download-blue?logo=apple)](https://testflight.apple.com/join/DUzVMDMK)

**Aegis** is a simple and cross-platform Nostr signer that supports multiple connection methods. 

## Features

- Supports `bunker://` connection
- Supports iOS URL Scheme redirection for login

## Supported Connection Methods

### 1. Using `bunker://` URL

You can generate a `bunker://` URI to allow clients to connect quickly via the bunker protocol.

**Example:**

`bunker://<encoded_bunker_connect_uri>`

### 2. Using iOS URL Scheme Redirection

On iOS, you can redirect users to Aegis using a custom URL scheme.

#### Aegis NIP-46 x-callback-url Integration Guide

##### Full Invocation Format
```text
aegis://x-callback-url/nip46Auth?
    nostrconnect=<URLEncodedNCURI>&
    x-source=<SourceApp>&
    x-success=<SourceApp>://x-callback-url/nip46AuthSuccess&
    x-error=<SourceApp>://x-callback-url/nip46AuthError
```

#### Parameter Reference
| Parameter | Required | Description |
|-----------|----------|-------------|
| `nostrconnect` | Yes | The **Nostr Connect URI** (defined in [NIP-46](https://github.com/nostr-protocol/nips/blob/master/46.md)), after `Uri.encodeComponent`; contains pubkey, relay list, etc. |
| `x-source` | Yes | Identifier (custom scheme) of the source app |
| `x-success` | Yes | Callback URL to invoke when the user authorises successfully |
| `x-error` | Yes | Callback URL to invoke when an internal error occurs |

---

#### 2.1. Callback Format

##### 2.1.1 Success (`x-success`)
```text
sourceApp://x-callback-url/nip46AuthSuccess?
    x-source=aegis
```
| Parameter | Description |
|-----------|-------------|
| `x-source` | Always `aegis`, indicating the response comes from Aegis |

##### 2.1.2 Failure / Rejection (`x-error`)
```text
sourceApp://x-callback-url/nip46AuthError?
    x-source=aegis&
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

---

#### 2.2. Sample Code (Flutter)
```dart
import 'package:url_launcher/url_launcher.dart';

Future<void> openAegisAuth() async {
  // 1. Build your Nostr Connect URI
  final ncUri = 'nostrconnect://…';

  // 2. Assemble the Aegis x-callback-url
  final uri = Uri(
    scheme: 'aegis',
    host: 'x-callback-url',
    path: '/nip46Auth',
    queryParameters: {
      'nostrconnect': Uri.encodeComponent(ncUri),
      'x-source': '<SourceApp>',
      'x-success': '<SourceApp>://x-callback-url/nip46AuthSuccess',
      'x-error' : '<SourceApp>://x-callback-url/nip46AuthError',
    },
  );

}
```

Calling this schemeURL from your iOS app will redirect to Aegis for signing authorization.


### 3. Future plans

- Nsec Login & Backup – Securely log in using your Nostr private key (nsec) and back it up for safe storage. ✅


-	Generate nsecbunker Links – Seamlessly connect with Nostr apps via the bunker:// protocol. ✅

	
-	iOS URL Scheme Support – Enable Nostr apps on iOS to connect and authorize via custom URL schemes. ✅

	
-	Local Relay Support – Connect with local relay servers like ws://127.0.0.1:8081 for secure and private communication. ✅

	
-	Multi-account Login – Manage and switch between multiple Nostr accounts effortlessly. 

	
-	Request Preview – Preview detailed information about signing requests before approval. 

	
-	Permission Control – Manage and control what each app or client is allowed to do when connected. 

	
-	Android Platform Support – Full support for Android platforms, ensuring compatibility across mobile devices. 

	
-	Desktop Version – Available on desktop, offering a comprehensive signing experience for both mobile and desktop users. 


