import 'package:go_router/go_router.dart';
import '../ui/screen.dart';
import '../models/payment.dart';
import '../ui/home/widget/select_location_screen.dart';
import 'package:flutter/material.dart';

CustomTransitionPage slideTransition(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

final List<RouteBase> userRoutes = [
  GoRoute(
    path: '/home',
    pageBuilder: (context, state) => slideTransition(const HomeScreen()),
    routes: [
      GoRoute(
        path: 'select-location',
        pageBuilder: (context, state) =>
            slideTransition(const SelectLocationScreen()),
      ),
      GoRoute(
        path: 'car_home',
        pageBuilder: (context, state) => slideTransition(const CarListScreen()),
      ),
    ],
  ),

  GoRoute(
    path: '/profile',
    pageBuilder: (context, state) => slideTransition(const ProfileScreen()),
  ),

  GoRoute(
    path: '/support',
    pageBuilder: (context, state) => slideTransition(const SupportScreen()),
  ),

  GoRoute(
    path: '/favorite',
    pageBuilder: (context, state) => slideTransition(const FavoriteScreen()),
  ),

  GoRoute(
    path: '/car_detail/:id',
    pageBuilder: (context, state) {
      final carId = state.pathParameters['id']!;
      return slideTransition(CarDetailScreen(carId: carId));
    },
  ),

  GoRoute(
    path: '/booking/:id',
    pageBuilder: (context, state) {
      final carId = state.pathParameters['id']!;
      return slideTransition(BookingScreen(carId: carId));
    },
  ),

  GoRoute(
    path: '/payment',
    pageBuilder: (context, state) {
      final paymentt = state.extra as Payment?;
      return slideTransition(PaymentScreen(payment: paymentt!));
    },
  ),

  GoRoute(
    path: '/payment_history',
    pageBuilder: (context, state) =>
        slideTransition(const UserPaymentHistoryScreen()),
  ),
];
