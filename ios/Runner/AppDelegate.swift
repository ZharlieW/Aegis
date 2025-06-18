import CryptoKit
import Flutter
import NostrSDK
import UIKit

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
            }
        }
    }

    func encryptWithKeys(plaintext: String, privateKeyA: String, publicKeyB: String) throws -> String {
        guard let privKeyA = parsePrivateKey(privateKeyA) else {
            throw NIP44Error.invalidPrivateKey
        }

        guard let pubKeyB = parsePublicKey(publicKeyB) else {
            throw NIP44Error.invalidPublicKey
        }

        do {
            return try encrypt(plaintext: plaintext, privateKeyA: privKeyA, publicKeyB: pubKeyB)
        } catch {
            throw NIP44Error.encryptionFailed("NostrSDK encryption failed: \(error.localizedDescription)")
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
            return try decrypt(payload: payload, privateKeyA: privKeyA, publicKeyB: pubKeyB)
        } catch {
            throw NIP44Error.decryptionFailed("NostrSDK decryption failed: \(error.localizedDescription)")
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
            return try legacyEncrypt(content: plaintext, privateKey: privKey, publicKey: pubKey)
        } catch {
            throw NIP44Error.encryptionFailed("NostrSDK NIP04 encryption failed: \(error.localizedDescription)")
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
            return try legacyDecrypt(encryptedContent: ciphertext, privateKey: privKey, publicKey: pubKey)
        } catch {
            throw NIP44Error.decryptionFailed("NostrSDK NIP04 decryption failed: \(error.localizedDescription)")
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
