package com.example.aegis

import android.util.Log
// Quartz library imports for NIP-04 and NIP-44 encryption
import com.vitorpamplona.quartz.nip04Dm.crypto.Nip04
import com.vitorpamplona.quartz.nip44Encryption.Nip44
import com.vitorpamplona.quartz.utils.Hex
// Event signing imports
import com.vitorpamplona.quartz.nip01Core.core.Event
import com.vitorpamplona.quartz.nip01Core.crypto.Nip01
import org.json.JSONObject
import org.json.JSONArray
import java.security.MessageDigest
import java.nio.charset.StandardCharsets

object NostrCryptoUtils {
    private const val TAG = "NostrCryptoUtils"
    
    /**
     * Validate hexadecimal string format
     */
    private fun isValidHexString(hex: String, expectedLength: Int): Boolean {
        if (hex.length != expectedLength) return false
        return hex.matches(Regex("^[0-9a-fA-F]+$"))
    }

    /**
     * Encrypt plaintext using NIP-04 (AES-256-CBC)
     */
    fun encryptNIP04(plaintext: String, privateKey: String, publicKey: String): String? {
        return try {
            if (!isValidHexString(privateKey, 64) || !isValidHexString(publicKey, 64)) {
                Log.e(TAG, "Invalid key format for NIP-04 encryption")
                return null
            }
            
            Nip04.encrypt(plaintext, Hex.decode(privateKey), Hex.decode(publicKey))
        } catch (e: Exception) {
            Log.e(TAG, "NIP-04 encryption failed", e)
            null
        }
    }

    /**
     * Decrypt ciphertext using NIP-04 (AES-256-CBC)
     */
    fun decryptNIP04(ciphertext: String, privateKey: String, publicKey: String): String? {
        return try {
            if (!isValidHexString(privateKey, 64) || !isValidHexString(publicKey, 64)) {
                Log.e(TAG, "Invalid key format for NIP-04 decryption")
                return null
            }
            
            Nip04.decrypt(ciphertext, Hex.decode(privateKey), Hex.decode(publicKey))
        } catch (e: Exception) {
            Log.e(TAG, "NIP-04 decryption failed", e)
            null
        }
    }

    /**
     * Encrypt plaintext using NIP-44 (ChaCha20-Poly1305)
     */
    fun encryptNIP44(plaintext: String, privateKey: String, publicKey: String): String? {
        return try {
            if (!isValidHexString(privateKey, 64) || !isValidHexString(publicKey, 64)) {
                Log.e(TAG, "Invalid key format for NIP-44 encryption")
                return null
            }
            
            Nip44.encrypt(plaintext, Hex.decode(privateKey), Hex.decode(publicKey)).encodePayload()
        } catch (e: Exception) {
            Log.e(TAG, "NIP-44 encryption failed", e)
            null
        }
    }

    /**
     * Decrypt ciphertext using NIP-44 (ChaCha20-Poly1305)
     */
    fun decryptNIP44(ciphertext: String, privateKey: String, publicKey: String): String? {
        return try {
            if (!isValidHexString(privateKey, 64) || !isValidHexString(publicKey, 64)) {
                Log.e(TAG, "Invalid key format for NIP-44 decryption")
                return null
            }
            
            Nip44.decrypt(ciphertext, Hex.decode(privateKey), Hex.decode(publicKey))
        } catch (e: Exception) {
            Log.e(TAG, "NIP-44 decryption failed", e)
            null
        }
    }

    /**
     * Auto-detect encryption type
     */
    fun detectEncryptionType(encryptedContent: String): String {
        return when {
            encryptedContent.startsWith("nip44_") -> "nip44"
            encryptedContent.contains("?iv=") -> "nip04"
            else -> "unknown"
        }
    }

    /**
     * Sign a rumor JSON string with the provided private key
     */
    fun signRumorEvent(rumorJsonString: String, privateKey: String): String? {
        return try {
            // Validate input parameters
            if (!isValidHexString(privateKey, 64)) {
                Log.e(TAG, "Invalid private key format for event signing")
                return null
            }
            
            if (rumorJsonString.isBlank()) {
                Log.e(TAG, "Invalid rumor JSON string")
                return null
            }
            
            // Parse the rumor JSON
            val rumorJson = JSONObject(rumorJsonString)
            
            // Log warnings for unexpected fields
            if (rumorJson.has("id")) {
                Log.w(TAG, "WARNING: Input rumor already has ID field")
            }
            if (rumorJson.has("sig") && rumorJson.optString("sig").isNotEmpty()) {
                Log.w(TAG, "WARNING: Input rumor already has signature")
            }
            
            // Extract event data
            val kind = rumorJson.optInt("kind", 1)
            val content = rumorJson.optString("content", "")
            val createdAt = rumorJson.optLong("created_at", System.currentTimeMillis() / 1000)
            
            // Convert tags from JSON to Array format
            val tagsJsonArray = if (rumorJson.has("tags")) {
                rumorJson.getJSONArray("tags")
            } else {
                JSONArray()
            }
            
            // Generate public key from private key
            val privateKeyBytes = Hex.decode(privateKey)
            val generatedPublicKeyBytes = Nip01.pubKeyCreate(privateKeyBytes)
            val generatedPublicKeyHex = Hex.encode(generatedPublicKeyBytes).lowercase()
            
            // Check if rumor has existing pubkey
            val inputPubkey = rumorJson.optString("pubkey", "")
            val finalPubkey = if (inputPubkey.isNotEmpty() && isValidHexString(inputPubkey, 64)) {
                if (inputPubkey.lowercase() != generatedPublicKeyHex) {
                    Log.w(TAG, "WARNING: Input pubkey does not match generated pubkey")
                }
                inputPubkey.lowercase()
            } else {
                generatedPublicKeyHex
            }
            
            // Use standard implementation for reliable event signing
            standardEventSigning(finalPubkey, createdAt, kind, content, tagsJsonArray, privateKeyBytes)
            
        } catch (e: Exception) {
            Log.e(TAG, "Event signing failed", e)
            null
        }
    }
    
