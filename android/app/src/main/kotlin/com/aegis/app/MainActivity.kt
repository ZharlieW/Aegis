package com.aegis.app

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("Aegis", "MainActivity created")
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        Log.d("Aegis", "New intent received: ${intent.action}")
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