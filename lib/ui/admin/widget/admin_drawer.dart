import 'package:flutter/material.dart';
import '../../auth/auth_manager.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Center(
              child: Text(
                'Quản lý hệ thống',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Tổng quan',
            route: '/admin',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.directions_car,
            title: 'Quản lý xe',
            route: '/admin/manage_cars',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people,
            title: 'Quản lý người dùng',
            route: '/admin/manage_users',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.shopping_cart,
            title: 'Quản lý đơn thuê',
            route: '/admin/manage_orders',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.payment,
            title: 'Quản lý thanh toán',
            route: '/admin/manage_payments',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.feedback,
            title: 'Quản lý phản hồi',
            route: '/admin/manage_feedbacks',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Đăng xuất',
            color: Colors.red,
            onPressed: () async {
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? color,
    String? route,
    VoidCallback? onPressed,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: () {
        if (onPressed != null) {
          onPressed();
        } else if (route != null) {
          context.go(route);
        }
      },
    );

  }
}
