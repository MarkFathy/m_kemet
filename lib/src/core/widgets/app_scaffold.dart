import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/themes/status_bar_and_orientations_theme.dart';
import 'package:m_kemet/src/core/widgets/connectivity_wrapper.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool safeTop;
  final bool safeBottom;
  final bool extendBody;

  /// Set to false to opt out of the automatic connectivity banner (rarely needed).
  final bool showConnectivityBanner;

  const AppScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.safeTop = false,
    this.safeBottom = true,
    this.extendBody = false,
    this.showConnectivityBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    final wrappedBody = showConnectivityBanner
        ? ConnectivityWrapper(child: body)
        : body;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppStatusBarAndOrientationsTheme.systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor: backgroundColor ?? AppColors.scaffoldBackgroundColor,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        extendBody: extendBody,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: SafeArea(
            top: safeTop,
            bottom: extendBody ? false : safeBottom,
            child: wrappedBody,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar != null
            ? SafeArea(
                top: false,
                bottom: safeBottom,
                child: bottomNavigationBar!,
              )
            : null,
      ),
    );
  }
}