    /**
     * Standard manual event signing implementation following iOS/Nostr standard
     */
    private fun standardEventSigning(
        publicKeyHex: String,
        createdAt: Long,
        kind: Int,
        content: String,
        tagsArray: JSONArray,
        privateKeyBytes: ByteArray
    ): String? {
        return try {
            // Create serialization array following Nostr standard: [0, pubkey, created_at, kind, tags, content]
            val serializedEvent = createExactDartJsonSerialization(
                publicKeyHex.lowercase(),
                createdAt,
                kind,
                tagsArray,
                content
            )
            
            // Calculate SHA-256 hash of serialized event (this becomes the event ID)
            val eventIdBytes = MessageDigest.getInstance("SHA-256")
                .digest(serializedEvent.toByteArray(StandardCharsets.UTF_8))
            val eventId = Hex.encode(eventIdBytes).lowercase()
            
            // Sign the event ID hash using Schnorr signature (NIP-01)
            val signatureBytes = Nip01.sign(eventIdBytes, privateKeyBytes)
            val signature = Hex.encode(signatureBytes).lowercase()
            
            // Validate signature length (128 hex chars = 64 bytes)
            if (signature.length != 128) {
                Log.e(TAG, "Invalid signature length: ${signature.length}, expected 128")
                return null
            }
            
            // Create final signed event JSON
            createFinalEventJson(
                eventId,
                publicKeyHex.lowercase(),
                createdAt,
                kind,
                tagsArray,
                content,
                signature
            )
            
        } catch (e: Exception) {
            Log.e(TAG, "Standard event signing failed", e)
            null
        }
    }
    
    /**
     * Create JSON serialization that exactly matches Dart's json.encode() output
     */
    private fun createExactDartJsonSerialization(
        pubkey: String,
        createdAt: Long,
        kind: Int,
        tagsArray: JSONArray,
        content: String
    ): String {
        val sb = StringBuilder()
        
        // Start array: [
        sb.append("[")
        
        // Element 0: 0
        sb.append("0")
        sb.append(",")
        
        // Element 1: pubkey (quoted string)
        sb.append("\"").append(pubkey).append("\"")
        sb.append(",")
        
        // Element 2: created_at (number)
        sb.append(createdAt)
        sb.append(",")
        
        // Element 3: kind (number)
        sb.append(kind)
        sb.append(",")
        
        // Element 4: tags (array of arrays)
        sb.append(serializeTagsForDart(tagsArray))
        sb.append(",")
        
        // Element 5: content (quoted string with minimal escaping)
        sb.append("\"").append(escapeForDartJson(content)).append("\"")
        
        // End array: ]
        sb.append("]")
        
        return sb.toString()
    }
    
    /**
     * Serialize tags array to match Dart's format exactly
     */
    private fun serializeTagsForDart(tagsArray: JSONArray): String {
        val sb = StringBuilder()
        sb.append("[")
        
        for (i in 0 until tagsArray.length()) {
            if (i > 0) sb.append(",")
            
            val tagArray = tagsArray.getJSONArray(i)
            sb.append("[")
            
            for (j in 0 until tagArray.length()) {
                if (j > 0) sb.append(",")
                sb.append("\"").append(escapeForDartJson(tagArray.getString(j))).append("\"")
            }
            
            sb.append("]")
        }
        
        sb.append("]")
        return sb.toString()
    }
    
    /**
     * Escape string for JSON exactly like Dart does
     * Key: Dart does NOT escape forward slashes by default
     */
    private fun escapeForDartJson(input: String): String {
        return input
            .replace("\\", "\\\\")  // Escape backslashes
            .replace("\"", "\\\"")  // Escape quotes
            .replace("\b", "\\b")   // Escape backspace
            .replace("\u000c", "\\f") // Escape form feed
            .replace("\n", "\\n")   // Escape newline
            .replace("\r", "\\r")   // Escape carriage return
            .replace("\t", "\\t")   // Escape tab
            // NOTE: Do NOT escape forward slashes (/) - this is the key difference!
    }
    
    /**
     * Create final event JSON manually to match Dart formatting exactly
     */
    private fun createFinalEventJson(
        id: String,
        pubkey: String,
        createdAt: Long,
        kind: Int,
        tagsArray: JSONArray,
        content: String,
        sig: String
    ): String {
        val sb = StringBuilder()
        
        sb.append("{")
        sb.append("\"id\":\"").append(id).append("\"")
        sb.append(",")
        sb.append("\"pubkey\":\"").append(pubkey).append("\"")
        sb.append(",")
        sb.append("\"created_at\":").append(createdAt)
        sb.append(",")
        sb.append("\"kind\":").append(kind)
        sb.append(",")
        sb.append("\"tags\":").append(serializeTagsForDart(tagsArray))
        sb.append(",")
        sb.append("\"content\":\"").append(escapeForDartJson(content)).append("\"")
        sb.append(",")
        sb.append("\"sig\":\"").append(sig).append("\"")
        sb.append("}")
        
        return sb.toString()
    }
} 