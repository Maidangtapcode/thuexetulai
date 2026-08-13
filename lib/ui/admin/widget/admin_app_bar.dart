import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_manager.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AdminAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final authManager = context.watch<AuthManager>();
    final adminName = authManager.user?.name ?? 'Admin';

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 10, 245, 147),
      elevation: 1,
      centerTitle: false,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions:
          (actions ?? []) +
          [
            Row(
              children: [
                Text(adminName, style: const TextStyle(color: Colors.black87)),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 224, 224, 224),
                  child: const Icon(Icons.person, color: Colors.black87),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
