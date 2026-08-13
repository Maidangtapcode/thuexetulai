import 'package:flutter/material.dart';

class ReportCarScreen extends StatefulWidget {
  const ReportCarScreen({super.key});
  @override
  State<ReportCarScreen> createState() => _ReportCarScreenState();
}

class _ReportCarScreenState extends State<ReportCarScreen> {
  String? selectedReason;
  final TextEditingController contentController = TextEditingController();

  final List<String> reasons = [
    "Thông tin sai lệch",
    "Hình ảnh không đúng thực tế",
    "Giá thuê không hợp lý",
    "Chủ xe có hành vi không tốt",
    "Khác",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Báo xấu"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lý do báo xấu
            const Text(
              "Lý do báo xấu",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(selectedReason ?? "Chưa chọn lý do báo xấu"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await showModalBottomSheet<String>(
                  context: context,
                  builder: (_) => ListView(
                    children: reasons.map((r) {
                      return ListTile(
                        title: Text(r),
                        onTap: () => Navigator.pop(context, r),
                      );
                    }).toList(),
                  ),
                );
                if (result != null) setState(() => selectedReason = result);
              },
            ),

            const SizedBox(height: 16),
            const Text(
              "Nội dung",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Nhập nội dung",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const Spacer(),

            // Nút gửi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Đã gửi báo xấu thành công"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "Gửi báo xấu",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}