import '../models/payment.dart';
import 'pocketbase_client.dart';

class PaymentService {
  Future<Payment> createPayment(Payment payment) async {
    try {
      final pb = await getPocketbaseInstance();
      final body = payment.toJson();

      //Tạo record
      final record = await pb.collection('payments').create(body: body);

      //Chuyển RecordModel -> Payment model
      return Payment.fromJson(record.toJson());
    } catch (e) {
      print('Lỗi khi tạo payment: $e');
      rethrow;
    }
  }

  Future<void> updatePaymentStatus(String paymentId, String status) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb
          .collection('payments')
          .update(paymentId, body: {'status': status});
    } catch (e) {
      print('Lỗi khi cập nhật payment status: $e');
      rethrow;
    }
  }
  Future<Payment?> getPaymentByOrderId(String orderId) async {
    try {
      final pb = await getPocketbaseInstance();

      // Tìm trong bảng 'payments' dòng nào có cột 'orderId' trùng với ID đơn hàng
      // Lưu ý: Tên trường bên trái dấu = ('orderId') phải khớp với tên trên PocketBase
      final record = await pb
          .collection('payments')
          .getFirstListItem('orderId = "$orderId"');

      return Payment.fromJson(record.toJson());
    } catch (e) {
      print('Không tìm thấy payment cho order này: $e');
      return null;
    }
  }
  Future<List<Payment>> fetchAllPayments() async {
    try {
      final pb = await getPocketbaseInstance();
      // expand: 'user,car' để lấy luôn thông tin người dùng và xe
      final records = await pb
          .collection('payments')
          .getFullList(
            sort: '-created',
            expand: 'userId,orderId,orderId.carId', // Sửa lại cho đúng
          );

      return records.map((record) {
        // Bạn sẽ cần cập nhật Order.fromJson để xử lý expand (nếu muốn hiển thị tên user/xe)
        // Tạm thời cứ lấy thông tin cơ bản
        return Payment.fromJson(record.toJson());
      }).toList();
    } catch (e) {
      print('Lỗi fetchAllOrders: $e');
      rethrow;
    }
  }
  Future<List<Payment>> fetchUserPayments({String? filter}) async {
    // 💡 Có tham số filter
    try {
      final pb = await getPocketbaseInstance();

      final records = await pb
          .collection('payments')
          .getFullList(
            sort: '-created',
            expand: 'userId,orderId,orderId.carId', // Mở rộng thêm thông tin xe
            filter: filter, // 💡 Truyền filter xuống PocketBase
          );

      return records
          .map((record) => Payment.fromJson(record.toJson()))
          .toList();
    } catch (e) {
      print('Lỗi fetchAllPayments: $e');
      rethrow;
    }
  }
  Future<bool> deletePayment(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('payments').delete(id);
      return true;
    } catch (error) {
      print('Lỗi khi xoá payment: $error');
      return false;
    }
  }
}