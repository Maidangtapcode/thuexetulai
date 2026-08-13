import 'package:flutter/material.dart';
import '../home/widget/benific_section.dart';
import '../home/widget/chatbot.dart';
import '../home/widget/header_section.dart';
import '../home/widget/location_card.dart';
import '../home/widget/promotion_card.dart';
import '../home/widget/section_title.dart';
import '../../../ui/widget/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      tablet: _buildMobileLayout(context),
      desktop: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _buildMobileLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Nội dung cuộn
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSection(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const SectionTitle(title: "Chương trình khuyến mãi"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: const [
                            PromotionCard(imageUrl: 'assets/images/km.jpg'),
                            PromotionCard(imageUrl: 'assets/images/km1.jpg'),
                            PromotionCard(imageUrl: 'assets/images/km3.jpg'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      const SectionTitle(title: "Địa điểm nổi bật"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: const [
                            LocationCard(
                              imageUrl: 'assets/images/tphcm.jpg',
                              city: 'TP.HCM',
                              cars: '3000+ xe',
                            ),
                            LocationCard(
                              imageUrl: 'assets/images/hanoi.jpg',
                              city: 'Hà Nội',
                              cars: '2500+ xe',
                            ),
                            LocationCard(
                              imageUrl: 'assets/images/danang.jpg',
                              city: 'Đà Nẵng',
                              cars: '500+ xe',
                            ),
                          ],
                        ),
                      ),

                      const SectionTitle(title: "Ưu điểm của Mioto"),
                      const MiotoBenefitsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Chatbotscreen(),
        ],
      ),
    );
  }
}
