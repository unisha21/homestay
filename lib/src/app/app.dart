import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/route_manager.dart';
import 'package:homestay_app/src/common/splash_screen.dart';
import 'package:homestay_app/src/themes/theme.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_599f6b5632ee4bfabc89b6d5dc55234d',
      enabledDebugging: true,
      navigatorKey: navigatorKey,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          home: const SplashScreen(),
          navigatorKey: navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: Routes.splashRoute,
          supportedLocales: const [Locale('en', 'US'), Locale('ne', 'NP')],
          localizationsDelegates: const [KhaltiLocalizations.delegate],
        );
      },
    );
  }
}
