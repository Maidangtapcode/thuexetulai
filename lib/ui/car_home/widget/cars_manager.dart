import 'package:flutter/foundation.dart';
import '../../../models/car.dart';
import '../../../services/car_service.dart';

class CarsManager with ChangeNotifier {
 
  final CarsService _carsService = CarsService();
  List<Car> _items = [];
  bool _isLoading = false;
  String? _error;
  List<String> _favoriteCarIds = [];
  List<Car> get items => [..._items];
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.length;
  int get carCount => _items.length;
  /// ✔ Danh sách xe yêu thích của user
  List<Car> get favoriteItems =>
      _items.where((car) => _favoriteCarIds.contains(car.id)).toList();

  /// ✔ Kiểm tra 1 xe có yêu thích không
  bool isFavorite(String carId) => _favoriteCarIds.contains(carId);

  Car? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  ///  FETCH CARS + FAVORITES
  Future<void> fetchCars({String? filter}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. tải danh sách xe
      _items = await _carsService.fetchCars(filter: filter);

      // 2. tải danh sách ID xe yêu thích theo user hiện tại
      _favoriteCarIds = await _carsService.getUserFavoriteIds();
    } catch (error) {
      print('Lỗi khi tải danh sách xe: $error');
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  ///  CRUD XE

  Future<void> addCar(Car car) async {
    try {
      final newCar = await _carsService.addCar(car);
      if (newCar != null) {
        _items.add(newCar);
        notifyListeners();
      }
    } catch (error) {
      print('Lỗi khi thêm xe: $error');
      rethrow;
    }
  }

  Future<void> updateCar(Car car) async {
    try {
      final index = _items.indexWhere((item) => item.id == car.id);
      if (index >= 0) {
        final updatedCar = await _carsService.updateCar(car);
        if (updatedCar != null) {
          _items[index] = updatedCar;
          notifyListeners();
        }
      }
    } catch (error) {
      print('Lỗi khi cập nhật xe: $error');
      rethrow;
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      final success = await _carsService.deleteCar(id);
      if (success) {
        _items.removeWhere((car) => car.id == id);
        _favoriteCarIds.remove(id); // Xóa khỏi danh sách yêu thích
        notifyListeners();
      }
    } catch (error) {
      print('Lỗi khi xoá xe: $error');
      rethrow;
    }
  }

  ///  FAVORITE – MỖI USER TÁCH BIỆT
  Future<void> toggleFavoriteStatus(String carId) async {
    final isFav = _favoriteCarIds.contains(carId);

    try {
      // Gọi API toggle
      await _carsService.toggleFavorite(carId, isFav);

      // Cập nhật local state
      if (isFav) {
        _favoriteCarIds.remove(carId);
      } else {
        _favoriteCarIds.add(carId);
      }

      // Cập nhật trạng thái isFavorite của xe trong list _items để UI thay đổi ngay lập tức
      final index = _items.indexWhere((car) => car.id == carId);
      if (index != -1) {
        final oldCar = _items[index];
        _items[index] = oldCar.copyWith(isFavorite: !isFav);
      }

      notifyListeners();
    } catch (error) {
      print("Lỗi toggle yêu thích: $error");
    }
  }
}
