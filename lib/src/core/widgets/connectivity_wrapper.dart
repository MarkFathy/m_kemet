import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/network/connectivity_cubit.dart';
import 'package:m_kemet/src/core/widgets/no_internet_banner.dart';

/// Wraps a screen so that:
/// - A red banner slides in at the top when internet is lost.
/// - A green snackbar appears when connection is restored.
///
/// Place this as the outermost widget inside any Scaffold body,
/// or use [ConnectivityWrapper.withBanner] which returns the combined Column.
///
/// Example usage inside AppScaffold:
/// ```dart
/// AppScaffold(
///   body: ConnectivityWrapper(child: MyPageContent()),
/// )
/// ```
class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          curr.isConnected &&
          prev.isDisconnected,
      listener: (context, state) {
        _showRestoredSnackBar(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const NoInternetBanner(),
          Expanded(child: child),
        ],
      ),
    );
  }

  static void _showRestoredSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.successGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(Icons.wifi_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              S.of(context).internetRestoredMsg,
              style: getTextStyle().whiteColor.w600.s13,
            ),
          ],
        ),
      ),
    );
  }
}
