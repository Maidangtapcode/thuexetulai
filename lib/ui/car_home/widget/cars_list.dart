import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:go_router/go_router.dart';
import '../../../models/car.dart';
import 'cars_manager.dart'; 
import 'car_card.dart';

class CarsList extends StatelessWidget {
  final List<Car>? carsToShow;
  const CarsList({super.key, this.carsToShow});

  @override
  Widget build(BuildContext context) {
    
    if (carsToShow == null) {
      final carsManager = context.watch<CarsManager>();

    if (carsManager.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (carsManager.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Lỗi: ${carsManager.error}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    }

    // Sử dụng carsToShow nếu được cung cấp, nếu không thì dùng carsManager.items
    final cars = carsToShow ?? context.watch<CarsManager>().items;

    if (cars.isEmpty) {
      return const Center(child: Text('Không có xe nào.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: cars.length,
      itemBuilder: (ctx, i) => GestureDetector(
        onTap: () {
          context.push('/car_detail/${cars[i].id}');
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CarCard(cars[i]),
        ),
      ),
    );
  }
}
