import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; 
import '../../widget/searchmanager.dart'; 
import '../../car_home/widget/cars_manager.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});
  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection>
    with TickerProviderStateMixin {
  bool isDriver = false;
  DateTimeRange? dateRange;
  String pickupText = '';
  int tripTypeIndex = 0;

  final DateFormat _df = DateFormat('HH:mm, dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEFFBF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  _buildTab(
                    icon: Icons.person,
                    label: 'Xe tự lái',
                    active: !isDriver,
                    onTap: () => _onTabTap(false),
                    roundLeft: true,
                    roundRight: false,
                  ),
                  _buildTab(
                    icon: Icons.local_taxi,
                    label: 'Xe có tài xế',
                    active: isDriver,
                    onTap: () => _onTabTap(true),
                    roundLeft: false,
                    roundRight: true,
                  ),
                ],
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _buildDriverTop(isDriver),
                    ),

                    // Điểm đón label + input row (single line)
                    const Text(
                      'Điểm đón',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    _inputRow(
                      icon: Icons.location_on_outlined,
                      text: pickupText.isEmpty ? 'Chọn địa điểm' : pickupText,
                      textColor: pickupText.isEmpty
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      onTap: () async {
                        final loc = await context.push<String>(
                          '/home/select-location',
                        );

                        if (loc == null || loc.isEmpty) return;
                        if (!mounted) return;

                        setState(() => pickupText = loc);

                        context.read<SearchManager>().updateSearch(
                          loc,
                          dateRange?.start,
                          dateRange?.end,
                        );
                      }

                    ),

                    const Divider(
                      height: 18,
                      thickness: 1,
                      color: Color(0xFFECECEC),
                    ),

                    // Thời gian label + input row
                    const Text(
                      'Thời gian',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _pickDateRange(context),
                      child: _inputRow(
                        icon: Icons.calendar_today_outlined,
                        text: dateRange == null
                            ? 'Chọn thời gian thuê'
                            : '${_df.format(dateRange!.start)} - ${_df.format(dateRange!.end)}',

                        textColor: dateRange == null
                            ? Colors.grey
                            : Colors.black87,

                        textSize: 13.5,
                      ),
                    ),

                    // thời lượng nếu có
                    if (dateRange != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Thời gian thuê: ${_formatDuration(dateRange!)}',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ] else
                      const SizedBox(height: 6),
                    const SizedBox(height: 8),

                    // Nút tìm xe
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lấy các manager
                          final searchManager = context.read<SearchManager>();
                          final carsManager = context.read<CarsManager>();

                          // Cập nhật lần cuối
                          searchManager.updateSearch(
                            pickupText,
                            dateRange?.start,
                            dateRange?.end,
                          );

                          // Tạo bộ lọc (filter)
                          String? filterString;
                          if (pickupText.isNotEmpty) {
                            // Dùng '~' để tìm kiếm chứa constant
                            filterString = 'location ~ "$pickupText"';
                          }

                          // Lọc xe trên server
                          carsManager.fetchCars(filter: filterString);

                          // Chuyển sang trang danh sách xe
                          context.push('/home/car_home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A86B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Tìm xe',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
    required bool roundLeft,
    required bool roundRight,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFBEEFCC) : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: roundLeft ? const Radius.circular(16) : Radius.zero,
              topRight: roundRight ? const Radius.circular(16) : Radius.zero,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: active ? Colors.black : Colors.black54,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.black : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverTop(bool visible) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 250),
      crossFadeState: visible
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Column(
        key: const ValueKey('driver_visible'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tripOption(0, 'Nội thành'),
              const SizedBox(width: 10),
              _tripOption(1, 'Liên tỉnh'),
              const SizedBox(width: 10),
              _tripOption(2, 'Liên tỉnh (1 chiều)'),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            tripTypeIndex == 0
                ? 'Di chuyển nội thành hoặc lân cận, lộ trình tự do.'
                : tripTypeIndex == 1
                ? 'Di chuyển giữa các tỉnh, phù hợp cho chuyến đi xa.'
                : 'Di chuyển 1 chiều giữa các tỉnh, tiết kiệm chi phí.',
            style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
        ],
      ),
      secondChild: const SizedBox.shrink(),
    );
  }

  Widget _inputRow({
    required IconData icon,
    required String text,
    Color textColor = Colors.black87,
    double textSize = 14,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: textColor, fontSize: textSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripOption(int index, String label) {
    final selected = tripTypeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => tripTypeIndex = index),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? const Color(0xFF00A86B) : Colors.grey,
              ),
              color: selected ? const Color(0xFF00A86B) : Colors.white,
            ),
            child: selected
                ? const Icon(Icons.check, size: 10, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _onTabTap(bool toDriver) {
    if (isDriver == toDriver) return; 
    setState(() {
      isDriver = toDriver;
    });
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange:
          dateRange ??
          DateTimeRange(
            start: now,
            end: now.add(const Duration(days: 1)),
          ), 
    );
    if (picked != null) {
      setState(() => dateRange = picked);

      // Ghi vào searchManager
      context.read<SearchManager>().updateSearch(
        pickupText,
        picked.start,
        picked.end,
      );
    }
  }

  String _formatDuration(DateTimeRange r) {
    final h = r.duration.inHours;
    if (h < 24) return '$h giờ';
    final days = h ~/ 24;
    final hours = h % 24;
    if (hours == 0) return '$days ngày';
    return '$days ngày $hours giờ';
  }
}
