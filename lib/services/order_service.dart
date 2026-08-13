import '../models/order.dart';
import 'pocketbase_client.dart';
import 'package:pocketbase/pocketbase.dart';

class OrderService {
  Future<RecordModel> createOrder(Order order) async {
    try {
      final pb = await getPocketbaseInstance();
      final body = order.toJson();
      final record = await pb.collection('orders').create(body: body);
      return record;
    } catch (e) {
      print('Lỗi khi tạo order: $e');
      rethrow; // Đẩy lỗi ra ui
    }
  }
  // Map<String,dynamic> các trường cần update
  Future<void> updateOrder(String orderId, Map<String, dynamic> data) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('orders').update(orderId, body: data);
    } catch (e) {
      print('Lỗi khi cập nhật order: $e');
      rethrow;
    }
  }
  Future<RecordModel> getOrderById(String orderId) async {
    try {
      final pb = await getPocketbaseInstance();
      // Dùng getOne để lấy 1 record
      final record = await pb.collection('orders').getOne(orderId);
      return record;
    } catch (e) {
      print('Lỗi khi getOrderById: $e');
      rethrow;
    }
  }
  Future<List<Order>> fetchAllOrders() async {
    try {
      final pb = await getPocketbaseInstance();
      // expand: 'user,car' để lấy luôn thông tin người dùng và xe
      final records = await pb
          .collection('orders')
          .getFullList(
            sort: '-created',
            expand: 'userId,carId',
          );

      return records.map((record) {
        return Order.fromJson(record.toJson());
      }).toList();
    } catch (e) {
      print('Lỗi fetchAllOrders: $e');
      rethrow;
    }
  }
  Future<bool> deleteOrder(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('orders').delete(id);
      return true;
    } catch (error) {
      print('Lỗi khi xoá order: $error');
      return false;
    }
  }
}
