import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../ui/admin/screen.dart';

// route của admin 
final adminRoutes = [
  GoRoute(
    path: '/admin',
    builder: (context, state) =>
        const _MaterialWrapper(child: AdminDashboardScreen()),
  ),
  GoRoute(
    path: '/admin/manage_cars',
    builder: (context, state) =>
        const _MaterialWrapper(child: ManageCarsScreen()),
  ),
  GoRoute(
    path: '/admin/manage_users',
    builder: (context, state) =>
        const _MaterialWrapper(child: ManageUsersScreen()),
  ),
  GoRoute(
    path: '/admin/manage_orders',
    builder: (context, state) =>
        const _MaterialWrapper(child: ManageOrdersScreen()),
  ),
  GoRoute(
    path: '/admin/manage_payments',
    builder: (context, state) =>
        const _MaterialWrapper(child: ManagePaymentsScreen()),
  ),
];
// Bọc MaterialApp bên trong giúp admin chạy độc lập ui
class _MaterialWrapper extends StatelessWidget {
  final Widget child;
  const _MaterialWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: child),
    );
  }
}
