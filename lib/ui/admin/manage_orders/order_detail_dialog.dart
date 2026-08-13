import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/order.dart';
import '../../../ui/booking/widget/orders_manager.dart';
class OrderDetailDialog extends StatelessWidget {
  final Order order;
  const OrderDetailDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('HH:mm dd/MM/yyyy');
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Chi tiết đơn hàng'),
          Text(
            '#${order.id?.substring(0, 6).toUpperCase() ?? ""}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow('Khách hàng (ID):', order.userId),
            _buildRow('Xe (ID):', order.carId),
            const Divider(),
            _buildRow('Ngày nhận:', dateFmt.format(order.startDate)),
            _buildRow('Ngày trả:', dateFmt.format(order.endDate)),
            _buildRow('Địa chỉ giao:', order.deliveryAddress ?? 'Tự đến lấy'),
            const Divider(),
            _buildRow(
              'Tổng tiền:',
              currencyFmt.format(order.totalPrice),
              isBold: true,
            ),
            _buildRow('Trạng thái:', order.status.toUpperCase(), isBold: true),
            if (order.message.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Lời nhắn:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                order.message,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
      actions: [
        // Các nút hành động
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng', style: TextStyle(color: Colors.grey)),
        ),

        if (order.status == 'pending' ||
            order.status == 'awaiting_confirmation') ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => _updateStatus(context, 'rejected'),
            child: const Text('Từ chối'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => _updateStatus(context, 'confirmed'),
            child: const Text('Duyệt đơn'),
          ),
        ],

        if (order.status == 'confirmed')
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => _updateStatus(context, 'completed'),
            child: const Text('Hoàn thành'),
          ),
      ],
    );
  }

 Future<void> _updateStatus(BuildContext context, String status) async {
    try {
      await context.read<OrdersManager>().updateOrderStatus(order, status);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      String msg = status == 'confirmed'
          ? 'Đã duyệt đơn và xác nhận thanh toán!'
          : 'Đã cập nhật trạng thái: $status';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Colors.black : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
