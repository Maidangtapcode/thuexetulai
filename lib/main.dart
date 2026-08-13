import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'router/app_router.dart';
import 'ui/auth/auth_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'services/notification_service.dart';

// Create a GlobalKey for the Navigator
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('vi_VN', null);

  // Initialize Notification Service
  await NotificationService().init(_navigatorKey);
  await NotificationService().requestPermissions();
  final authManager = AuthManager();
  //await authManager.logout();
  await authManager.tryAutoLogin();
  final router = createAppRouter(authManager, _navigatorKey);
  runApp(MyApp(authManager: authManager, router: router));
}
