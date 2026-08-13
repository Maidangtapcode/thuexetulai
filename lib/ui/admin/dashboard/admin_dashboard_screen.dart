import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../admin/widget/dashboard_card.dart';
import '../widget/admin_app_bar.dart';
import '../manage_users/user_manager.dart';
import '../widget/admin_drawer.dart';
import '../../car_home/widget/cars_manager.dart';
import '../../payment/widget/payments_manager.dart';
import '../../booking/widget/orders_manager.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBar: const AdminAppBar(title: 'Welcome Admin'),
      drawer: const AdminDrawer(),
      // Không dùng FutureBuilder vì dữ liệu đã load sẵn ở Provider
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2, // 2 card mỗi hàng
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            // Card Xe
            Consumer<CarsManager>(
              builder: (context, carsManager, child) => DashboardCard(
                title: 'Xe hoạt động',
                value: carsManager.carCount.toString(),
                icon: Icons.directions_car,
                color: Colors.blueAccent,
                onTap: () => context.push('/admin/manage_cars'),
              ),
            ),

            // Card Người dùng
            Consumer<UserManager>(
              builder: (context, userManager, child) => DashboardCard(
                title: 'Người dùng',
                value: userManager.userCount.toString(),
                icon: Icons.people,
                color: Colors.orangeAccent,
                onTap: () => context.push('/admin/manage_users'),
              ),
            ),

            // Card Đơn hàng
            Consumer<OrdersManager>(
              builder: (context, ordersManager, child) => DashboardCard(
                title: 'Đơn thuê xe',
                value: ordersManager.orderCount.toString(),
                icon: Icons.shopping_cart,
                color: Colors.green,
                onTap: () => context.push('/admin/manage_orders'),
              ),
            ),

            // Card Thanh toán
            Consumer<PaymentsManager>(
              builder: (context, paymentsManager, child) => DashboardCard(
                title: 'Thanh toán',
                value: paymentsManager.paymentCount.toString(),
                icon: Icons.payments,
                color: Colors.green,
                onTap: () => context.push('/admin/manage_payments'),
              ),
            ),
            DashboardCard(
              title: 'Phản hồi',
              value: '23',
              icon: Icons.feedback,
              color: Colors.purple,
              onTap: () => context.push(''),
            ),
            DashboardCard(
              title: 'Doanh thu tháng',
              value: '98tr ₫',
              icon: Icons.bar_chart,
              color: Colors.redAccent,
              onTap: () => context.push(''),
            ),
          ],
        ),
      ),
    );
  }
}
