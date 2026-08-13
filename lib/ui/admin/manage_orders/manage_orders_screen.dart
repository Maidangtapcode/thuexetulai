import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/booking/widget/orders_manager.dart';
import 'order_row.dart';
import 'order_detail_dialog.dart';
import '../widget/admin_app_bar.dart';
import '../widget/admin_drawer.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  late Future<void> _fetchOrdersFuture;

  @override
  void initState() {
    super.initState();
    _fetchOrdersFuture = context.read<OrdersManager>().fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    final ordersManager = context.watch<OrdersManager>();
    return Scaffold(
      appBar: const AdminAppBar(title: 'Quản lý Đơn hàng'),
      drawer: const AdminDrawer(),
      body: FutureBuilder(
        future: _fetchOrdersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (ordersManager.error != null) {
            return Center(child: Text('Lỗi: ${ordersManager.error}'));
          }
          final orders = ordersManager.items;
          if (orders.isEmpty) {
            return const Center(child: Text('Chưa có đơn hàng nào.'));
          }
          return RefreshIndicator(
            // Gọi lại khi kéo xuống
            onRefresh: () => context.read<OrdersManager>().fetchAllOrders(),
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, i) => OrderRow(
                order: orders[i],
                onViewDetail: (order) {
                  showDialog(
                    context: context,
                    builder: (_) => OrderDetailDialog(order: order),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
