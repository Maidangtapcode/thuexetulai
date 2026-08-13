import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String imageUrl;
  final String city;
  final String cars;
  const LocationCard({
    super.key,
    required this.imageUrl,
    required this.city,
    required this.cars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 3 / 4, // Màn hình 
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            city,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            cars,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
