package com.aegis.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "aegis_nostr"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "nip04Encrypt" -> {
                    val plaintext = call.argument<String>("plaintext")
                    val privateKey = call.argument<String>("privateKey")
                    val publicKey = call.argument<String>("publicKey")
                    
                    if (plaintext != null && privateKey != null && publicKey != null) {
                        val encrypted = NostrCryptoUtils.encryptNIP04(plaintext, privateKey, publicKey)
                        result.success(encrypted)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                    }
                }
                "nip04Decrypt" -> {
                    val ciphertext = call.argument<String>("ciphertext")
                    val privateKey = call.argument<String>("privateKey")
                    val publicKey = call.argument<String>("publicKey")
                    
                    if (ciphertext != null && privateKey != null && publicKey != null) {
                        val decrypted = NostrCryptoUtils.decryptNIP04(ciphertext, privateKey, publicKey)
                        result.success(decrypted)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                    }
                }
                "nip44Encrypt" -> {
                    val plaintext = call.argument<String>("plaintext")
                    val privateKey = call.argument<String>("privateKey")
                    val publicKey = call.argument<String>("publicKey")
                    
                    if (plaintext != null && privateKey != null && publicKey != null) {
                        val encrypted = NostrCryptoUtils.encryptNIP44(plaintext, privateKey, publicKey)
                        result.success(encrypted)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                    }
                }
                "nip44Decrypt" -> {
                    val ciphertext = call.argument<String>("ciphertext")
                    val privateKey = call.argument<String>("privateKey")
                    val publicKey = call.argument<String>("publicKey")
                    
                    if (ciphertext != null && privateKey != null && publicKey != null) {
                        val decrypted = NostrCryptoUtils.decryptNIP44(ciphertext, privateKey, publicKey)
                        result.success(decrypted)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                    }
                }
                "signRumorEvent" -> {
                    val rumorJsonString = call.argument<String>("rumorJsonString")
                    val privateKey = call.argument<String>("privateKey")
                    
                    if (rumorJsonString != null && privateKey != null) {
                        val signed = NostrCryptoUtils.signRumorEvent(rumorJsonString, privateKey)
                        result.success(signed)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    override fun onResume() {
        super.onResume()
        // Start foreground service when app is resumed
        ForegroundService.startService(this)
    }
    
    override fun onPause() {
        super.onPause()
        // Keep foreground service running even when app is paused
        // This ensures the app stays connected in background
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Stop foreground service when app is destroyed
        ForegroundService.stopService(this)
    }
}
