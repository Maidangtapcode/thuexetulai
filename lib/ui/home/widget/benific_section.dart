import 'package:flutter/material.dart';

class MiotoBenefitsSection extends StatelessWidget {
  const MiotoBenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Nội dung chính
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _smallBenefitBox(
                      icon: Icons.directions_car_rounded,
                      title: 'Lái xe an toàn cùng Mioto',
                      desc:
                          'Các chuyến đi được bảo hiểm bởi MIC & VNI. Khách thuê chỉ bồi thường tối đa 2 triệu đồng khi có sự cố.',
                    ),
                    _smallBenefitBox(
                      icon: Icons.map_outlined,
                      title: 'Tự do lộ trình',
                      desc:
                          'Bạn có thể di chuyển linh hoạt nội thành hoặc liên tỉnh, không giới hạn quãng đường trong hợp đồng.',
                    ),
                    _smallBenefitBox(
                      icon: Icons.verified_user_outlined,
                      title: 'Đảm bảo uy tín',
                      desc:
                          'Mioto xác minh thông tin xe và chủ xe, đảm bảo trải nghiệm thuê xe an toàn, minh bạch.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Ô giới thiệu
              _wideBenefitBox(
                color: const Color(0xFFDFF6FF),
                image: 'assets/images/friend_invite.png',
                title: 'Giới thiệu Mioto đến bạn bè',
                desc:
                    'Người giới thiệu & người được giới thiệu cùng nhận nhiều ưu đãi hấp dẫn từ Mioto.',
                linkText: 'Tìm hiểu thêm',
              ),

              const SizedBox(height: 18),

              // Ô ảnh nền
              _imageBackgroundBox(
                imageBg: 'assets/images/car_road.jpg',
                title: 'Bạn muốn cho thuê xe?',
                desc:
                    'Hơn 10,000 chủ xe đang cho thuê hiệu quả trên Mioto. Đăng kí trở thành đối tác của chúng tôi ngay hôm nay để gia tăng thu nhập hàng tháng.',
                buttonText: 'Đăng ký ngay',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _smallBenefitBox({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      width: 280, 
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F9EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF00A86B), size: 28),
          ),
          const SizedBox(height: 10),
          // Tiêu đề
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          // Mô tả
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wideBenefitBox({
    required Color color,
    required String image,
    required String title,
    required String desc,
    required String linkText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  linkText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF00A86B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
  Widget _imageBackgroundBox({
    required String imageBg,
    required String title,
    required String desc,
    required String buttonText,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.asset(
            imageBg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 180,
          ),
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.65),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A86B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) ,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
