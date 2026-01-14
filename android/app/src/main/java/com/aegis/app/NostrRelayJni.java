package com.aegis.app;

/**
 * JNI wrapper for Rust relay functions
 * This allows the Android Service to call Rust directly without Flutter Engine
 */
public class NostrRelayJni {
    static {
        System.loadLibrary("rust_lib_nostr_rust");
    }

    /**
     * Start the relay
     * @param host IP address to bind (e.g. "0.0.0.0")
     * @param port Port number (e.g. 8081)
     * @param dbPath Database path
     * @return "OK" on success, error message on failure
     */
    public static native String startRelay(String host, int port, String dbPath);

    /**
     * Check if relay is running
     * @return true if relay is running, false otherwise
     */
    public static native boolean isRelayRunning();

    /**
     * Get relay URL
     * @return Relay URL string, or null if relay is not running
     */
    public static native String getRelayUrl();
}

