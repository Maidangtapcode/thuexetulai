import 'package:flutter/foundation.dart';
import '../../../models/payment.dart';
import '../../../services/payment_service.dart';

class PaymentsManager with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  List<Payment> _items = [];
  bool _isLoading = false;
  String? _error;
  List<Payment> get items => [..._items];
  List<Payment> _userItems = [];
  List<Payment> get userItems => [..._userItems];
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get paymentCount => _items.length;
  Future<Payment> createPayment(Payment payment) async {
    try {
      return await _paymentService.createPayment(payment);
    } catch (e) {
      throw Exception('Tạo thanh toán thất bại: ${e.toString()}');
    }
  }

  Future<void> fetchAllPayments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _paymentService.fetchAllPayments();
    } catch (error) {
      print('Lỗi khi tải danh sách thanh toán: $error');
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
  Future<void> updatePaymentStatus(String paymentId, String status) async {
    try {
      await _paymentService.updatePaymentStatus(paymentId, status);
      final index = _items.indexWhere((item) => item.id == paymentId);
      if (index >= 0) {
        await fetchAllPayments();
      }
    } catch (e) {
      throw Exception('Cập nhật thanh toán thất bại: ${e.toString()}');
    }
  }

  Future<void> deletePayment(String id) async {
    try {
      await _paymentService.deletePayment(id);
      _items.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (error) {
      print('Lỗi khi xoá thanh toán: $error');
      rethrow;
    }
  }
  Future<void> fetchUserPayments(String userId) async {
    _isLoading = true;
    _error = null; 
    notifyListeners();
    try {
      _userItems = await _paymentService.fetchUserPayments(
        filter: 'userId = "$userId"', 
      );
    } catch (error) {
      print('Lỗi tải lịch sử user: $error');
      _error = error.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
