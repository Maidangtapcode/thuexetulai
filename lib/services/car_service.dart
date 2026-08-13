import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import '../models/car.dart'; 
import 'pocketbase_client.dart';

class CarsService {
  final String _fileKey = 'featuredImages';
  List<String> _getFeaturedImageUrls(PocketBase pb, RecordModel carModel) {
    final imageFileNames = carModel.getListValue<String>(_fileKey);
    if (imageFileNames.isEmpty) {
      return [];
    }
    return imageFileNames
        .map((fileName) => pb.files.getUrl(carModel, fileName).toString())
        .toList();
  }

  Future<Car?> addCar(Car car) async {
    try {
      final pb = await getPocketbaseInstance();
      final body = car.toJson();
      final List<http.MultipartFile> files = [];
      if (car.featuredImages != null) {
        for (var file in car.featuredImages!) {
          files.add(
            http.MultipartFile.fromBytes(
              _fileKey, 
              await file.readAsBytes(),
              filename: file.uri.pathSegments.last,
            ),
          );
        }
      }

      final carModel = await pb
          .collection('cars')
          .create(body: body, files: files);

      return car.copyWith(
        id: carModel.id,
        imageUrls: _getFeaturedImageUrls(pb, carModel),
        resetFeaturedImage: true,
      );
    } catch (error) {
      print('Lỗi khi thêm xe: $error');
      rethrow;
    }
  }
  Future<List<Car>> fetchCars({String? filter}) async {
    try {
      final pb = await getPocketbaseInstance();
      final carModels = await pb
          .collection('cars')
          .getFullList(sort: '-created', filter: filter);

      return carModels.map((carModel) {
        final imageUrls = _getFeaturedImageUrls(pb, carModel);
        final json = carModel.toJson();
        return Car.fromJson(json, imageUrls);
      }).toList();
    } catch (error) {
      print('Lỗi khi tải danh sách xe: $error');
      rethrow;
    }
  }

  Future<Car?> updateCar(Car car) async {
    try {
      final pb = await getPocketbaseInstance();
      final List<http.MultipartFile> files = [];
      if (car.featuredImages != null) {
        for (var file in car.featuredImages!) {
          files.add(
            http.MultipartFile.fromBytes(
              _fileKey,
              await file.readAsBytes(),
              filename: file.uri.pathSegments.last,
            ),
          );
        }
      }

      final carModel = await pb
          .collection('cars')
          .update(car.id!, body: car.toJson(), files: files);

      final newImageUrls = _getFeaturedImageUrls(pb, carModel);
      return car.copyWith(
        imageUrls: newImageUrls,
        resetFeaturedImage: true, 
      );
    } catch (error) {
      print('Lỗi khi cập nhật xe: $error');
      return null;
    }
  }

  Future<bool> deleteCar(String id) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('cars').delete(id);
      return true;
    } catch (error) {
      print('Lỗi khi xoá xe: $error');
      return false;
    }
  }


  Future<void> addFavorite(String carId) async {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.record!.id;

    await pb
        .collection('favorites')
        .create(body: {"user": userId, "car": carId});
  }

  Future<void> removeFavorite(String carId) async {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.record!.id;

    final result = await pb
        .collection('favorites')
        .getList(filter: 'user = "$userId" && car = "$carId"');

    if (result.items.isNotEmpty) {
      await pb.collection('favorites').delete(result.items.first.id);
    }
  }

  Future<void> toggleFavorite(String carId, bool isFav) async {
    if (isFav) {
      await removeFavorite(carId);
    } else {
      await addFavorite(carId);
    }
  }

  // Lấy danh sách ID các xe yêu thích của user hiện tại
  Future<List<String>> getUserFavoriteIds() async {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.record!.id;

    final result = await pb
        .collection('favorites')
        .getList(expand: 'car', filter: 'user = "$userId"');

    return result.items.map((e) => e.expand['car']!.first.id).toList();
  }

  // Gắn isFavorite theo user
  Future<List<Car>> fetchCarsWithFavoriteMark() async {
    final cars = await fetchCars();
    final favIds = await getUserFavoriteIds();

    return cars.map((c) {
      final isFav = favIds.contains(c.id);
      return c.copyWith(isFavorite: isFav);
    }).toList();
  }
}
