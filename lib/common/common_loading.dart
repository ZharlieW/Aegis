import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:aegis/utils/adapt.dart';

class OXLoading extends State<StatefulWidget> with TickerProviderStateMixin {

  static Completer initCompleter = Completer();
  static Future get initComplete => initCompleter.future;

  static TransitionBuilder init() {
    if (!initCompleter.isCompleted) {
      initCompleter.complete();
    }
    return EasyLoading.init();
  }

  static bool get isShow => EasyLoading.isShow;

  static Future<void> show({
    BuildContext? context,
    String? status,
    Widget? indicator,
    EasyLoadingMaskType? maskType,
    bool dismissOnTap = false,
  }) async {
    final colorScheme = _colorSchemeFromContext(context);
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.indicatorColor = colorScheme.primary;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
    EasyLoading.instance.indicatorSize = Adapt.px(20);
    EasyLoading.instance.contentPadding = EdgeInsets.only(left: Adapt.px(20), top: Adapt.px(16), right: Adapt.px(20), bottom: Adapt.px(16));
    EasyLoading.instance.textColor = colorScheme.onSurfaceVariant;
    EasyLoading.instance.lineWidth = Adapt.px(2);
    EasyLoading.instance.backgroundColor = colorScheme.surfaceContainerHighest;
    await EasyLoading.show(status: status, indicator: null, maskType: maskType, dismissOnTap: dismissOnTap);
  }

  static void showProgress({
    BuildContext? context,
    double process = 0,
    String? status,
    EasyLoadingMaskType? maskType,
  }) {
    final colorScheme = _colorSchemeFromContext(context);
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.indicatorColor = colorScheme.primary;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
    EasyLoading.instance.indicatorSize = Adapt.px(20);
    EasyLoading.instance.contentPadding = EdgeInsets.only(left: Adapt.px(20), top: Adapt.px(16), right: Adapt.px(20), bottom: Adapt.px(16));
    EasyLoading.instance.textColor = colorScheme.onSurfaceVariant;
    EasyLoading.instance.lineWidth = Adapt.px(2);
    EasyLoading.instance.backgroundColor = colorScheme.surfaceContainerHighest;
    EasyLoading.instance.progressColor = colorScheme.primary;
    EasyLoading.showProgress(process, status: status, maskType: maskType);
  }

  /// Resolve ColorScheme from context when available and mounted; otherwise use light defaults.
  static ColorScheme _colorSchemeFromContext(BuildContext? context) {
    if (context != null && context.mounted) {
      return Theme.of(context).colorScheme;
    }
    return ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light);
  }

  static Future<void> dismiss({
    bool animation = true,
  }) {
    return EasyLoading.dismiss(animation: animation);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
