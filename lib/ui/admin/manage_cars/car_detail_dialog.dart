import 'package:flutter/material.dart';
import '../../../models/car.dart';
// Hiển thị chi tiết thông tin xe 
class CarDetailDialog extends StatelessWidget {
  final Car car;
  const CarDetailDialog({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final String thumbnailUrl = car.imageUrls.isNotEmpty
        ? car.imageUrls.first
        : '';

    return AlertDialog(
      title: Text(car.title),
      // Giới hạn chiều rộng của Dialog
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8 > 400
            ? 400
            : MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần ảnh 
              (thumbnailUrl.isEmpty)
                  ? Container(
                      height: 150,
                      decoration: BoxDecoration(
                        // Thêm bo góc
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.grey,
                          size: 60,
                        ),
                      ),
                    )
                  : ClipRRect(
                      // Bo góc cho ảnh
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        thumbnailUrl,
                        height: 150,
                        fit: BoxFit.cover,
                        width: double.infinity, // Để ảnh lấp đầy SizedBox
                        errorBuilder: (ctx, err, stack) => Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
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
              const SizedBox(height: 16),

              // Dùng widget _buildDetailRow để canh đều
              _buildDetailRow('ID', car.id ?? "N/A"),
              _buildDetailRow('Vị trí', car.location),
              _buildDetailRow('Hộp số', car.gearbox),
              _buildDetailRow('Số ghế', '${car.seats} chỗ'),
              _buildDetailRow('Nhiên liệu', car.fuel),
              _buildDetailRow(
                'Đánh giá',
                '${car.rating.toStringAsFixed(1)} (${car.trips} chuyến)',
              ),
              _buildDetailRow(
                'Giá',
                '${car.newPrice.toStringAsFixed(0)} ₫/ngày',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    );
  }

  // Hỗ trợ hiển thị label và value đều nhau
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột 1: Tiêu đề
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          // Cột 2: Giá trị 
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
