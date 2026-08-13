import 'package:flutter/material.dart';

class OwnerDetailScreen extends StatelessWidget {
  final String ownerName;
  final String ownerAvatar;
  const OwnerDetailScreen({
    super.key,
    required this.ownerName,
    required this.ownerAvatar,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin chủ xe
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(ownerAvatar),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ownerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        const Text("5.0", style: TextStyle(fontSize: 12)),

                        const SizedBox(width: 12),

                        const Icon(
                          Icons.card_travel,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "100 chuyến",
                          style: const TextStyle(fontSize: 12),
                        ),

                        const Spacer(),
                      ],
                    ),
                    const Text("Ngày tham gia: năm 2022"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Chủ xe 5 sao có thời gian phản hồi nhanh chóng, "
                "tỉ lệ đồng ý cao, mức giá cạnh tranh & dịch vụ được đánh giá tốt.",
                style: TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),
            // Thống kê
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _StatItem(label: "Tỉ lệ phản hồi", value: "100%"),
                _StatItem(label: "Phản hồi trong", value: "5 phút"),
                _StatItem(label: "Tỉ lệ đồng ý", value: "100%"),
              ],
            ),

            const SizedBox(height: 32),

            // Phần xe tự lái
            const SizedBox(height: 32),
            // Phần đánh giá
            const Text(
              "Đánh giá của khách thuê và chủ xe",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Tổng điểm
            Row(
              children: const [
                Icon(Icons.star, color: Colors.orange, size: 28),
                SizedBox(width: 6),
                Text(
                  "5.0",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text("(112 đánh giá)", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),

            // Danh sách đánh giá
            const _ReviewItem(
              avatar: "assets/images/users/user1.jpg",
              name: "Nguyễn Văn A",
              date: "12/09/2025",
              stars: 5,
              comment:
                  "Chủ xe rất thân thiện, xe sạch sẽ và chạy tốt. Sẽ thuê lại lần sau!",
            ),
            const _ReviewItem(
              avatar: "assets/images/users/user2.jpg",
              name: "Lê Thị B",
              date: "05/09/2025",
              stars: 5,
              comment:
                  "Trải nghiệm tuyệt vời! Chủ xe hỗ trợ nhanh chóng và nhiệt tình.",
            ),
            const _ReviewItem(
              avatar: "assets/images/users/user3.jpg",
              name: "Trần Minh C",
              date: "28/08/2025",
              stars: 4,
              comment: "Xe hơi cũ chút nhưng chạy ổn định, giá hợp lý.",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Xe tự lái",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("Xem tất cả >", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _CarCard(
                    image: "assets/images/cars/C1.jpg",
                    name: "TOYOTA AVANZA 2024",
                    price: "681K",
                    oldPrice: "821K",
                    discount: "Giảm 20%",
                    location: "Quận Thủ Đức, TP.HCM",
                    trips: 6,
                  ),
                  SizedBox(width: 12),
                  _CarCard(
                    image: "assets/images/cars/C2.jpg",
                    name: "TOYOTA RUSH 2019",
                    price: "567K",
                    oldPrice: "707K",
                    discount: "Giảm 23%",
                    location: "Phường Linh Đông, Quận Thủ Đức",
                    trips: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _CarCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String oldPrice;
  final String discount;
  final String location;
  final int trips;

  const _CarCard({
    required this.image,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.location,
    required this.trips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    discount,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Text(
            location,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              const Text("5.0", style: TextStyle(fontSize: 12)),
              const SizedBox(width: 12),
              const Icon(Icons.card_travel, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text("$trips chuyến", style: const TextStyle(fontSize: 12)),

              const Spacer(),
            ],
          ),

          const Spacer(),
          Row(
            children: [
              Text(
                oldPrice,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text("/ngày", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// WIDGET HIỂN THỊ MỘT ĐÁNH GIÁ
class _ReviewItem extends StatelessWidget {
  final String avatar;
  final String name;
  final String date;
  final int stars;
  final String comment;

  const _ReviewItem({
    required this.avatar,
    required this.name,
    required this.date,
    required this.stars,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 22, backgroundImage: AssetImage(avatar)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < stars ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(comment, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
