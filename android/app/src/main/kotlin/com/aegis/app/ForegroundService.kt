package com.aegis.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import java.io.File

class ForegroundService : Service() {
    companion object {
        private const val TAG = "ForegroundService"
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "aegis_foreground_service"
        private const val CHANNEL_NAME = "Aegis Background Service"
        
        fun startService(context: Context) {
            val intent = Intent(context, ForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }
        
        fun stopService(context: Context) {
            val intent = Intent(context, ForegroundService::class.java)
            context.stopService(intent)
        }
    }

    private var isServiceRunning = false
    private var isRelayStarted = false

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "ForegroundService onCreate")
        createNotificationChannel()
        startRelay()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "ForegroundService onStartCommand")
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)
        
        if (!isServiceRunning) {
            isServiceRunning = true
        }
        
        // Ensure relay is running
        if (!isRelayStarted) {
            startRelay()
        }
        
        return START_STICKY
    }

    override fun onDestroy() {
        Log.d(TAG, "ForegroundService onDestroy")
        if (isServiceRunning) {
            isServiceRunning = false
        }
        isRelayStarted = false
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun startRelay() {
        try {
            // Check if relay is already running
            if (NostrRelayJni.isRelayRunning()) {
                Log.d(TAG, "Relay is already running")
                isRelayStarted = true
                return
            }
            
            // Get database path
            val appDir = File(applicationContext.filesDir, "app_flutter")
            if (!appDir.exists()) {
                appDir.mkdirs()
            }
            val dbPath = File(appDir, "nostr_relay").absolutePath
            
            // Start relay via JNI
            val host = "0.0.0.0"
            val port = 8081
            Log.d(TAG, "Starting relay via JNI: host=$host, port=$port, dbPath=$dbPath")
            
            val result = NostrRelayJni.startRelay(host, port, dbPath)
            if (result == "OK") {
                Log.d(TAG, "✅ Relay started successfully via JNI")
                isRelayStarted = true
            } else {
                Log.e(TAG, "❌ Failed to start relay: $result")
                isRelayStarted = false
            }
        } catch (e: Exception) {
            Log.e(TAG, "❌ Exception while starting relay", e)
            isRelayStarted = false
        }
    }


    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Keeps Aegis relay and signer running in the background"
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Aegis")
            .setContentText("Relay and signer running")
            .setSmallIcon(R.drawable.ic_notification)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }
}
