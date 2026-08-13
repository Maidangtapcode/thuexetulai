import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_manager.dart';
import '../shared/dialog_utils.dart';
import '../widget/responsive_layout.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _authData = {
    'email': '',
    'name': '',
    'password': '',
  };

  final _passwordController = TextEditingController();
  final _isSubmitting = ValueNotifier<bool>(false);
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agreed = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _isSubmitting.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      await context.read<AuthManager>().signup(
        _authData['email']!,
        _authData['password']!,
        _authData['name']!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      log('$error');
      if (mounted) {
        showErrorDialog(
          context,
          error.toString().replaceFirst('Exception: ', ''),
        );
      }
    }

    _isSubmitting.value = false;
  }

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Đăng ký',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      backgroundColor: Colors.white,

      body: SafeArea(child: _buildForm()),

      bottomNavigationBar: SafeArea(child: _buildBottomBar()),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(
              label: 'Email',
              hint: 'Nhập email',
              keyboard: TextInputType.emailAddress,
              validator: (v) {
                if (v!.isEmpty || !v.contains('@')) {
                  return 'Email không hợp lệ!';
                }
                return null;
              },
              onSaved: (v) => _authData['email'] = v!,
            ),
            const SizedBox(height: 16),

            _buildTextFormField(
              label: 'Họ Tên',
              hint: 'Nhập họ tên',
              validator: (v) {
                if (v!.isEmpty) return 'Vui lòng nhập họ tên!';
                return null;
              },
              onSaved: (v) => _authData['name'] = v!,
            ),
            const SizedBox(height: 16),

            _buildTextFormField(
              label: 'Mật khẩu',
              hint: 'Nhập mật khẩu',
              controller: _passwordController,
              obscure: _obscurePass,
              onToggle: () => setState(() => _obscurePass = !_obscurePass),
              validator: (v) {
                if (v == null || v.length < 5) {
                  return 'Mật khẩu quá ngắn!';
                }
                return null;
              },
              onSaved: (v) => _authData['password'] = v!,
            ),
            const SizedBox(height: 16),

            _buildTextFormField(
              label: 'Xác nhận mật khẩu',
              hint: 'Nhập lại mật khẩu',
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              validator: (v) {
                if (v != _passwordController.text) {
                  return 'Mật khẩu không khớp!';
                }
                return null;
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAgreement(),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isSubmitting,
              builder: (context, isSubmitting, child) {
                if (isSubmitting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: _agreed ? _submitRegister : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String hint,
    TextEditingController? controller,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: onToggle != null
                ? IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: onToggle,
                  )
                : null,
          ),
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget _buildAgreement() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreed,
          activeColor: Colors.green,
          onChanged: (v) => setState(() => _agreed = v ?? false),
        ),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black87, fontSize: 14),
              children: [
                TextSpan(text: 'Tôi đã đọc và đồng ý với '),
                TextSpan(
                  text: 'Chính sách & quy định',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: ' và '),
                TextSpan(
                  text: 'Chính sách bảo vệ dữ liệu cá nhân',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: ' của App'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
