import 'package:flutter/material.dart';

class CarTypeSheet extends StatefulWidget {
  final List<String> selectedTypes; // các loại đã chọn trước đó
  const CarTypeSheet({super.key, required this.selectedTypes});

  @override
  State<CarTypeSheet> createState() => _CarTypeSheetState();
}

class _CarTypeSheetState extends State<CarTypeSheet> {
  late List<String> _selected;

  final List<String> _carTypes = [
    'Xe 4 chỗ',
    'Xe 7 chỗ',
    'Xe bán tải',
    'Xe thể thao',
    'Xe điện',
    'SUV',
    'Crossover',
    'MPV',
    'Coupe',
  ];

  @override
  void initState() {
    super.initState();
    _selected = List<String>.from(widget.selectedTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tiêu đề
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chọn loại xe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => setState(() => _selected.clear()),
                child: const Text(
                  'Đặt lại',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          const Divider(),

          // Danh sách loại xe
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _carTypes.length,
              itemBuilder: (context, index) {
                final type = _carTypes[index];
                final isSelected = _selected.contains(type);
                return CheckboxListTile(
                  title: Text(type),
                  activeColor: Colors.green,
                  value: isSelected,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selected.add(type);
                      } else {
                        _selected.remove(type);
                      }
                    });
                  },
                );
              },
            ),
          ),

          const Divider(),

          // Nút xác nhận
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () => Navigator.pop(context, _selected),
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text('Áp dụng', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
