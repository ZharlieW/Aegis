import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class BackgroundAudioManager {
  static final BackgroundAudioManager _instance = BackgroundAudioManager._internal();
  factory BackgroundAudioManager() => _instance;

  late final AudioSession _session;
  late final AudioHandler _audioHandler;

  BackgroundAudioManager._internal();

  Future<void> init() async {
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

    Future.delayed(Duration(seconds: 3),()async{
      await _audioHandler.play();
    });

  }
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler();

  Future<void> init() async {
    await _player.setLoopMode(LoopMode.one);
    await _player.setVolume(0.0);
    await _player.setAudioSource(AudioSource.asset('assets/audio/63bfeedb233d5546.mp3'));
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
}