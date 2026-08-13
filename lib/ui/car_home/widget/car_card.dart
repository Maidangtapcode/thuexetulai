import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/car.dart'; // Đảm bảo đường dẫn này đúng
import '../../../utils/format_helper.dart';
import 'cars_manager.dart';

class CarCard extends StatelessWidget {
  const CarCard(this.car, {super.key});

  final Car car;

  @override
  Widget build(BuildContext context) {
    // 💡 SỬA LỖI 1: Lấy ảnh thumbnail (ảnh đầu tiên)
    // Kiểm tra xem list có rỗng không
    final String thumbnailUrl =
        car
            .imageUrls
            .isNotEmpty // <-- Dùng 'imageUrls' (số nhiều)
        ? car
              .imageUrls
              .first // Lấy ảnh đầu tiên
        : ''; // Để rỗng nếu không có ảnh

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- ẢNH XE & ICON ---
          Stack(
            children: [
              // 💡 SỬA LỖI 2: Hiển thị ảnh (có kiểm tra rỗng)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: (thumbnailUrl.isEmpty)
                    // Nếu không có ảnh, hiển thị placeholder
                    ? Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.directions_car,
                            color: Colors.grey,
                            size: 60,
                          ),
                        ),
                      )
                    // Nếu có ảnh, hiển thị nó
                    : Image.network(
                        thumbnailUrl, // Dùng ảnh đã sửa
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        // Xử lý nếu link ảnh bị lỗi
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
              ),

              // Icon trái tim
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () =>
                      context.read<CarsManager>().toggleFavoriteStatus(car.id!),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    radius: 16,
                    child: Icon(
                      // Sử dụng Consumer để lắng nghe thay đổi
                      context.watch<CarsManager>().isFavorite(car.id!)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: context.watch<CarsManager>().isFavorite(car.id!)
                          ? Colors.red
                          : Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              // Nhãn giảm giá
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Giảm ${car.discount}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- PHẦN THÔNG TIN XE ---
          // (Code phần này của bạn đã đúng, giữ nguyên)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: Colors.green,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Miễn thế chấp',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  car.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.settings, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(car.gearbox),
                    const SizedBox(width: 12),
                    const Icon(Icons.event_seat, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${car.seats} chỗ'),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.local_gas_station,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(car.fuel),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        car.location,
                        style: const TextStyle(color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.end, // Căn chỉnh dưới cùng
                  children: [
                    Flexible(
                      // Sử dụng Flexible để phần này co giãn
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(car.rating.toStringAsFixed(1)),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.directions_car,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          // Bọc Text trong Expanded để nó xuống dòng nếu cần
                          Expanded(
                            child: Text(
                              '${car.trips} chuyến',
                              overflow: TextOverflow.ellipsis, // Tránh tràn chữ
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8), // Thêm khoảng cách giữa 2 phần
                    Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .baseline, // Căn chỉnh baseline của Text
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (car.oldPrice > 0 && car.discount > 0) ...[
                          Text(
                            formatPrice(car.oldPrice),
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          formatPrice(car.newPrice),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('/ngày', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
