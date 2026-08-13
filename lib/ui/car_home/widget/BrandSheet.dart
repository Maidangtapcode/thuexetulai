import 'package:flutter/material.dart';

class BrandSheet extends StatefulWidget {
  final List<String> selectedBrands;
  const BrandSheet({super.key, required this.selectedBrands});
  @override
  State<BrandSheet> createState() => _BrandSheetState();
}

class _BrandSheetState extends State<BrandSheet> {
  late List<String> _selected;

  final List<String> _brands = [
    'Toyota',
    'Honda',
    'Mazda',
    'Ford',
    'Hyundai',
    'Kia',
    'VinFast',
    'Mercedes',
    'BMW',
  ];

  @override
  void initState() {
    super.initState();
    _selected = List<String>.from(widget.selectedBrands);
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chọn hãng xe',
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

          // Danh sách hãng xe
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _brands.length,
              itemBuilder: (context, index) {
                final brand = _brands[index];
                final isSelected = _selected.contains(brand);
                return CheckboxListTile(
                  title: Text(brand),
                  activeColor: Colors.green,
                  value: isSelected,
                  onChanged: (v) {
                    setState(() {
                      if (v == true && !_selected.contains(brand)) {
                        _selected.add(brand);
                      } else if (v == false) {
                        _selected.remove(brand);
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
