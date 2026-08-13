import 'package:flutter/material.dart';

class BaoHiemBottomSheet extends StatelessWidget {
  const BaoHiemBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFDFF7E5), 
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nút đóng
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Tiêu đề
                const Text(
                  "Bảo hiểm thuê xe tự lái",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF25A065),
                  ),
                ),
                const SizedBox(height: 12),
                // Đoạn giới thiệu
                const Text(
                  "Với nhiều năm kinh nghiệm trong lĩnh vực cho thuê xe, "
                  "Mioto hiểu rằng các rủi ro đâm đụng, cháy nổ, thủy kích gây tổn thất lớn "
                  "(vượt quá khả năng chi trả) luôn tiềm ẩn trong thời gian thuê xe.",
                  style: TextStyle(fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: 12),

                _buildInfoRow(
                  icon: "X",
                  text:
                      "Trong khi đó, hầu hết các rủi ro phát sinh trong quá trình thuê xe tự lái "
                      "sẽ không thuộc phạm vi của Bảo hiểm thân vỏ xe theo năm "
                      "(hay còn gọi là Bảo hiểm 2 chiều).",
                  color: Colors.red,
                ),
                const SizedBox(height: 10),

                _buildInfoRow(
                  icon:"O",
                  text:
                      "Xuất phát từ nhu cầu thiết yếu của khách hàng, Mioto kết hợp với các đối tác bảo hiểm "
                      "hàng đầu Việt Nam cùng mang đến sản phẩm Bảo hiểm thuê xe tự lái "
                      "với mức phí thực sự tiết kiệm và số tiền bảo hiểm lớn "
                      "(đến 100% giá trị xe) giúp bạn an tâm tận hưởng hành trình.",
                  color: Colors.green,
                ),

                const SizedBox(height: 20),

                // PHẦN I
                const Text(
                  "I. Nội dung sản phẩm Bảo hiểm thuê xe",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Trong thời gian thuê xe, nếu xảy ra các sự cố va chạm ngoài ý muốn dẫn đến tổn thất về xe, "
                  "khách thuê sẽ chỉ bồi thường tối đa 2.000.000 VNĐ để sửa chữa xe (mức khấu trừ), "
                  "nhà bảo hiểm sẽ hỗ trợ chi phí vượt mức này.",
                  style: TextStyle(fontSize: 14, height: 1.6),
                ),

                const SizedBox(height: 12),

                // Bảng minh họa
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Thiệt hại xe",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Khách thanh toán",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("BH thanh toán",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("≤ 2 triệu"),
                          Text("≤ 2 triệu"),
                          Text("0 triệu"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("> 2 triệu"),
                          Text("2 triệu"),
                          Text("298 triệu"),
                        ],
                      ),
                      SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ví dụ minh họa: Xe có sự cố tổn thất 300.000.000đ.",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "• Lưu ý: Khách hàng cần thực hiện đầy đủ Quy trình xử lý khi xảy ra sự cố (Mục III bên dưới).",
                  style: TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 18),

                // PHẦN II
                const Text(
                  "II. Điều khoản Bảo hiểm",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                const Text(
                  "- Bảo hiểm vật chất xe: đâm va, hỏa hoạn, cháy nổ.\n"
                  "- Miễn phí cứu hộ tối đa 70km/vụ.\n"
                  "- Bảo hiểm thủy kích (khấu trừ 20% số tiền bảo hiểm, tối thiểu 3 triệu đồng).\n"
                  "- Mức khấu trừ: 2.000.000 VNĐ/vụ.\n"
                  "- Giải thích: Mức khấu trừ là số tiền khách thuê phải chi trả tối đa 2.000.000 VNĐ cho mỗi sự cố.\n"
                  "- Thiệt hại do xe không cho thuê được trong thời gian sửa chữa nếu có.\n"
                  "- Các lí do chủ quan khác nằm ngoài phạm vi bảo hiểm.",
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),

                const SizedBox(height: 6),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(text: "Xem thêm quy tắc bảo hiểm MIC tại "),
                      TextSpan(
                        text: "liên kết.",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(text: "Xem thêm quy tắc bảo hiểm DBV (VNI) tại "),
                      TextSpan(
                        text: "liên kết.",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // PHẦN III
                const Text(
                  "III. Quy trình xử lý nếu xảy ra sự cố",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                const Text(
                  "1. Khách thuê giữ nguyên hiện trường & chụp ảnh xe.\n"
                  "2. Tại thời điểm xảy ra sự cố, khách thuê gọi trung tâm bồi thường của nhà bảo hiểm "
                  "MIC (1900 55 88 91) hoặc DBV (1900 96 96 90), đọc số hợp đồng và làm theo hướng dẫn.\n"
                  "3. Giám định viên liên hệ xác minh thông tin, hiện trường.\n"
                  "4. Giám định viên & khách thuê mang xe ra garage để giám định và báo giá sửa chữa.\n"
                  "5. Trung tâm bồi thường ra Biên bản giám định.\n"
                  "6. Garage tiến hành sửa chữa theo báo giá.",
                  style: TextStyle(fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String text,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: TextStyle(fontSize: 18, color: color)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.5,
              color: color == Colors.red ? Colors.black : Colors.black87,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}