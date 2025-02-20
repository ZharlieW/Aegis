
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Parameter description:
/// package When not transferred, read the common image under ox_common, if not empty, read the image resource under a plugin
///
class CommonImage extends StatelessWidget{

  final String iconName;
  ///Whether to use a theme image
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit? fit;
  ///plugin name

  CommonImage({
    required this.iconName,
    this.color,
    double? height,
    double? width,
    double? size,
    this.fit,
  }): this.height = size ?? height,
        this.width = size ?? width;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image.asset(
      'assets/images/$iconName',
      width: this.width,
      height: this.height,
      color: this.color,
      fit: this.fit,
    );
  }
}

class CommonIconButton extends StatelessWidget {
  CommonIconButton({
    required this.iconName,
    this.useTheme = false,
    this.color,
    double? height,
    double? width,
    double? size,
    this.fit,
    this.padding,
    required this.onPressed,
  }): this.height = size ?? height,
        this.width = size ?? width;

  final String iconName;
  ///Whether to use a theme image
  final bool useTheme;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit? fit;

  final EdgeInsetsGeometry? padding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: CommonImage(
          iconName: iconName,
          height: height,
          width: width,
          color: color,
        ),
      ),
    );
  }
}