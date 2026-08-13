import 'package:flutter/material.dart';

class PromotionCard extends StatelessWidget {
  final String imageUrl;
  const PromotionCard({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 250,
      height: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imageUrl, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
