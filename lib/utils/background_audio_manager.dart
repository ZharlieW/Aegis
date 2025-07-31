import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'platform_utils.dart';

class BackgroundAudioManager {
  static final BackgroundAudioManager _instance = BackgroundAudioManager._internal();
  factory BackgroundAudioManager() => _instance;

  late final AudioSession _session;
  late final AudioHandler _audioHandler;
  bool _isInitialized = false;

  BackgroundAudioManager._internal();

  Future<void> init() async {
    // Only initialize audio service on iOS
    if (!PlatformUtils.shouldEnableAudioService) {
      print('🔇 Skipping audio service initialization on ${PlatformUtils.platformName}');
      return;
    }

    try {
      print('🎵 Initializing audio service on ${PlatformUtils.platformName}...');
      
      _session = await AudioSession.instance;
      await _session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
          flags: AndroidAudioFlags.none,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      ));

      final handler = MyAudioHandler();
      await handler.init();

      _audioHandler = await AudioService.init(
        builder: () => handler,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.aegis.app.audio',
          androidNotificationChannelName: 'Audio Playback',
          androidNotificationOngoing: true,
        ),
      );

      _isInitialized = true;
      print('✅ Audio service initialized successfully on ${PlatformUtils.platformName}');

      // Auto-play after 3 seconds (only on iOS)
      Future.delayed(Duration(seconds: 3), () async {
        if (_isInitialized) {
          await _audioHandler.play();
        }
      });
      
    } catch (e) {
      print('❌ Failed to initialize audio service: $e');
      // Don't throw error, just log it
    }
  }

  // Getter to check if audio service is available
  bool get isAvailable => PlatformUtils.shouldEnableAudioService && _isInitialized;
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler();

  Future<void> init() async {
    try {
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(0.0);
      await _player.setAudioSource(AudioSource.asset('assets/audio/63bfeedb233d5546.mp3'));
    } catch (e) {
      print('❌ Failed to initialize audio player: $e');
    }
  }

  @override
  Future<void> play() async {
    try {
      return await _player.play();
    } catch (e) {
      print('❌ Failed to play audio: $e');
    }
  }
  
  @override
  Future<void> pause() async {
    try {
      return await _player.pause();
    } catch (e) {
      print('❌ Failed to pause audio: $e');
    }
  }
  
  @override
  Future<void> stop() async {
    try {
      return await _player.stop();
    } catch (e) {
      print('❌ Failed to stop audio: $e');
    }
  }
}