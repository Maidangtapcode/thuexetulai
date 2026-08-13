import 'package:flutter/material.dart';
import '../../../ui/widget/responsive_layout.dart';
import '../../models/filter_option.dart';
import '../car_home/widget/cars_list.dart';
import 'package:provider/provider.dart';
import 'widget/filter_sheet.dart';
import '../car_home/widget/car_type_sheet.dart';
import 'widget/brandsheet.dart';
import '../widget/searchmanager.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final Set<String> _selectedFilters = {};
  Map<String, dynamic>? _mainFilterData;

  final List<String> _carTypeLabels = const [
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

  final List<String> _brandLabels = [
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

  void _handleFilterSelection(String label, bool selected) {
    if (label == 'Reset') {
      setState(() {
        _selectedFilters.clear();
        _mainFilterData = null;
      });
      return;
    }

    if (label == 'Loại xe') {
      showModalBottomSheet<List<String>>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) =>
            CarTypeSheet(selectedTypes: _selectedFilters.toList()),
      ).then((result) {
        if (result != null) {
          setState(() {
            _selectedFilters
              ..removeWhere((f) => _carTypeLabels.contains(f))
              ..addAll(result);
          });
        }
      });
      return;
    }

    if (label == 'Hãng xe') {
      showModalBottomSheet<List<String>>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => BrandSheet(
          selectedBrands: _selectedFilters
              .where((f) => _brandLabels.contains(f))
              .toList(),
        ),
      ).then((result) {
        if (result != null) {
          setState(() {
            _selectedFilters
              ..removeWhere((f) => _brandLabels.contains(f))
              ..addAll(result);
          });
        }
      });
      return;
    }

    setState(() {
      selected ? _selectedFilters.add(label) : _selectedFilters.remove(label);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchManager = context.watch<SearchManager>();
    final location = searchManager.location;

    return ResponsiveLayout(
      mobile: _buildScaffold(location),
      tablet: _buildScaffold(location),
      desktop: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _buildScaffold(location),
        ),
      ),
    );
  }

  Widget _buildScaffold(String? location) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          location != null && location.isNotEmpty ? location : 'Tất cả xe',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {
              showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) =>
                    FilterSheet(initialFilters: _mainFilterData),
              ).then((result) {
                if (result != null) {
                  setState(() => _mainFilterData = result);
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.green.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterButtons(),
              const SizedBox(height: 20),
              const Expanded(
                child: Padding(padding: EdgeInsets.all(5), child: CarsList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButtons() {
    final row1 = [
      FilterOption(icon: Icons.refresh, label: 'Reset'),
      FilterOption(icon: Icons.directions_car, label: 'Loại xe'),
      FilterOption(icon: Icons.language, label: 'Hãng xe'),
      FilterOption(icon: Icons.workspace_premium, label: 'Chủ xe 5★'),
      FilterOption(icon: Icons.location_on, label: 'Giao xe tận nơi'),
    ];

    final row2 = [
      FilterOption(icon: Icons.access_time, label: 'Thuê giờ'),
      FilterOption(icon: Icons.flash_on, label: 'Đặt xe nhanh'),
      FilterOption(icon: Icons.verified_user, label: 'Miễn thế chấp'),
      FilterOption(icon: Icons.local_offer, label: 'Xe giảm giá'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: row1.map((f) => _buildFilterChip(f)).toList()),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: row2.map((f) => _buildFilterChip(f)).toList()),
        ),
      ],
    );
  }

  Widget _buildFilterChip(FilterOption filter) {
    final label = filter.label;

    final isSelected = label == 'Loại xe'
        ? _selectedFilters.any((f) => _carTypeLabels.contains(f))
        : label == 'Hãng xe'
        ? _selectedFilters.any((f) => _brandLabels.contains(f))
        : _selectedFilters.contains(label);

    final isReset = label == 'Reset';

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            fontWeight: isReset ? FontWeight.bold : FontWeight.normal,
            color: isReset ? Colors.red.shade700 : Colors.black,
          ),
        ),
        avatar: Icon(
          filter.icon,
          size: 18,
          color: isReset ? Colors.red.shade700 : Colors.black87,
        ),
        onSelected: (selected) => _handleFilterSelection(label, selected),
        backgroundColor: Colors.white,
        selectedColor: Colors.green[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: isSelected ? Colors.green.shade400 : Colors.black26,
            width: isSelected ? 1.5 : 1,
          ),
        ),
      ),
    );
  }
}
