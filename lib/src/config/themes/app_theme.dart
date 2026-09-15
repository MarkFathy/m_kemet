import 'package:flutter/material.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/config/themes/status_bar_and_orientations_theme.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';

class AppTheme {
  BuildContext context = Go.navigatorKey.currentContext!;

  static ThemeData get light => ThemeData(
    fontFamily: FontManager.fontFamilyCairo,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    primaryColor: AppColors.darkNavy,
    canvasColor: AppColors.scaffoldBackgroundColor,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.darkNavy,
      selectionColor: AppColors.skyBlue.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.darkNavy,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: AppStatusBarAndOrientationsTheme.systemUiOverlayStyle,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.darkNavy),
      titleTextStyle: getTextStyle().darkNavy.w700.s20,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.darkNavy,
      primaryContainer: AppColors.darkNavy,
      secondary: AppColors.steelBlue,
      secondaryContainer: AppColors.softBlueBg,
      surface: AppColors.whiteColor,
      surfaceContainer: AppColors.whiteColor,
      surfaceContainerHighest: AppColors.softBlueBg,
      error: AppColors.errorRed,
      outline: AppColors.borderGrey,
      onPrimary: AppColors.whiteColor,
      onSecondary: AppColors.whiteColor,
      onSurface: AppColors.darkNavy,
      onSurfaceVariant: AppColors.greyColor,
    ),
    splashColor: Colors.transparent,
    useMaterial3: true,
    highlightColor: AppColors.skyBlue.withValues(alpha: 0.6),
    bottomSheetTheme: BottomSheetThemeData(
      modalBackgroundColor: AppColors.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppCircular.r32),
          topRight: Radius.circular(AppCircular.r32),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: AppColors.skyBlue,
      unselectedItemColor: AppColors.greyColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.pW4),
        foregroundColor: AppColors.skyBlue,
        minimumSize: Size(AppSize.sW30, AppSize.sH30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCircular.r8)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCircular.r20)),
    ),
    iconTheme: const IconThemeData(color: AppColors.skyBlue),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.scaffoldBackgroundColor,
      prefixIconColor: AppColors.greyColor,
      hintStyle: getTextStyle().greyColor.w400.s14,
      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.pW16, vertical: AppPadding.pH16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppCircular.r12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppCircular.r12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppCircular.r12),
        borderSide: const BorderSide(color: AppColors.skyBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppCircular.r12),
        borderSide: const BorderSide(color: AppColors.skyBlue, width: 2),
      ),
    ),
  );
}
