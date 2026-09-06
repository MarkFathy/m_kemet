import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

/// A professional error widget shown when a network/server error occurs
/// that connectivity_plus cannot detect (host unreachable, timeouts, etc.).
///
/// Usage in a BlocBuilder failure branch:
/// ```dart
/// if (state.lookupsStatus == LoadingStatus.failure) {
///   return NetworkErrorWidget(
///     errorMessage: state.errorMessage,
///     onRetry: () => cubit.loadInitialData(),
///   );
/// }
/// ```
class NetworkErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  /// Optionally pass the exception to get a context-aware title/icon.
  final ServerException? exception;

  const NetworkErrorWidget({
    super.key,
    this.errorMessage,
    this.onRetry,
    this.exception,
  });

  @override
  Widget build(BuildContext context) {
    final config = _resolveConfig(context, exception);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            _AnimatedErrorIcon(icon: config.icon, color: config.color)
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 450.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 300.ms),

            24.szH,

            // Title
            Text(
              config.title,
              textAlign: TextAlign.center,
              style: getTextStyle().darkNavy.w700.s18,
            )
                .animate(delay: 80.ms)
                .slideY(begin: 0.3, end: 0, duration: 350.ms, curve: Curves.easeOut)
                .fadeIn(),

            10.szH,

            // Subtitle
            Text(
              config.subtitle,
              textAlign: TextAlign.center,
              style: getTextStyle().greyColor.w400.s13,
              maxLines: 3,
            )
                .animate(delay: 150.ms)
                .slideY(begin: 0.3, end: 0, duration: 350.ms, curve: Curves.easeOut)
                .fadeIn(),

            if (onRetry != null) ...[
              28.szH,
              _RetryButton(onTap: onRetry!)
                  .animate(delay: 220.ms)
                  .slideY(begin: 0.4, end: 0, duration: 350.ms, curve: Curves.easeOut)
                  .fadeIn(),
            ],
          ],
        ),
      ),
    );
  }

  static _ErrorConfig _resolveConfig(
    BuildContext context,
    ServerException? exception,
  ) {
    final s = S.of(context);

    if (exception is NetworkException) {
      return switch (exception.kind) {
        NetworkErrorKind.hostUnreachable => _ErrorConfig(
            icon: Icons.cloud_off_rounded,
            color: AppColors.steelBlue,
            title: s.hostUnreachableTitle,
            subtitle: s.hostUnreachableSubtitle,
          ),
        NetworkErrorKind.connectionTimeout ||
        NetworkErrorKind.receiveTimeout ||
        NetworkErrorKind.sendTimeout =>
          _ErrorConfig(
            icon: Icons.timer_off_rounded,
            color: AppColors.warningAmber,
            title: s.timeoutErrorTitle,
            subtitle: s.timeoutErrorSubtitle,
          ),
        _ => _ErrorConfig(
            icon: Icons.signal_wifi_connected_no_internet_4_rounded,
            color: AppColors.steelBlue,
            title: s.networkErrorTitle,
            subtitle: s.networkErrorSubtitle,
          ),
      };
    }

    // Generic server error (5xx, etc.)
    return _ErrorConfig(
      icon: Icons.error_outline_rounded,
      color: AppColors.errorRed,
      title: s.serverErrorTitle,
      subtitle: s.serverErrorSubtitle,
    );
  }
}

class _ErrorConfig {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _ErrorConfig({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}

class _AnimatedErrorIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  const _AnimatedErrorIcon({required this.icon, required this.color});

  @override
  State<_AnimatedErrorIcon> createState() => _AnimatedErrorIconState();
}

class _AnimatedErrorIconState extends State<_AnimatedErrorIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => Transform.scale(scale: _pulse.value, child: child),
      child: Container(
        width: 88.r,
        height: 88.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.1),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.15),
              blurRadius: 24.r,
              spreadRadius: 4.r,
            ),
          ],
        ),
        child: Icon(widget.icon, size: 40.sp, color: widget.color),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RetryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 13.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.darkNavy, Color(0xFF0A4F84)],
            begin: AlignmentDirectional.centerStart,
            end: AlignmentDirectional.centerEnd,
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkNavy.withValues(alpha: 0.28),
              blurRadius: 14.r,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, color: Colors.white, size: 18.sp),
            8.szW,
            Text(
              S.of(context).retryAction,
              style: getTextStyle().whiteColor.w700.s14,
            ),
          ],
        ),
      ),
    );
  }
}
