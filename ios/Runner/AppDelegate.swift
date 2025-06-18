import CryptoKit
import Flutter
import UIKit
import NostrSDK

@main
@objc class AppDelegate: FlutterAppDelegate, EventCreating {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        let channel = FlutterMethodChannel(name: "aegis_nostr",
                                           binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            self.handleNostrMethodCall(call, result: result)
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func handleNostrMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
            return
        }

        switch call.method {
        case "nip44Encrypt":
            handleNIP44Encrypt(args: args, result: result)
        case "nip44Decrypt":
            handleNIP44Decrypt(args: args, result: result)
        case "nip04Encrypt":
            handleNIP04Encrypt(args: args, result: result)
        case "nip04Decrypt":
            handleNIP04Decrypt(args: args, result: result)
        case "signRumorEvent":
            handleSignRumorEvent(args: args, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleNIP44Encrypt(args: [String: Any], result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let encrypted = try NIP44Native.shared.encryptWithKeys(
                    plaintext: args["plaintext"] as! String,
                    privateKeyA: args["privateKey"] as! String,
                    publicKeyB: args["publicKey"] as! String
                )
                DispatchQueue.main.async {
                    result(encrypted)
                }
            } catch let error as NIP44Native.NIP44Error {
                DispatchQueue.main.async {
                    result(FlutterError(code: "NIP44_ERROR", message: error.localizedDescription, details: nil))
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        }
    }

    private func handleNIP44Decrypt(args: [String: Any], result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let decrypted = try NIP44Native.shared.decryptWithKeys(
                    payload: args["ciphertext"] as! String,
                    privateKeyA: args["privateKey"] as! String,
                    publicKeyB: args["publicKey"] as! String
                )
                DispatchQueue.main.async {
                    result(decrypted)
                }
            } catch let error as NIP44Native.NIP44Error {
                DispatchQueue.main.async {
                    result(FlutterError(code: "NIP44_ERROR", message: error.localizedDescription, details: nil))
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        }
    }

    private func handleNIP04Encrypt(args: [String: Any], result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let encrypted = try NIP44Native.shared.nip04Encrypt(
                    plaintext: args["plaintext"] as! String,
                    privateKey: args["privateKey"] as! String,
                    publicKey: args["publicKey"] as! String
                )
                DispatchQueue.main.async {
                    result(encrypted)
                }
            } catch let error as NIP44Native.NIP44Error {
                DispatchQueue.main.async {
                    result(FlutterError(code: "NIP04_ERROR", message: error.localizedDescription, details: nil))
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        }
    }

    private func handleNIP04Decrypt(args: [String: Any], result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let decrypted = try NIP44Native.shared.nip04Decrypt(
                    ciphertext: args["ciphertext"] as! String,
                    privateKey: args["privateKey"] as! String,
                    publicKey: args["publicKey"] as! String
                )
                DispatchQueue.main.async {
                    result(decrypted)
                }
            } catch let error as NIP44Native.NIP44Error {
                DispatchQueue.main.async {
                    result(FlutterError(code: "NIP04_ERROR", message: error.localizedDescription, details: nil))
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        }
    }

    private func handleSignRumorEvent(args: [String: Any], result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let rumorJson = args["rumorJsonString"] as? String,
                      let privKey = args["privateKey"] as? String else {
                    throw NIP44Native.NIP44Error.signingFailed("Missing required arguments")
                }

                let signed = try NIP44Native.shared.signRumorEvent(rumorJsonString: rumorJson,
                                                                     privateKey: privKey)
                DispatchQueue.main.async {
                    result(signed)
                }
            } catch let error as NIP44Native.NIP44Error {
                DispatchQueue.main.async {
                    result(FlutterError(code: "SIGN_ERROR", message: error.localizedDescription, details: nil))
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        }
    }

    override func application(
        _: UIApplication,
        open url: URL,
        options _: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "app.channel.shared.data", binaryMessenger: controller.binaryMessenger)
        channel.invokeMethod("onSchemeCalled", arguments: url.absoluteString)
        return true
    }
}

class NIP44Native: EventCreating {
    static let shared = NIP44Native()

    private init() {}

