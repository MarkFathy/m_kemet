import 'package:flutter/material.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AppLoadingOverlay({
    required this.isLoading, required this.child, super.key,
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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF9EC5F3)),
              ],
            ),
          ),
      ],
    );
}
