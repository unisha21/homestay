import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/route_manager.dart';
import 'package:homestay_app/src/common/splash_screen.dart';
import 'package:homestay_app/src/themes/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: Routes.splashRoute,
    );
  }
}
