# Aegis - Nostr Signer

[![Download on TestFlight](https://img.shields.io/badge/TestFlight-Download-blue?logo=apple)](https://testflight.apple.com/join/DUzVMDMK)

**Aegis** is a simple and cross-platform Nostr signer that supports multiple connection methods. 

## Features

- **[NIP-55](https://github.com/nostr-protocol/nips/blob/master/55.md)** – Act as a signer for other apps via Android Content Provider / Intent and `nostrsigner://` URL scheme (sign, encrypt, decrypt).
- **[NIP-46](https://github.com/nostr-protocol/nips/blob/master/46.md)** – Nostr Connect remote signing (bunker protocol); supports `bunker://` and Nostr Connect URI.
- **[NIP-07](https://github.com/nostr-protocol/nips/blob/master/07.md)** – Inject `window.nostr` in the in-app browser so web Nostr apps can use Aegis as the signer.
- **Local Relay** – Connect via a local relay (iOS: `wss://127.0.0.1:28443`, other platforms: `ws://127.0.0.1:8081`) for on-device communication with Nostr apps.
- **Nostr Apps** – Integrate with Nostr clients and web apps via NIP-46 (including local relay), NIP-07 in the built-in browser, and NIP-55 on Android.

## Supported Connection Methods

### 1. Using `bunker://` URL (NIP-46)

You can generate a `bunker://` URI to allow clients to connect quickly via the bunker protocol.

**Example:**

`bunker://<encoded_bunker_connect_uri>`

### 2. Using iOS URL Scheme Redirection (NIP-46)

See [iOS_URL_SCHEME_REDIRECTION.md](iOS_URL_SCHEME_REDIRECTION.md) for detailed documentation on using iOS URL scheme redirection with Aegis.

### 3. Android (NIP-55) and in-app browser (NIP-07)

On Android, other apps can connect via NIP-55 (Intent / Content Provider or `nostrsigner://` URL scheme). Web Nostr apps can use Aegis as the signer from the in-app browser via the injected NIP-07 API.

## Future plans

- **Refactor** – Rewrite logic layer in Rust; Flutter responsible for UI only.
- **Local relay** – Add maintenance features: sync, scan, delete.
- **Nostr apps** – Support local WebXDC format.
- **Nostr MLS Signer** – Support MLS signer and maintain MLS state storage.

