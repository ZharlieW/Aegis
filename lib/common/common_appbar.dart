import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aegis/navigator/navigator.dart';
import 'common_image.dart';

const double commonBarHeight = 56.0;
const double largeTitleHeight = 32.0;

class CommonAppBar extends StatefulWidget {
  final bool canBack;
  final bool isClose;
  final VoidCallback? backCallback;
  final Brightness? brightness;
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleTextColor;
  final Widget? titleWidget;
  final Widget? leading;
  final double elevation;
  final bool centerTitle;
  final bool useLargeTitle;
  final double titleSpacing;
  final double? leadingWidth;
  final bool useMediumTitle;

  const CommonAppBar({
    super.key,
    this.isClose = false,
    this.canBack = true,
    this.backCallback,
    this.brightness,
    this.title = "",
    this.elevation = 0,
    this.titleWidget,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.titleTextColor,
    this.useLargeTitle = false,
    this.useMediumTitle = false,
    this.centerTitle = true,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.leadingWidth,
  });

  @override
  State<StatefulWidget> createState() {
    return BaseAppBarState();
  }
}

class BaseAppBarState extends State<CommonAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(
      leading: _leadingWidget(),
      title: Text(
          widget.title,
      ),
    );
  }


  Widget _leadingWidget() {
    String getIcon = widget.isClose ? 'title_close_icon.png' : 'back_icon.png';
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => AegisNavigator.pop(context),
      child: Center(
        child: CommonImage(
          iconName: getIcon,
          size: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
