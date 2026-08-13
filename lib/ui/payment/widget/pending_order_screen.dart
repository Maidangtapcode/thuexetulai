import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../../services/pocketbase_client.dart'; // Import file client của bạn

class PendingOrderScreen extends StatefulWidget {
  final String orderId;
  const PendingOrderScreen({super.key, required this.orderId});
  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  String _statusMessage = 'Đang chờ Admin xác nhận thanh toán...';
  bool _isConfirmed = false;
  PocketBase? pb;
  void Function()? _unsubscribe;
  @override
  void initState() {
    super.initState();
    _initializeAndSubscribe();
  }

  Future<void> _initializeAndSubscribe() async {
    pb = await getPocketbaseInstance();

    try {
      print('Kiểm tra tình trạng hiện tại của order: ${widget.orderId}');
      final record = await pb?.collection('orders').getOne(widget.orderId);
      final currentStatus = record?.getStringValue('status') ?? 'pending';
      print('Tình trạng hiện tại là: $currentStatus');

      if (currentStatus == 'confirmed') {
        _handleConfirmation();
        return;
      } else if (currentStatus == 'rejected') {
        _handleRejection();
        return;
      }

      print(
        'Tình trạng vẫn pending, bắt đầu lắng nghe (subscribe) ID: ${widget.orderId}...',
      );
      _unsubscribe = await pb
          ?.collection('orders')
          .subscribe(widget.orderId, _onOrderUpdate);

      print('Đã subscribe thành công!');
    } catch (e) {
      print('LỖI KHI GETONE/SUBSCRIBE: $e');
      setState(() {
        _statusMessage = "Lỗi khi lấy đơn hàng: ${e.toString()}";
      });
    }
  }

  void _onOrderUpdate(RecordSubscriptionEvent event) {
    if (event.record == null) return;
    print('Nhận được cập nhật cho record: ${event.record!.id}');
    final newStatus = event.record!.getStringValue('status');
    if (newStatus == 'confirmed') {
      print('Trạng thái đã đổi thành CONFIRMED!');
      _handleConfirmation();
    }
    if (newStatus == 'rejected') {
      print('Trạng thái đã đổi thành REJECTED!');
      _handleRejection();
    }
  }

  void _handleRejection() {
    setState(() {
      _statusMessage = 'Đơn hàng đã bị từ chối. Vui lòng liên hệ Admin.';
    });
    _unsubscribe?.call(); 
  }

  void _handleConfirmation() {
    setState(() {
      _isConfirmed = true;
      _statusMessage = 'Đơn hàng đã được xác nhận!';
    });

    _unsubscribe?.call(); 

    Future.microtask(() => _showSuccessDialog());
  }

  void _showSuccessDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Thanh toán thành công!'),
        content: const Text(
          'Đơn hàng của bạn đã được xác nhận. Chủ xe sẽ liên hệ với bạn sớm.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/home'); 
            },
            child: const Text('Về Trang chủ'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _unsubscribe?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang xử lý đơn hàng'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isConfirmed)
                const CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                )
              else
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 32),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
