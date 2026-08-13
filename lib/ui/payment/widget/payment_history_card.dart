import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/payment.dart';

class PaymentHistoryCard extends StatelessWidget {
  final Payment payment;
  const PaymentHistoryCard({super.key, required this.payment});
  @override
  Widget build(BuildContext context) {
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateTimeFmt = DateFormat('dd/MM/yy');

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (payment.status) {
      case 'success':
        statusColor = Colors.green;
        statusText = 'Thành công';
        statusIcon = Icons.check_circle;
        break;
      case 'awaiting_confirmation':
        statusColor = Colors.orange;
        statusText = 'Chờ xác nhận';
        statusIcon = Icons.hourglass_bottom;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusText = 'Thất bại';
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Chờ thanh toán';
        statusIcon = Icons.pending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mã GD: ...${payment.id?.substring(payment.id!.length - 6).toUpperCase() ?? ''}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Số tiền:", style: TextStyle(fontSize: 16)),
                const Spacer(),
                Text(
                  currencyFmt.format(payment.amount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            if (payment.order?.carId != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.directions_car,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      payment.order!.carId,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (payment.order?.startDate != null &&
                payment.order?.endDate != null) ...[
              const SizedBox(height: 4),
              Text(
                "Thời gian: ${dateTimeFmt.format(payment.order!.startDate!)} - ${dateTimeFmt.format(payment.order!.endDate)}",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Phương thức:",
                  style: TextStyle(color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  payment.paymentMethod,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (payment.orderId.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    "Mã đơn hàng:",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    payment.orderId.substring(0, 6).toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
