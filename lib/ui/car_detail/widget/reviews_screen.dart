import 'package:flutter/material.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reviews = [
      {
        "avatar": "assets/images/users/user1.jpg",
        "name": "Hồng Vân",
        "date": "06/10/2025",
        "comment": "Xe đẹp, dịch vụ tốt",
        "rating": 5,
      },
      {
        "avatar": "assets/images/users/user2.jpg",
        "name": "Nguyễn Thanh Tùng",
        "date": "05/10/2025",
        "comment": "",
        "rating": 5,
      },
      {
        "avatar": "assets/images/users/user3.jpg",
        "name": "Vũ Thạnh Lập",
        "date": "03/10/2025",
        "comment": "",
        "rating": 5,
      },
      {
        "avatar": "assets/images/users/user4.jpg",
        "name": "Jet Nguyen",
        "date": "28/09/2025",
        "comment":
            "Dịch vụ nhanh gọn, xe sạch đẹp hoạt động mượt mà, chuyến đi thuận lợi. Cảm ơn Micaro.",
        "rating": 5,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final review = reviews[index];
          final avatar = review["avatar"] as String;
          final name = review["name"] as String;
          final date = review["date"] as String;
          final comment = review["comment"] as String;
          final rating = review["rating"] as int;

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(avatar),
                  radius: 25,
                ),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              Text(rating.toString()),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        date,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      if (comment.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          comment,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: reviews.length,
      ),
    );
  }
}