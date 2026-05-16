import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'background_audio_manager.dart';
import 'platform_utils.dart';
import 'relay_service.dart';
import 'remote_session_audio_settings.dart';

class RemoteSessionAudioCoordinator {
  RemoteSessionAudioCoordinator._();

  static final RemoteSessionAudioCoordinator instance =
      RemoteSessionAudioCoordinator._();

  final ValueNotifier<bool> shouldShowDisclosure = ValueNotifier(false);

  Timer? _timer;
  bool _isMonitoring = false;
  bool _isEvaluating = false;

  void startMonitoring() {
    if (!PlatformUtils.isIOS || _isMonitoring) return;

    _isMonitoring = true;
    RelayService.instance.serverNotifier.addListener(_onRelayStatusChanged);
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _evaluate());
    _evaluate();
  }

  Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    _timer?.cancel();
    _timer = null;
    RelayService.instance.serverNotifier.removeListener(_onRelayStatusChanged);
    shouldShowDisclosure.value = false;
    await BackgroundAudioManager().stopAmbientSound();
  }

  Future<void> refresh() => _evaluate();

  Future<void> handleDisclosureChoice({required bool enabled}) async {
    await RemoteSessionAudioSettings.setEnabled(enabled);
    await RemoteSessionAudioSettings.setDisclosureSeen(true);
    shouldShowDisclosure.value = false;
    await _evaluate();
  }

  void _onRelayStatusChanged() {
    _evaluate();
  }

  Future<void> _evaluate() async {
    if (!_isMonitoring || _isEvaluating || !PlatformUtils.isIOS) return;

    _isEvaluating = true;
    try {
      if (!RelayService.instance.serverNotifier.value) {
        await BackgroundAudioManager().stopAmbientSound();
        return;
      }

      final externalConnections = await _externalConnectionCount();
      if (externalConnections <= 0) {
        shouldShowDisclosure.value = false;
        await BackgroundAudioManager().stopAmbientSound();
        return;
      }

      if (!RemoteSessionAudioSettings.disclosureSeen) {
        shouldShowDisclosure.value = true;
        await BackgroundAudioManager().stopAmbientSound();
        return;
      }

      if (!RemoteSessionAudioSettings.enabled) {
        await BackgroundAudioManager().stopAmbientSound();
        return;
      }

      await BackgroundAudioManager().playAmbientSound(
        soundId: RemoteSessionAudioSettings.soundId,
        volume: RemoteSessionAudioSettings.volume,
      );
    } finally {
      _isEvaluating = false;
    }
  }

  Future<int> _externalConnectionCount() async {
    final stats = await RelayService.instance.getStats();
    final totalConnections = stats?['connections'] as int? ?? 0;

    // One connection is Aegis' own NIP-46 subscription to its local relay.
    return max(0, totalConnections - 1);
  }
}
