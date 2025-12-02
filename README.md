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

See [iOS_URL_SCHEME_REDIRECTION.md](iOS_URL_SCHEME_REDIRECTION.md) for detailed documentation on using iOS URL scheme redirection with Aegis.


### 3. Future plans

- Nsec Login & Backup – Securely log in using your Nostr private key (nsec) and back it up for safe storage. ✅

-	Generate nsecbunker Links – Seamlessly connect with Nostr apps via the bunker:// protocol. ✅

-	iOS URL Scheme Support – Enable Nostr apps on iOS to connect and authorize via custom URL schemes. ✅
	
-	Local Relay Support – Connect with local relay servers (wss://127.0.0.1:28443 on iOS, ws://127.0.0.1:8081 elsewhere) for secure and private communication. ✅

-	Android Platform Support – Full support for Android platforms, ensuring compatibility across mobile devices. ✅
	
-	Desktop Version – Available on desktop, offering a comprehensive signing experience for both mobile and desktop users. ✅
	
-	Multi-account Login – Manage and switch between multiple Nostr accounts effortlessly. 

-	Request Preview – Preview detailed information about signing requests before approval. 

-	Permission Control – Manage and control what each app or client is allowed to do when connected. 


