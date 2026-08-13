import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class AuthManager with ChangeNotifier {
  final AuthService _auth = AuthService();
  User? _loggedInUser;
  AuthManager() {
    _auth.onAuthChange = (user) {
      _loggedInUser = user;
      notifyListeners();
    };
  }
  User? get user => _loggedInUser;
  bool get isAuth => _loggedInUser != null;
  bool get isAdmin => _loggedInUser?.role == "admin";

  Future<User> signup(String email, String password, String name) =>
      _auth.signup(email, password, name);

  Future<User> login(String email, String password) =>
      _auth.login(email, password);

  Future<void> tryAutoLogin() async {
    _loggedInUser = await _auth.getUserFromStore();
    notifyListeners();
  }

  Future<void> logout() => _auth.logout();

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final updated = await _auth.updateProfile(data);
    _loggedInUser = updated;
    notifyListeners();
  }
}
