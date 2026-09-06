import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/network/connectivity_cubit.dart';

/// Full-screen no-internet overlay/page.
///
/// Use this when you need to block the entire UI during loss of connectivity.
class NoInternetScreen extends StatefulWidget {
  final VoidCallback? onRetry;

  const NoInternetScreen({super.key, this.onRetry});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleRetry() async {
    if (_isRetrying) return;
    setState(() => _isRetrying = true);
    await context.read<ConnectivityCubit>().retry();
    widget.onRetry?.call();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isRetrying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated wifi icon
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.9 + (_pulseController.value * 0.1),
                    child: child,
                  );
                },
                child: Container(
                  width: 120.r,
                  height: 120.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.errorBg,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDC2626).withValues(alpha: 0.18),
                        blurRadius: 40.r,
                        spreadRadius: 8.r,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer ring
                        Container(
                          width: 90.r,
                          height: 90.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFFDC2626).withValues(alpha: 0.25),
                              width: 2.r,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 52.sp,
                          color: AppColors.errorRed,
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(begin: const Offset(0.6, 0.6), duration: 500.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 400.ms),

              36.szH,

              // Title
              Text(
                S.of(context).noInternetTitle,
                style: getTextStyle().darkNavy.w700.s22,
                textAlign: TextAlign.center,
              )
                  .animate(delay: 100.ms)
                  .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut)
                  .fadeIn(duration: 350.ms),

              12.szH,

              // Subtitle
              Text(
                S.of(context).noInternetSubtitle,
                style: getTextStyle().greyColor.w400.s14,
                textAlign: TextAlign.center,
                maxLines: 3,
              )
                  .animate(delay: 200.ms)
                  .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut)
                  .fadeIn(duration: 350.ms),

              40.szH,

              // Connection type hints
              _ConnectionHintsRow()
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms),

              const Spacer(),

              // Retry button
              _RetryButton(isRetrying: _isRetrying, onRetry: _handleRetry)
                  .animate(delay: 400.ms)
                  .slideY(begin: 0.4, end: 0, duration: 450.ms, curve: Curves.easeOut)
                  .fadeIn(duration: 350.ms),

              24.szH,
            ],
          ),
        ),
      ),
    );
  }
}

class _ConnectionHintsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final hints = isAr
        ? [
            (Icons.wifi_rounded, 'Wi-Fi'),
            (Icons.cell_tower_rounded, 'بيانات الجوال'),
            (Icons.airplanemode_active_rounded, 'وضع الطيران'),
          ]
        : [
            (Icons.wifi_rounded, 'Wi-Fi'),
            (Icons.cell_tower_rounded, 'Mobile Data'),
            (Icons.airplanemode_active_rounded, 'Flight Mode'),
          ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: hints
          .map(
            (h) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: AppColors.softBlueBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderGrey),
                    ),
                    child: Icon(h.$1, size: 22.sp, color: AppColors.darkNavy),
                  ),
                  6.szH,
                  Text(
                    h.$2,
                    style: getTextStyle().greyColor.w500.s11,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final bool isRetrying;
  final VoidCallback onRetry;

  const _RetryButton({required this.isRetrying, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isRetrying ? null : onRetry,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isRetrying
                ? [AppColors.greyColor, AppColors.greyColor]
                : [AppColors.darkNavy, const Color(0xFF0A4F84)],
            begin: AlignmentDirectional.centerStart,
            end: AlignmentDirectional.centerEnd,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: isRetrying
              ? []
              : [
                  BoxShadow(
                    color: AppColors.darkNavy.withValues(alpha: 0.3),
                    blurRadius: 16.r,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isRetrying
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: Colors.white, size: 20.sp),
                    8.szW,
                    Text(
                      S.of(context).noInternetRetry,
                      style: getTextStyle().whiteColor.w700.s15,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
