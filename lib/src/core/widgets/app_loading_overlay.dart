import 'package:flutter/material.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/widgets/app_progress_indicator.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AppLoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          if (isLoading)
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withValues(alpha: 0.65),
            ),
          if (isLoading)
            const AppProgressIndicator.centered(color: AppColors.skyBlue),
        ],
      );
}
