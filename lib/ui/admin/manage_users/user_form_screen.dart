import 'package:flutter/material.dart';
import '../../../models/user.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;
  const UserFormScreen({super.key, this.user});
  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _emaill;
  late String _phone;
  late String _role;
  late bool _isActive;
  late DateTime _created;

  @override
  void initState() {
    super.initState();
    _name = widget.user?.name ?? '';
    _emaill = widget.user?.emaill ?? '';
    _phone = widget.user?.phone ?? '';
    _role = widget.user?.role ?? 'user';
    _isActive = widget.user?.isActive ?? true;
    _created = widget.user?.created ?? DateTime.now();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = User(
        id: widget.user?.id ?? '',
        name: _name,
        email: _emaill, 
        emaill: _emaill,
        phone: _phone,
        role: _role,
        isActive: _isActive,
        created: _created,
      );
      Navigator.pop(context, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user == null ? 'Thêm người dùng' : 'Chỉnh sửa người dùng',
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Họ tên'),
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập họ tên' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _emaill,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Vui lòng nhập email hợp lệ'
                    : null,
                onSaved: (value) => _emaill = value!,
              ),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
                onSaved: (value) => _phone = value!,
              ),
              DropdownButtonFormField<String>(
                initialValue: _role,
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('Người dùng')),
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Quản trị viên'),
                  ),
                ],
                onChanged: (value) => setState(() => _role = value!),
                decoration: const InputDecoration(labelText: 'Vai trò'),
              ),
              SwitchListTile(
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
                title: const Text('Trạng thái hoạt động'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
