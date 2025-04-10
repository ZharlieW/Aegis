
# Aegis - Nostr Signer

**Aegis** is a Nostr signer that supports multiple connection methods. It works seamlessly with Nostr clients that support Nostr Connect.

## ✨ Features

- Supports `bunker://` connection
- Supports iOS URL Scheme redirection for login
- On iOS, the signer app can remain active in the background, ensuring availability for signing requests

## 📦 Supported Connection Methods

### 1. Using `bunker://` URL

You can generate a `bunker://` URI to allow clients to connect quickly via the bunker protocol.

**Example:**

`bunker://<encoded_bunker_connect_uri>`

### 2. Using iOS URL Scheme Redirection

On iOS, you can redirect users to Aegis using a custom URL scheme.

Format of the URL scheme:

```
aegis://${Uri.encodeComponent("$nostrConnectURI&scheme=$yourappurlcheme://")
```

You can generate a redirect URL like this:

```dart
final nostrConnectURI = createNostrConnectURI(
  relay: 'ws://127.0.0.1:8081',
  // other params
);

final schemeURL = 'aegis://${Uri.encodeComponent("$nostrConnectURI&scheme=oxchat://")}';
```

Calling this schemeURL from your iOS app will redirect to Aegis for signing authorization.


