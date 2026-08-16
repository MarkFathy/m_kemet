import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            if (Go.canPop) {
              Go.back();
            } else {
              Go.offAllNamed(NamedRoutes.userTypeSelection);
            }
          },
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: color ?? AppColors.darkNavy,
        size: size ?? 20.sp,
      ),
    );
  }
}
