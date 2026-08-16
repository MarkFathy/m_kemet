import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/themes/app_theme.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/app_cubit/app_state.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/navigation/route_generator.dart';
import 'package:m_kemet/src/core/services/service_locater/service_locator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (context) => sl<AppCubit>()..loadSettings(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              locale: state.locale,
              navigatorKey: Go.navigatorKey,
              initialRoute: NamedRoutes.splash.routeName,
              onGenerateRoute: RouterGenerator.getRoute,
              onUnknownRoute: (_) => RouterGenerator.undefineRoute(),
            ),
          );
        },
      ),
    );
  }
}
