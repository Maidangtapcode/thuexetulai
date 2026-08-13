import 'package:flutter/material.dart';

class Chatbotscreen extends StatefulWidget {
  const Chatbotscreen({super.key});

  @override
  State<Chatbotscreen> createState() => _ChatbotscreenState();
}

class _ChatbotscreenState extends State<Chatbotscreen> {
  bool _isVisible = true; // ẩn/hiện nút chat

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: 40,// Vị trí chatbox
      right: 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ảnh chatbox chính
          GestureDetector(
            onTap: () {
              debugPrint("Chatbox clicked!");
              // TODO: mở chat popup 
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: AssetImage('assets/images/chatbot.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),

          // --- Dấu X nhỏ ---
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: () {
                setState(() => _isVisible = false);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
