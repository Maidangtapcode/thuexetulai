import 'package:flutter/material.dart';
class CollateralBottomSheet extends StatelessWidget {
  const CollateralBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh đóng
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                const Text(
                  "Tài sản thế chấp",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Nội dung chi tiết
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "○ Chủ xe hỗ trợ chính sách miễn thế chấp. Khách hàng không cần để lại tài sản (xe máy hoặc 15tr tiền mặt) khi thuê xe của chủ xe.",
                    style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "○ Các phụ phí phát sinh (nếu có) trong quá trình thuê xe, khách hàng vui lòng thanh toán trực tiếp cho chủ xe khi làm thủ tục trả xe.",
                    style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}