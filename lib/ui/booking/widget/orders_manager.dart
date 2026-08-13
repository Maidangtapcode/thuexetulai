import 'package:flutter/foundation.dart';
import '../../../models/order.dart';
import '../../../services/order_service.dart';
import '../../../services/payment_service.dart';
import '../../../models/payment.dart';
import '../../payment/widget/payments_manager.dart';

class OrdersManager with ChangeNotifier {
  final OrderService _orderService = OrderService();
  final PaymentService _paymentService = PaymentService();
  List<Order> _items = [];
  bool _isLoading = false;
  String? _error;
  List<Order> get items => [..._items];
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get orderCount => _items.length;
  Future<Payment> createOrderAndPayment(
    Order order,
    double depositAmount,
    PaymentsManager paymentsManager,
  ) async {
    try {
      // 1. Tạo Order
      final orderRecord = await _orderService.createOrder(order);
      final orderId = orderRecord.id;

      // 2. Tạo Payment
      final payment = Payment(
        orderId: orderId,
        userId: order.userId,
        amount: depositAmount,
      );
      final newPayment = await paymentsManager.createPayment(payment);

      // 3. Link Payment vào Order
      await _orderService.updateOrder(orderId, {'paymentId': newPayment.id});
      return newPayment;
    } catch (e) {
      throw Exception('Gửi yêu cầu thất bại: ${e.toString()}');
    }
  }

  Future<String> getOrderStatus(String orderId) async {
    try {
      final record = await _orderService.getOrderById(orderId);
      return record.getStringValue('status');
    } catch (e) {
      print('Lỗi getOrderStatus: $e');
      return 'error';
    }
  }

  Future<void> fetchAllOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _orderService.fetchAllOrders();
    } catch (error) {
      print('Lỗi khi tải danh sách đơn hàng: $error');
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateOrderStatus(Order order, String newStatus) async {
    try {
      await _orderService.updateOrder(order.id!, {'status': newStatus});
      if (newStatus == 'confirmed') {
        try {
          final payment = await _paymentService.getPaymentByOrderId(order.id!);
          if (payment != null && payment.id != null) {
            await _paymentService.updatePaymentStatus(payment.id!, 'success');
          }
        } catch (e) {
          print('Cảnh báo: Không thể cập nhật payment: $e');
        }
      }
      await fetchAllOrders();
    } catch (e) {
      throw Exception('Cập nhật thất bại: ${e.toString()}');
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await _orderService.deleteOrder(id);
      _items.removeWhere((order) => order.id == id);
      notifyListeners();
    } catch (error) {
      print('Lỗi khi xoá đơn hàng: $error');
      rethrow;
    }
  }
}
