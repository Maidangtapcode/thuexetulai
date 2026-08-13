import 'package:flutter/material.dart';
class DieuKhoanSection extends StatefulWidget {
  const DieuKhoanSection({super.key});
  @override
  State<DieuKhoanSection> createState() => _DieuKhoanSectionState();
}

class _DieuKhoanSectionState extends State<DieuKhoanSection> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Điều khoản",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        // Hiển thị nội dung: rút gọn hoặc đầy đủ
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const Text(
            _DieuKhoanSectionShort._text,
            style: TextStyle(color: Colors.black87, height: 1.4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: const Text(
            _DieuKhoanSectionFull._text,
            style: TextStyle(color: Colors.black87, height: 1.4),
          ),
        ),
        const SizedBox(height: 8),
        // Nút Xem thêm / Thu gọn
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
                _isExpanded ? Icons.keyboard_arrow_up : Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DieuKhoanSectionShort {
  static const String _text = "# Thanh toán tiền thuê ngay khi bàn giao xe\n"
      "Quy định khác:\n"
      "o Sử dụng xe đúng mục đích.\n"
      "○ Không sử dụng xe thuê vào mục đích phi pháp, trái pháp luật.\n"
      "○ Không sử dụng xe thuê để cầm cố, thế chấp.\n"
      "○ Không hút thuốc, nhả kẹo cao su, xả rác trong xe....";
}

class _DieuKhoanSectionFull {
  static const String _text = "# Thanh toán tiền thuê ngay khi bàn giao xe\n"
      "Quy định khác:\n"
      "○ Sử dụng xe đúng mục đích.\n"
      "○ Không sử dụng xe thuê vào mục đích phi pháp, trái pháp luật.\n"
      "○ Không sử dụng xe thuê để cầm cố, thế chấp.\n"
      "○ Không hút thuốc, nhả kẹo cao su, xả rác trong xe.\n"
      "○ Không chở hàng quốc cấm dễ cháy nổ.\n"
      "○ Không chở hoa quả, thực phẩm nặng mùi trong xe.\n"
      "○ Khi trả xe, nếu xe bẩn hoặc có mùi trong xe, khách hàng vui lòng vệ sinh xe hoặc chịu phụ thu phí vệ sinh.\n\n"
      "Trân trọng cảm ơn, chúc quý khách hàng có những chuyến đi tuyệt vời!";
}