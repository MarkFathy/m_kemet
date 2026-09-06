import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/network/connectivity_cubit.dart';

/// Animated banner that appears when internet is lost and hides when restored.
///
/// Wrap your scaffold body or place it at the top of any screen:
/// ```dart
/// Column(children: [const NoInternetBanner(), Expanded(child: body)])
/// ```
class NoInternetBanner extends StatelessWidget {
  const NoInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status || prev.isChecking != curr.isChecking,
      builder: (context, state) {
        final isOffline = state.isDisconnected;

        return AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          child: isOffline ? _OfflineBanner(state: state) : const SizedBox.shrink(),
        );
      },
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  final ConnectivityState state;
  const _OfflineBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final isChecking = state.isChecking;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFDC2626),
            Color(0xFFB91C1C),
          ],
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          10.szW,
          Expanded(
            child: Text(
              S.of(context).noInternetBannerMsg,
              style: getTextStyle().whiteColor.w600.s13,
            ),
          ),
          10.szW,
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20.r),
              onTap: isChecking
                  ? null
                  : () async {
                      final cubit = context.read<ConnectivityCubit>();
                      await cubit.retry();
                      if (context.mounted && cubit.state.isDisconnected) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF1F2937),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            margin: EdgeInsets.all(16.r),
                            content: Row(
                              children: [
                                const Icon(Icons.wifi_off_rounded, color: Colors.white70, size: 18),
                                8.szW,
                                Expanded(
                                  child: Text(
                                    S.of(context).noInternetTitle,
                                    style: getTextStyle().whiteColor.w500.s12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                ),
                child: isChecking
                    ? SizedBox(
                        width: 14.w,
                        height: 14.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh_rounded, color: Colors.white, size: 14.sp),
                          4.szW,
                          Text(
                            S.of(context).noInternetRetry,
                            style: getTextStyle().whiteColor.w700.s11,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: -1, end: 0, duration: 350.ms, curve: Curves.easeOut)
        .fadeIn(duration: 250.ms);
  }
}
