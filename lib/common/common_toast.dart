
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:aegis/utils/adapt.dart';
import 'package:aegis/common/common_image.dart';

class CommonToast {
  static CommonToast get instance => _getInstance();
  static CommonToast? _instance;

  static CommonToast _getInstance() {
    _instance ??= CommonToast._internal();
    return _instance!;
  }

  CommonToast._internal();

  static OverlayEntry? _entry;

  Future<void> show(BuildContext? context, String message,
      {int duration = 2000, ToastType toastType = ToastType.normal}) async{
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.successWidget = _getToastTypeIconName(toastType);
    EasyLoading.instance.backgroundColor = Colors.grey;
    EasyLoading.instance.indicatorColor = Colors.transparent;
    EasyLoading.instance.textColor =  Colors.white;
    EasyLoading.instance.textStyle = TextStyle(
      fontSize: Adapt.px(12),
      fontWeight: FontWeight.w400,
    );
    if (toastType == ToastType.normal) {
     await EasyLoading.showToast(
        message,
        duration: Duration(milliseconds: duration),
      );
    } else {
     await EasyLoading.showSuccess(
        message,
        duration: Duration(milliseconds: duration),
      );
    }
  }

  Widget? _getToastTypeIconName(ToastType type) {
    String? iconName;
    switch (type) {
      case ToastType.normal:
        iconName = null;
        break;
      case ToastType.success:
        iconName = 'icon_toast_success.png';
        break;
      case ToastType.failed:
        iconName = 'icon_toast_failed.png';
        break;
    }
    if (iconName == null) {
      return null;
    } else {
      return CommonImage(
        iconName: iconName,
        width: Adapt.px(16),
        height: Adapt.px(16),
      );
    }
  }
}

enum ToastType { normal, success, failed }
