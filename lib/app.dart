import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:PKMOTO/core/theme/app_theme.dart';
import 'ui/admin/manage_users/user_manager.dart';
import 'ui/auth/auth_manager.dart';
import 'ui/car_home/widget/cars_manager.dart';
import 'ui/booking/widget/orders_manager.dart';
import 'ui/widget/searchmanager.dart';
import 'ui/payment/widget/payments_manager.dart';

class MyApp extends StatelessWidget {
  final AuthManager authManager;
  final GoRouter router;

  const MyApp({super.key, required this.authManager, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authManager),

        ChangeNotifierProxyProvider<AuthManager, UserManager>(
          create: (context) => UserManager(),
          update: (context, authManager, userManager) {
            if (authManager.isAdmin &&
                (userManager == null || userManager.users.isEmpty)) {
              Future.microtask(() => userManager?.fetchUsers());
            }
            return userManager!;
          },
        ),

        ChangeNotifierProxyProvider<AuthManager, CarsManager>(
          create: (context) => CarsManager(),
          update: (context, authManager, carsManager) {
            if (authManager.isAuth &&
                (carsManager == null || carsManager.items.isEmpty)) {
              Future.microtask(() => carsManager?.fetchCars());
            }
            return carsManager!;
          },
        ),

        ChangeNotifierProxyProvider<AuthManager, OrdersManager>(
          create: (context) => OrdersManager(),
          update: (context, authManager, ordersManager) {
            if (authManager.isAdmin &&
                (ordersManager == null || ordersManager.items.isEmpty)) {
              Future.microtask(() => ordersManager?.fetchAllOrders());
            }
            return ordersManager!;
          },
        ),
        ChangeNotifierProvider(create: (ctx) => SearchManager()),
        ChangeNotifierProxyProvider<AuthManager, PaymentsManager>(
          create: (context) => PaymentsManager(),
          update: (context, authManager, paymentsManager) {
            if (authManager.isAdmin &&
                (paymentsManager == null || paymentsManager.items.isEmpty)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                paymentsManager?.fetchAllPayments();
              });
            }
            return paymentsManager!;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Ứng dụng thuê xe tự lái',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
  
}
