import 'package:eden_test/features/auth/views/login_view.dart';
import 'package:eden_test/features/orders/views/order_details_view.dart';
import 'package:eden_test/features/orders/views/track_order_view.dart';
import 'package:eden_test/features/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loginView = '/login_view';
  static const String profileView = '/profile_view';
  static const String orderView = '/order_view';
  static const String trackOrderView = '/track_order_view';

  static Map<String, WidgetBuilder> routes = {
    loginView: (context) => LoginView(),
    profileView: (context) => const ProfileView(),
    orderView: (context) => const OrderView(),
    trackOrderView: (context) => const TrackOrderView(),
  };
}
