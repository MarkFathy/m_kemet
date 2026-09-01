import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';

/// A standardized, reusable circular progress indicator used across the application.
class AppProgressIndicator extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final double strokeWidth;
  final double? value;

  const AppProgressIndicator({
    super.key,
    this.color,
    this.backgroundColor,
    this.size,
    this.strokeWidth = 3.0,
    this.value,
  });

  /// Factory constructor for a centered loader filling its container or screen.
  const factory AppProgressIndicator.centered({
    Key? key,
    Color? color,
    Color? backgroundColor,
    double? size,
    double strokeWidth,
  }) = _CenteredAppProgressIndicator;

  /// Factory constructor for a small spinner (e.g. inside buttons or trailing slots).
  factory AppProgressIndicator.small({
    Key? key,
    Color? color,
    double? size,
    double strokeWidth = 2.0,
  }) {
    return AppProgressIndicator(
      key: key,
      size: size ?? 20.r,
      strokeWidth: strokeWidth,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.darkNavy),
      backgroundColor: backgroundColor,
    );

    if (size != null) {
      return SizedBox(
        width: size,
        height: size,
        child: indicator,
      );
    }

    return indicator;
  }
}

class _CenteredAppProgressIndicator extends AppProgressIndicator {
  const _CenteredAppProgressIndicator({
    super.key,
    super.color,
    super.backgroundColor,
    super.size,
    super.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: super.build(context),
    );
  }
}
