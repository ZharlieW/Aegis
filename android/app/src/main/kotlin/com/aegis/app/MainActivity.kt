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
        Log.d("Aegis", "onCreate - Intent action: ${intent.action}")
        Log.d("Aegis", "onCreate - Intent data: ${intent.data}")
        Log.d("Aegis", "onCreate - Intent extras: ${intent.extras?.keySet()}")
        
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
        Log.d("Aegis", "configureFlutterEngine - Intent action: ${intent.action}")
        Log.d("Aegis", "configureFlutterEngine - Intent data: ${intent.data}")
        Log.d("Aegis", "configureFlutterEngine - Intent extras: ${intent.extras?.keySet()}")
        Log.d("Aegis", "configureFlutterEngine - Intent flags: ${intent.flags}")
        
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
                    // Send to Flutter for processing instead of handling locally
                    sendIntentDataToFlutter(data.toString(), mapOf(
                        "type" to "get_public_key",
                        "id" to intent.getStringExtra("id"),
                        "current_user" to intent.getStringExtra("current_user"),
                        "pubkey" to intent.getStringExtra("pubkey")
                    ))
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
            
            // Send all requests to Flutter for processing
            sendIntentDataToFlutter(data, mapOf(
                "type" to requestType,
                "id" to requestId,
                "current_user" to currentUser,
                "pubkey" to pubkey
            ))
            
            // For sign_event requests, don't finish immediately - let the result handler finish the activity
            // For other requests, finish immediately
            if (requestType != "sign_event") {
                finish()
            }
        } catch (e: Exception) {
            Log.e("Aegis", "Error processing signing request", e)
            setResult(RESULT_CANCELED)
            finish()
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
    
    
    private fun setSignResult(resultData: Map<String, Any?>) {
        try {
            val result = resultData["result"] as? String
            val eventId = resultData["id"] as? String
            val signedEvent = resultData["event"] as? String
            val packageName = resultData["package"] as? String
            
            Log.d("Aegis", "Setting sign result: result=${result?.substring(0, 16)}..., id=$eventId, package=$packageName")
            
            // Create result Intent following NIP-55 protocol
            val resultIntent = Intent().apply {
                putExtra("result", result)
                putExtra("id", eventId)
                putExtra("event", signedEvent)
                putExtra("package", packageName)
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

}