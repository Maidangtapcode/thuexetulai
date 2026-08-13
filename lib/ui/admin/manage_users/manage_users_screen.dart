import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../manage_users/user_form_screen.dart';
import 'user_manager.dart';
import '../manage_users/user_detail_screen.dart';
import 'package:provider/provider.dart';
import '../widget/admin_app_bar.dart';
import '../widget/admin_drawer.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  Future<void> _refreshUsers() async {
    final manager = context.read<UserManager>();
    await manager.fetchUsers();
  }

  void _openUserForm({User? user}) async {
    final manager = context.read<UserManager>();

    final result = await Navigator.push<User>(
      context,
      MaterialPageRoute(builder: (_) => UserFormScreen(user: user)),
    );

    if (!mounted || result == null) return;

    if (user == null) {
      await manager.addUser(result);
    } else {
      await manager.updateUser(result);
    }
  }

  void _viewUserDetail(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
    );
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${user.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserManager>().deleteUser(user.id);
              Navigator.pop(ctx);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<UserManager>();
    final users = manager.users;

    return Scaffold(
      appBar: AdminAppBar(
        title: 'Quản lý người dùng',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openUserForm(),
          ),
        ],
      ),
      drawer: const AdminDrawer(),

      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: manager.isLoading
            ? const Center(child: CircularProgressIndicator())
            : users.isEmpty
            ? const Center(
                child: Text(
                  "Không có người dùng",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user.isActive
                            ? Colors.green
                            : Colors.grey,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(user.name),
                      subtitle: Text('${user.emaill} • ${user.phone}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.teal,
                            ),
                            onPressed: () => _viewUserDetail(user),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () => _openUserForm(user: user),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _deleteUser(user),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
