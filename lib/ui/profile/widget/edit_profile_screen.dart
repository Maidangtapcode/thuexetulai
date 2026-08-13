import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_manager.dart';
import '../../../ui/widget/responsive_layout.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthManager>().user;

    _nameController.text = user?.name ?? "";
    _emailController.text = user?.email ?? "";
    _phoneController.text = user?.phone ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildForm(context, maxWidth: double.infinity),
      tablet: Center(child: _buildForm(context, maxWidth: 500)),
      desktop: Center(child: _buildForm(context, maxWidth: 450)),
    );
  }
  Widget _buildForm(BuildContext context, {required double maxWidth}) {
    final auth = context.watch<AuthManager>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Chỉnh sửa",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: Container(
          width: maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _title("Tên người dùng"),
              _input(_nameController),
              const SizedBox(height: 16),
              _title("Email"),
              _input(_emailController),
              const SizedBox(height: 16),
              _title("Số điện thoại"),
              _input(_phoneController, icon: Icons.phone),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await auth.updateProfile({
                      "name": _nameController.text,
                      "email": _emailController.text,
                      "emaill": _emailController.text,
                      "phone": _phoneController.text,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Lưu", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _input(TextEditingController controller, {IconData? icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
