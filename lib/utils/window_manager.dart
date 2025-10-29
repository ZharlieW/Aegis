
import 'dart:io' show exit;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'platform_utils.dart';


class OXWindowManager with WindowListener {

  Map<String, String> windowInfo = {};

  Future initWindow() async {
    if (!PlatformUtils.isDesktop) return;

    await windowManager.ensureInitialized();

    await windowManager.waitUntilReadyToShow(WindowOptions(
      title: 'Aegis',
      size: Size(windowWidth, windowHeight),
      minimumSize: WindowInfoEx.minWindowSize,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      windowButtonVisibility: true,
    ));

    if (windowPositionX == null && windowPositionY == null) {
      await windowManager.center();
    } else {
      await windowManager.setPosition(Offset(windowPositionX ?? 0.0, windowPositionY ?? 0.0));
    }
    if (!PlatformUtils.isLinux) {
      await windowManager.setPreventClose(true);
    }

    await windowManager.show();

    addWindowObserver();
  }

  void addWindowObserver() {
    windowManager.addListener(this);
  }

  void onWindowResized() async {
    final size = await windowManager.getSize();
    windowWidth = size.width;
    windowHeight = size.height;
  }

  void onWindowMoved() async {
    final position = await windowManager.getPosition();
    windowPositionX = position.dx;
    windowPositionY = position.dy;
  }

  /// Emitted when the window is going to be closed.
  void onWindowClose() {
    if (PlatformUtils.isWindows) {
      exit(0);
    } else if (PlatformUtils.isLinux) {
      SystemNavigator.pop();
    } else {
      // On macOS, hide the window (keep running in background)
      windowManager.hide();
    }
  }

  /// Emitted when the window gains focus.
  void onWindowFocus() {
    windowManager.show();
  }
}

extension WindowInfoEx on OXWindowManager {
  get windowInfoStoreKey => 'WindowInfoStoreKey';
  get windowInfoSizeWidthKey => 'WindowInfoSizeWidth';
  get windowInfoSizeHeightKey => 'WindowInfoSizeHeight';
  get windowInfoPositionXKey => 'WindowInfoPositionX';
  get windowInfoPositionYKey => 'WindowInfoPositionY';

  static Size get minWindowSize => Size(430, 600);

  static Size get defaultWindowSize => Size(850, 850);

  double get windowWidth {
    final value = windowInfo[windowInfoSizeWidthKey];
    if (value == null || value.isEmpty) return defaultWindowSize.width;

    return double.tryParse(value) ?? defaultWindowSize.width;
  }

  set windowWidth(double value) {
    windowInfo[windowInfoSizeWidthKey] = value.toStringAsFixed(2);
  }

  double get windowHeight {
    final value = windowInfo[windowInfoSizeHeightKey];
    if (value == null || value.isEmpty) return defaultWindowSize.height;

    return double.tryParse(value) ?? defaultWindowSize.height;
  }

  set windowHeight(double value) {
    windowInfo[windowInfoSizeHeightKey] = value.toStringAsFixed(2);
  }

  double? get windowPositionX {
    final value = windowInfo[windowInfoPositionXKey];
    if (value == null || value.isEmpty) return null;

    return double.tryParse(value);
  }

  set windowPositionX(double? value) {
    windowInfo[windowInfoPositionXKey] = value?.toStringAsFixed(2) ?? '';
  }

  double? get windowPositionY {
    final value = windowInfo[windowInfoPositionYKey];
    if (value == null || value.isEmpty) return null;

    return double.tryParse(value);
  }

  set windowPositionY(double? value) {
    windowInfo[windowInfoPositionYKey] = value?.toStringAsFixed(2) ?? '';
  }
}

