package com.aegis.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class ForegroundService : Service() {
    companion object {
        private const val TAG = "ForegroundService"
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "aegis_foreground_service"
        private const val CHANNEL_NAME = "Aegis Background Service"
        private const val ENGINE_ID = "foreground_service_engine"
        private const val FLUTTER_METHOD_CHANNEL = "com.aegis.app/foreground_service"
        
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

    private var flutterEngine: FlutterEngine? = null
    private var methodChannel: MethodChannel? = null
    private var isServiceRunning = false

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "ForegroundService onCreate")
        createNotificationChannel()
        initializeFlutterEngine()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "ForegroundService onStartCommand")
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)
        
        // Notify Flutter to start relay and signer
        if (!isServiceRunning) {
            isServiceRunning = true
            notifyFlutterStartService()
        }
        
        return START_STICKY
    }

    override fun onDestroy() {
        Log.d(TAG, "ForegroundService onDestroy")
        // Notify Flutter to stop relay and signer
        if (isServiceRunning) {
            isServiceRunning = false
            notifyFlutterStopService()
        }
        
        // Clean up Flutter engine
        flutterEngine?.destroy()
        flutterEngine = null
        methodChannel = null
        
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun initializeFlutterEngine() {
        try {
            // Try to get existing Flutter engine from cache
            val engineCache = FlutterEngineCache.getInstance()
            flutterEngine = engineCache.get(ENGINE_ID)
            if (flutterEngine == null) {
                Log.d(TAG, "Creating new Flutter engine for foreground service")
                flutterEngine = FlutterEngine(applicationContext).also { engine ->
                    engine.dartExecutor.executeDartEntrypoint(
                        DartExecutor.DartEntrypoint.createDefault()
                    )
                    engineCache.put(ENGINE_ID, engine)
                }
            } else {
                Log.d(TAG, "Using cached Flutter engine for foreground service")
            }

            // Set up method channel
            flutterEngine?.let { engine ->
                methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, FLUTTER_METHOD_CHANNEL)
                methodChannel?.setMethodCallHandler { call, result ->
                    when (call.method) {
                        "getServiceStatus" -> {
                            result.success(mapOf("isRunning" to isServiceRunning))
                        }
                        else -> {
                            result.notImplemented()
                        }
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize Flutter engine", e)
        }
    }

    private fun notifyFlutterStartService() {
        try {
            // Wait a bit for Flutter engine to be ready
            Handler(Looper.getMainLooper()).postDelayed({
                val port = "8081"
                if (methodChannel != null) {
                    methodChannel?.invokeMethod("startRelayAndSigner", mapOf("port" to port))
                    Log.d(TAG, "Requested relay and signer start")
                } else {
                    Log.w(TAG, "Method channel not available, retrying...")
                    // Retry after a longer delay
                    Handler(Looper.getMainLooper()).postDelayed({
                        methodChannel?.invokeMethod("startRelayAndSigner", mapOf("port" to port))
                        Log.d(TAG, "Requested relay and signer start on retry")
                    }, 2000)
                }
            }, 1000)
        } catch (e: Exception) {
            Log.e(TAG, "Error notifying Flutter to start service", e)
        }
    }

    private fun notifyFlutterStopService() {
        try {
            if (methodChannel != null) {
                methodChannel?.invokeMethod("stopRelayAndSigner", null)
                Log.d(TAG, "Requested relay and signer stop")
            } else {
                Log.w(TAG, "Method channel not available for stopping service")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error notifying Flutter to stop service", e)
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
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }
}
