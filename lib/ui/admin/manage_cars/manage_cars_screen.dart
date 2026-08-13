import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../../models/car.dart';
import '../../car_home/widget/cars_manager.dart';
import 'car_form_screen.dart';
import 'car_detail_dialog.dart';
import 'car_row.dart';
import '../widget/admin_app_bar.dart';
import '../widget/admin_drawer.dart';

class ManageCarsScreen extends StatefulWidget {
  const ManageCarsScreen({super.key});
  @override
  State<ManageCarsScreen> createState() => _ManageCarsScreenState();
}

class _ManageCarsScreenState extends State<ManageCarsScreen> {
  String _searchQuery = '';

  void _addCar() async {
    final newCar = await Navigator.push<Car>(
      context,
      MaterialPageRoute(builder: (_) => const CarFormScreen()),
    );
    if (!mounted || newCar == null) return; 
      await context.read<CarsManager>().addCar(newCar);
    
  }

  void _editCar(Car car) async {
    final updatedCar = await Navigator.push<Car>(
      context,
      MaterialPageRoute(builder: (_) => CarFormScreen(car: car)),
    );
    if (!mounted || updatedCar == null) return; 
      await context.read<CarsManager>().updateCar(updatedCar);
    
  }

  void _deleteCar(Car car) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa xe "${car.title}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CarsManager>().deleteCar(car.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _viewCarDetail(Car car) {
    showDialog(
      context: context,
      builder: (_) => CarDetailDialog(car: car),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe dữ liệu từ Provider
    final carsManager = context.watch<CarsManager>();
    // Hiển thị loading
    if (carsManager.isLoading) {
      return Scaffold(
        appBar: AdminAppBar(title: 'Quản lý xe'),
        drawer: const AdminDrawer(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (carsManager.error != null) {
      return Scaffold(
        appBar: AdminAppBar(title: 'Quản lý xe'),
        drawer: const AdminDrawer(),
        body: Center(child: Text('Lỗi: ${carsManager.error}')),
      );
    }

    // Lọc danh sách theo tìm kiếm
    final filteredCars = carsManager.items
        .where(
          (car) => car.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AdminAppBar(
        title: 'Quản lý xe',
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addCar)],
      ),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm xe...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          // Danh sách xe
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<CarsManager>().fetchCars(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filteredCars.length,
                itemBuilder: (ctx, i) => CarRow(
                  car: filteredCars[i],
                  onEdit: _editCar,
                  onDelete: _deleteCar,
                  onView: _viewCarDetail,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
