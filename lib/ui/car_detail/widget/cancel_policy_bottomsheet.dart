import 'package:flutter/material.dart';
class RefundProcedureBottomSheet extends StatelessWidget {
  const RefundProcedureBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh tiêu đề + nút đóng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chính sách huỷ chuyến",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Nội dung chính
              const Text(
                "Thủ tục hoàn tiền & bồi thường huỷ chuyến",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "PMKOTO sẽ hoàn lại tiền giữ chỗ (& tiền bồi thường do chủ xe huỷ chuyến nếu có) "
                "theo chính sách huỷ chuyến qua tài khoản ngân hàng của khách thuê "
                "trong vòng 1–3 ngày làm việc kể từ thời điểm huỷ chuyến.",
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 10),
              const Text(
                "* Nhân viên PMKOTO sẽ liên hệ khách thuê (qua số điện thoại đã đăng ký trên PMKOTO) "
                "để xin thông tin tài khoản ngân hàng, hoặc Khách thuê có thể chủ động gửi thông tin "
                "cho PMKOTO qua email contact@PMKOTO.vn hoặc nhắn tin tại PMKOTO Fanpage.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}