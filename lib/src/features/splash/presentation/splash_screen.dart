import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/gen/assets.gen.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Go.offAllNamed(NamedRoutes.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.steelBlue,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pW24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.pngs.plane
                  .image(width: 150.w, height: 100.h)
                  .animate()
                  .slideX(
                    begin: -1.5,
                    end: 0,
                    duration: 1200.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeIn(
                    duration: 800.ms,
                    curve: Curves.easeIn,
                  )
                  .scale(
                    begin: const Offset(0.6, 0.6),
                    end: const Offset(1.0, 1.0),
                    duration: 1200.ms,
                    curve: Curves.easeOutBack,
                  ),
              Text(
                S.of(context).splashTitle,
                textAlign: TextAlign.center,
                style: getTextStyle().whiteColor.w700.s18,
              )
                  .animate()
                  .fadeIn(
                    delay: 600.ms,
                    duration: 900.ms,
                    curve: Curves.easeIn,
                  )
                  .slideY(
                    begin: 0.4,
                    end: 0,
                    delay: 600.ms,
                    duration: 900.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}