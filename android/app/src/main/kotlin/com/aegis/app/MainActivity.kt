package com.aegis.app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    
    private val CHANNEL = "com.aegis.app/intent"
    private var methodChannel: MethodChannel? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("Aegis", "MainActivity created")
        
        // Handle initial intent if app was launched via intent
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
                else -> {
                    result.notImplemented()
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
        when (intent.action) {
            Intent.ACTION_VIEW -> {
                val data: Uri? = intent.data
                if (data != null) {
                    Log.d("Aegis", "Received URI: $data")
                    
                    // Check if this is a simple nostrsigner: intent (no specific action)
                    val path = data.path ?: ""
                    val query = data.query ?: ""
                    val host = data.host ?: ""
                    
                    // Handle nostrsigner:null or simple nostrsigner: intents
                    if (data.scheme == "nostrsigner" && 
                        (path.isEmpty() || path == "null") && 
                        (query.isEmpty() || query == "null") &&
                        (host.isEmpty() || host == "null")) {
                        Log.d("Aegis", "Simple nostrsigner intent detected, requesting public key")
                        
                        // Request public key from Flutter and return result to calling app
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
                                
                                // Close activity after setting result
                                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                                    Log.d("Aegis", "Closing activity after setting result")
                                    finish()
                                }, 500) // Shorter delay since we have the result
                            }
                            
                            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                                Log.d("Aegis", "Error getting public key: $errorMessage")
                                setResult(RESULT_CANCELED)
                                
                                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                                    Log.d("Aegis", "Closing activity after error")
                                    finish()
                                }, 500)
                            }
                            
                            override fun notImplemented() {
                                Log.d("Aegis", "getPublicKeyForIntent not implemented")
                                setResult(RESULT_CANCELED)
                                
                                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                                    Log.d("Aegis", "Closing activity after not implemented")
                                    finish()
                                }, 500)
                            }
                        })
                        return
                    }
                    
                    sendIntentDataToFlutter(data.toString())
                }
            }
            Intent.ACTION_SEND -> {
                val type = intent.type
                if (type == "application/nostr+json") {
                    val text = intent.getStringExtra(Intent.EXTRA_TEXT)
                    Log.d("Aegis", "Received NIP-55 intent with data: $text")
                    sendIntentDataToFlutter(text)
                }
            }
            else -> {
                Log.d("Aegis", "Unhandled intent action: ${intent.action}")
            }
        }
    }
    
    private fun sendIntentDataToFlutter(data: String?) {
        methodChannel?.invokeMethod("onIntentReceived", mapOf("data" to data))
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

    override fun onResume() {
        super.onResume()
        ForegroundService.startService(this)
    }

    override fun onPause() {
        super.onPause()
    }

    override fun onDestroy() {
        super.onDestroy()
        ForegroundService.stopService(this)
    }
}