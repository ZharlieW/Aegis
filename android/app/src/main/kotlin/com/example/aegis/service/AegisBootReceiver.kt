package com.example.aegis.service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import kotlinx.coroutines.*

class AegisBootReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "AegisBootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Received intent: ${intent.action}")
        
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED -> {
                Log.d(TAG, "Device boot completed, starting service")
                startServiceWithDelay(context, 5000) // 5 seconds delay
            }
            Intent.ACTION_MY_PACKAGE_REPLACED,
            Intent.ACTION_PACKAGE_REPLACED -> {
                if (intent.dataString?.contains("com.example.aegis") == true) {
                    Log.d(TAG, "Package updated, starting service")
                    startServiceWithDelay(context, 2000) // 2 seconds delay
                }
            }
        }
    }

    private fun startServiceWithDelay(context: Context, delayMs: Long) {
        CoroutineScope(Dispatchers.IO).launch {
            delay(delayMs)
            try {
                AegisWebSocketService.startService(context.applicationContext)
                Log.d(TAG, "Service started successfully after delay")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start service", e)
            }
        }
    }
}
