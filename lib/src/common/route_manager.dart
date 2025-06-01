import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/splash_screen.dart';
import 'package:homestay_app/src/features/auth/screens/login_screen.dart';
import 'package:homestay_app/src/features/auth/screens/sign_up_screen.dart';
import 'package:homestay_app/src/features/booking/screens/booking_screen.dart';
import 'package:homestay_app/src/features/chat/screens/recent_chat_screen.dart';
import 'package:homestay_app/src/features/home/screens/home_screen.dart';
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_app/src/features/homestay/screens/service_detail_screen.dart';
import 'package:homestay_app/src/features/notification/screens/notification_screen.dart';
import 'package:homestay_app/src/features/order/screens/order_list_screen.dart';
import 'package:homestay_app/src/features/payment/screens/payment_history_screen.dart';
import 'package:homestay_app/src/features/profile/screens/profile_edit_screen.dart';
import 'package:homestay_app/src/features/profile/screens/profile_screen.dart';
import 'package:homestay_app/src/features/profile/screens/support_screen.dart';
import 'package:homestay_app/src/features/search/screens/search_screen.dart';

class Routes {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String serviceDetailRoute = '/service-detail';
  static const String notificationRoute = '/notification';
  static const String profileRoute = '/profile';
  static const String recentChats = '/recent-chat';
  static const String chatRoute = '/chat';
  static const String supportRoute = '/support';
  static const String profileEditRoute = '/profile-edit';
  static const String searchRoute = '/search';
  static const String paymentHistoryRoute = '/payment-history';
  static const String bookingRoute = '/booking';
  static const String orderListRoute = '/order-list';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.searchRoute:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case Routes.serviceDetailRoute:
        final args = settings.arguments as HomestayModel;
        return MaterialPageRoute(builder: (_) => ServiceDetailScreen(args));
      case Routes.orderListRoute:
        return MaterialPageRoute(builder: (_) => const OrderListScreen());
      case Routes.profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.profileEditRoute:
        return MaterialPageRoute(builder: (_) => const ProfileEditScreen());
      case Routes.supportRoute:
        return MaterialPageRoute(builder: (_) => const SupportScreen());
      case Routes.paymentHistoryRoute:
        return MaterialPageRoute(builder: (_) => const PaymentHistoryScreen());
      case Routes.notificationRoute:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case Routes.bookingRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => BookingScreen(
                homestayId: args['homestayId'],
                numberOfGuests: args['numberOfGuests'],
                homestayDetails: args['homestayDetails'] as HomestayModel,
              ),
        );
      case Routes.recentChats:
        return MaterialPageRoute(builder: (_) => RecentChatScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Invalid Route')),
            body: const Center(child: Text('Route does not exist')),
          ),
    );
  }
}
