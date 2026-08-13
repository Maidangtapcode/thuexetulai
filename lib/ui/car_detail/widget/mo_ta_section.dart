import 'package:flutter/material.dart';
class MoTaSection extends StatefulWidget {
  const MoTaSection({super.key});
  @override
  State<MoTaSection> createState() => _MoTaSectionState();
}
class _MoTaSectionState extends State<MoTaSection> {
  bool _isExpanded = false;

  static const String _shortText =
      "- Ngoài các ưu đãi về giá, MICARRO còn hỗ trợ thêm cho Quý khách các chính sách sau:\n"
      "* Hoàn tiền đổ xăng dư.\n"
      "* Miễn phí vượt dưới 1h.\n"
      "* Miễn phí vượt dưới 10Km.\n"
      "- Sử dụng miễn phí: Nước, đồ ăn vặt, khăn giấy có trong gói MICAR KIT khi thuê xe...";

  static const String _fullText =
      "- Ngoài các ưu đãi về giá MICARRO còn hỗ trợ thêm cho Quý Khách hàng các Chính sách như sau:\n"
      "* Hoàn Tiền đổ xăng dư.\n"
      "* Miễn phí vượt dưới 1h.\n"
      "* Miễn phí vượt dưới 10Km.\n"
      "- Sử dụng miễn phí: Nước, Đồ ăn vặt, Khăn giấy có trong gói MICAR KIT khi thuê xe.\n\n"
      "Mitsubishi Xpander là một mẫu MPV 7 chỗ ngồi. Xe được thiết kế hiện đại và thể thao, với đường nét sắc sảo và mạnh mẽ. "
      "Xpander trang bị động cơ xăng tiết kiệm nhiên liệu và hiệu suất cao, cung cấp trải nghiệm lái êm ái và mạnh mẽ. "
      "Xe có không gian nội thất rộng rãi và thoải mái, với nhiều tiện nghi hiện đại và tiện lợi cho người sử dụng. "
      "Mitsubishi Xpander được xem là một lựa chọn phù hợp cho gia đình hoặc các chuyến đi dài hạn.";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 0.6,
          height: 24,
        ),

        // Tiêu đề
        const Text(
          "Mô tả",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),

        // Nội dung ( rút gọn / đầy đủ )
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          firstChild: Text(
            _shortText,
            style: const TextStyle(color: Colors.black87, height: 1.4),
          ),
          secondChild: Text(
            _fullText,
            style: const TextStyle(color: Colors.black87, height: 1.4),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),

        const SizedBox(height: 8),

        // Nút xem thêm / thu gọn
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            children: [
              Text(
                _isExpanded ? "Thu gọn" : "Xem thêm",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black,
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.6,
          height: 24,
        ),
      ],
    );
  }
}