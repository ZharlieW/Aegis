import 'package:aegis/utils/background_audio_manager.dart';
import 'package:aegis/utils/local_storage.dart';

class RemoteSessionAudioSettings {
  RemoteSessionAudioSettings._();

  static const String enabledKey = 'remote_session_ambient_sound_enabled';
  static const String soundIdKey = 'remote_session_ambient_sound_id';
  static const String volumeKey = 'remote_session_ambient_sound_volume';
  static const String disclosureSeenKey =
      'remote_session_ambient_sound_disclosure_seen';

  static bool get enabled {
    final value = LocalStorage.get(enabledKey);
    return value is bool ? value : true;
  }

  static Future<void> setEnabled(bool value) {
    return LocalStorage.set(enabledKey, value);
  }

  static String get soundId {
    final value = LocalStorage.get(soundIdKey);
    return value is String && value.isNotEmpty
        ? value
        : BackgroundAudioManager.defaultSoundId;
  }

  static Future<void> setSoundId(String value) {
    return LocalStorage.set(soundIdKey, value);
  }

  static double get volume {
    final value = LocalStorage.get(volumeKey);
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return BackgroundAudioManager.defaultVolume;
  }

  static Future<void> setVolume(double value) {
    return LocalStorage.set(volumeKey, value.clamp(0.05, 0.25).toDouble());
  }

  static bool get disclosureSeen {
    final value = LocalStorage.get(disclosureSeenKey);
    return value is bool ? value : false;
  }

  static Future<void> setDisclosureSeen(bool value) {
    return LocalStorage.set(disclosureSeenKey, value);
  }
}
