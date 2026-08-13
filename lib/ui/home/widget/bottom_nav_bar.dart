import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'TRANG CHỦ',
        ),
        const BottomNavigationBarItem(
            icon: Icon(Icons.work_history),
            label: 'Lịch sử',
          ),
        
        const BottomNavigationBarItem(
          icon: Icon(Icons.headset_mic),
          label: 'HỖ TRỢ',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'CÁ NHÂN',
        ),
      ],
    );
  }
}
