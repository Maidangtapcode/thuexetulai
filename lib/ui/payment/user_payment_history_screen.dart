import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/payments_manager.dart';
import '../auth/auth_manager.dart';
import 'widget/payment_history_card.dart';

class UserPaymentHistoryScreen extends StatefulWidget {
  const UserPaymentHistoryScreen({super.key});
  @override
  State<UserPaymentHistoryScreen> createState() =>
      _UserPaymentHistoryScreenState();
}

class _UserPaymentHistoryScreenState extends State<UserPaymentHistoryScreen> {
  Future<void>? _fetchFuture;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthManager>().user?.id;

      if (userId != null) {
        setState(() {
          _fetchFuture = context.read<PaymentsManager>().fetchUserPayments(
            userId,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử giao dịch"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            if (snapshot.error.toString().contains("null")) {
              return const Center(
                child: Text("Vui lòng đăng nhập để xem lịch sử."),
              );
            }
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          return Consumer<PaymentsManager>(
            builder: (ctx, manager, child) {
              final payments = manager.userItems; 
              if (payments.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Bạn chưa có giao dịch nào",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () {
                  final userId = context.read<AuthManager>().user?.id;
                  if (userId != null) {
                    return manager.fetchUserPayments(userId);
                  }
                  return Future.value();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: payments.length,
                  itemBuilder: (ctx, i) =>
                      PaymentHistoryCard(payment: payments[i]),
                ),
              );
              
            },
          );
        },
      ),
    );
  }
}
