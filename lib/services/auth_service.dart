import '../models/user.dart';
import 'pocketbase_client.dart';

class AuthService {
  void Function(User? user)? onAuthChange;
  // Lắng nghe sự thay đổi của PocketBase AuthStore - Khi có login/logout tự động gọi callback
  AuthService({this.onAuthChange}) {
    getPocketbaseInstance().then((pb) {
      pb.authStore.onChange.listen((auth) {
        if (onAuthChange != null) {
          final record = auth.record;
          // Nếu record = null - Đã logout
          onAuthChange!(record == null ? null : User.fromJson(record.toJson()));
        }
      });
    });
  }

  Future<User> signup(String email, String password, String name) async {
    final pb = await getPocketbaseInstance();
    final body = {
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": password,
      "name": name,
      "phone": "",
      "role": "user",
    };
    // Tạo bản ghi
    final record = await pb.collection('users').create(body: body);
    await login(email, password);
    return User.fromJson(record.toJson());
  }

  Future<User> login(String email, String password) async {
    final pb = await getPocketbaseInstance();
    final authData = await pb
        .collection('users')
        .authWithPassword(email, password);

    return User.fromJson(authData.record.toJson());
  }

  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    pb.authStore.clear();
  }
  // Lấy user từ authStore
  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    // Token không hợp lệ - chưa login
    if (!pb.authStore.isValid) return null;
    final model = pb.authStore.record;
    if (model == null) return null;
    return User.fromJson(model.toJson());
  }

  Future<User> updateProfile(Map<String, dynamic> data) async {
    final pb = await getPocketbaseInstance();
    try {
      final id = pb.authStore.record!.id;
      final record = await pb.collection('users').update(id, body: data);
      // Lưu vào authStore
      pb.authStore.save(pb.authStore.token, record);
      return User.fromJson(record.toJson());
    } catch (error) {
      throw Exception("Không thể cập nhật hồ sơ: $error");
    }
  }
}
