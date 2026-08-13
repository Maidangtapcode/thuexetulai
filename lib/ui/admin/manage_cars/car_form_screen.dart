import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/car.dart';

class CarFormScreen extends StatefulWidget {
  final Car? car; // Nếu có xe thì là edit, không thì là add
  const CarFormScreen({super.key, this.car});

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Các trường dữ liệu
  late String _title;
  late double _newPrice;
  late String _location;
  late String _gearbox;
  late int _seats;
  late String _fuel;
  late double _rating;
  late int _trips;
  late double _oldPrice;
  late int _discount;

  // Biến cho ảnh
  final ImagePicker _picker = ImagePicker();
  late List<String> _existingImageUrls; // Ảnh cũ (dạng URL)
  late List<File> _newImages; // Ảnh mới (dạng File)

  @override
  void initState() {
    super.initState();
    final car = widget.car;
    // Gán giá trị từ xe (nếu là edit) hoặc mặc định (nếu là add)
    _title = car?.title ?? '';
    _newPrice = car?.newPrice ?? 0;
    _location = car?.location ?? '';
    _gearbox = car?.gearbox ?? 'Số tự động';
    _seats = car?.seats ?? 4;
    _fuel = car?.fuel ?? 'Xăng';
    _rating = car?.rating ?? 5.0;
    _trips = car?.trips ?? 0;
    _oldPrice = car?.oldPrice ?? 0;
    _discount = car?.discount ?? 0;
    // Lấy ảnh
    _existingImageUrls = car?.imageUrls ?? [];
    _newImages = [];
  }

  // Hàm chọn ảnh
  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      imageQuality: 80, // Giảm chất lượng
    );

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _newImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
      });
    }
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final newCar = Car(
      id: widget.car?.id, // Giữ id cũ nếu là edit
      title: _title,
      location: _location,
      gearbox: _gearbox,
      seats: _seats,
      fuel: _fuel,
      rating: _rating,
      trips: _trips,
      oldPrice: _oldPrice,
      newPrice: _newPrice,
      discount: _discount,

      featuredImages: _newImages, // Ảnh mới để upload
      imageUrls: _existingImageUrls, // Ảnh cũ để giữ
    );

    Navigator.pop(context, newCar);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.car != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Chỉnh sửa xe' : 'Thêm xe mới'),
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
              // Widget hiển thị và chọn ảnh
              _buildImagePicker(),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Tên xe'),
                onSaved: (value) => _title = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập tên xe'
                    : null,
              ),

              //XÓA TextFormField cho imageUrl
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Vị trí'),
                onSaved: (value) => _location = value ?? '',
              ),
              TextFormField(
                initialValue: _gearbox,
                decoration: const InputDecoration(labelText: 'Hộp số'),
                onSaved: (value) => _gearbox = value ?? '',
              ),
              TextFormField(
                initialValue: _seats == 0 ? '' : _seats.toString(),
                decoration: const InputDecoration(labelText: 'Số ghế'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _seats = int.tryParse(value ?? '0') ?? 0,
              ),
              TextFormField(
                initialValue: _fuel,
                decoration: const InputDecoration(labelText: 'Nhiên liệu'),
                onSaved: (value) => _fuel = value ?? '',
              ),
              TextFormField(
                initialValue: _newPrice == 0
                    ? ''
                    : _newPrice.toStringAsFixed(0),
                decoration: const InputDecoration(labelText: 'Giá thuê (VNĐ)'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _newPrice = double.tryParse(value ?? '0') ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget chọn ảnh
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hình ảnh',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Hiển thị ảnh cũ (url)
                ..._existingImageUrls.map(
                  (url) =>
                      _buildImageItem(Image.network(url, fit: BoxFit.cover)),
                ),
                // Hiển thị ảnh mới (file)
                ..._newImages.map(
                  (file) =>
                      _buildImageItem(Image.file(file, fit: BoxFit.cover)),
                ),

                // Nút thêm ảnh
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_a_photo, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem(Widget imageWidget) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 100, height: 100, child: imageWidget),
      ),
    );
  }
}
