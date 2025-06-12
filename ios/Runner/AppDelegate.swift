import UIKit
import Flutter
import NostrSDK
import CryptoKit
import CryptoSwift

@main
@objc class AppDelegate: FlutterAppDelegate, EventCreating {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        

        let channel = FlutterMethodChannel(name: "aegis_nostr", 
                                         binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self.handleNostrMethodCall(call, result: result)
        })
        
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
        case "encryptWithKeys":
            handleNIP44EncryptWithKeys(args: args, result: result)
        case "decryptWithKeys":
            handleNIP44DecryptWithKeys(args: args, result: result)
        case "nip04Encrypt":
            handleNIP04Encrypt(args: args, result: result)
        case "nip04Decrypt":
            handleNIP04Decrypt(args: args, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleNIP44Encrypt(args: [String: Any], result: @escaping FlutterResult) {
        do {
            let encrypted = try NIP44Native.shared.encryptWithConversationKey(
                plaintext: args["plaintext"] as! String,
                conversationKeyHex: args["conversationKey"] as! String
            )
            result(encrypted)
        } catch let error as NIP44Native.NIP44Error {
            result(FlutterError(code: "NIP44_ERROR", message: error.localizedDescription, details: nil))
        } catch {
            result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleNIP44Decrypt(args: [String: Any], result: @escaping FlutterResult) {
        do {
            let decrypted = try NIP44Native.shared.decryptWithConversationKey(
                payload: args["payload"] as! String,
                conversationKeyHex: args["conversationKey"] as! String
            )
            result(decrypted)
        } catch let error as NIP44Native.NIP44Error {
            result(FlutterError(code: "NIP44_ERROR", message: error.localizedDescription, details: nil))
        } catch {
            result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleNIP44EncryptWithKeys(args: [String: Any], result: @escaping FlutterResult) {
        do {
            let encrypted = try NIP44Native.shared.encryptWithKeys(
                plaintext: args["plaintext"] as! String,
                privateKeyA: args["privateKeyA"] as! String,
                publicKeyB: args["publicKeyB"] as! String
            )
            result(encrypted)
        } catch let error as NIP44Native.NIP44Error {
            result(FlutterError(code: "NIP44_ERROR", message: error.localizedDescription, details: nil))
        } catch {
            result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleNIP44DecryptWithKeys(args: [String: Any], result: @escaping FlutterResult) {
        do {
            let decrypted = try NIP44Native.shared.decryptWithKeys(
                payload: args["payload"] as! String,
                privateKeyA: args["privateKeyA"] as! String,
                publicKeyB: args["publicKeyB"] as! String
            )
            result(decrypted)
        } catch let error as NIP44Native.NIP44Error {
            result(FlutterError(code: "NIP44_ERROR", message: error.localizedDescription, details: nil))
        } catch {
            result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleNIP04Encrypt(args: [String: Any], result: @escaping FlutterResult) {
        do {
            let encrypted = try NIP44Native.shared.nip04Encrypt(
                plaintext: args["plaintext"] as! String,
                privateKey: args["privateKey"] as! String,
                publicKey: args["publicKey"] as! String
            )
            result(encrypted)
        } catch let error as NIP44Native.NIP44Error {
            result(FlutterError(code: "NIP04_ERROR", message: error.localizedDescription, details: nil))
        } catch {
            result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleNIP04Decrypt(args: [String: Any], result: @escaping FlutterResult) {
        do {
            let decrypted = try NIP44Native.shared.nip04Decrypt(
                ciphertext: args["ciphertext"] as! String,
                privateKey: args["privateKey"] as! String,
                publicKey: args["publicKey"] as! String
            )
            result(decrypted)
        } catch let error as NIP44Native.NIP44Error {
            result(FlutterError(code: "NIP04_ERROR", message: error.localizedDescription, details: nil))
        } catch {
            result(FlutterError(code: "UNKNOWN_ERROR", message: error.localizedDescription, details: nil))
        }
    }

    override func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
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
            case .encryptionFailed(let message):
                return "Encryption failed: \(message)"
            case .decryptionFailed(let message):
                return "decryption failure: \(message)"
            case .keyParsingFailed(let message):
                return "Key parsing failed.: \(message)"
            }
        }
    }
    

    func encryptWithConversationKey(plaintext: String, conversationKeyHex: String) throws -> String {
        guard let conversationKeyData = Data(hex: conversationKeyHex) else {
            throw NIP44Error.invalidConversationKey
        }
        
        do {
         
            return try nip44Encrypt(plaintext: plaintext, conversationKey: conversationKeyData)
        } catch {
            throw NIP44Error.encryptionFailed("NIP44 encryption with conversation key failed: \(error.localizedDescription)")
        }
    }
    
  
    func decryptWithConversationKey(payload: String, conversationKeyHex: String) throws -> String {
      
        guard let conversationKeyData = Data(hex: conversationKeyHex) else {
            throw NIP44Error.invalidConversationKey
        }
        
        do {
         
            return try nip44Decrypt(payload: payload, conversationKey: conversationKeyData)
        } catch {
            throw NIP44Error.decryptionFailed("NIP44 decryption with conversation key failed: \(error.localizedDescription)")
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
    
    private func nip44Encrypt(plaintext: String, conversationKey: Data, nonce: Data? = nil) throws -> String {
        let nonceData: Data
        if let nonce = nonce {
            nonceData = nonce
        } else {
           
            var randomBytes = Data(count: 32)
            let result = randomBytes.withUnsafeMutableBytes {
                SecRandomCopyBytes(kSecRandomDefault, 32, $0.bindMemory(to: UInt8.self).baseAddress!)
            }
            guard result == errSecSuccess else {
                throw NIP44Error.encryptionFailed("Failed to generate random nonce")
            }
            nonceData = randomBytes
        }
        
        let messageKeys = try getMessageKeys(conversationKey: conversationKey, nonce: nonceData)
        let padded = try pad(plaintext)
        let paddedBytes = toBytes(from: padded)
        
        let chaChaKey = toBytes(from: messageKeys.chaChaKey)
        let chaChaNonce = toBytes(from: messageKeys.chaChaNonce)
        
        let ciphertext = try ChaCha20(key: chaChaKey, iv: chaChaNonce).encrypt(paddedBytes)
        let ciphertextData = Data(ciphertext)
        
        let mac = try hmacAad(key: messageKeys.hmacKey, message: ciphertextData, aad: nonceData)
        
        let data = Data([2]) + nonceData + ciphertextData + mac
        return data.base64EncodedString()
    }
    
    private func nip44Decrypt(payload: String, conversationKey: Data) throws -> String {
        let decodedPayload = try decodePayload(payload)
        let nonce = decodedPayload.nonce
        let ciphertext = decodedPayload.ciphertext
        let ciphertextBytes = toBytes(from: ciphertext)
        let mac = decodedPayload.mac
        
        let messageKeys = try getMessageKeys(conversationKey: conversationKey, nonce: nonce)
        
        let calculatedMac = try hmacAad(key: messageKeys.hmacKey, message: ciphertext, aad: nonce)
        
        guard calculatedMac == mac else {
            throw NIP44Error.decryptionFailed("Invalid MAC")
        }
        
        let chaChaNonce = toBytes(from: messageKeys.chaChaNonce)
        let chaChaKey = toBytes(from: messageKeys.chaChaKey)
        
        let paddedPlaintext = try ChaCha20(key: chaChaKey, iv: chaChaNonce).decrypt(ciphertextBytes)
        let paddedPlaintextData = Data(paddedPlaintext.bytes)
        
        return try unpad(paddedPlaintextData)
    }
    
    private struct MessageKeys {
        let chaChaKey: Data
        let chaChaNonce: Data
        let hmacKey: Data
    }
    
    private struct DecodedPayload {
        let nonce: Data
        let ciphertext: Data
        let mac: Data
    }
    
    private func getMessageKeys(conversationKey: Data, nonce: Data) throws -> MessageKeys {
        guard conversationKey.count == 32 else {
            throw NIP44Error.encryptionFailed("Invalid conversation key length")
        }
        
        guard nonce.count == 32 else {
            throw NIP44Error.encryptionFailed("Invalid nonce length")
        }
        
        let keys = CryptoKit.HKDF<CryptoKit.SHA256>.expand(pseudoRandomKey: conversationKey, info: nonce, outputByteCount: 76)
        let keysBytes = keys.bytes
        
        let chaChaKey = Data(keysBytes[0..<32])
        let chaChaNonce = Data(keysBytes[32..<44])
        let hmacKey = Data(keysBytes[44..<76])
        
        return MessageKeys(chaChaKey: chaChaKey, chaChaNonce: chaChaNonce, hmacKey: hmacKey)
    }
    
    private func pad(_ plaintext: String) throws -> Data {
        guard let unpadded = plaintext.data(using: .utf8) else {
            throw NIP44Error.encryptionFailed("UTF8 encoding failed")
        }
        
        let unpaddedLength = unpadded.count
        
        guard 1...65535 ~= unpaddedLength else {
            throw NIP44Error.encryptionFailed("Invalid plaintext length")
        }
        
        var prefix = Data(count: 2)
        prefix.withUnsafeMutableBytes { (ptr: UnsafeMutableRawBufferPointer) in
            ptr.storeBytes(of: UInt16(unpaddedLength).bigEndian, as: UInt16.self)
        }
        
        let paddedLength = try calculatePaddedLength(unpaddedLength)
        let suffix = Data(count: paddedLength - unpaddedLength)
        
        return prefix + unpadded + suffix
    }
    
    private func unpad(_ padded: Data) throws -> String {
        guard padded.count >= 2 else {
            throw NIP44Error.decryptionFailed("Invalid padding")
        }
        
        let unpaddedLength = (Int(padded[0]) << 8) | Int(padded[1])
        
        guard 2+unpaddedLength <= padded.count else {
            throw NIP44Error.decryptionFailed("Invalid padding")
        }
        
        let unpadded = toBytes(from: padded)[2..<2+unpaddedLength]
        let paddedLength = try calculatePaddedLength(unpaddedLength)
        
        guard unpaddedLength > 0,
              unpadded.count == unpaddedLength,
              padded.count == 2 + paddedLength,
              let result = String(data: Data(unpadded), encoding: .utf8) else {
            throw NIP44Error.decryptionFailed("Invalid padding")
        }
        
        return result
    }
    
    private func calculatePaddedLength(_ unpaddedLength: Int) throws -> Int {
        guard unpaddedLength > 0 else {
            throw NIP44Error.encryptionFailed("Invalid unpadded length")
        }
        if unpaddedLength <= 32 {
            return 32
        }
        
        let nextPower = 1 << (Int(floor(log2(Double(unpaddedLength) - 1))) + 1)
        let chunk: Int
        
        if nextPower <= 256 {
            chunk = 32
        } else {
            chunk = nextPower / 8
        }
        
        return chunk * (Int(floor((Double(unpaddedLength) - 1) / Double(chunk))) + 1)
    }
    
    private func decodePayload(_ payload: String) throws -> DecodedPayload {
        let payloadLength = payload.count
        
        guard payloadLength > 0 && payload.first != "#" else {
            throw NIP44Error.decryptionFailed("Unknown version")
        }
        guard 132...87472 ~= payloadLength else {
            throw NIP44Error.decryptionFailed("Invalid payload length")
        }
        
        guard let data = Data(base64Encoded: payload) else {
            throw NIP44Error.decryptionFailed("Base64 decoding failed")
        }
        
        let dataLength = data.count
        
        guard 99...65603 ~= dataLength else {
            throw NIP44Error.decryptionFailed("Invalid data length")
        }
        
        guard let version = data.first else {
            throw NIP44Error.decryptionFailed("Unknown version")
        }
        
        guard version == 2 else {
            throw NIP44Error.decryptionFailed("Unknown version \(version)")
        }
        
        let nonce = data[data.index(data.startIndex, offsetBy: 1)..<data.index(data.startIndex, offsetBy: 33)]
        let ciphertext = data[data.index(data.startIndex, offsetBy: 33)..<data.index(data.startIndex, offsetBy: dataLength - 32)]
        let mac = data[data.index(data.startIndex, offsetBy: dataLength - 32)..<data.index(data.startIndex, offsetBy: dataLength)]
        
        return DecodedPayload(nonce: nonce, ciphertext: ciphertext, mac: mac)
    }
    
    private func hmacAad(key: Data, message: Data, aad: Data) throws -> Data {
        guard aad.count == 32 else {
            throw NIP44Error.encryptionFailed("AAD must be 32 bytes")
        }
        
        let combined = aad + message
        
        return Data(CryptoKit.HMAC<CryptoKit.SHA256>.authenticationCode(for: combined, using: SymmetricKey(data: key)))
    }
    
    private func toBytes(from data: Data) -> [UInt8] {
        data.withUnsafeBytes { bytesPointer in Array(bytesPointer) }
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
        for i in 0..<len {
            let j = hex.index(hex.startIndex, offsetBy: i*2)
            let k = hex.index(j, offsetBy: 2)
            let bytes = hex[j..<k]
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

