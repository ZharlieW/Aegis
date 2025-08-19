package com.example.aegis

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.aegis.service.AegisWebSocketService

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.channel.shared.data"
    private val CRYPTO_CHANNEL = "aegis_nostr"
    private val SERVICE_CHANNEL = "aegis_service_control"
    private var methodChannel: MethodChannel? = null
    private var cryptoMethodChannel: MethodChannel? = null
    private var serviceMethodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Original method channel for scheme handling
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            // Handle scheme-related method calls if needed
            result.notImplemented()
        }
        
        // Crypto method channel for NIP04/NIP44 encryption/decryption
        cryptoMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CRYPTO_CHANNEL)
        cryptoMethodChannel?.setMethodCallHandler { call, result ->
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
                "detectEncryptionType" -> {
                    val content = call.argument<String>("content")
                    if (content != null) {
                        val type = NostrCryptoUtils.detectEncryptionType(content)
                        result.success(type)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing content argument", null)
                    }
                }
                "signRumorEvent" -> {
                    val rumorJsonString = call.argument<String>("rumorJsonString")
                    val privateKey = call.argument<String>("privateKey")
                    
                    if (rumorJsonString != null && privateKey != null) {
                        try {
                            val signed = NostrCryptoUtils.signRumorEvent(rumorJsonString, privateKey)
                            result.success(signed)
                        } catch (e: Exception) {
                            android.util.Log.e("MainActivity", "Event signing failed: ${e.message}", e)
                            result.error("SIGNING_ERROR", "Event signing failed: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        // Service control channel
        serviceMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SERVICE_CHANNEL)
        serviceMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startWebSocketService" -> {
                    AegisWebSocketService.startService(this)
                    result.success(true)
                }
                "stopWebSocketService" -> {
                    AegisWebSocketService.stopService(this)
                    result.success(true)
                }
                "requestBatteryOptimizationWhitelist" -> {
                    requestBatteryOptimizationWhitelist()
                    result.success(true)
                }
                "checkBatteryOptimizationStatus" -> {
                    val isIgnoring = isBatteryOptimizationIgnored()
                    result.success(isIgnoring)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        val action = intent.action
        val data = intent.data
        
        if (Intent.ACTION_VIEW == action && data != null) {
            val schemeUrl = data.toString()
            methodChannel?.invokeMethod("onSchemeCalled", schemeUrl)
        }
    }
    
    private fun requestBatteryOptimizationWhitelist() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!powerManager.isIgnoringBatteryOptimizations(packageName)) {
                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = Uri.parse("package:$packageName")
                }
                try {
                    startActivity(intent)
                } catch (e: Exception) {
                    // Fallback to settings page
                    val settingsIntent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                    startActivity(settingsIntent)
                }
            }
        }
    }

    private fun isBatteryOptimizationIgnored(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            powerManager.isIgnoringBatteryOptimizations(packageName)
        } else {
            true // Not applicable for older versions
        }
    }
} 