import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/payment.dart';
import '../../payment/widget/payments_manager.dart'; // Import Manager dùng chung

class PaymentDetailDialog extends StatelessWidget {
  final Payment payment;
  const PaymentDetailDialog({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return AlertDialog(
      title: const Text('Chi tiết Thanh toán'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mã GD: ${payment.id}'),
            const Divider(),
            Text(
              'Số tiền: ${currencyFmt.format(payment.amount)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text('Người dùng: ${payment.userId}'), // (Có thể expand tên)
            Text('Đơn hàng: ${payment.orderId}'),
            Text('Phương thức: ${payment.paymentMethod}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Trạng thái: '),
                Text(
                  payment.status.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng', style: TextStyle(color: Colors.grey)),
        ),
        if (payment.status == 'awaiting_confirmation')
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => _confirmPayment(context),
            child: const Text('Xác nhận đã nhận tiền'),
          ),
      ],
    );
  }

  Future<void> _confirmPayment(BuildContext context) async {
    try {
      await context.read<PaymentsManager>().updatePaymentStatus(
        payment.id!,
        'success',
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xác nhận thanh toán thành công!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }
}
