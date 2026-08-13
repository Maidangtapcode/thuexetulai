import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/screen.dart';
import '../ui/auth/auth_manager.dart';
import '../ui/home/widget/bottom_nav_bar.dart';
import 'admin_router.dart';
import 'user_router.dart';

// Key cho sell navigator - dùng điều khiển trong shellroute
final _shellNavigatorKey = GlobalKey<NavigatorState>();
//Xác định tap đang chọn dựa trên url
int _calculateSelectedIndex(BuildContext context) {
  // Lấy url hiện tại
  final String location = GoRouterState.of(context).matchedLocation;
  if (location.startsWith('/home')) {
    return 0;
  }
  if (location.startsWith('/payment_history')) {
    return 1;
  }
  if (location.startsWith('/support')) {
    return 2;
  }
  if (location.startsWith('/profile')) {
    return 3;
  }
  return 0;
}
// Xử lý khi ấn icon trên bottom nav
void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go('/home');
      break;
    case 1:
      context.go('/payment_history');
      break;
    case 2: // Hỗ trợ
      context.go('/support');
      break;
    case 3: // Cá nhân
      context.go('/profile');
      break;
  }
}


GoRouter createAppRouter(
  AuthManager authManager,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return GoRouter(
    navigatorKey: navigatorKey,

    initialLocation: '/login',
    refreshListenable: authManager,

    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const Signup()),

      // ShellRoute sẽ hiển thị UI chung (AppScaffoldWithNavBar)
      // cho các route con của nó.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavBar(
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) => _onItemTapped(index, context),
            ),
          );
        },
        routes: userRoutes, // Các route sử dụng NavBar
      ),

      ...adminRoutes,
    ],
    // Kiểm soát - xem quyền
    redirect: (context, state) {
      final isLoggedIn = authManager.isAuth;
      final isAdmin = authManager.user?.role == 'admin';

      final loggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !loggingIn) {
        return '/login';
      }
      if (isLoggedIn && loggingIn) {
        return isAdmin ? '/admin' : '/home'; 
      }

      return null;
    },
  );
}
