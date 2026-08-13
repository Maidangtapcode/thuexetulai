import 'order.dart';

class Payment {
  final String? id;
  final String orderId;
  final String userId;
  final double amount;
  final String status;
  final String paymentMethod;
  final Order? order; // Thêm thuộc tính để giữ thông tin đơn hàng

  Payment({
    this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    this.status = 'pending',
    this.paymentMethod = 'QR_CODE_SIM',
    this.order,
  });
  
  // Chuyển object thành json để gửi server
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'status': status,
      'payment_method': paymentMethod,
    };
  }

  // Đọc JSON từ server
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      orderId: json['orderId'],
      userId: json['userId'],
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'] ?? 'unknown',
      // Xử lý dữ liệu expand từ PocketBase
      order: json['expand']?['orderId'] != null
          ? Order.fromJson(json['expand']['orderId'])
          : null,
    );
  }
}
