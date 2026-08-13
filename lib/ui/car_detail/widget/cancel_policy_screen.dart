import 'package:flutter/material.dart';
import '../widget/cancel_policy_bottomsheet.dart'; 
class CancelPolicyScreen extends StatelessWidget {
  const CancelPolicyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Chính sách huỷ chuyến"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bảng chính sách
              Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "Thời điểm huỷ chuyến",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "Phí huỷ chuyến",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  _buildRow(
                    "Trong vòng 1h sau giữ chỗ",
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 6),
                        Text("Miễn phí"),
                      ],
                    ),
                  ),
                  _buildRow(
                    "Trước chuyến đi > 7 ngày\n(Sau 1h giữ chỗ)",
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 6),
                        Text("10% giá trị chuyến đi"),
                      ],
                    ),
                  ),
                  _buildRow(
                    "Trong vòng 7 ngày trước chuyến đi\n(Sau 1h giữ chỗ)",
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cancel, color: Colors.red),
                        SizedBox(width: 6),
                        Text("40% giá trị chuyến đi"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "* Chính sách huỷ chuyến áp dụng chung cho cả khách thuê và chủ xe (ngoại lệ tùy vào thời điểm huỷ chuyến...).\n"
                "* Khách thuê không nhận xe sẽ mất phí huỷ chuyến (40% giá trị chuyến đi).\n"
                "* Chủ xe không giao xe sẽ hoàn tiền giữ chỗ & bồi thường phí huỷ chuyến cho khách thuê.\n"
                "* Tiền giữ chỗ & bồi thường do chủ xe huỷ chuyến (nếu có) sẽ được hoàn trả bằng chuyển khoản trong vòng 1-3 ngày làm việc.",
                style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const RefundProcedureBottomSheet(),
                  );
                },
                child: const Text(
                  "Thủ tục hoàn tiền & bồi thường huỷ chuyến",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildRow(String col1, Widget col2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(col1),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: col2,
        ),
      ],
    );
  }
}