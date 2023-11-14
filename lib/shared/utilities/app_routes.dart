import 'package:eden_test/features/auth/views/login_view.dart';
import 'package:eden_test/features/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginView = '/login_view';
  static const String profileView = '/profile_view';

  // static const String iphone14PlusTwoScreen = '/iphone_14_plus_two_screen';

  // static const String iphone14PlusThreeScreen = '/iphone_14_plus_three_screen';

  // static const String iphone14PlusFourScreen = '/iphone_14_plus_four_screen';

  // static const String iphone14PlusFiveScreen = '/iphone_14_plus_five_screen';

  // static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    loginView: (context) => LoginView(),
    profileView: (context) => const ProfileView(),
    // iphone14PlusTwoScreen: (context) => Iphone14PlusTwoScreen(),
    // iphone14PlusThreeScreen: (context) => Iphone14PlusThreeScreen(),
    // iphone14PlusFourScreen: (context) => Iphone14PlusFourScreen(),
    // iphone14PlusFiveScreen: (context) => Iphone14PlusFiveScreen(),
    // appNavigationScreen: (context) => AppNavigationScreen()
  };
}
