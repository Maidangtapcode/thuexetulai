import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/order.dart';

class OrderRow extends StatelessWidget {
  final Order order;
  final Function(Order) onViewDetail;
  const OrderRow({super.key, required this.order, required this.onViewDetail});

  @override
  Widget build(BuildContext context) {
    // Format ngày và tiền
    final dateFmt = DateFormat('dd/MM/yyyy');
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    // Màu trạng thái
    Color statusColor = Colors.grey;
    String statusText = 'Chờ xử lý';

    switch (order.status) {
      case 'confirmed':
        statusColor = Colors.green;
        statusText = 'Đã duyệt';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Từ chối';
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusText = 'Hoàn thành';
        break;
      case 'cancelled':
        statusColor = Colors.grey;
        statusText = 'Đã hủy';
        break;
      // pending
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        onTap: () => onViewDetail(order),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(Icons.receipt_long, color: statusColor),
        ),
        title: Text(
          'Đơn #${order.id?.substring(0, 6).toUpperCase() ?? "???"}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Khách: ${order.userId}',
            ),
            Text(
              '${dateFmt.format(order.startDate)} - ${dateFmt.format(order.endDate)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFmt.format(order.totalPrice),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                statusText,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
