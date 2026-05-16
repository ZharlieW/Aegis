import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import 'logger.dart';
import 'platform_utils.dart';

class AmbientSound {
  const AmbientSound({
    required this.id,
    required this.name,
    required this.assetPath,
  });

  final String id;
  final String name;
  final String assetPath;
}

class BackgroundAudioManager {
  static final BackgroundAudioManager _instance =
      BackgroundAudioManager._internal();
  factory BackgroundAudioManager() => _instance;

  static const String defaultSoundId = 'soft_pulse';
  static const double defaultVolume = 0.10;
  static const List<AmbientSound> ambientSounds = [
    AmbientSound(
      id: defaultSoundId,
      name: 'Soft Pulse',
      assetPath: 'assets/audio/soft_pulse.mp3',
    ),
  ];

  late final AudioSession _session;
  late final AudioHandler _audioHandler;
  late final MyAudioHandler _handler;
  bool _isInitialized = false;

  BackgroundAudioManager._internal();

  Future<void> init() async {
    if (Platform.isAndroid) {
      return;
    }

    if (!PlatformUtils.shouldEnableAudioService || _isInitialized) {
      return;
    }

    try {
      _session = await AudioSession.instance;
      await _session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
          flags: AndroidAudioFlags.none,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      ));

      _handler = MyAudioHandler();
      await _handler.init(
        soundId: defaultSoundId,
        volume: defaultVolume,
      );

      _audioHandler = await AudioService.init(
        builder: () => _handler,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.aegis.remote_session_audio',
          androidNotificationChannelName: 'Remote Session Ambient Sound',
          androidNotificationOngoing: true,
        ),
      );

      _isInitialized = true;
    } catch (e) {
      // Audio is optional. A failed setup should not block account access.
      AegisLogger.error('Failed to initialize remote session ambient sound', e);
    }
  }

  bool get isAvailable =>
      PlatformUtils.shouldEnableAudioService && _isInitialized;
  bool get isInitialized => _isInitialized;
  bool get isPlaying => _isInitialized && _handler.isPlaying;

  Future<void> playAmbientSound({
    String soundId = defaultSoundId,
    double volume = defaultVolume,
  }) async {
    if (!PlatformUtils.shouldEnableAudioService) return;
    if (!_isInitialized) {
      await init();
    }
    if (!_isInitialized) return;

    await _handler.setVolume(volume);
    await _handler.setSound(soundId);
    await _audioHandler.play();
  }

  Future<void> stopAmbientSound() async {
    if (!_isInitialized) return;
    await _audioHandler.stop();
  }

  Future<void> setVolume(double volume) async {
    if (!_isInitialized) return;
    await _handler.setVolume(volume);
  }

  Future<void> setSound(String soundId) async {
    if (!_isInitialized) return;
    await _handler.setSound(soundId);
  }

  AmbientSound soundForId(String soundId) {
    return ambientSounds.firstWhere(
      (sound) => sound.id == soundId,
      orElse: () => ambientSounds.first,
    );
  }
}

class MyAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  String? _soundId;

  bool get isPlaying => _player.playing;

  Future<void> init({
    required String soundId,
    required double volume,
  }) async {
    await _player.setLoopMode(LoopMode.one);
    await setVolume(volume);
    await setSound(soundId);
  }

  Future<void> setSound(String soundId) async {
    if (_soundId == soundId) return;

    final wasPlaying = _player.playing;
    final sound = BackgroundAudioManager().soundForId(soundId);
    await _player.setAudioSource(AudioSource.asset(sound.assetPath));
    _soundId = sound.id;

    if (wasPlaying) {
      await _player.play();
    }
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.05, 0.25).toDouble());
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
