
# Aegis - Nostr Signer

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

Format of the URL scheme:

```
aegis://${Uri.encodeComponent("$nostrConnectURI&scheme=$yourappurlscheme://")
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