    enum NIP44Error: Error {
        case invalidPrivateKey
        case invalidPublicKey
        case invalidConversationKey
        case encryptionFailed(String)
        case decryptionFailed(String)
        case keyParsingFailed(String)
        case signingFailed(String)

        var localizedDescription: String {
            switch self {
            case .invalidPrivateKey:
                return "Invalid private key"
            case .invalidPublicKey:
                return "Invalid public key"
            case .invalidConversationKey:
                return "Invalid session key"
            case let .encryptionFailed(message):
                return "Encryption failed: \(message)"
            case let .decryptionFailed(message):
                return "decryption failure: \(message)"
            case let .keyParsingFailed(message):
                return "Key parsing failed.: \(message)"
            case let .signingFailed(message):
                return "Signing failed: \(message)"
            }
        }
    }

    // Cache for conversation keys: key is "privHex|pubHex"
    private static var conversationKeyCache = [String: Data]()
    // Provide a thread-safe concurrent queue for the cache dictionary above
    private static let cacheQueue = DispatchQueue(label: "NIP44Native.conversationKeyCacheQueue", attributes: .concurrent)

    // MARK: - Shared secret cache for NIP04 (legacy) -------------------------
    /// Obtain and cache the shared secret used by NIP04 to avoid redundant calculations.
    private func getSharedSecretKey(privateKey: PrivateKey, publicKey: PublicKey) throws -> Data {
        // Reuse the same cache dictionary, key format: "privHex|pubHex"
        let cacheKey = "\(privateKey.hex)|\(publicKey.hex)"

        // Perform a lock-free read first
        var cached: Data?
        NIP44Native.cacheQueue.sync {
            cached = NIP44Native.conversationKeyCache[cacheKey]
        }

        if let existing = cached {
            return existing
        }

        // Cache miss, derive a new shared secret
        let secretBytes = try getSharedSecret(privateKey: privateKey, recipient: publicKey)
        let secretData = Data(secretBytes)

        // Write with a barrier to ensure exclusive access during writes
        NIP44Native.cacheQueue.async(flags: .barrier) {
            NIP44Native.conversationKeyCache[cacheKey] = secretData
        }

        return secretData
    }

    private func getConversationKey(privateKey: PrivateKey, publicKey: PublicKey) throws -> Data {
        let cacheKey = "\(privateKey.hex)|\(publicKey.hex)"

        // First attempt a lock-free read
        var cached: Data?
        NIP44Native.cacheQueue.sync {
            cached = NIP44Native.conversationKeyCache[cacheKey]
        }

        if let existing = cached {
            return existing
        }

        // Cache miss, derive a new session key
        let convKeyBytes = try conversationKey(privateKeyA: privateKey, publicKeyB: publicKey)
        let convKeyData = Data(convKeyBytes.bytes)

        // Write with a barrier to guarantee exclusive access for writes
        NIP44Native.cacheQueue.async(flags: .barrier) {
            NIP44Native.conversationKeyCache[cacheKey] = convKeyData
        }

        return convKeyData
    }

    func encryptWithKeys(plaintext: String, privateKeyA: String, publicKeyB: String) throws -> String {
        guard let privKeyA = parsePrivateKey(privateKeyA) else {
            throw NIP44Error.invalidPrivateKey
        }

        guard let pubKeyB = parsePublicKey(publicKeyB) else {
            throw NIP44Error.invalidPublicKey
        }

        do {
            let convKey = try getConversationKey(privateKey: privKeyA, publicKey: pubKeyB)
            return try encrypt(plaintext: plaintext, conversationKey: convKey)
        } catch {
            throw NIP44Error.encryptionFailed("NIP44v2 encryption failed: \(error.localizedDescription)")
        }
    }

    func decryptWithKeys(payload: String, privateKeyA: String, publicKeyB: String) throws -> String {
        guard let privKeyA = parsePrivateKey(privateKeyA) else {
            throw NIP44Error.invalidPrivateKey
        }

        guard let pubKeyB = parsePublicKey(publicKeyB) else {
            throw NIP44Error.invalidPublicKey
        }

        do {
            let convKey = try getConversationKey(privateKey: privKeyA, publicKey: pubKeyB)
            return try decrypt(payload: payload, conversationKey: convKey)
        } catch {
            throw NIP44Error.decryptionFailed("NIP44v2 decryption failed: \(error.localizedDescription)")
        }
    }

