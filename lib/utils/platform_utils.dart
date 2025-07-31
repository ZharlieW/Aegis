import 'dart:io';

class PlatformUtils {
  /// Check if running on iOS
  static bool get isIOS => Platform.isIOS;
  
  /// Check if running on Android
  static bool get isAndroid => Platform.isAndroid;
  
  /// Check if running on macOS
  static bool get isMacOS => Platform.isMacOS;
  
  /// Check if running on Windows
  static bool get isWindows => Platform.isWindows;
  
  /// Check if running on Linux
  static bool get isLinux => Platform.isLinux;
  
  /// Check if running on mobile (iOS or Android)
  static bool get isMobile => Platform.isIOS || Platform.isAndroid;
  
  /// Check if running on desktop (macOS, Windows, or Linux)
  static bool get isDesktop => Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  
  /// Get platform name
  static String get platformName {
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
  
  /// Check if audio service should be enabled
  static bool get shouldEnableAudioService => Platform.isIOS;
} 