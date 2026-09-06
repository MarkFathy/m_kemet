import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A high-performance, smooth custom shimmer effect widget.
/// Wraps any widget tree containing [ShimmerBox], [ShimmerCircle], or [ShimmerLine]
/// and applies a synchronized sweeping gradient shine across all elements.
class CustomShimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final bool enabled;

  const CustomShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1400),
    this.enabled = true,
  });

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final base = widget.baseColor ?? const Color(0xFFE2E8F0);
    final highlight = widget.highlightColor ?? const Color(0xFFF8FAFC);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: const Alignment(-1.0, -0.4),
              end: const Alignment(1.0, 0.4),
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
              colors: [
                base,
                base,
                highlight,
                base,
                base,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final dx = bounds.width * (slidePercent * 3.0 - 1.5);
    return Matrix4.translationValues(dx, 0.0, 0.0);
  }
}

/// A rectangular or custom-shaped placeholder box for shimmer loading.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Border? border;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.margin,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE2E8F0),
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius ?? 8.r),
        border: border,
      ),
    );
  }
}

/// A circular placeholder for avatars or icon buttons in shimmer loading.
class ShimmerCircle extends StatelessWidget {
  final double radius;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const ShimmerCircle({
    super.key,
    required this.radius,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE2E8F0),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// A text-line placeholder for titles, subtitles, or labels in shimmer loading.
class ShimmerLine extends StatelessWidget {
  final double? width;
  final double height;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const ShimmerLine({
    super.key,
    this.width,
    this.height = 12,
    this.borderRadius,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height.h,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(borderRadius ?? 6.r),
      ),
    );
  }
}