    func nip04Encrypt(plaintext: String, privateKey: String, publicKey: String) throws -> String {
        guard let privKey = parsePrivateKey(privateKey) else {
            throw NIP44Error.invalidPrivateKey
        }

        guard let pubKey = parsePublicKey(publicKey) else {
            throw NIP44Error.invalidPublicKey
        }

        do {
            // Use cached shared secret to avoid repeated calculation
            let sharedSecret = try getSharedSecretKey(privateKey: privKey, publicKey: pubKey)
            return try legacyEncrypt(content: plaintext, conversationKey: sharedSecret)
        } catch {
            throw NIP44Error.encryptionFailed("NIP04 encryption failed: \(error.localizedDescription)")
        }
    }

    func nip04Decrypt(ciphertext: String, privateKey: String, publicKey: String) throws -> String {
        guard let privKey = parsePrivateKey(privateKey) else {
            throw NIP44Error.invalidPrivateKey
        }

        guard let pubKey = parsePublicKey(publicKey) else {
            throw NIP44Error.invalidPublicKey
        }

        do {
            // Use cached shared secret to avoid repeated calculation
            let sharedSecret = try getSharedSecretKey(privateKey: privKey, publicKey: pubKey)
            return try legacyDecrypt(payload: ciphertext, conversationKey: sharedSecret)
        } catch {
            throw NIP44Error.decryptionFailed("NIP04 decryption failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Nostr Event Signing -----------------------------------------

    /// Sign a rumor JSON string (draft event produced by Rumor) with the provided private key and return the final signed event JSON string.
    /// - Parameters:
    ///   - rumorJsonString: A JSON string that represents an unsigned Nostr event (Rumor format).
    ///   - privateKey: The signer private key in hex or bech32 `nsec` format.
    /// - Returns: The signed event encoded as a JSON string ready to be sent to relays.
    func signRumorEvent(rumorJsonString: String, privateKey: String) throws -> String {
        guard let privKey = parsePrivateKey(privateKey) else {
            throw NIP44Error.invalidPrivateKey
        }

        do {
            // Leverage the new initializer added in NostrSDK
            let event = try NostrEvent(rumorJsonString: rumorJsonString, privkey: privKey)

            // Attempt to obtain JSON string representation. Prefer `json()` if the SDK provides it, otherwise fallback to encoder.
            if let jsonConvertible = event as? NSObject,
               jsonConvertible.responds(to: Selector("json")) {
                if let jsonString = jsonConvertible.value(forKey: "json") as? String {
                    return jsonString
                }
            }

            // Fallback: use JSONEncoder
            let encoder = JSONEncoder()
            encoder.outputFormatting = []
            let data = try encoder.encode(event)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw NIP44Error.signingFailed("Unable to encode event to UTF-8 string")
            }
            return jsonString
        } catch let error as NIP44Error {
            throw error
        } catch {
            throw NIP44Error.signingFailed(error.localizedDescription)
        }
    }

    private func parsePrivateKey(_ key: String) -> PrivateKey? {
        if key.hasPrefix("nsec") {
            guard let keypair = Keypair(nsec: key) else { return nil }
            return keypair.privateKey
        } else {
            return PrivateKey(hex: key)
        }
    }

    private func parsePublicKey(_ key: String) -> PublicKey? {
        if key.hasPrefix("npub") {
            return PublicKey(npub: key)
        } else {
            return PublicKey(hex: key)
        }
    }
}

extension Data {
    init?(hex: String) {
        let len = hex.count / 2
        var data = Data(capacity: len)
        for i in 0 ..< len {
            let j = hex.index(hex.startIndex, offsetBy: i * 2)
            let k = hex.index(j, offsetBy: 2)
            let bytes = hex[j ..< k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}

extension Data: @retroactive ContiguousBytes {
    public var bytes: [UInt8] {
        return withUnsafeBytes { bytesPointer in Array(bytesPointer) }
    }
}
