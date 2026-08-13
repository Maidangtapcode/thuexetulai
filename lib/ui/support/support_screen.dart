import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Trung tâm hỗ trợ nhanh',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE7F7EE),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/CSKH.png', width: 80),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Trung tâm hỗ trợ nhanh',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Cần hỗ trợ nhanh vui lòng gọi ',
                    style: TextStyle(fontSize: 14),
                  ),
                  const Text(
                    '1900 9217 (7:00AM - 10:00PM) hoặc gửi tin nhắn vào Mioto Fanpage.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                          ),
                          icon: const Icon(Icons.phone),
                          label: const Text('Gọi'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.message_outlined),
                          label: const Text('Gửi tin nhắn'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hotline Bảo hiểm',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InsuranceLogo('assets/images/MIC.png', 'MIC'),
                const SizedBox(width: 5),
                _InsuranceLogo('assets/images/PVI.png', 'PVI'),
                const SizedBox(width: 5),
                _InsuranceLogo('assets/images/DBV.png', 'DBV'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Hướng dẫn',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: _GuideCard(
                title: 'Hướng dẫn \nđặt xe',

                imagePath: 'assets/images/huongdan.png',
                onTap: () {},
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Thông tin',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              children: const [
                _InfoItem(icon: Icons.apartment, title: 'Thông tin công ty'),
                _InfoItem(
                  icon: Icons.assignment,
                  title: 'Chính sách và quy định',
                ),
                _InfoItem(icon: Icons.star_rate, title: 'Đánh giá ứng dụng'),
                _InfoItem(icon: Icons.facebook, title: 'Fanpage Mioto'),
                _InfoItem(icon: Icons.help_outline, title: 'Hỏi và trả lời'),
                _InfoItem(icon: Icons.receipt_long, title: 'Quy chế hoạt động'),
                _InfoItem(icon: Icons.lock_outline, title: 'Bảo mật thông tin'),
                _InfoItem(
                  icon: Icons.check_circle_outline,
                  title: 'Giải quyết tranh chấp',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Phiên bản 4.2.7 (887)',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _InsuranceLogo extends StatelessWidget {
  final String imagePath;
  final String label;
  const _InsuranceLogo(this.imagePath, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Center(child: Image.asset(imagePath, height: 100)),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _GuideCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 500,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE7F7EE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 200),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const _InfoItem({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 170, 218, 172), size: 60),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}
