import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ui/widget/responsive_layout.dart';
import '../car_home/widget/cars_list.dart';
import '../car_home/widget/cars_manager.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildContent(context),
      tablet: _buildContent(context),
      desktop: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _buildContent(context),
        ),
      ),
    );
  }

  // Tách giao diện gốc thành một hàm tái sử dụng
  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Thêm nút quay lại
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Xe yêu thích',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Consumer<CarsManager>(
                  builder: (context, carsManager, child) {
                    final favoriteCars = carsManager.favoriteItems;

                    if (favoriteCars.isEmpty) {
                      return const Center(
                        child: Text('Bạn chưa có xe yêu thích nào.'),
                      );
                    }
                    return CarsList(carsToShow: favoriteCars);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
