import 'package:flutter/material.dart';
import '../../../models/car.dart'; 

class CarRow extends StatelessWidget {
  final Car car;
  final void Function(Car) onEdit;
  final void Function(Car) onDelete;
  final void Function(Car) onView;

  const CarRow({
    super.key,
    required this.car,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy ảnh đầu tiên trong danh sách imageUrls
    final String thumbnailUrl = car.imageUrls.isNotEmpty
        ? car.imageUrls.first
        : '';

    return Card(
      child: ListTile(
        leading: (thumbnailUrl.isEmpty)
            ? Container(
                width: 60,
                height: 60, // Kích thước cố định để giữ layout
                color: Colors.grey[200],
                child: const Icon(Icons.directions_car, color: Colors.grey),
              )
            : Image.network(
                thumbnailUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
        title: Text(car.title),
        subtitle: Text(
          '${car.newPrice.toStringAsFixed(0)} vn₫/ngày - ${car.location}',
        ),
        // Action button
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => onView(car),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () => onEdit(car),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(car),
            ),
          ],
        ),
      ),
    );
  }
}
