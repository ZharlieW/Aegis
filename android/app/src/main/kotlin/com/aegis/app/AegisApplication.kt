package com.aegis.app

import android.app.Application
import android.util.Log

/**
 * Aegis Application class for managing app-level initialization
 * 
 * This class handles:
 * - Starting foreground service on app launch
 * - Managing app lifecycle
 * - Initializing core services
 */
class AegisApplication : Application() {
    
    companion object {
        private const val TAG = "AegisApplication"
    }
    
    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "AegisApplication onCreate")
        
        // Start foreground service immediately when app starts
        startForegroundService()
    }
    
    /**
     * Start the foreground service to keep the app running in background
     */
    private fun startForegroundService() {
        try {
            Log.d(TAG, "Starting foreground service from Application")
            ForegroundService.startService(this)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start foreground service from Application", e)
        }
    }
    
    /**
     * Stop the foreground service (called when app is being terminated)
     */
    fun stopForegroundService() {
        try {
            Log.d(TAG, "Stopping foreground service from Application")
            ForegroundService.stopService(this)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to stop foreground service from Application", e)
        }
    }
    
    override fun onTerminate() {
        super.onTerminate()
        Log.d(TAG, "AegisApplication onTerminate")
        
        // Stop foreground service when app is terminated
        stopForegroundService()
    }
}
