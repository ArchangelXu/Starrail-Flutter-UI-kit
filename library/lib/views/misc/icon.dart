import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SRIcon extends StatelessWidget {
  static const double _iconSize = 14;
  final Widget? child;

  /// supports assets path/url/file path
  final String? iconPath;
  final IconData? iconData;
  final Color? color;
  final double size;

  const SRIcon({
    super.key,
    this.iconPath,
    this.iconData,
    this.color,
    this.size = _iconSize,
    this.child,
  });

  Widget _buildIcon({
    String? iconPath,
    IconData? iconData,
    Widget? child,
  }) {
    if (child == null) {
      if (iconData != null) {
        child = Icon(
          iconData,
          size: size,
          color: color ?? Colors.black,
        );
      } else if ((iconPath != null)) {
        bool svg = iconPath.toLowerCase().contains(".svg");
        if (iconPath.startsWith("/")) {
          //file
          dynamic file = File(iconPath);
          child = svg
              ? SvgPicture.file(
                  file,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  colorFilter: color == null
                      ? null
                      : ColorFilter.mode(color!, BlendMode.srcIn),
                )
              : Image.file(
                  file,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  color: color,
                );
        } else if (iconPath.startsWith("http")) {
          //network
          child = svg
              ? SvgPicture.network(
                  iconPath,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  colorFilter: color == null
                      ? null
                      : ColorFilter.mode(color!, BlendMode.srcIn),
                )
              : Image.network(
                  iconPath,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  color: color,
                );
        } else {
          //asset
          child = svg
              ? SvgPicture.asset(
                  iconPath,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  colorFilter: color == null
                      ? null
                      : ColorFilter.mode(color!, BlendMode.srcIn),
                )
              : Image.asset(
                  iconPath,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  color: color,
                );
        }
      }
    }
    return child!;
  }

  @override
  Widget build(BuildContext context) {
    return _buildIcon(
      child: child,
      iconPath: iconPath,
      iconData: iconData,
    );
  }

  SRIcon copyWith({
    Widget? child,
    String? iconPath,
    IconData? iconData,
    Color? color,
    double? size,
  }) {
    return SRIcon(
      iconPath: iconPath ?? this.iconPath,
      iconData: iconData ?? this.iconData,
      color: color ?? this.color,
      size: size ?? this.size,
      child: child ?? this.child,
    );
  }
}
