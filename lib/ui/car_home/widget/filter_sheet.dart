import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  const FilterSheet({super.key, this.initialFilters});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  // 🔹 Các biến trạng thái cơ bản (Đã có)
  double _priceValue = 0; // 0 = Bất kỳ, 3000 = max
  double _kmLimit = 0;
  String _transmission = 'Tất cả';
  bool _unlimitedKm = false;
  String _selectedSortOption = 'Tối ưu';

  // 🔹 Các biến trạng thái BỔ SUNG
  double _overFeeValue = 0; // Phí vượt giới hạn
  double _distanceValue = 44; // Khoảng cách (44km trở lại)
  double _seatsValue = 0; // Số chỗ (0 = Bất kỳ)
  double _yearValue = 0; // Năm sản xuất (0 = Bất kỳ, 2025 = Max)
  String _fuelType = 'Tất cả'; // Nhiên liệu
  double _fuelConsumption = 0; // Mức nhiên liệu tiêu thụ (0 = Mặc định)
  Map<String, bool> _selectedFeatures = {}; // Danh sách Tính năng

  // Danh sách đầy đủ các Tính năng
  final List<String> _featureList = [
    'Bản đồ',
    'Cửa sổ trời',
    'Bluetooth',
    'Định vị GPS',
    'Camera 360',
    'Ghế trẻ em',
    'Camera cập lề',
    'Khe cắm USB',
    'Camera hành trình',
    'Lốp dự phòng',
    'Camera lùi',
    'Màn hình DVD',
    'Cảm biến lốp',
    'Nắp thùng xe bán tải',
    'Cảm biến va chạm',
    'ETC',
    'Cảnh báo tốc độ',
    'Túi khí an toàn',
  ];

  @override
  void initState() {
    super.initState();
    // Nếu có dữ liệu lọc ban đầu, hãy áp dụng nó
    if (widget.initialFilters != null) {
      final filters = widget.initialFilters!;
      _priceValue = filters['price_max'] ?? 0;
      _transmission = filters['transmission'] ?? 'Tất cả';
      _kmLimit = (filters['km_limit'] is num)
          ? (filters['km_limit'] as num).toDouble()
          : 0;
      _unlimitedKm = filters['km_limit'] == 'unlimited';
      _selectedSortOption = filters['sort_by'] ?? 'Tối ưu';
      _overFeeValue = (filters['over_fee'] is num)
          ? (filters['over_fee'] as num).toDouble()
          : 0;
      _distanceValue = (filters['distance_max'] is num)
          ? (filters['distance_max'] as num).toDouble()
          : 44;
      _seatsValue = (filters['seats'] is num)
          ? (filters['seats'] as num).toDouble()
          : 0;
      _yearValue = (filters['year_min'] is num)
          ? (filters['year_min'] as num).toDouble()
          : 0;
      _fuelType = filters['fuel_type'] ?? 'Tất cả';
      _fuelConsumption = (filters['fuel_consumption'] is num)
          ? (filters['fuel_consumption'] as num).toDouble()
          : 0;

      final features = (filters['features'] as List?)?.cast<String>() ?? [];
      for (var feature in _featureList) {
        _selectedFeatures[feature] = features.contains(feature);
      }
    } else {
      // Khởi tạo mặc định nếu không có dữ liệu
      for (var feature in _featureList) {
        _selectedFeatures[feature] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9, // Tăng kích thước ban đầu để hiển thị nhiều hơn
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 🔹 Header (Được điều chỉnh để giống ảnh)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bộ lọc',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),

              // 🔹 Sắp xếp theo (Được điều chỉnh để giống ảnh)
              GestureDetector(
                onTap: () => _showSortOptions(context),
                child: Row(
                  children: [
                    const Text('Sắp xếp theo: '),
                    Text(
                      _selectedSortOption,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              ),

              const Divider(),

              // 🔹 Nội dung bộ lọc
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Mức giá (Đã có)
                    _buildFilterSlider(
                      title: 'Mức giá',
                      value: _priceValue,
                      min: 0,
                      max: 3000,
                      divisions: 30,
                      onChanged: (v) => setState(() => _priceValue = v),
                      displayValue: _priceValue == 0
                          ? 'Bất kỳ'
                          : '${_priceValue.toInt()}k',
                    ),
                    const Divider(),

                    // Truyền động (Đã có)
                    _buildRadioGroup(
                      title: 'Truyền động',
                      currentValue: _transmission,
                      options: ['Tất cả', 'Số sàn', 'Số tự động'],
                      onChanged: (v) => setState(() => _transmission = v),
                    ),
                    const Divider(),

                    // Giới hạn số km (Đã có, được tách riêng do có Checkbox)
                    _buildKmLimitSection(),
                    const Divider(),

                    // 🔹 Phí vượt giới hạn (BỔ SUNG)
                    _buildFilterSlider(
                      title: 'Phí vượt giới hạn',
                      value: _overFeeValue,
                      min: 0,
                      max: 100, // Ví dụ: 100k
                      divisions: 10,
                      onChanged: (v) => setState(() => _overFeeValue = v),
                      displayValue: _overFeeValue == 0
                          ? 'Mặc định'
                          : '${_overFeeValue.toInt()}k/km',
                    ),
                    const Divider(),

                    // 🔹 Khoảng cách (BỔ SUNG)
                    _buildFilterSlider(
                      title: 'Khoảng cách',
                      value: _distanceValue,
                      min: 1,
                      max: 100,
                      divisions: 99,
                      onChanged: (v) => setState(() => _distanceValue = v),
                      displayValue: '${_distanceValue.toInt()} km trở lại',
                      hasInfo: true,
                    ),
                    const Divider(),

                    // 🔹 Số chỗ (BỔ SUNG)
                    _buildFilterSlider(
                      title: 'Số chỗ',
                      value: _seatsValue,
                      min: 0,
                      max: 16,
                      divisions: 16,
                      onChanged: (v) => setState(() => _seatsValue = v),
                      displayValue: _seatsValue == 0
                          ? 'Bất kỳ'
                          : '${_seatsValue.toInt()} chỗ',
                    ),
                    const Divider(),

                    // 🔹 Năm sản xuất (BỔ SUNG)
                    _buildFilterSlider(
                      title: 'Năm sản xuất',
                      value: _yearValue,
                      min: 0,
                      max: 2025,
                      divisions: 50,
                      onChanged: (v) => setState(() => _yearValue = v),
                      displayValue: _yearValue == 0
                          ? 'Bất kỳ'
                          : '${_yearValue.toInt()}',
                    ),
                    const Divider(),

                    // 🔹 Nhiên liệu (BỔ SUNG)
                    _buildRadioGroup(
                      title: 'Nhiên liệu',
                      currentValue: _fuelType,
                      options: ['Tất cả', 'Xăng', 'Dầu', 'Điện', 'Xăng & điện'],
                      onChanged: (v) => setState(() => _fuelType = v),
                    ),
                    const Divider(),

                    // 🔹 Mức nhiên liệu tiêu thụ (BỔ SUNG)
                    _buildFilterSlider(
                      title: 'Mức nhiên liệu tiêu thụ',
                      value: _fuelConsumption,
                      min: 0,
                      max: 20, // Ví dụ: 20 lít/100km
                      divisions: 20,
                      onChanged: (v) => setState(() => _fuelConsumption = v),
                      displayValue: _fuelConsumption == 0
                          ? 'Mặc định'
                          : '${_fuelConsumption.toInt()} L/100km',
                    ),
                    const Divider(),

                    // 🔹 Tính năng (BỔ SUNG)
                    _buildFeaturesSection(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // 🔹 Nút Áp dụng (Thường có ở cuối)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý logic áp dụng bộ lọc và đóng sheet
                      Navigator.pop(context, _collectFilterData());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------
  // 🔸 HELPER WIDGETS
  // ---------------------------------------------

  // 🔸 Tiêu đề phần
  Widget _buildSectionTitle(String title, {bool hasInfo = false}) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 4),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (hasInfo)
          const Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Icon(Icons.help_outline, size: 16, color: Colors.grey),
          ),
      ],
    ),
  );

  // 🔸 Widget chung cho Slider
  Widget _buildFilterSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String displayValue,
    bool hasInfo = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, hasInfo: hasInfo),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: displayValue,
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
        Text(
          displayValue,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // 🔸 Widget chung cho Radio Group
  Widget _buildRadioGroup({
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    // Để giữ giao diện mở rộng, tôi dùng ExpansionTile để cuộn nội dung
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: currentValue,
          activeColor: Colors.green,
          onChanged: (value) => onChanged(value!),
        );
      }).toList(),
    );
  }

  // 🔸 Phần Giới hạn số km (Riêng biệt)
  Widget _buildKmLimitSection() {
    String kmDisplay = _unlimitedKm
        ? 'Không giới hạn'
        : '${_kmLimit.toInt()} km/ngày';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Giới hạn số km', hasInfo: true),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Slider(
                value: _kmLimit,
                min: 0,
                max: 500,
                divisions: 50,
                label: kmDisplay,
                activeColor: Colors.green,
                onChanged: _unlimitedKm
                    ? null
                    : (value) => setState(() => _kmLimit = value),
              ),
            ),
            Checkbox(
              value: _unlimitedKm,
              onChanged: (v) => setState(() => _unlimitedKm = v!),
              activeColor: Colors.green,
            ),
            const Text('Không giới hạn'),
          ],
        ),
        Text(
          kmDisplay,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  // 🔸 Phần Tính năng (Sử dụng Checkbox)
  Widget _buildFeaturesSection() {
    // Chia danh sách thành 2 cột
    List<String> col1 = [];
    List<String> col2 = [];
    for (int i = 0; i < _featureList.length; i++) {
      if (i % 2 == 0) {
        col1.add(_featureList[i]);
      } else {
        col2.add(_featureList[i]);
      }
    }

    // Để giữ giao diện mở rộng, tôi dùng ExpansionTile
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: const Text(
        'Tính năng',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột 1
            Expanded(
              child: Column(
                children: col1
                    .map((feature) => _buildFeatureCheckbox(feature))
                    .toList(),
              ),
            ),
            // Cột 2
            Expanded(
              child: Column(
                children: col2
                    .map((feature) => _buildFeatureCheckbox(feature))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 🔸 Tùy chọn Checkbox cho Tính năng
  Widget _buildFeatureCheckbox(String label) {
    // Điều chỉnh để checkbox nhỏ hơn và sát lề hơn (dùng Padding và Row)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFeatures[label] = !(_selectedFeatures[label] ?? false);
          });
        },
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _selectedFeatures[label] ?? false,
                onChanged: (v) {
                  setState(() {
                    _selectedFeatures[label] = v ?? false;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------
  // 🔸 LOGIC
  // ---------------------------------------------

  void _resetFilters() {
    setState(() {
      _priceValue = 0;
      _kmLimit = 0;
      _unlimitedKm = false;
      _transmission = 'Tất cả';
      _selectedSortOption = 'Tối ưu';

      // Reset BỔ SUNG
      _overFeeValue = 0;
      _distanceValue = 44;
      _seatsValue = 0;
      _yearValue = 0;
      _fuelType = 'Tất cả';
      _fuelConsumption = 0;
      _selectedFeatures.updateAll((key, value) => false);
      Navigator.pop(context, _collectFilterData()); // Trả về bộ lọc đã reset
    });
  }

  // 🔹 Hiển thị phần "Sắp xếp theo" (Đã có, chỉ thay đổi icon đóng)
  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String tempSelection = _selectedSortOption;

        final options = [
          'Tối ưu',
          'Khoảng cách gần nhất',
          'Giá thấp nhất',
          'Giá cao nhất',
          'Đánh giá tốt nhất',
        ];

        return StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Nút đóng (X)
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Sắp xếp theo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Danh sách lựa chọn
                ...options.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: tempSelection,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setModalState(() => tempSelection = value!);
                      setState(() => _selectedSortOption = value!);
                      Navigator.pop(context); // Tự động đóng sau khi chọn
                    },
                  );
                }).toList(),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔸 Hàm thu thập dữ liệu lọc
  Map<String, dynamic> _collectFilterData() {
    return {
      'sort_by': _selectedSortOption,
      'price_max': _priceValue,
      'transmission': _transmission,
      'km_limit': _unlimitedKm ? 'unlimited' : _kmLimit,
      'over_fee': _overFeeValue,
      'distance_max': _distanceValue,
      'seats': _seatsValue,
      'year_min': _yearValue,
      'fuel_type': _fuelType,
      'fuel_consumption': _fuelConsumption,
      'features': _selectedFeatures.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList(),
    };
  }
}
