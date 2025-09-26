package com.aegis.app

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity: FlutterActivity() {
    
    private val CHANNEL = "com.aegis.app/intent"
    private var methodChannel: MethodChannel? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("Aegis", "MainActivity created")
        
        // Check if this is a simple nostrsigner intent that should be handled immediately
        if (intent.action == Intent.ACTION_VIEW) {
            val data: Uri? = intent.data
            if (data != null && data.scheme == "nostrsigner") {
                val path = data.path ?: ""
                val query = data.query ?: ""
                val host = data.host ?: ""
                
                // Check if this is a simple public key request
                val isSimpleRequest = (path.isEmpty() || path == "null") && 
                                    (query.isEmpty() || query == "null") &&
                                    (host.isEmpty() || host == "null") &&
                                    !data.toString().startsWith("nostrsigner:{")
                
                if (isSimpleRequest) {
                    Log.d("Aegis", "Simple public key request detected in onCreate, will handle after Flutter init")
                    // Don't call handleIntent here, let configureFlutterEngine handle it
                    return
                } else {
                    Log.d("Aegis", "Signing request detected in onCreate, will handle after Flutter init")
                    // Don't call handleIntent here, let configureFlutterEngine handle it
                    return
                }
            }
        }
        
        // Handle other intents normally
        handleIntent(intent)
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Set up method channel for intent communication
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getIntentData" -> {
                    val intentData = getIntentData()
                    result.success(intentData)
                }
                "closeActivity" -> {
                    finish()
                    result.success(null)
                }
                "setSignResult" -> {
                    val resultData = call.arguments as? Map<String, Any?>
                    if (resultData != null) {
                        setSignResult(resultData)
                    }
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        // Handle nostrsigner intents immediately after Flutter engine is ready
        if (intent.action == Intent.ACTION_VIEW) {
            val data: Uri? = intent.data
            if (data != null && data.scheme == "nostrsigner") {
                val path = data.path ?: ""
                val query = data.query ?: ""
                val host = data.host ?: ""
                
                // Check if this is a simple public key request
                val isSimpleRequest = (path.isEmpty() || path == "null") && 
                                    (query.isEmpty() || query == "null") &&
                                    (host.isEmpty() || host == "null") &&
                                    !data.toString().startsWith("nostrsigner:{")
                
                if (isSimpleRequest) {
                    Log.d("Aegis", "Handling simple public key request in configureFlutterEngine")
                    handleSimplePublicKeyRequest()
                } else {
                    Log.d("Aegis", "Handling signing request in configureFlutterEngine")
                    handleSigningRequest(data.toString())
                }
            }
        }
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        Log.d("Aegis", "New intent received: ${intent.action}")
        
        // Handle the new intent
        handleIntent(intent)
    }
    
    private fun handleIntent(intent: Intent) {
        try {
            when (intent.action) {
                Intent.ACTION_VIEW -> {
                    val data: Uri? = intent.data
                    if (data != null) {
                        Log.d("Aegis", "Received URI: $data")
                        
                        // Only handle non-nostrsigner intents here
                        // nostrsigner intents are handled in configureFlutterEngine
                        if (data.scheme != "nostrsigner") {
                            sendIntentDataToFlutter(data.toString())
                        }
                    } else {
                        Log.w("Aegis", "ACTION_VIEW intent has no data")
                    }
                }
                Intent.ACTION_SEND -> {
                    val type = intent.type
                    Log.d("Aegis", "Received ACTION_SEND with type: $type")
                    
                    when (type) {
                        "application/nostr+json" -> {
                            val text = intent.getStringExtra(Intent.EXTRA_TEXT)
                            Log.d("Aegis", "Received NIP-55 intent with data: $text")
                            if (text != null) {
                                sendIntentDataToFlutter(text)
                            } else {
                                Log.w("Aegis", "ACTION_SEND intent has no EXTRA_TEXT")
                            }
                        }
                        "text/plain" -> {
                            val text = intent.getStringExtra(Intent.EXTRA_TEXT)
                            Log.d("Aegis", "Received text intent with data: $text")
                            if (text != null && text.startsWith("nostrsigner:")) {
                                sendIntentDataToFlutter(text)
                            }
                        }
                        else -> {
                            Log.w("Aegis", "Unsupported ACTION_SEND type: $type")
                        }
                    }
                }
                Intent.ACTION_PROCESS_TEXT -> {
                    val text = intent.getStringExtra(Intent.EXTRA_PROCESS_TEXT)
                    Log.d("Aegis", "Received ACTION_PROCESS_TEXT with data: $text")
                    if (text != null && text.startsWith("nostrsigner:")) {
                        sendIntentDataToFlutter(text)
                    }
                }
                else -> {
                    Log.d("Aegis", "Unhandled intent action: ${intent.action}")
                }
            }
        } catch (e: Exception) {
            Log.e("Aegis", "Error handling intent: ${intent.action}", e)
            // Send error to Flutter for handling
            sendIntentDataToFlutter("error:${e.message}")
        }
    }
    
    private fun handleSimplePublicKeyRequest() {
        Log.d("Aegis", "Requesting public key from Flutter")
        methodChannel?.invokeMethod("getPublicKeyForIntent", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                val publicKey = result as? String
                if (publicKey != null) {
                    Log.d("Aegis", "Public key obtained: $publicKey")
                    
                    // Set result for calling app with public key in data
                    val resultIntent = Intent().apply {
                        setData(Uri.parse("nostrsigner://public_key?key=$publicKey"))
                        putExtra("public_key", publicKey)
                        putExtra("success", true)
                        putExtra("result", publicKey) // Add result field for OX Pro
                    }
                    setResult(RESULT_OK, resultIntent)
                } else {
                    Log.d("Aegis", "Failed to get public key")
                    setResult(RESULT_CANCELED)
                }
                
                // Close activity immediately after setting result
                Log.d("Aegis", "Closing activity after setting result")
                finish()
            }
            
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                Log.d("Aegis", "Error getting public key: $errorMessage")
                setResult(RESULT_CANCELED)
                Log.d("Aegis", "Closing activity after error")
                finish()
            }
            
            override fun notImplemented() {
                Log.d("Aegis", "getPublicKeyForIntent not implemented")
                setResult(RESULT_CANCELED)
                Log.d("Aegis", "Closing activity after not implemented")
                finish()
            }
        })
    }
    
    private fun handleSigningRequest(data: String) {
        try {
            Log.d("Aegis", "Processing signing request in background")
            
            // Get request type from Intent extras (following NIP-55 protocol)
            val requestType = intent.getStringExtra("type") ?: "sign_event"
            val requestId = intent.getStringExtra("id")
            val currentUser = intent.getStringExtra("current_user")
            val pubkey = intent.getStringExtra("pubkey")
            
            Log.d("Aegis", "Request type from Intent: $requestType")
            Log.d("Aegis", "Request ID: $requestId")
            Log.d("Aegis", "Current user: $currentUser")
            Log.d("Aegis", "Pubkey: $pubkey")
            
            when (requestType) {
                "get_public_key" -> {
                    // Handle public key request
                    handleSimplePublicKeyRequest()
                }
                "sign_event" -> {
                    // Handle signing requests - don't finish immediately, wait for result
                    sendIntentDataToFlutter(data, mapOf(
                        "type" to requestType,
                        "id" to requestId,
                        "current_user" to currentUser,
                        "pubkey" to pubkey
                    ))
                    // Don't call finish() here - let the result handler finish the activity
                }
                "nip04_encrypt", "nip04_decrypt", "nip44_encrypt", "nip44_decrypt" -> {
                    // Handle encryption/decryption requests
                    sendIntentDataToFlutter(data, mapOf(
                        "type" to requestType,
                        "id" to requestId,
                        "current_user" to currentUser,
                        "pubkey" to pubkey
                    ))
                    finish()
                }
                "decrypt_zap_event" -> {
                    // Handle zap event decryption
                    sendIntentDataToFlutter(data, mapOf(
                        "type" to requestType,
                        "id" to requestId,
                        "current_user" to currentUser
                    ))
                    finish()
                }
                else -> {
                    Log.w("Aegis", "Unknown request type: $requestType")
                    // Try to handle as generic request
                    sendIntentDataToFlutter(data, mapOf(
                        "type" to requestType,
                        "id" to requestId,
                        "current_user" to currentUser
                    ))
                    finish()
                }
            }
        } catch (e: Exception) {
            Log.e("Aegis", "Error processing signing request", e)
            setResult(RESULT_CANCELED)
            finish()
        }
    }
    
    private fun parseRequestType(data: String): String {
        return try {
            when {
                data.startsWith("nostrsigner:{") -> {
                    // Parse JSON to determine request type
                    val jsonStart = data.indexOf('{')
                    val jsonEnd = data.lastIndexOf('}')
                    if (jsonStart != -1 && jsonEnd != -1) {
                        val jsonStr = data.substring(jsonStart, jsonEnd + 1)
                        val json = org.json.JSONObject(jsonStr)
                        when {
                            json.has("event") -> "sign_event"
                            json.has("message") -> "sign_message"
                            json.has("nip04") -> "nip04_encrypt"
                            json.has("nip44") -> "nip44_encrypt"
                            json.has("zap") -> "decrypt_zap_event"
                            else -> "unknown"
                        }
                    } else {
                        "unknown"
                    }
                }
                data.contains("public_key") -> "public_key"
                data.contains("sign") -> "sign_event"
                data.contains("encrypt") -> "nip04_encrypt"
                data.contains("decrypt") -> "nip04_decrypt"
                else -> "unknown"
            }
        } catch (e: Exception) {
            Log.e("Aegis", "Error parsing request type", e)
            "unknown"
        }
    }

    private fun sendIntentDataToFlutter(data: String?, extras: Map<String, Any?> = emptyMap()) {
        try {
            if (methodChannel != null) {
                val args = mutableMapOf<String, Any?>()
                args["data"] = data
                args.putAll(extras)
                
                methodChannel?.invokeMethod("onIntentReceived", args)
                Log.d("Aegis", "Sent intent data to Flutter: ${data?.substring(0, minOf(100, data.length ?: 0))}...")
                Log.d("Aegis", "Intent extras: $extras")
            } else {
                Log.e("Aegis", "MethodChannel is null, cannot send data to Flutter")
            }
        } catch (e: Exception) {
            Log.e("Aegis", "Error sending intent data to Flutter", e)
        }
    }
    
    private fun getIntentData(): Map<String, Any?> {
        val intent = this.intent
        val data: Uri? = intent.data
        val action = intent.action
        
        return mapOf(
            "action" to action,
            "data" to data?.toString(),
            "scheme" to data?.scheme,
            "host" to data?.host,
            "path" to data?.path,
            "query" to data?.query
        )
    }
    
    private fun setSignResult(resultData: Map<String, Any?>) {
        try {
            val signature = resultData["result"] as? String
            val eventId = resultData["id"] as? String
            val signedEvent = resultData["event"] as? String
            
            Log.d("Aegis", "Setting sign result: signature=${signature?.substring(0, 16)}..., id=$eventId")
            
            // Create result Intent following NIP-55 protocol
            val resultIntent = Intent().apply {
                putExtra("result", signature)
                putExtra("id", eventId)
                putExtra("event", signedEvent)
            }
            
            setResult(Activity.RESULT_OK, resultIntent)
            Log.d("Aegis", "Sign result set successfully")
            
            // Close activity after setting result
            finish()
            
        } catch (e: Exception) {
            Log.e("Aegis", "Error setting sign result", e)
            setResult(Activity.RESULT_CANCELED)
            finish()
        }
    }

    override fun onResume() {
        super.onResume()
        // Foreground service is now started from AegisApplication.onCreate()
        // No need to start/stop service here anymore
    }

    override fun onPause() {
        super.onPause()
        // Foreground service is managed by AegisApplication
        // No need to stop service here anymore
    }

    override fun onDestroy() {
        super.onDestroy()
        // Foreground service is managed by AegisApplication
        // No need to stop service here anymore
    }
}