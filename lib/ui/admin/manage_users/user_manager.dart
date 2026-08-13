import 'package:flutter/foundation.dart';
import '../../../models/user.dart';
import '../../auth/auth_manager.dart';
import '../../../services/pocketbase_client.dart';

class UserManager with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  List<User> get users => [..._users];
  int get userCount => _users.length;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers({AuthManager? authManager}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final pb = await getPocketbaseInstance();
      final records = await pb
          .collection('users')
          .getFullList(sort: '-created');
      _users = records.map((record) => User.fromJson(record.toJson())).toList();
    } catch (error) {
      print('Error fetching users: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(User user) async {
    _isLoading = true;
    notifyListeners();
    try {
      final pb = await getPocketbaseInstance();
      final body = user.toJson()..remove('id');
      body['password'] = '12345678';
      body['passwordConfirm'] = '12345678';
      final record = await pb.collection('users').create(body: body);
      _users.add(User.fromJson(record.toJson()));
    } catch (error) {
      print('Error adding user: $error');
      // Xử lý lỗi
    } finally {
      _isLoading = false;
      notifyListeners();
      await fetchUsers();
    }
  }

  Future<void> updateUser(User updatedUser) async {
    _isLoading = true;
    notifyListeners();
    try {
      final index = _users.indexWhere((user) => user.id == updatedUser.id);
      if (index == -1) {
        throw Exception('User not found');
      }
      final oldUser = _users[index];
      final pb = await getPocketbaseInstance();
      final body = updatedUser.toJson();

      if (updatedUser.email != oldUser.email) {
        body['emailConfirm'] = body['email'];
      } else {
        body.remove('email');
      }
      final record = await pb
          .collection('users')
          .update(updatedUser.id, body: body);
      if (index != -1) {
        _users[index] = User.fromJson(record.toJson());
      }
    } catch (error) {
      print('Error updating user: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
      await fetchUsers();
    }
  }

  Future<void> deleteUser(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('users').delete(userId);
      _users.removeWhere((user) => user.id == userId);
    } catch (error) {
      print('Error deleting user: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
      await fetchUsers();
    }
  }

  List<User> filterUsers(String query) {
    if (query.isEmpty) {
      return users;
    }
    return _users
        .where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.emaill.toLowerCase().contains(query.toLowerCase()) ||
              user.phone.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
