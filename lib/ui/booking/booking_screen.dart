import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../models/car.dart';
import '../car_home/widget/cars_manager.dart';
import '../widget/searchmanager.dart';
import '../../models/order.dart';
import 'widget/orders_manager.dart';
import '../auth/auth_manager.dart';
import '../car_detail/widget/rental_documents_bottom_sheet.dart';
import '../payment/widget/payments_manager.dart';
import '../../models/payment.dart';
import '../../utils/format_helper.dart';

class BookingScreen extends StatefulWidget {
  final String carId;
  const BookingScreen({super.key, required this.carId});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  bool _agreedPolicy = false; // Biến để track checkbox
  String _formatDateTime(DateTime dt) {
    return DateFormat('HH:mm E, dd/MM/yyyy', 'vi_VN').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final car = context.read<CarsManager>().findById(widget.carId);
    final searchManager = context.read<SearchManager>();
    final DateTime? startDate = searchManager.startDate;
    final DateTime? endDate = searchManager.endDate;
    final String deliveryLocation =
        searchManager.location ?? car?.location ?? "N/A";

    if (car == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Lỗi")),
        body: const Center(child: Text("Không tìm thấy xe.")),
      );
    }

    final thumbnailUrl = car.imageUrls.isNotEmpty ? car.imageUrls.first : '';
    int days = 1;
    if (startDate != null && endDate != null) {
      days = endDate.difference(startDate).inDays;
      if (days == 0) days = 1;
    }
    double total = car.newPrice * days;
    double discount = car.discount.toDouble();
    double finalTotal = total - discount;
    double deposit =
        (car.newPrice * (days == 0 ? 1 : days) - car.discount) * 0.4;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Xác nhận đặt xe',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _vehicleCard(car, thumbnailUrl),
                  const SizedBox(height: 12),
                  _insuranceCard(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Colors.black12, height: 1),
                  ),
                  _timeRentCard(car, startDate, endDate, deliveryLocation),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Colors.black12, height: 1),
                  ),
                  _ownerCard(),
                ],
              ),
            ),

            const SizedBox(height: 12),
            _messageInputCard(_messageController),
            const SizedBox(height: 12),
            _priceBreakdownCard(
              car,
              days,
              total,
              discount,
              finalTotal,
              deposit,
            ),
            const SizedBox(height: 12),
            _documentsCard(context),
            const SizedBox(height: 12),
            _pledgeCard(),
            const SizedBox(height: 18),
            // Checkbox đồng ý chính sách
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _agreedPolicy
                      ? const Color(0xFF3FC27B)
                      : Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _agreedPolicy,
                    onChanged: (value) {
                      setState(() {
                        _agreedPolicy = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFF3FC27B),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _agreedPolicy = !_agreedPolicy;
                        });
                      },
                      child: const Text(
                        'Tôi đồng ý với Chính sách hủy chuyến',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Gửi yêu cầu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (!_agreedPolicy || _isLoading)
                    ? null
                    : () {
                        if (startDate == null || endDate == null) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Lỗi"),
                              content: const Text(
                                "Không tìm thấy ngày thuê. Vui lòng chọn lại từ Trang chủ.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        // Gọi hàm gửi
                        _sendBookingRequest(
                          context,
                          car,
                          startDate,
                          endDate,
                          deliveryLocation,
                          finalTotal,
                          deposit,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3FC27B),
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                    : const Text(
                        'Gửi yêu cầu thuê xe',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _sendBookingRequest(
    BuildContext context,
    Car car,
    DateTime startDate,
    DateTime endDate,
    String? deliveryAddress,
    double finalTotal,
    double deposit,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userId = context.read<AuthManager>().user?.id;
      if (userId == null) {
        throw Exception("Bạn chưa đăng nhập.");
      }

      // Tạo đối tượng Order
      final newOrder = Order(
        userId: userId,
        carId: car.id!,
        startDate: startDate,
        endDate: endDate,
        totalPrice: finalTotal,
        message: _messageController.text,
        deliveryAddress: deliveryAddress,
      );
      final paymentsManager = context.read<PaymentsManager>();
      final Payment newPayment = await context
          .read<OrdersManager>()
          .createOrderAndPayment(newOrder, deposit, paymentsManager);
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon thành công
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF3FC27B),
                          const Color(0xFF2DA55F),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3FC27B).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tiêu đề
                  const Text(
                    'Yêu cầu đã gửi!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mô tả
                  Text(
                    'Yêu cầu của bạn đã được gửi thành công.\nVui lòng thanh toán tiền cọc để hoàn tất.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Chi tiết
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Xe được đặt',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                car.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),

                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Tiền cọc',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'vnđ',
                                ).format(deposit),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3FC27B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Nút thanh toán
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.push('/payment', extra: newPayment);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3FC27B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Đi tới trang thanh toán',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {}
    }
  }

  Widget _vehicleCard(Car car, String thumbnailUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (thumbnailUrl.isEmpty)
                  ? Container(
                      width: 100,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.grey,
                        size: 40,
                      ),
                    )
                  : Image.network(
                      thumbnailUrl,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        width: 100,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mã số xe: ${car.id?.substring(0, 6).toUpperCase() ?? "N/A"}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${car.rating.toStringAsFixed(1)} • ${car.trips} chuyến',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _insuranceCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.verified_user, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Bảo hiểm thuê xe',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 6),
              Text(
                'Chuyến đi có mua bảo hiểm. Khách thuê bồi thường tối đa 2.000.000 VND trong trường hợp có sự cố ngoài ý muốn.',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timeRentCard(
    Car car,
    DateTime? startDate,
    DateTime? endDate,
    String? address,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thời gian thuê xe',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Nhận xe\n${startDate != null ? _formatDateTime(startDate) : '(Chưa chọn)'}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Trả xe\n${endDate != null ? _formatDateTime(endDate) : '(Chưa chọn)'}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Địa điểm nhận xe',
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          address ?? car.location,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _ownerCard() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: const AssetImage('assets/images/users/user.jpg'),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'MICARRO Thủ Đức',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                '5.0  •  100+ chuyến',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              SizedBox(height: 8),
              Text(
                'Nhằm bảo mật thông tin cá nhân, Mioto sẽ gửi chi tiết liên hệ của chủ xe sau khi khách hàng hoàn tất bước thanh toán trên ứng dụng.',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _messageInputCard(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nhập lời nhắn cho chủ xe',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 6,
            decoration: InputDecoration(
              hintText:
                  'Gợi ý:\nChào anh chủ xe?\nTôi cần thuê xe của anh để đi du lịch cùng gia đình với thời gian như trên.',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.lock, size: 16, color: Colors.green),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Giao dịch qua Mioto để chúng tôi bảo vệ bạn tốt nhất trong trường hợp bị hủy chuyến ngoài ý muốn & phát sinh sự cố bảo hiểm.',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceBreakdownCard(
    Car car,
    int days,
    double total,
    double discount,
    double finalTotal,
    double deposit,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bảng tính giá',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đơn giá thuê',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text('${formatPriceWithSeparator(car.newPrice)} /ngày'),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bảo hiểm thuê xe',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text('0 /ngày'),
            ],
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${formatPriceWithSeparator(total)} x $days ngày'),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.discount, size: 16, color: Colors.green),
              const SizedBox(width: 6),
              const Text(
                'Chương trình giảm giá',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 6),
              Text(
                '-${formatPriceWithSeparator(discount)}đ',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thành tiền',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${formatPriceWithSeparator(finalTotal)}đ'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thanh toán giữ chỗ',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                '${formatPriceWithSeparator(deposit)}đ',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thanh toán Khi nhận xe',
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              Text(
                '${formatPriceWithSeparator(finalTotal - deposit)}đ',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _documentsCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.description_outlined, color: Colors.black87),
        title: const Text(
          'Giấy tờ thuê xe',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: const Text('Xem chi tiết yêu cầu (Bắt buộc)'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const RentalDocumentsBottomSheet(),
          );
        },
      ),
    );
  }

  Widget _pledgeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Tài sản thế chấp',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            'Không yêu cầu khách thuê thế chấp Tiền mặt hoặc Xe máy',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
