import 'package:flutter/material.dart';

class BaoHiemChiTietBottomSheet extends StatelessWidget {
  const BaoHiemChiTietBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Text(
                "Bảo hiểm Bình An Vạn Dặm",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/banners/bannercar.jpg", // ảnh banner
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "🧑‍✈️ Bảo vệ cho tài xế & các thành viên trên xe cùng gói bảo hiểm Bình An Vạn Dặm từ bảo hiểm Hàng không DBV (VNI).",
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                "I. Nội dung sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text(
                "Trong thời gian thuê xe, tài xế & người ngồi trên xe được bảo hiểm nếu có thiệt hại về thân thể do sự cố không may phát sinh khi tham gia giao thông, với quyền lợi bảo hiểm lên tới 300.000.000 VNĐ/người/chuyến.",
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 12),
              const Text(
                "II. Điều khoản bảo hiểm",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text(
                "- Phạm vi bảo hiểm: Thiệt hại thân thể do tai nạn giao thông.\n"
                "- Lựa chọn cơ sở khám chữa bệnh bất kỳ trên toàn quốc.\n"
                "- Xem thêm nội dung bảo hiểm tại liên kết.",
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "III. Quy trình xử lý nếu xảy ra sự cố",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "1. Sơ cứu người bị thương hoặc gọi cấp cứu 115.",
                    style: TextStyle(height: 1.6),
                  ),
                  Text(
                    "2. Thông báo cho Bảo hiểm DBV (VNI) - 1900 96 96 90 và làm theo hướng dẫn tổng đài.",
                    style: TextStyle(height: 1.6),
                  ),
                  Text(
                    "3. Nộp hồ sơ yêu cầu bồi thường, gồm:",
                    style: TextStyle(height: 1.6),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• Giấy tờ xe bản photo (giấy đăng ký xe, giấy đăng kiểm), giấy phép lái xe, giấy CNBH;",
                        ),
                        Text("• Giấy yêu cầu bảo hiểm;"),
                        Text(
                          "• Toa thuốc hoặc giấy xuất viện hoặc giấy xác nhận thương tật (bản photo);",
                        ),
                        Text(
                          "• Chứng từ y tế: hoá đơn, phiếu chỉ định, kết quả chỉ định (bản online hoặc photo);",
                        ),
                        Text(
                          "• Các hồ sơ, tài liệu khác theo yêu cầu của nhà bảo hiểm.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}