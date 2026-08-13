import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/payment.dart';

class PaymentRow extends StatelessWidget {
  final Payment payment;
  final Function(Payment) onViewDetail;
  const PaymentRow({
    super.key,
    required this.payment,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    Color statusColor;
    String statusText;
    switch (payment.status) {
      case 'success':
        statusColor = Colors.green;
        statusText = 'Thành công';
        break;
      case 'awaiting_confirmation':
        statusColor = Colors.orange;
        statusText = 'Chờ xác nhận';
        break;
      case 'failed':
        statusColor = Colors.red;
        statusText = 'Thất bại';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Chờ thanh toán';
    }

    return Card(
      child: ListTile(
        onTap: () => onViewDetail(payment),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(Icons.payment, color: statusColor),
        ),
        title: Text(
          currencyFmt.format(payment.amount),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        subtitle: Text(
          'Đơn hàng: ${payment.orderId.substring(0, 6).toUpperCase()}',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusText,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
