package com.example.aegis.service

import android.app.*
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class AegisWebSocketService : Service() {
    companion object {
        private const val TAG = "AegisWebSocketService"
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "aegis_websocket_service"
        private var isServiceRunning = false
        
        fun startService(context: Context) {
            if (!isServiceRunning) {
                val intent = Intent(context, AegisWebSocketService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
            }
        }
        
        fun stopService(context: Context) {
            val intent = Intent(context, AegisWebSocketService::class.java)
            context.stopService(intent)
        }
    }

    private var flutterEngine: FlutterEngine? = null
    private var methodChannel: MethodChannel? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private val serviceScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    
    // Network monitoring
    private val networkCallback = object : ConnectivityManager.NetworkCallback() {
        override fun onAvailable(network: Network) {
            Log.d(TAG, "Network available: $network")
            // Restart WebSocket server if needed
            restartWebSocketServerIfNeeded()
        }
        
        override fun onLost(network: Network) {
            Log.d(TAG, "Network lost: $network")
            // Handle network disconnection
        }
        
        override fun onCapabilitiesChanged(network: Network, networkCapabilities: NetworkCapabilities) {
            val isWifi = networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
            val isCellular = networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)
            Log.d(TAG, "Network capabilities changed - WiFi: $isWifi, Cellular: $isCellular")
        }
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service created")
        
        if (isServiceRunning) {
            Log.w(TAG, "Service already running")
            return
        }
        
        isServiceRunning = true
        
        // Create notification channel
        createNotificationChannel()
        
        // Start foreground service
        startForeground(NOTIFICATION_ID, createNotification())
        
        // Acquire wake lock
        acquireWakeLock()
        
        // Initialize Flutter engine
        initializeFlutterEngine()
        
        // Register network callback
        registerNetworkCallback()
        
        // Start WebSocket server
        startWebSocketServer()
        
        Log.d(TAG, "Service started successfully")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service start command received")
        
        // Update notification
        val notification = createNotification()
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(NOTIFICATION_ID, notification)
        
        // Return START_STICKY to restart service if killed
        return START_STICKY
    }

    override fun onDestroy() {
        Log.d(TAG, "Service destroying")
        
        isServiceRunning = false
        
        // Stop WebSocket server
        stopWebSocketServer()
        
        // Unregister network callback
        unregisterNetworkCallback()
        
        // Release wake lock
        releaseWakeLock()
        
        // Cleanup Flutter engine
        cleanupFlutterEngine()
        
        // Cancel all coroutines
        serviceScope.cancel()
        
        super.onDestroy()
        Log.d(TAG, "Service destroyed")
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Aegis WebSocket Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Maintains WebSocket server for NIP-46 signing requests"
                setShowBadge(false)
                setSound(null, null)
                enableVibration(false)
            }
            
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val intent = Intent(this, Class.forName("com.example.aegis.MainActivity")).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Aegis Signer Active")
            .setContentText("WebSocket server running - Ready to sign requests")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setAutoCancel(false)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }

    private fun acquireWakeLock() {
        try {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "Aegis::WebSocketService"
            ).apply {
                acquire(10 * 60 * 1000L) // 10 minutes timeout
            }
            Log.d(TAG, "Wake lock acquired")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to acquire wake lock", e)
        }
    }

    private fun releaseWakeLock() {
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
                Log.d(TAG, "Wake lock released")
            }
        }
        wakeLock = null
    }

    private fun initializeFlutterEngine() {
        try {
            flutterEngine = FlutterEngine(this)
            
            // Initialize Dart isolate
            flutterEngine?.dartExecutor?.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            
            // Setup method channel for communication
            methodChannel = MethodChannel(
                flutterEngine!!.dartExecutor.binaryMessenger,
                "aegis_websocket_service"
            )
            
            methodChannel?.setMethodCallHandler { call, result ->
                when (call.method) {
                    "startWebSocketServer" -> {
                        startWebSocketServer()
                        result.success(true)
                    }
                    "stopWebSocketServer" -> {
                        stopWebSocketServer()
                        result.success(true)
                    }
                    "getServiceStatus" -> {
                        result.success(mapOf(
                            "isRunning" to isServiceRunning,
                            "hasNetwork" to hasNetworkConnection()
                        ))
                    }
                    else -> result.notImplemented()
                }
            }
            
            Log.d(TAG, "Flutter engine initialized")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize Flutter engine", e)
        }
    }

    private fun cleanupFlutterEngine() {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        
        flutterEngine?.destroy()
        flutterEngine = null
    }

    private fun registerNetworkCallback() {
        try {
            val connectivityManager = getSystemService(ConnectivityManager::class.java)
            val networkRequest = NetworkRequest.Builder()
                .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                .build()
                
            connectivityManager.registerNetworkCallback(networkRequest, networkCallback)
            Log.d(TAG, "Network callback registered")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to register network callback", e)
        }
    }

    private fun unregisterNetworkCallback() {
        try {
            val connectivityManager = getSystemService(ConnectivityManager::class.java)
            connectivityManager.unregisterNetworkCallback(networkCallback)
            Log.d(TAG, "Network callback unregistered")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to unregister network callback", e)
        }
    }

    private fun startWebSocketServer() {
        serviceScope.launch {
            try {
                // Call Flutter method to start WebSocket server
                methodChannel?.invokeMethod("flutter_startWebSocketServer", mapOf(
                    "port" to "8080"
                ))
                Log.d(TAG, "WebSocket server start requested")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start WebSocket server", e)
            }
        }
    }

    private fun stopWebSocketServer() {
        serviceScope.launch {
            try {
                methodChannel?.invokeMethod("flutter_stopWebSocketServer", null)
                Log.d(TAG, "WebSocket server stop requested")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to stop WebSocket server", e)
            }
        }
    }

    private fun restartWebSocketServerIfNeeded() {
        serviceScope.launch {
            delay(1000) // Wait a moment for network to stabilize
            if (hasNetworkConnection()) {
                Log.d(TAG, "Network available, restarting WebSocket server")
                stopWebSocketServer()
                delay(500)
                startWebSocketServer()
            }
        }
    }

    private fun hasNetworkConnection(): Boolean {
        return try {
            val connectivityManager = getSystemService(ConnectivityManager::class.java)
            val activeNetwork = connectivityManager.activeNetwork
            val networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork)
            networkCapabilities?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to check network connection", e)
            false
        }
    }
}
