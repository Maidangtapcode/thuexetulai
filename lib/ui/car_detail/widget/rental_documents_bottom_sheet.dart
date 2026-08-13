import 'package:flutter/material.dart';
class RentalDocumentsBottomSheet extends StatelessWidget {
  const RentalDocumentsBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh kéo nhỏ ở trên
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Nút đóng + Tiêu đề
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Giấy tờ thuê xe",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black87),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              "Bạn đã có CCCD gắn chip",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Giấy tờ thuê xe bao gồm:",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 4),
            const Text(
              "o Giấy phép lái xe (chủ xe đối chiếu bản gốc với thông tin GPLX đã xác thực trên app Mioto & gửi lại bạn);\n"
              "o CCCD gắn chip (chủ xe đối chiếu bản gốc với thông tin cá nhân trên VNeID & gửi lại bạn)",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 16),

            const Text(
              "Bạn chưa có CCCD gắn chip",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Giấy tờ thuê xe bao gồm:",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 4),
            const Text(
              "o Giấy phép lái xe (chủ xe đối chiếu bản gốc với thông tin GPLX đã xác thực trên app Mioto & gửi lại bạn);\n"
              "o Passport (chủ xe kiểm tra bản gốc, giữ lại và hoàn trả khi bạn trả xe)",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 16),

            const Text(
              "Lưu ý: Khách thuê vui lòng chuẩn bị đầy đủ BẢN GỐC tất cả giấy tờ thuê xe khi làm thủ tục nhận xe.",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}