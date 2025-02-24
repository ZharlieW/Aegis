import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../navigator/navigator.dart';
import 'common_image.dart';

const double commonBarHeight = 56.0;
const double largeTitleHeight = 32.0;

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  final Size preferredSize;
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
    Size? preferredSize,
  }) : preferredSize = preferredSize ?? const Size.fromHeight(commonBarHeight + largeTitleHeight);

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

  // marked by ccso
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        child: AppBar(
          title: null,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          leading: _leadingWidget(),
          titleSpacing: widget.titleSpacing,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          centerTitle: widget.centerTitle,
          elevation: widget.elevation,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.042),
            child: LargeTitle(
              title: widget.title,
            ),
          ),
          leadingWidth: widget.leadingWidth,
        ),
      ),
    );
  }

  Widget _leadingWidget(){
    return GestureDetector(
      behavior: HitTestBehavior.translucent ,
      onTap: () => AegisNavigator.pop(context),
      child: Center(
        child: CommonImage(
          iconName: 'back_icon.png',
          size: 24,
        ),
      ),
    );
  }
}

class LargeTitle extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  const LargeTitle({super.key, this.title = ""}) : preferredSize = const Size.fromHeight(largeTitleHeight);

  @override
  State<StatefulWidget> createState() {
    return LargeTitleState();
  }
}

class LargeTitleState extends State<LargeTitle> {
  @override
  Widget build(BuildContext context) {
    return buildLargeTitle();
  }

  Widget buildLargeTitle() {
    return Container(
      margin:  EdgeInsets.only(
          top: kToolbarHeight + MediaQueryData.fromView(window).padding.top),
      child: Text(
        widget.title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
      ),
    );
  }
}

