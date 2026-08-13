import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../payment/widget/payments_manager.dart';
import 'payment_row.dart';
import 'payment_detail_dialog.dart';
import '../widget/admin_app_bar.dart';
import '../widget/admin_drawer.dart';

class ManagePaymentsScreen extends StatefulWidget {
  const ManagePaymentsScreen({super.key});
  @override
  State<ManagePaymentsScreen> createState() => _ManagePaymentsScreenState();
}

class _ManagePaymentsScreenState extends State<ManagePaymentsScreen> {
  late Future<void> _fetchPaymentsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPaymentsFuture = context.read<PaymentsManager>().fetchAllPayments();
  }

  @override
  Widget build(BuildContext context) {
    final paymentsManager = context.watch<PaymentsManager>();

    return Scaffold(
      appBar: const AdminAppBar(title: 'Quản lý Thanh toán'),
      drawer: const AdminDrawer(),
      body: FutureBuilder(
        future: _fetchPaymentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildBody(paymentsManager, context);
        },
      ),
    );
  }

  Widget _buildBody(PaymentsManager manager, BuildContext context) {
    if (manager.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (manager.error != null) {
      return Center(child: Text('Lỗi: ${manager.error}'));
    }
    if (manager.items.isEmpty) {
      return const Center(child: Text('Chưa có giao dịch nào.'));
    }
    return RefreshIndicator(
      onRefresh: () => manager.fetchAllPayments(),
      child: ListView.builder(
        itemCount: manager.items.length,
        itemBuilder: (ctx, i) => PaymentRow(
          payment: manager.items[i],
          onViewDetail: (payment) {
            showDialog(
              context: context,
              builder: (_) => PaymentDetailDialog(payment: payment),
            );
          },
        ),
      ),
    );
  }
}
