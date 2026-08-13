import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_manager.dart';
import '../profile/widget/change_password_screen.dart';
import '../profile/widget/profile_detail_screen.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthManager>().user;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 244, 233),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
                title: Text(
                  user?.name ?? "Người dùng",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileDetailsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            _optionBlock([
              _profileOption(
                Icons.work_history,
                "Lịch sử thanh toán",
                onTap: () => context.push('/payment_history'),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
                height: 4,
                indent: 16,
                endIndent: 16,
              ),
              _profileOption(
                Icons.favorite,
                "Xe yêu thích",
                onTap: () => context.push('/favorite'),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
                height: 4,
                indent: 16,
                endIndent: 16,
              ),
              _profileOption(Icons.directions_car, "Đăng ký cho thuê xe"),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
                height: 4,
                indent: 16,
                endIndent: 16,
              ),

              _profileOption(Icons.location_on, "Địa chỉ của tôi"),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
                height: 4,
                indent: 16,
                endIndent: 16,
              ),
              _profileOption(Icons.card_membership, "Giấy phép lái xe"),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
                height: 4,
                indent: 16,
                endIndent: 16,
              ),
              _profileOption(Icons.credit_card, "Thẻ thanh toán"),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
                height: 4,
                indent: 16,
                endIndent: 16,
              ),
              _profileOption(Icons.star, "Đánh giá từ chủ xe"),
            ]),

            const SizedBox(height: 16),

            _optionBlock([
              _profileOption(Icons.card_giftcard, "Quà tặng"),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
                height: 4,
                indent: 16,
                endIndent: 16,
              ),
              _profileOption(Icons.group_add, "Giới thiệu bạn bè"),
            ]),

            const SizedBox(height: 16),
            _optionBlock([
              ListTile(
                leading: Icon(Icons.lock, color: Colors.grey),
                title: const Text(
                  "Đổi mật khẩu",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.6,
                height: 4,
                indent: 16,
                endIndent: 16,
              ),
              _profileOption(Icons.delete_forever, "Yêu cầu xóa tài khoản"),
            ]),

            const SizedBox(height: 32),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  context.read<AuthManager>().logout();
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Đăng xuất",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionBlock(List<Widget> options) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: options
            .map(
              (widget) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: widget,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _profileOption(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ?? () {},
    );
  }
}
