package com.aegis.app

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    
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
